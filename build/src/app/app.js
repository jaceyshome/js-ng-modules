angular.module("myApp", ['templates-app', 'templates-common', 'myApp.home', 'myApp.js-ng-modules', 'ui.state', 'ui.route', 'ui.bootstrap', 'utilService']).config(function($stateProvider, $urlRouterProvider) {
  return $urlRouterProvider.otherwise("/home");
}).run(function() {}).controller("AppCtrl", [
  "$scope", "$location", "utilService", function($scope, $location, utilService) {
    $scope.$on('$stateChangeSuccess', function(event, toState, toParams, fromState, fromParams) {
      if (angular.isDefined(toState.data.pageTitle)) {
        return $scope.pageTitle = toState.data.pageTitle;
      }
    });
    return utilService.closeAllPopup = function() {
      return $scope.$broadcast("CLOSE_ALL_POPUP_PANELS");
    };
  }
]);
