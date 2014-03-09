angular.module("myApp.js-ng-modules", [
		"ui.state"
]).config(($stateProvider) ->
		$stateProvider.state "js-ng-modules",
				url: "/js-ng-modules"
				views:
						main:
								controller: "jsNgModulesCtrl"
								templateUrl: "js-ng-modules/js-ng-modules.tpl.html"
				data:
						pageTitle: 'js-ng-modules'

).controller "jsNgModulesCtrl", jsNgModulesCtrl = ($scope) ->

