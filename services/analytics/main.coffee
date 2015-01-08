define [
  'angular'
  ], ->
  module = angular.module 'common.analytics', []
  module.factory 'Analytics', ($q)->
    init: (code, callback) ->
      deferred = $q.defer()
      #console.log "pipwerks", pipwerks
      ((i, s, o, g, r, a, m) ->
        i["GoogleAnalyticsObject"] = r
        i[r] = i[r] or ->
          (i[r].q = i[r].q or []).push arguments
          return

        i[r].l = 1 * new Date()

        a = s.createElement(o)
        m = s.getElementsByTagName(o)[0]

        a.async = 1
        a.src = g
        m.parentNode.insertBefore a, m
        return
      ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"
      ga "create", code, "auto"
      ga "send", "pageview"
      deferred.resolve
      if callback
        deferred.promise.then callback
      deferred.promise

    trackEvent: (category, action, label, value, nonInteraction)->
      ga 'send', 'event', category, action, label, value, nonInteraction