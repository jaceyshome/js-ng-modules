angular.module('templates-app', ['home/home.tpl.html']);

angular.module("home/home.tpl.html", []).run(["$templateCache", function($templateCache) {
  $templateCache.put("home/home.tpl.html",
    "<div data-ng-cloak class=\"homePage\">\n" +
    "\n" +
    "</div>\n" +
    "\n" +
    "\n" +
    "");
}]);
