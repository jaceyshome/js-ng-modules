define [
  'angular'
], ->
  module = angular.module 'common.imagebutton', [
    'templates'
  ]
  module.directive 'imageButton', ($rootScope)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/imagebutton/imagebutton"
    link: ($scope, $element, $attrs) ->

      $scope.showImage = ()->
        $rootScope.$emit('$popupImage', $scope.settings)
        return