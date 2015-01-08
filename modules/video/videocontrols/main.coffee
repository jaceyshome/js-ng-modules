define [
  'angular'
  'videojs'
  'common/video/main'
  'common/timecode/main'
  'common/mediaslider/main'
  'common/animatefade/main'
  'common/videooverlaybutton/main'
  ], ->
  module = angular.module 'common.videocontrols', [
    'templates'
    'common.timecode'
    'common.mediaslider'
    'common.video.service'
    'common.scenario.service'
    'common.animatefade'
    'common.videooverlaybutton'
  ]
  module.directive 'tntVideoControls', (Video, Scenario) ->
    restrict:"A"
    scope:
      control:"="
    templateUrl: "common/videocontrols/main"
    link:($scope, element, attrs) ->
      $scope.Scenario = Scenario
      $scope.Video = Video
      $scope.videoIsPlaying = ()->
        if Video.playing
          $scope.videoOverlayBtnText = "pause"
        else
          $scope.videoOverlayBtnText = "play"
        return Video.playing
      $scope.pause = () ->
        Video.pause.apply Video, arguments
        console.log Video
      $scope.play = () ->
        Video.play.apply Video, arguments
      $scope.playPause = () ->
        Video.playPause.apply Video, arguments
      $scope.mute = () ->
        Video.mute.apply Video, arguments
      $scope.unmute = () ->
        Video.unmute.apply Video, arguments
      $scope.muteUnmute = () ->
        Video.muteUnmute.apply Video, arguments
      $scope.seek = () ->
        Video.seek.apply Video, arguments
      $scope.replay = ()->
        Scenario.replaySection()
      $scope.restartScenario = ()->
        Video.pause()
        Video.seek(0)
        $scope.Scenario.restart()

      $scope.requestFullScreen = () ->
        Video.requestFullScreen.apply Video, arguments
      $scope.cancelFullScreen = () ->
        Video.cancelFullScreen.apply Video, arguments
      $scope.skip = () ->
        Video.pause()
        Scenario.handleVideoEnd()
#        Video.skip.apply Video, arguments
      $scope.showCaptions = () ->
        Video.showCaptions.apply Video, arguments
      $scope.hideCaptions = () ->
        Video.hideCaptions.apply Video, arguments
      $scope.setFocusOnBtn = (btnClass)->
        setTimeout(()->
          element.find(btnClass).focus()
        ,20)
      $scope.$watch (()-> Video.playing), ((val)->
        $scope.playing = val), true
      $scope.$watch (()-> Video.muted), ((val)->
        $scope.muted = val), true
      $scope.$watch (()-> Video.currentTime), ((val)->
        $scope.currentTime = val), true
      $scope.$watch (()-> Video.duration), ((val)->
        $scope.duration = val), true
      $scope.$watch (()-> Video.bufferedPercent), ((val)->
        $scope.bufferedPercent = val), true
      $scope.$watch (()-> Video.firstPlay), ((val)->
        $scope.firstPlay = val), true
      $scope.$watch (()-> Video.captionsVisible), ((val)->
        $scope.captionsVisible = val), true
