define [
  'angular'
  'videojs'
  'modernizr'
  'common/video/service'
  'common/captions/main'
], ->

  checkBrowserVersion = (name)->
    return navigator.userAgent.search(name) > 0

  supports_h264 = () ->
    return false if !Modernizr.video
    Modernizr.video.h264

  iOSversion = () ->
    if (/iP(hone|od|ad)/.test(navigator.platform))
      #supports iOS 2.0 and later: <http://bit.ly/TJjs1V>
      v = (navigator.appVersion).match(/OS (\d+)_(\d+)_?(\d+)?/)
      return [parseInt(v[1], 10), parseInt(v[2], 10), parseInt(v[3] || 0, 10)]

  isIOS = (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i))
  isIOS6 = (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i)) && iOSversion()[0] <= 6
  isIOS7 = /iP(hone|od|ad)/.test(navigator.platform) && iOSversion()[0] == 7
  isIPad = !!navigator.userAgent.match(/iPad/i)

  module = angular.module 'common.video.directive', ['templates', 'common.captions']
  module.directive 'tntVideo', ($http, Video)->
    restrict:"A"
    scope:
      control:"="
      bufferFill:"@bufferFill"
    templateUrl:"common/video/main"
    link:($scope, element, attrs) ->
      floodingBuffer = false
      player = null
      preMutedVolume = null
      $parent = element.parent()
      _preFloodingVolume = null

      playPause = ->
        if player.paused()
          play()
        else
          pause()

      play = ->
        Video.hideOverlay()
        if $scope.flash
          element.find("#videoPlayer").toggleClass "hiddenVideo", true
        player.play()

      pause = ->
        player.pause()

      setSrc = (val)->
        if floodingBuffer && _preFloodingVolume != null
          setVolume _preFloodingVolume
          _preFloodingVolume = null
        floodingBuffer = false

        $scope.videoRatio = false
        if $scope.control
          $scope.control.firstPlay = true
          $scope.control.currentTime = 0
          $scope.control.bufferedPercent = 0
        if $scope.width? && $scope.height?
          $scope.videoWidth = parseInt($scope.width)
          $scope.videoHeight =  parseInt($scope.height)
          $scope.videoRatio = $scope.videoHeight/$scope.videoWidth
        #Jake: reload video on each time set src, and then on
        # player.on "loadedmetadata", reload video and resize the video size
        player.src { type: "video/mp4", src: val + "?hash=#{Math.random()*1000}" }

      floodBuffer = ->
        #Jake: it will break Ipad and IE8, make it real slow
        return
        if $scope.bufferFill?
          setSrc $scope.bufferFill
          _preFloodingVolume =  player.volume()
          setVolume 0.0
          floodingBuffer = true
          play()

      muteUnmute = ->
        if player.volume() is 0
          unmute()
        else
          mute()

      mute = ->
        preMutedVolume = player.volume()
        setVolume 0.0

      unmute = ->
        player.volume(preMutedVolume || 1.0)

      setVolume = (val)->
        player.volume val

      seek = (time) ->
        player.currentTime time

      skip = ->
        player.pause()
        if $scope.flash or (isIPad && isIOS7) then floodBuffer()
        $scope.control.ended.dispatch()

      requestFullScreen = ->
        player.requestFullScreen()

      cancelFullScreen = ->
        player.cancelFullScreen()

      setVisible = (val) ->
        $scope.visible = val
        $scope.control.visible = val
        if player?
          if val
            if isIOS6 && $.contains($parent[0], element[0]) is false
              $parent.prepend(element)
            element.show()
          else
            player.width 1
            player.height 1
            if isIOS6 && $.contains($parent[0], element[0])
              element.remove()
            #flash player needs a clear function to stop last frame carrying over
            #if $scope.flash
            #	player.tech.el_.vjs_stop()
            if $scope.flash or (isIPad && isIOS7) then floodBuffer()
        # SH - hack because on mobile reflow of page the video cannot resize immediatly for an unknown reason.
        #setTimeout resize, 0
        handleIpadTopOffset()
        return undefined

      showOverlay = (imageUrl)->
        element.find("#videoOverlay").css({
          'background-image': 'url(' + imageUrl + ')'
          '-ms-filter': "progid:DXImageTransform.Microsoft.AlphaImageLoader(src="+imageUrl+", sizingMethod='scale')"
          'filter' : "progid:DXImageTransform.Microsoft.AlphaImageLoader(src="+imageUrl+", sizingMethod='scale'"
        }, )
        element.find("#videoOverlay").show()

      hideOverlay = ()->
        element.find("#videoOverlay").css('background-image', 'none')
        element.find("#videoOverlay").hide()

      setVideoRatio = (val) ->
        $scope.videoRatio = val

      resize = ->
        ratio = $scope.videoRatio
        firstPlay = $scope.control.firstPlay
        if $scope.visible and not firstPlay and ratio
          data = Video.trimMaximizedVideo(element, ratio)
          #player width and height update
          player.width data.width
          player.height data.height
          #video width and height update
          element.find("video").width data.width
          element.find("video").height data.height
          #video overlay update
          element.find("#videoOverlay").width data.width
          element.find("#videoOverlay").height data.height
          element.find(".videoPending").width data.width

      handleSafariVideoAutoPlay = ()->
        if checkBrowserVersion("afari")
          #Jake: handle safari 7 fails to  first time autoplay fail
          # It will break IE8 and IE9
          Video.setVisible(false)
          Video.setSrc "assets/video/black.mp4"
          Video.play()
          Video.pause()

      handleIEVideoIssue = ()->
        return if $scope.flash
        element.find("video").width 1
        element.find("video").height 1
        return undefined

      setCaptions = (val)->
        Video.captions = val

      showCaptions = ()->
        $scope.control.captionsVisible = true if $scope.control?
        $scope.captionsVisible = true

      hideCaptions = ()->
        $scope.control.captionsVisible = false if $scope.control?
        $scope.captionsVisible = false

      resetAspectRatio = ->
        useGivenDimensions = false
        proposedWidth = 1
        proposedHeight = 1
        proposedAspect = 1

      handleIpadTopOffset = ->
        if(navigator.platform.indexOf("iPad") != -1)
          $(window).scrollTop(0)

      setAspectRatio = (w = 1, h = 1) ->
        # Aspect ratio only needs to be set if the browser is bugged
        # and can't get the video's width and height automatically
        # (ie native Android v4.1.2 browser)
        proposedWidth = w if !isNaN(parseInt(w)) and isFinite(w)
        proposedHeight = h if !isNaN(parseInt(h)) and isFinite(h)
        return unless proposedWidth? and proposedHeight?
        proposedAspect = proposedHeight / proposedWidth
        useGivenDimensions = true

      removeVjsLoadingSpinnerForIE = ()->
        #Jake: to resolved the problem of the spinner flashing on IE browsers for couple seconds
        element.find(".vjs-loading-spinner").remove()

      $scope.$watch "control", (val) ->
        $scope.control = val
        if val?
          val.setSrc = setSrc
          val.play = play
          val.pause = pause
          val.playPause = playPause
          val.setCaptions = setCaptions
          val.showCaptions = showCaptions
          val.hideCaptions = hideCaptions
          val.setAspectRatio = setAspectRatio
          val.resetAspectRatio = resetAspectRatio
          val.mute = mute
          val.unmute = unmute
          val.muteUnmute = muteUnmute
          val.forceResize = resize
          val.seek = seek
          val.requestFullScreen = requestFullScreen
          val.cancelFullScreen = cancelFullScreen
          val.setVisible = setVisible
          val.skip = skip
          val.showOverlay = showOverlay
          val.hideOverlay = hideOverlay
          val.handleSafariVideoAutoPlay = handleSafariVideoAutoPlay
          val.handleIEVideoIssue = handleIEVideoIssue

      initVideo = ->
        videojs.options.flash.swf = "assets/js/lib/video-js/video-js.swf"
        options = {
          techOrder: if supports_h264() then ["html5","flash"] else ["flash","html5"]
        }
        videojs("videoPlayer", options).ready ->
          $scope.player = player = this
          $scope.flash = player.techName is "Flash"
          if !$scope.visible
            player.width 1
            player.height 1
          if isIOS
            el = element.find("video")[0]
            el.addEventListener 'webkitendfullscreen', () ->
              if $scope.player? && $scope.player.paused
                $scope.control.ended.dispatch()
                $scope.$apply() if !$scope.$root.$$phase?
            , false

          player.on "loadstart", (e) ->
            if $scope.control?
              $scope.control.loadstart.dispatch()
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "loadedmetadata", (e) ->
            if !$scope.width? && !$scope.height?
              if $scope.flash
                $scope.videoWidth = player.techGet "videoWidth"
                $scope.videoHeight = player.techGet "videoHeight"
              else
                $scope.videoWidth = element.find("video").get(0).videoWidth
                $scope.videoHeight = element.find("video").get(0).videoHeight
                # SH - Hack to resolve issue that some browsers do not
                # have the correct videoHeight and videoWidth yet!
                $scope.$watch (()-> element.find("video").get(0).videoHeight), (val) ->
                  setVideoRatio val /  element.find("video").get(0).videoWidth
                $scope.$watch (()-> element.find("video").get(0).videoWidth), (val) ->
                  setVideoRatio element.find("video").get(0).videoHeight /  val
              $scope.videoRatio = $scope.videoHeight/$scope.videoWidth
            if $scope.control?
              $scope.control.duration = player.duration()
              $scope.control.width = player.width()
              $scope.control.height = player.height()
              $scope.control.loadedmetadata.dispatch()
              $scope.$apply() if !$scope.$root.$$phase?
            #Jake: important!, only call resize function on loaded metadata, and
            #video src must have hash code, so each time when set src, video will load
            #src again, and resize the video size from 1px * 1px to full size, to avoid
            #IE 9 and IE10 play last frames of previous video on playing new video
            setTimeout ->
              resize()
            , 0

          player.on "canplay", (e) ->


          player.on "canplaythrough", (e) ->
            if $scope.flash
              element.find("#videoPlayer").toggleClass "hiddenVideo", false

          player.on "loadeddata", (e) ->
            $scope.control.loadeddata.dispatch() if $scope.control?
            $scope.$apply() if !$scope.$root.$$phase?

          player.on "loadedalldata", (e) ->
            $scope.control.loadedalldata.dispatch() if $scope.control?
            $scope.$apply() if !$scope.$root.$$phase?

          player.on "play", (e) ->
            if $scope.control?
              $scope.control.playing = true
              $scope.control.firstPlay = false
              $scope.control.onPlay.dispatch()
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "pause", (e) ->
            if $scope.control?
              $scope.control.playing = false
              $scope.control.onPause.dispatch()
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "timeupdate", (e) ->
            if $scope.control?
              $scope.control.currentTime = player.currentTime()
              $scope.control.timeupdate.dispatch $scope.control.currentTime
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "ended", (e) ->
            if isIOS
              # Force player out of fullscreen
              el = element.find("video")[0]
              if el.exitFullScreen?
                el.exitFullScreen()
              else if el.webkitExitFullScreen?
                el.webkitExitFullScreen()
            if floodingBuffer
              $scope.$apply() if !$scope.$root.$$phase?
              return
            if $scope.control?
              $scope.control.ended.dispatch()
              $scope.$apply() if !$scope.$root.$$phase?
            if $scope.flash or (isIPad && isIOS7) then floodBuffer()

          player.on "durationchange", (e) ->
            if $scope.control?
              $scope.control.duration = player.duration()
              $scope.control.durationchange.dispatch $scope.control.duration
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "progress", (e) ->
            if $scope.control?
              #console.log player
              $scope.control.bufferedPercent = player.bufferedPercent()
              $scope.control.progress.dispatch $scope.control.bufferedPercent
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "resize", (e) ->
            $scope.control.resize.dispatch() if $scope.control?
            $scope.$apply() if !$scope.$root.$$phase?

          player.on "volumechange", (e) ->
            if $scope.control?
              $scope.control.volume = player.volume()
              $scope.control.muted = $scope.control.volume is 0
              $scope.control.volumechange.dispatch $scope.control.volume
              $scope.$apply() if !$scope.$root.$$phase?

          player.on "error", (e) ->
            $scope.control.error.dispatch() if $scope.control?
            $scope.$apply() if !$scope.$root.$$phase?

          player.on "fullscreenchange", (e) ->
            $scope.control.fullscreenchange.dispatch() if $scope.control?
            $scope.$apply() if !$scope.$root.$$phase?

          player.on "abort", (e) ->
            # 'Fix' Mac OSX Safari aborting all videos when flash isn't installed
            plyr = document.getElementsByTagName("video")[0]
            if plyr?
              plyr.load()
              plyr.play()

          $scope.control.ready = true
          $scope.$apply() if !$scope.$root.$$phase?
          removeVjsLoadingSpinnerForIE()

      $(window).resize resize
      initVideo()

