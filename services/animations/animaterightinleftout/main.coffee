define [
  'angular'
  'angular_animate'
  'jquery'
  'jquery_easing'
  ], ->
  module = angular.module 'common.animaterightinleftout', [
    'ngAnimate'
  ]
  module.animation '.animate-rightin-leftout', (Structure, Module, $rootScope) ->

    service = {}

    #Data key is used for sending the animation element for top interactive container
    sendEnteringElementToParentData = (dataKey, element)->
      return unless dataKey and element
      parentData = Structure.getDataFromKey(dataKey)
      parentData.currentTopInteractiveElement = element
      $rootScope.$apply() if !$rootScope.$root.$$phase?

    service.enter = (element, done) ->
      windowWidth = $(window).width()
      _easing = element.attr("data-anim-easing")
      _duration = element.attr("data-anim-duration") || 400
      _dataKey = element.attr("data-key") || null
      jQuery(element).css({right: "#{windowWidth}px"})
      element.velocity(
        {right: 0},
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
      _easing = element.attr("data-anim-easing")
      _duration = element.attr("data-anim-duration") || 400
      jQuery(element).css({right: "auto"})
      jQuery(element).css({left: "0"})
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
        jQuery(element).animate({right: '-100%'}, done)
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
        jQuery(element).animate({right: '0'}, done)
      else
        done()
      (cancelled)->
        jQuery(element).stop() if cancelled
    service.allowCancel = (element, event, className) ->
      true

    service