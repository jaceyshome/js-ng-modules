define [
  'angular'
], ->
  module = angular.module 'common.animatebarprogress', [
    'templates'
  ]
  module.directive 'animateBarProgress', ($timeout)->
    restrict: "A"
    scope:
      animDelay: "="
      animWidth: "="
      animDuration: "="
      animEasing: "="
    link: ($scope, $element, $attrs) ->

      run = ()->
        $element.velocity(
          {width: "#{$scope.animWidth}%"},
          {
            easing: $scope.animEasing || 'linear'
            duration: $scope.animDuration || 400
            delay: $scope.animDelay || 0
            begin: begin
            complete: complete
          }
        )

      begin = ()->
      complete = ()->

      $timeout run, 100

