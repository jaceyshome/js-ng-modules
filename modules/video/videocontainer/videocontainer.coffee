define [
  'angular'
  'videojs'
  'modernizr'
  'common/video/main'
  'common/captions/main'
  'common/videocontrols/main'
  'common/scenario/main'
  ], ->

  module = angular.module 'common.videocontainer', [
    'templates',
    'common.captions'
    'common.videocontrols'
    'common.video'
    'common.scenario'
  ]
  module.directive 'videoContainer', (Video, Scenario)->
    restrict:"A"
    scope:
      control:"="
    templateUrl:"common/videocontainer/main"
    link:($scope, element, attrs) ->
      $scope.Video = Video
      $scope.Scenario = Scenario


