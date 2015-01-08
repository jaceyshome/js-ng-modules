define [
  'angular'
], ->
  module = angular.module 'common.tinycarousel.slide', []
  module.directive 'carouselSlide', ()->
    restrict: "A"
    scope: {
      slide:"="
    }
    link: ($scope, $element, $attrs) ->

      init = ()->
        addWatchers()

      addWatchers = ->
        $scope.$watch "slide", (val)->
          val.element = $element

      init()