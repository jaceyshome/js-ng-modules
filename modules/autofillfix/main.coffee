define [
  'angular'
  ], ->
  module = angular.module 'common.autofillfix', [
  ]
  module.directive 'tntAutofillFix', () ->
    restrict:"A"
    scope:{
    }
    link:($scope, element, attrs) ->
      monitorId = window.setInterval ->
        element.find('input').trigger('input')
        element.find('input').trigger('change')
      , 100
      $scope.$on "$destroy", ()->
        window.clearInterval monitorId
