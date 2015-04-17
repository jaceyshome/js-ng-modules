define [
  'angular'
], ->
  module = angular.module 'common.bindhtmlcompile', [
    'templates'
  ]
  module.directive 'bindHtmlCompile', ($compile)->
    restrict: "A"
    link: ($scope, $element, $attrs) ->
      $scope.$watch (()->$scope.$eval($attrs.bindHtmlCompile)), (value) ->
        $element.html(value)
        $compile($element.contents())($scope)