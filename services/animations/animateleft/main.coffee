define [
  'angular'
  'angular_animate'
  'jquery'
  'jquery_easing'
  ], ->
  module = angular.module 'common.animateleft', [
    'ngAnimate'
  ]
  module.animation '.animate-left', (Structure, Module, $rootScope) ->
    service = {}

    #Data key is used for sending the animation element for top interactive container
    sendEnteringElementToParentData = (dataKey, element)->
      return unless dataKey and element
      parentData = Structure.getDataFromKey(dataKey)
      parentData.currentTopInteractiveElement = element
      $rootScope.$apply() if !$rootScope.$root.$$phase?

    service.enter = (element, done) ->
      windowWidth = $(window).width()
      _easing = element.attr("data-anim-easing") || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      _dataKey = element.attr("data-key") || null
      jQuery(element).css({left: "#{windowWidth}px"})
      element.velocity(
        {left: 0},
        {
          easing: _easing
          duration: _duration
          begin: ()->
            sendEnteringElementToParentData(_dataKey, element)
          complete: done
        }
      )
      (cancelled)->
        jQuery(element).stop() if cancelled
    service.leave = (element, done) ->
      windowWidth = $(window).width()
      _easing = element.attr("data-anim-easing")  || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      element.velocity(
        {left: -windowWidth},
        {
          easing: _easing
          duration: _duration
          complete: done
        }
      )
      (cancelled)->
        jQuery(element).stop() if cancelled
    service.move = (element, done) ->
      done()
    service.beforeAddClass = (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).animate({left: '-100%'}, done)
      else
        done()
      (cancelled)->
        jQuery(element).stop() if cancelled
    service.addClass = (element, className, done) ->
      done()
    service.beforeRemoveClass = (element, className, done) ->
      done()
    service.removeClass = (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).animate({left: '0'}, done)
      else
        done()
      (cancelled)->
        jQuery(element).stop() if cancelled
    service.allowCancel = (element, event, className) ->
      true

    service

