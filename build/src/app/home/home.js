var HomeCtrl;

angular.module("myApp.home", ["ui.state", "Utils"]).config(function($stateProvider) {
  return $stateProvider.state("home", {
    url: "/home",
    views: {
      main: {
        controller: "HomeCtrl",
        templateUrl: "home/home.tpl.html"
      }
    },
    data: {
      pageTitle: 'js modules home'
    }
  });
}).controller("HomeCtrl", HomeCtrl = function($scope) {});
