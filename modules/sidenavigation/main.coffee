define [
  'angular'
], ->
  module = angular.module 'common.sidenavigation', [
    'templates'
  ]
  module.directive 'tntSideNavigation', (Module, $timeout, Structure, $rootScope, AnimateScroll)->
    restrict: "A"
    scope: {}
    templateUrl: "common/sidenavigation/main"
    link: ($scope, $element, $attrs) ->
      $scope.showMenu = false
      $scope.data = null

      init = ->
        registerEventListerners()
        registerWatchers()

      registerWatchers = ()->
        $scope.$watch ()->
          Structure.data?.modules
        , (val)->
          if val isnt undefined then  $scope.data = Structure.data

      registerEventListerners = ()->
        $scope.$on('closeSideNavigation',()->
          $scope.showMenu = false
        )
        $scope.$on('showSideNavigation', (e, data)->
          $scope.showMenu = true
        )

      $scope.setModuleLabelColor = (moduleKey)->
        return Structure.appendStyles.navigationLabelStyles[moduleKey]

      $scope.goTo = (moduleKey)->
        Module.goToModule moduleKey

      $scope.goToTopic = (topic)->
        unless topic.element
          AnimateScroll.scrollToPagePosition(0, AnimateScroll.calculateScrollRunTime())
        else
          config =
            element: topic.element
            runtime: AnimateScroll.calculateScrollRunTime(topic.element.offset().top)
          AnimateScroll.scrollToElementTop config

      $scope.getModuleBadge = (key)->
        module = $scope.data.modules[key]
        if module.completed
          return module.badge.small
        else
          return module.badge.smallDefault

      $scope.close = ()->
        $rootScope.$broadcast('closeSideNavigation')

      init()