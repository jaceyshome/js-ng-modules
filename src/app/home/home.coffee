angular.module("myApp.home", [
		"ui.state"
		"Utils"
]).config(($stateProvider) ->
		$stateProvider.state "home",
				url: "/home"
				views:
						main:
								controller: "HomeCtrl"
								templateUrl: "home/home.tpl.html"
				data:
						pageTitle: 'OZ365'

).controller "HomeCtrl", HomeCtrl = ($scope) ->
