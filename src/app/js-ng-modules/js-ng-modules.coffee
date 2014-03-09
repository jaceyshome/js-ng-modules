angular.module("myApp.js-ng-modules", [
		"ui.state"
		"jsGoogleSearchBar"
		"jsMomentService"
]).config(($stateProvider) ->
		$stateProvider.state "js-ng-modules",
				url: "/js-ng-modules"
				views:
						main:
								controller: "jsNgModulesCtrl"
								templateUrl: "js-ng-modules/js-ng-modules.tpl.html"
				data:
						pageTitle: 'js-ng-modules'

).controller "jsNgModulesCtrl", jsNgModulesCtrl = ($scope,jsMomentService) ->
		$scope.utcTimeExample = "2014-03-08 00:00:56"
		$scope.localTimeExample = jsMomentService.UTCToLocal($scope.utcTimeExample)
		console.log "localTimeExample", $scope.localTimeExmaple
