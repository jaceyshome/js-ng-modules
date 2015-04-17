define [
  'angular'
], ->
  module = angular.module 'common.videoimage', []
  module.directive 'tntVideoImage', ($timeout, Structure) ->
    restrict: "A"
    scope: {
      settings: "="
    }
    replace:true
    templateUrl: "common/videoimage/main"
    link: ($scope, $element, $attrs) ->
      $scope.currentSize = ''
      videoConfig =
        sizes:
          large: 600
          medium: 400
          small: 220

      init = ->
        $(window).resize resizeVideo
        updateCurrentSize($element.width())

      resizeVideo = ->
        width =  $element.width() + 'px'
        height = ($element.width()/1280)*720+'px'
        $element.find(".videoPlayer").css height: height
        $element.find(".videoPlayer").css width: width
        $element.css height: height
        updateCurrentSize($element.width())
        $scope.$apply() if !$scope.$root.$$phase?
        return

      updateCurrentSize = (width)->
        if width >= videoConfig.sizes['large'] then return $scope.currentSize = 'large'
        if width >= videoConfig.sizes['medium'] then return $scope.currentSize = 'medium'
        if width >= videoConfig.sizes['small'] then return $scope.currentSize = 'small'
        return $scope.currentSize = 'small'

      init()