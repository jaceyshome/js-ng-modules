angular.module("jsIconButton", []).directive "jsIconButton", ->
		restrict: "A"

		scope:
				resource:"="

		replace: true

		template:
				'<div class="quickLink">
						<a href="{{resource.link}}" target="_blank">
							<span class="thumb"></span>
							<span class="title">{{resource.name}}</span>
						</a>
				</div>'

		link: ($scope, $element, $attrs) ->
				init = () ->
#						console.log "icon button", $scope.resources
						undefined

				init()