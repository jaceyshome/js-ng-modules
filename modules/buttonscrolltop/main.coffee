define [
  'angular'
  'jquery'
  'common/animatefade/main'
  'common/animatescroll/main'
], ->
  module = angular.module 'common.buttonscrolltop', [
    'templates'
    'common.animatefade'
    'common.animatescroll'
    'common.scenario.service'
    'ngAnimate'
  ]
  module.directive 'tntButtonScrolltop', (AnimateScroll, Scenario)->
    restrict: "A"
    scope: {
      fromPosition:"="
      toPosition:"="
    }
    templateUrl: "common/buttonscrolltop/main"
    link: ($scope, element, attrs) ->
      $scope.visible = false
      $scope.isIE = false
      $scope.IEVersion = undefined
      toPosition = 0
      fromPosition = 0

      init = ()->
        hideButton()
        initParameter()
        checkBrowser()
        registerWindowScrollFunction()

      initParameter = ()->
        toPosition = $scope.toPosition || 0
        fromPosition = $scope.fromPosition || 700

      checkBrowser = ()->
        detectResult = navigator.userAgent
        if detectResult.indexOf("MSIE") > -1
          $scope.isIE = true
          if detectResult.indexOf("MSIE 7.0") > -1
            $scope.IEVersion = 7
            $scope.placeHolderFallback = true
          else if detectResult.indexOf("MSIE 8.0") > -1
            $scope.IEVersion = 8
            $scope.placeHolderFallback = true
          else $scope.IEVersion = 9  if detectResult.indexOf("MSIE 9.0") > -1
        else
          $scope.isIE = false

      registerWindowScrollFunction = ()->
        $(window).scroll ()->
          currentScrollY = 0
          if $scope.isIE
            if $scope.IEVersion >= 9
              currentScrollY = window.pageYOffset
            else
              currentScrollY = $(window).scrollTop()
          else
            currentScrollY = window.pageYOffset
          if currentScrollY > fromPosition
            showButton()
          else
            hideButton()
          $scope.$apply()

      hideButton = ()->
        $scope.visible = false

      showButton = ()->
        $scope.visible = true

      $scope.backToPosition = ()->
        data = {
          element: Scenario.moreInfoScrollTarget
          runtime: AnimateScroll.calculateScrollRunTime(Scenario.moreInfoBaseScrollPosition, 0.1)
        }
        AnimateScroll.scrollToElementTop(data)

      init()