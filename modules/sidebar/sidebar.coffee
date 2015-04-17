define [
  'angular'
], ->
  module = angular.module 'common.sidebar', []
  module.directive 'tntSideBar', (Module, $timeout, Structure, $rootScope, AnimateScroll, Helper, AppendStyle) ->
    restrict: "A"
    scope: {
      settings: "="
    }
    templateUrl: "common/sidebar/sidebar"
    replace: true
    link: ($scope, $element, $attrs) ->
      $scope.data = null
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.showPanel = true

      previousScrollPosition = 0

      init = ->
        addWatchers()
        addListeners()
#        hacker() #hacker function for refresh the view
        previousScrollPosition = $("body").scrollTop()
        setInterval(updateSideBarMarkerStyles, 400)
        return

      addWatchers = ->
        $scope.$watch ()->
          Structure.data?.modules
        , (val)->
          if val isnt undefined then  $scope.data = Structure.data

      addListeners = ->
        $scope.$on('closeSideNavigation', (e, data)->
          $scope.showPanel = true
        )
        $scope.$on('currentModuleCompleted', onCurrentModuleCompleted)
        return

      onCurrentModuleCompleted = (e,data)->
        topic = Module.topicMarkers[Module.topicMarkers.length-1]
        topic.settings.completed = true

      updateSideBarMarkerStyles = ()->
        return if previousScrollPosition is $("body").scrollTop()
        previousScrollPosition = $("body").scrollTop()
        viewCenterPositionY = $("body").scrollTop() + Helper.getViewportSize().height / 2
        currentViewTopicIndex = 0
        for topic, index in Module.topicMarkers
          if viewCenterPositionY > topic.element.offset().top
            setTopicViewState(topic, 'viewed')
            currentViewTopicIndex = index
          else
            setTopicViewState(topic)
        setTopicViewState(Module.topicMarkers[currentViewTopicIndex],'current')
        $scope.$apply() if !$scope.$root.$$phase?

      setTopicViewState = (topic, viewState)->
        unless topic
          renderTopicMarker(topic)
        else
          topic.viewState = viewState || ''
          renderTopicMarker(topic)
        return

      renderTopicMarker = (topic)->
        return unless topic?
        style =
          color : "#FFFFFF"
        if topic?.viewState is 'viewed' or topic?.viewState is 'current'
          style.color = Module.currentModule.color
        topic.viewStyle = style
        return

      $scope.showMenu = (e)->
        e.stopPropagation()
        $rootScope.$broadcast("showSideNavigation",e)
        $scope.showPanel = false

      $scope.setSpecialType = (topic)->
        speicals = [
          'assessment'
          'finalaward'
        ]
        for speical in speicals
          if topic.type is speical
            classes = 'ticker'
            classes += ' completed' if topic.settings?.completed
            return classes

      $scope.setTopicMarkersContainerHeight = ()->
        if Module.currentModule?.scaleTopicMarker is false
          return {height: '480px', 'padding-top': '57px'}
        viewportHeight = Helper.getViewportSize().height
        availableHeight = viewportHeight - 10 - 22 - 24 - 10
        bottom = 0
        ###
        - 10(.sidebar's padding-top) - 22(.toggleMenuBtn's height)
        - 24(.topics-markers-container's padding-top)
        - 10(leave some space for bottom)
        ###
        $footer = $("html body").find ".footer"
        scrollHeight = $("html body").prop("scrollHeight")
        scrollTop = $(window).scrollTop()
        footerHeight = scrollHeight - scrollTop - viewportHeight
        if footerHeight < (scrollHeight - $footer.offset().top)
          bottom = (scrollHeight - $footer.offset().top) - footerHeight
        markerContainerHeight = parseInt((availableHeight - bottom))
        {'height':"#{markerContainerHeight}px"}

      $scope.checkTopicCompleted = (topic)->
        if topic.settings?.completed
          return  Module.currentModule.color

      $scope.handleClickTopic = (topic)->
        config =
          element: topic.element
          duration: AnimateScroll.calculateScrollRunTime(topic.element.offset().top)
        AnimateScroll.scrollToElementTop config

      $timeout init, 200