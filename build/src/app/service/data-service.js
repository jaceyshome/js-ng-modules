angular.module("dataService", ["ngResource"]).factory("dataService", function($resource) {
  return $resource('assets/data.json');
});
