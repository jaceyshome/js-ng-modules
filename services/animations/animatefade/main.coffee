define [
  'angular'
  'angular_animate'
  'jquery'
  ], ->
  module = angular.module 'common.animatefade', [
    'ngAnimate'
  ]
  module.animation '.animate-fade', () ->
    service = {}

    fadeIn = (element, done)->
      _easing = element.attr("data-anim-easing") || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      _delay = element.attr("data-anim-in-delay") || false
      element.css({opacity:0})
      element.velocity(
        {
          opacity:1
        },
        {
          easing: _easing
          duration: _duration
          complete: done
          delay: _delay
          queue: false
        }
      )

    fadeOut = (element, done)->
      _easing = element.attr("data-anim-easing") || 'linear'
      _duration = element.attr("data-anim-duration") || 400
      _delay = element.attr("data-anim-out-delay") || false
      element.css({opacity:1})
      element.velocity(
        {
          opacity: 0
        },
        {
          easing: _easing
          duration: _duration
          complete: done
          delay: _delay
          queue: false
        }
      )

    service.enter = (element, done)->
      fadeIn(element,done)
      (cancelled)->
        element.velocity("stop") if cancelled

    service.leave = (element, done)->
      fadeOut(element,done)
      (cancelled)->
        element.velocity("stop") if cancelled

    service.move = (element, done) ->
      done()

    service.beforeAddClass = (element, className, done) ->
      if className is "ng-hide"
        fadeOut(element,done)
      else
        done()
      (cancelled)->
        jQuery(element).hide() if cancelled

    service.addClass = (element, className, done) ->
      done()

    service.beforeRemoveClass = (element, className, done) ->
      done()

    service.removeClass = (element, className, done) ->
      if className is "ng-hide"
        fadeIn(element,done)
      else
        done()
      (cancelled)->
        jQuery(element).show() if cancelled

    service.allowCancel = (element, event, className) ->
      true

    service
