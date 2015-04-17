define [
  'angular'
], ->
  module = angular.module 'common.topicmarker', [
    'templates'
  ]
  module.directive 'topicMarker', (Module, Structure, $timeout, Helper)->
    restrict: "A"
    scope:{
      config:"="
    }
    link: ($scope, $element, $attrs) ->

      init = ->
        currentTopicType = getCurrentTopicType()
        handleIdAttr(currentTopicType)
        data =
          id: $element.attr("id")
          type: currentTopicType
          element: $element
          viewState: getViewState()
          main: getTopicMain()
          settings: $scope.config?.settings || {}
        Module.addTopicMarkers(data)

      getCurrentTopicType = ()->
        return $scope.config.type if $scope.config?.type
        topicTypes = angular.copy Structure.data.config.topicTypes
        for topicType in topicTypes
          if $element.hasClass topicType then return topicType
        return 'default'

      getViewState = ->
        windowScrollPosition = $("body").scrollTop()
        viewportSize = Helper.getViewportSize()
        viewcenterPositionY = windowScrollPosition + viewportSize.height / 2
        if viewcenterPositionY > $element.offset().top
          return 'viewed'
        else
          return ' '

      getTopicMain = ->
        return false unless $scope.config?.main
        return $scope.config.main

      handleIdAttr = (currentTopicType)->
        unless $element.attr("id")
          if $scope.config?.id?
            $element.attr('id', $scope.config.id)
            return
          $element.attr("id", currentTopicType+'_'+$scope.$id)
          return

      $timeout init, 100

