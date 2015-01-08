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
      $scope.videoPlay = false
      $scope.currentSize = ''
      videoConfig = null
      videoDefaultConfig =
        sizes:
          large: 600
          medium: 400
          small: 220
        rootPath:
          'https://www.youtube.com/embed/'
        options: [
          'autoplay=1'
          'controls=1'
          'enablejsapi=1'
          'modestbranding=1'
          'rel=0'
          'showinfo=0'
          'wmode=opaque'
          'frameborder=0'
        ]

      init = ->
        #video settings can be override by data/structure.yml
        videoConfig = angular.extend(videoDefaultConfig, Structure.data.config.videoConfig)
        initVideo()
        $(window).resize resizeVideo
        updateCurrentSize($element.width())

      initVideo = ->
        unless $scope.settings.src
          $scope.settings.src = generateVideoSrc($scope.settings.videoId)
        return

      generateVideoSrc = (videoId)->
        paramKey = '&'
        url = videoConfig.rootPath
        options = videoConfig.options
        return url+videoId+'/?'+options.join(paramKey)

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
        $element.find(".videoPlayer").append appendContent()
        resizeVideo()
        return

      appendContent = ->
        return "<iframe id='"+$scope.settings.playerId+
        "' width=\"100%\" height=\"100%\" src="+$scope.settings.src+
        " allowfullscreen></iframe>"

      $scope.handleClick = ()->
        if $element.width() < videoConfig.sizes.medium
          $scope.$emit('$popupVideo', $scope.settings)
        else
          playVideo()
          $timeout ()->
            $scope.videoPlay = true
          , 500

      init()