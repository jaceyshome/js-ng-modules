define [
  'angular'
  'common/text/main'
], ->
  module = angular.module 'common.footer', [
    'templates'
  ]
  module.directive 'curtFooter', ($state)->
    restrict: "A"
    scope: {}
    templateUrl: "common/footer/footer"
    replace: true
    link: ($scope, element, attrs) ->
      $scope.base_url = window.base_url
      $scope.goToCredits = () ->
        $state.go "module", {moduleKey: "credits"}
