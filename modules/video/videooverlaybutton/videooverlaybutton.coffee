define [
  'angular'
  'common/text/main'
  'common/animatespark/main'
], ->
  module = angular.module 'common.videooverlaybutton', [
    'templates'
    'common.text'
    'common.video'
    'common.animatespark'
  ]
  module.directive 'videoOverlayButton', (Video, $timeout)->
    restrict: "A"
    scope: {}
    templateUrl: "common/videooverlaybutton/main"
    replace: true
    link: ($scope, element, attrs) ->

      init = ()->
        $scope.currentButton = undefined

      showButtonPause = ()->
        $scope.currentButton = 'pause'

      showButtonPlay = ()->
        $scope.currentButton = 'play'

      $scope.playPause = ()->
        if Video.playing
          showButtonPause()
        else
          showButtonPlay()
        Video.playPause()

      init()

