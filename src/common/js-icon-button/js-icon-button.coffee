angular.module("jsIconButton", []).directive "jsIconButton", ->
		restrict: "A"

		scope:
				icon:"="

		replace: true

		template:
				'<div class="quickLink">
						<a href="javascipt:void();" target="_blank"
							title="click link {{icon.name}} to open a new widnow">
							<span class="thumb"></span>
							<span class="title">{{icon.name}}</span>
						</a>
				</div>'

		link: ($scope, $element, $attrs) ->
				init = () ->
						undefined

				init()