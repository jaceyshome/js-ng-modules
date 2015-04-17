define [
  'angular'
], ->
  module = angular.module 'common.curtbutton', []
  module.directive 'moocCurtbutton', (Structure)->
    restrict: "A"
    scope:
      settings: "="
    link: ($scope, $element, $attrs) ->
      moduleKey = Structure.data.currentModuleKey
      moduleKey = $scope.settings.moduleKey if $scope.settings?.moduleKey?
      $element.addClass(Structure.appendStyles.curtButtonHoverStyles[moduleKey])
