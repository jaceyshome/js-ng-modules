define [
  'angular'
  'angular_animate'
  'jquery'
  ], ->
  module = angular.module 'common.animatespark', [
    'ngAnimate'
  ]
  module.animation '.animate-spark', () ->
    enter: (element, done) ->
      jQuery(element).fadeOut(400, done)
      done()
    leave: (element, done) ->
      done()
      true