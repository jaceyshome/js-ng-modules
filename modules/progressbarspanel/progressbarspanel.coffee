define [
  'angular'
], ->
  module = angular.module 'common.progressbarspanel', [
    'templates'
  ]
  module.directive 'progressBarsPanel', ($sce)->
    restrict: "A"
    scope:
      progresses: "="
      progressDelay: "@"
    templateUrl: "common/progressbarspanel/progressbarspanel"
    link: ($scope, $element, $attrs) ->

      $scope.progressDelay = 800 unless $scope.progressDelay

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.getProgressStyleWidth = (value)->
        return {'width': "#{value}%"}

      $scope.getProgressWidth = (value)->
        if value then return value
        return 97
