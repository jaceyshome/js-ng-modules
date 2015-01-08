define [
  'angular'
], ->
  module = angular.module 'common.popupimage', [
    'templates'
  ]
  module.directive 'popupImage', ($rootScope)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/popup/popupimage/popupimage"
    link: ($scope, $element, $attrs) ->
      $scope.image = null
      defaultConfig = {} #it will be override later

      init = ->
        registerListeners()

      registerListeners = ->
        $rootScope.$on("$popupImage", popup)

      popup = (e,data)->
        $scope.image = angular.extend(defaultConfig, data)

      $scope.close = ->
        if typeof $scope.image?.handleClose is 'function'
          $scope.image?.handleClose()
        $scope.image = null

      init()

