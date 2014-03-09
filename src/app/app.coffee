angular.module(
		"myApp",[
			'templates-app',
			'templates-common',
			'myApp.home',
			'myApp.js-ng-modules',
			'ui.state',
			'ui.route'
			'ui.bootstrap'
			'utilService'
		])
.config(
		($stateProvider, $urlRouterProvider) ->
				$urlRouterProvider.otherwise("/home")
		)
.run(
		()->
		)
.controller "AppCtrl", [
		"$scope",
		"$location",
		"utilService",
($scope,$location,utilService) ->
		$scope.$on('$stateChangeSuccess',
					( event, toState, toParams, fromState, fromParams)->
							if ( angular.isDefined( toState.data.pageTitle ) )
									$scope.pageTitle = toState.data.pageTitle

				)

		utilService.closeAllPopup = ()->
				$scope.$broadcast("CLOSE_ALL_POPUP_PANELS")


	]