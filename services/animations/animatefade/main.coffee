define [
  'angular'
  'angular_animate'
  'jquery'
  ], ->
  module = angular.module 'common.animatefade', [
    'ngAnimate'
  ]
  module.animation '.animate-fade', () ->
    enter: (element, done) ->
      jQuery(element).fadeIn(200, done)
      (cancelled)->
        jQuery(element).stop() if cancelled
    leave: (element, done) ->
      jQuery(element).fadeOut(100,done)
      (cancelled)->
        jQuery(element).stop() if cancelled
    move: (element, done) ->
      done()
    beforeAddClass: (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).fadeOut(200, done)
      else
        done()
      (cancelled)->
        jQuery(element).hide() if cancelled
    addClass: (element, className, done) ->
      done()
    beforeRemoveClass: (element, className, done) ->
      done()
    removeClass: (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).fadeIn(200, done)
      else
        done()
      (cancelled)->
        jQuery(element).show() if cancelled
    allowCancel: (element, event, className) ->
      true