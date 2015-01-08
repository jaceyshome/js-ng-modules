define [
  'angular'
  'jquery'
], ->
  module = angular.module 'common.notab', []
  module.directive 'tntNoTab', () ->
    restrict: "A"
    replace: true

    link: ($scope, $element, $attrs) ->
      # ---- Private Functions
      init = () ->
        addWatchers()

      addWatchers = ()->
        $scope.$watch($attrs['tntNoTab'], handleNoTabChanges)

      handleNoTabChanges = (val)->
        if(val)
          $element.attr("tabindex", "-1")
        else
          $element.removeAttr("tabIndex")

      init()
