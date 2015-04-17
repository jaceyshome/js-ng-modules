define [
  'angular'
], ->
  module = angular.module 'common.notab', []
  module.directive 'tntNoTab', ()->
    restrict: "A"
    link: ($scope, $element, $attrs) ->
      init = ()->
        addWatchers()

      addWatchers = ()->
        $scope.$watch($attrs['tntNoTab'], handleNoTabChange)

      handleNoTabChange = (val)->
        if val is true
          $element.attr("tabindex", "-1")
        else
          $element.removeAttr("tabindex")

      init()