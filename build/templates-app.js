angular.module('templates-app', ['home/home.tpl.html', 'js-ng-modules/js-ng-modules.tpl.html']);

angular.module("home/home.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("home/home.tpl.html",
    "<div data-ng-cloak class=\"container homePage\">\n" +
    "	<div class=\"inner-container\">\n" +
    "		<div class=\"inner-block title\">\n" +
    "			<h1>JS-Modules</h1>\n" +
    "			<p>It is Jake and Stacey's modules library</p>\n" +
    "		</div>\n" +
    "\n" +
    "	</div>\n" +
    "</div>\n" +
    "\n" +
    "\n" +
    "");
}]);

angular.module("js-ng-modules/js-ng-modules.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("js-ng-modules/js-ng-modules.tpl.html",
    "<div data-ng-cloak class=\"jsNgModules\">\n" +
    "\n" +
    "</div>\n" +
    "");
}]);
