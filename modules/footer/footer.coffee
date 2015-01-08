define [
  'angular'
  'common/text/main'
], ->
  module = angular.module 'common.footer', [
    'templates'
  ]
  module.directive 'curtFooter', ()->
    restrict: "A"
    scope: {}
    templateUrl: "common/footer/footer"
    replace: true
    link: ($scope, element, attrs) ->
