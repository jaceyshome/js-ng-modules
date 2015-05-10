define [
  'angular'
  'angular_animate'
  'jquery'
  'jquery_easing'
  ], ->
  module = angular.module 'common.animateprogress', [
    'ngAnimate'
  ]
  module.animation '.animate-progress', (Structure, Module, $rootScope) ->
    service = {}

    #Data key is used for sending the animation element for top interactive container
    sendEnteringElementToParentData = (dataKey, element)->
      return unless dataKey and element
      parentData = Structure.getDataFromKey(dataKey)
      parentData.currentTopInteractiveElement = element
      $rootScope.$apply() if !$rootScope.$root.$$phase?

    service.enter = (element, done) ->
      _easing = element.attr("data-anim-easing") || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      _dataKey = element.attr("data-key") || null
      _delay = element.attr("data-anim-enter-delay") || 0
#      FIXME: _width can not set default value
      _width = element.attr("data-anim-width") || 97
      if _width > 0 and _width < 1
        _width =  _width * 100
      jQuery(element).css({width: "0"})
      element.velocity(
        {width: "#{_width}%"},
        {
          easing: _easing
          duration: _duration
          delay: _delay
          begin: ()->
            sendEnteringElementToParentData(_dataKey, element)
          complete: done
        }
      )
      (cancelled)->
        jQuery(element).stop() if cancelled

    service.leave = (element, done) ->
      _easing = element.attr("data-anim-easing")  || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      _delay = element.attr("data-anim-leave-delay") || 0
      element.velocity(
        {width: 0},
        {
          easing: _easing
          duration: _duration
          delay: _delay
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

