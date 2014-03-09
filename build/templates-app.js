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
    "<div data-ng-cloak class=\"container jsNgModules\">\n" +
    "	<div class=\"inner-container\">\n" +
    "		<h1>Js Ng-modules</h1>\n" +
    "	</div>\n" +
    "\n" +
    "	<div class=\"inner-container googleSearchContainer\">\n" +
    "		<h2>Google search bar</h2>\n" +
    "		<div data-js-google-search-bar ></div>\n" +
    "	</div>\n" +
    "\n" +
    "	<div class=\"inner-container\">\n" +
    "		<h2>MomentJs Services</h2>\n" +
    "		<p>Convert UTS time to user local time (IE8, Firefox)</p>\n" +
    "		<p>UTS time (YYYY-MM-DD HH:mm:ss): {{utcTimeExample}} </p>\n" +
    "		<p>Local time: {{localTimeExample}} </p>\n" +
    "	</div>\n" +
    "\n" +
    "	<div class=\"inner-container\">\n" +
    "		<h2>Small icon button</h2>\n" +
    "		<div data-js-icon-button data-icon=\"icon\"></div>\n" +
    "	</div>\n" +
    "\n" +
    "</div>\n" +
    "");
}]);
