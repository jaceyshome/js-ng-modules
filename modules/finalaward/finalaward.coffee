define [
  'angular'
  'common/text/main'
], ->
  module = angular.module 'common.finalaward', [
    'templates'
  ]
  module.directive 'finalaward', (Module)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/finalaward/finalaward"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.topicMarkerSettings =
        completed: Module.currentModule.completed