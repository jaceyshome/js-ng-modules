define [
  'angular'
], ->
  module = angular.module 'common.tooltip', [
  ]
  module.directive 'tntTooltip', ($sce, $timeout) ->
    restrict: "A"
    scope: {
      tooltip:"="
    }
    templateUrl: "common/tooltip/tooltip"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables

      # -------------------------------------------------------------------------------- Private Variables

      # -------------------------------------------------------------------------------- init
      init = () ->

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.getX = (x) ->
        #console.log "hi"
        return x
        #return x+15
      $scope.getY = (y) ->
        return y
        #return y-4
      $scope.bindText = (text) ->
        return $sce.trustAsHtml(text)

      # -------------------------------------------------------------------------------- Private Functions

      # -------------------------------------------------------------------------------- Handler Functions

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      init()