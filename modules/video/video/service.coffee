define [
  'angular'
  'signals'
  ], (angular, signals)->
  module = angular.module 'common.video.service', []
  module.factory 'Video', ($q, $rootScope)->
    service = {
      #properties
      captions: null
      currentTime:null
      bufferedPercent:null
      duration:null
      volume:null
      muted:null
      playing:null
      firstPlay:null
      ready:false
      visible:false
      size:{
        width: 0
        height: 0
      }
      captionsVisible : false

      #methods (overwritten by video directive)
      setSrc:->
      setCaptions:->
      play:->
      pause:->
      playPause:->
      mute:->
      unmute:->
      muteUnmute:->
      setVolume:->
      setWidth:->
      setHeight:->
      seek:->
      requestFullScreen:->
      cancelFullScreen:->
      setVisible:->
      setAspectRatio:->
      resetAspectRatio:->
      skip:->
      hideOverlay: ->
      showOverlay: ->
      handleSafariVideoAutoPlay: ->
      handleIEVideoIssue: ->

      init:->
        deferred = $q.defer()
        $rootScope.$watch ->
          service.ready
        , (ready) ->
          deferred.resolve() if ready
        deferred.promise

      trimMaximizedVideo : (videoEle, ratio)->
        windowRatio = $(window).height() / $(window).width()
        if( ratio > windowRatio)
          width = $(window).width()
          height = width * ratio
          videoEle.css({'top': -( (height - $(window).height()) / 2)+"px"})
          videoEle.css({'left': 0})
        else
          offsetHeight  = 5
          height = ($(window).height()) - offsetHeight
          width =  Math.floor(height / ratio)
          videoEle.css({"margin": "auto"})
          videoEle.css({'top': 0})
          videoEle.css({'left': -( (width - $(window).width()) / 2)+"px"})
        return {width: width, height: height}

      scaleFixedSizeVideo : (videoEle, ratio)->
        windowRatio = $(window).height() / $(window).width()
        if( ratio <= windowRatio)
          width = videoEle.outerWidth()
          height = width * ratio
        else
          height = $(window).height()
          width =  Math.floor(height / ratio)
          videoEle.find("#videoPlayer").css({"margin": "auto"})
        return {width: width, height: height}

      #signals
      loadstart: new signals.Signal
      loadedmetadata: new signals.Signal
      loadeddata: new signals.Signal
      loadedalldata: new signals.Signal
      onPlay: new signals.Signal
      onPause: new signals.Signal
      timeupdate: new signals.Signal
      ended: new signals.Signal
      durationchange: new signals.Signal
      progress: new signals.Signal
      resize: new signals.Signal
      volumechange: new signals.Signal
      error: new signals.Signal
      fullscreenchange: new signals.Signal
    }
