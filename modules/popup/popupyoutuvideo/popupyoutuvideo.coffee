define [
  'angular'
], ->
  module = angular.module 'common.popupyoutuvideo', []
  module.directive 'popupYoutuVideo', ($timeout, Structure, $rootScope) ->
    restrict: "A"
    scope: {
      settings:"="
    }
    templateUrl: "common/popup/popupyoutuvideo/popupyoutuvideo"
    link: ($scope, $element, $attrs) ->
      $scope.video = null
      defaultConfig =
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

      init = () ->
        registerListeners()

      registerListeners = ()->
        $rootScope.$on("$popupVideo", popup)

      popup = (e, data)->
        #video settings can be override by data/structure.yml
        $scope.video = angular.extend(defaultConfig, data)
        setupVideo()
        $(window).resize resizeVideo
        $timeout playVideo, 10

      setupVideo = ->
        $scope.video.src = generateVideoSrc($scope.video)
        ###unless $scope.video.src
          $scope.video.src = generateVideoSrc($scope.video)
        return###

      generateVideoSrc = (video)->
        paramKey = '&'
        url = video.rootPath
        options = video.options
        return url+video.videoId+'/?'+options.join(paramKey)

      playVideo = ->
        $element.find(".videoPlayer").append appendContent()
        resizeVideo()
        return

      appendContent = ->
        return "<iframe id='"+$scope.video.playerId+'pupup'+
        "' width=\"100%\" height=\"100%\" src="+$scope.video.src+
        " allowfullscreen></iframe>"

      resizeVideo = ->
        borderSide = 5
        width =  $element.find(".videoPlayer").width()
        height = (width/1920)*1080 + borderSide*2
        $element.find(".videoPlayer").css height: height+'px'
        return

      $scope.close = ->
        if typeof $scope.video?.handleClose is 'function'
          $scope.video?.handleClose()
        $scope.video = null

      init()
