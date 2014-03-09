var jsNgModulesCtrl;

angular.module("myApp.js-ng-modules", ["ui.state", "jsGoogleSearchBar", "jsMomentService", "jsIconButton"]).config(function($stateProvider) {
  return $stateProvider.state("js-ng-modules", {
    url: "/js-ng-modules",
    views: {
      main: {
        controller: "jsNgModulesCtrl",
        templateUrl: "js-ng-modules/js-ng-modules.tpl.html"
      }
    },
    data: {
      pageTitle: 'js-ng-modules'
    }
  });
}).controller("jsNgModulesCtrl", jsNgModulesCtrl = function($scope, jsMomentService) {
  $scope.utcTimeExample = "2014-03-08 00:00:56";
  $scope.localTimeExample = jsMomentService.UTCToLocal($scope.utcTimeExample);
  return $scope.icon = {
    name: "demo"
  };
});
