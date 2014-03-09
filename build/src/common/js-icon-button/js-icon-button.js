angular.module("jsIconButton", []).directive("jsIconButton", function() {
  return {
    restrict: "A",
    scope: {
      resource: "="
    },
    replace: true,
    template: '<div class="quickLink">\
						<a href="{{resource.link}}" target="_blank">\
							<span class="thumb"></span>\
							<span class="title">{{resource.name}}</span>\
						</a>\
				</div>',
    link: function($scope, $element, $attrs) {
      var init;
      init = function() {
        return void 0;
      };
      return init();
    }
  };
});
