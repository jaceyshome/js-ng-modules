define [
  'angular'
  'angular_animate'
  'jquery'
  ], ->
  module = angular.module 'common.animateslide', [
    'ngAnimate'
  ]
  module.animation '.animate-slide', () ->
    enter: (element, done) ->
      jQuery(element).slideDown(done)
      (cancelled)->
        jQuery(element).stop() if cancelled
    leave: (element, done) ->
      jQuery(element).slideUp(done)
      (cancelled)->
        jQuery(element).stop() if cancelled
    move: (element, done) ->
      done()
    beforeAddClass: (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).slideUp(done)
      else
        done()
      (cancelled)->
        jQuery(element).stop() if cancelled
    addClass: (element, className, done) ->
      done()
    beforeRemoveClass: (element, className, done) ->
      done()
    removeClass: (element, className, done) ->
      if className is "ng-hide"
        jQuery(element).slideDown(done)
      else
        done()
      (cancelled)->
        jQuery(element).stop() if cancelled
    allowCancel: (element, event, className) ->
      true