define [
  'angular'
], ->
  module = angular.module 'common.bgimage.directive', []
  module.directive 'tntBgImage', () ->
    restrict: "A"
    scope: {}
    link: ($scope, element, attrs) ->
      $scope.$watch ()->
        $scope.url = attrs.tntBgImage
      , (val)->
        if val then init()

      init = ()->
        element.css({
          'background-image': 'url(' + $scope.url + ')'
          'background-repeat': 'no-repeat'
          'background-position': 'center'
          '-webkit-background-size': 'cover'
          '-moz-background-size': 'cover'
          '-o-background-size': 'cover'
          'background-size': 'cover'
          '-ms-filter': "progid:DXImageTransform.Microsoft.AlphaImageLoader(src="+$scope.url+", sizingMethod='scale')"
          'filter' : "progid:DXImageTransform.Microsoft.AlphaImageLoader(src="+$scope.url+", sizingMethod='scale'"
        }, )