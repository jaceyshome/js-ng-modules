;(function() {

	define([
		'angular',
		'jquery',
		'appmodule'
	],
	function() {
		var module = angular.module('tnt.directive.noTab', []);
		module.directive('jsNoTab', [function() {
			return {
				restrict: "A",

				link: function($scope, $element, $attrs) {
					var init = function() {
						addWatchers();
					};

					var addWatchers = function() {
						$scope.$watch($attrs['jsNoTab'], handleNoTabChange)
					};

					var handleNoTabChange = function(val) {
						if (val) {
							$element.attr("tabindex", "-1");
						} else {
							$element.removeAttr("tabindex");
						}
					};

					init();
				}
			};
		}]);
	});

})();
