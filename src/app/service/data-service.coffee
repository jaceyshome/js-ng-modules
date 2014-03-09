angular.module("dataService", ["ngResource"])
.factory "dataService", ($resource) ->
		return $resource 'assets/data.json'