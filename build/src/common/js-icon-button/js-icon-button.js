angular.module("jsIconButton", []).directive("jsIconButton", function() {
  return {
    restrict: "A",
    scope: {
      icon: "="
    },
    replace: true,
    template: '<div class="quickLink">\
						<a href="javascipt:void();" target="_blank"\
							title="click link {{icon.name}} to open a new widnow">\
							<span class="thumb"></span>\
							<span class="title">{{icon.name}}</span>\
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
