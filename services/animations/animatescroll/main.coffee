define [
  'angular'
  'jquery'
], (angular)->
  module = angular.module 'common.animatescroll', []
  module.factory 'AnimateScroll', ()->

    service = {}

    service.scrollToElementTop = (customSettings) ->
      defaultSettings ={
        element : undefined
        runtime: 200
        offset: 0
        easing: "linear"
      }
      settings = {}
      angular.extend(settings, defaultSettings, customSettings)
      $("html, body").animate({
        scrollTop: settings.element.offset().top + settings.offset
      }, settings.runtime, settings.easing)
      undefined

    service.scrollToPagePosition = (position, runtime)->
      position = position || 0
      runtime = runtime || 100
      $("html, body").animate({scrollTop:position}, runtime)
      undefined

    service.calculateScrollRunTime = (toLocation=0,speed=0.1)->
      return parseInt(Math.abs($(document).scrollTop() - toLocation) * speed)

    service