angular.module("jsNoTab", []).directive("jsNoTab", function() {
	return {
		restrict: "A",

		link: function($scope, $element, $attrs) {
			var init = function() {
				addWatchers();
			};

			var addWatchers = function() {
				$scope.$watch($attrs['jsNoTab'], handleNoTabChange);
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
});
