angular.module("jsGoogleSearchBar", []).directive("jsGoogleSearchBar", function() {
  return {
    restrict: "A",
    scope: {
      onClick: '@',
      onShow: '&',
      isDisabled: '&',
      label: '=',
      texts: '=',
      classes: '@'
    },
    replace: true,
    template: '<div class="googleSearchBar" >\
					<div class="container">\
						<img src="" data-ng-src="{{imageUrl}}" alt="google logo"/>\
						<label for="googleSearchBarDeskInput" >Google search input</label>\
						<input id="googleSearchBarDeskInput" class="desktopInput"\
										type="text" 	data-ng-model="query"/>\
						<label for="googleSearchBarMobileInput">Google search input</label>\
						<input id="googleSearchBarMobileInput" class="mobileInput"\
										type="text" data-ng-model="query" placeholder="Google"/>\
						<a class="searchButton"\
							href="" data-ng-href="{{searchEngine}}{{query}}"\
							target="_blank" ><span>Search</span></a>\
					</div>\
				</div>',
    link: function($scope, $element, $attrs) {
      var init;
      $scope.imageUrl = "assets/images/google_web.png";
      init = function() {
        $scope.searchEngine = "https://www.google.com.au/search?q=";
        return $scope.query = "";
      };
      return init();
    }
  };
});
