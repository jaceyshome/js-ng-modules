define [
  'angular'
  ], ->
  module = angular.module 'common.btnclick', []
  module.directive 'btnClick', ($rootScope)->
    restrict:"A"
    link:($scope, element, attrs) ->
      element.attr "onclick", "return false;"
      element.attr "href", "JavaScript:void(0);"

        