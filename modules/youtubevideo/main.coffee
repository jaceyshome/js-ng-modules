define [
  'angular'
], ->
  module = angular.module 'common.youtubevideo', []
  module.directive 'tntYoutubeVideo', ($timeout, Structure) ->
    restrict: "A"
    scope: {
      settings: "="
    }
    replace:true
    templateUrl: "common/youtubevideo/main"
    link: ($scope, $element, $attrs) ->
      $scope.videoPlayer = null
      $scope.videoPlayerId = null
      $scope.showVideo = false
      $scope.currentSize = ''
      videoConfig = null
      videoDefaultConfig =
        sizes:
          large: 600
          medium: 400
          small: 220
        rootPath:
          'https://www.youtube.com/embed/'
        options:
          autoplay: 1
          enablejsapi: 1
          showinfo: 0
          modestbranding: 0
          frameborder: 0
          rel: 0
          controls: 1

      init = ->
        #video settings can be override by data/structure.yml
        videoConfig = angular.extend(videoDefaultConfig, Structure.data.config.videoConfig)
        generateVideoPlayerId()
        $(window).resize resizeVideo
        updateCurrentSize($element.width())

      generateVideoPlayerId = ()->
        $scope.videoPlayerId = $scope.settings.playerId || 'player'
        $scope.videoPlayerId += $scope.$id
        $scope.videoPlayerId += $scope.settings.videoId || ''

      embedVideo = ->
        $scope.videoPlayer = new YT.Player $scope.videoPlayerId, {
          height: '100%'
          width: '100%'
          videoId: $scope.settings.videoId
          playerVars: videoConfig.options
          events:
            'onReady': onPlayerReady
            'onStateChange': onPlayerStateChange
        }

      resizeVideo = ->
        width =  $element.width() + 'px'
        height = ($element.width()/1280)*720+'px'
        $element.find(".videoPlayer").css height: height
        $element.find(".videoPlayer").css width: width
        $element.css height: height
        updateCurrentSize($element.width())
        $scope.$apply() if !$scope.$root.$$phase?
        return

      updateCurrentSize = (width)->
        if width >= videoConfig.sizes['large'] then return $scope.currentSize = 'large'
        if width >= videoConfig.sizes['medium'] then return $scope.currentSize = 'medium'
        if width >= videoConfig.sizes['small'] then return $scope.currentSize = 'small'
        return $scope.currentSize = 'small'

      playVideo = ->
        if $scope.videoPlayer
          $scope.videoPlayer.pauseVideo().seekTo(0).playVideo()
        else
          embedVideo()
        $scope.showVideo = true
        resizeVideo()
        return

      onPlayerReady = (event)->
        if event and event.target
          setInterval(updateytplayerInfo, 600)
          updateytplayerInfo()

      onPlayerStateChange = (event)->
        if event.data is 1 # playing
          $scope.showVideo = true unless $scope.showVideo
        if event.data is 0 # end
          $scope.showVideo = false
        $scope.$apply() if !$scope.$root.$$phase?

      updateytplayerInfo = ()->
        coverOnBeforeEndSeconds = 2
        if $scope.videoPlayer and $scope.showVideo
          if $scope.videoPlayer.getDuration() - $scope.videoPlayer.getCurrentTime() < coverOnBeforeEndSeconds
            $scope.showVideo = false
            $scope.$apply() if !$scope.$root.$$phase?

      $scope.handleClick = ()->
        if $element.width() < videoConfig.sizes.medium
          $scope.$emit('$popupVideo', $scope.settings)
        else
          playVideo()

      init()