define [
  'angular'
  ], ->
  module = angular.module 'common.navigation', []
  module.directive 'tntNavigation', ($rootScope, Screen)->
    restrict:"A"
    scope:{}
    templateUrl: "common/navigation/main"
    link:($scope, element, attrs) ->
      $scope.Screen = Screen
      $scope.$watch ->
        Screen.screen
      , (screen)->
        $scope.screen = screen