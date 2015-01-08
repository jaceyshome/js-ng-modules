define [
  'angular'
], (angular)->
  module = angular.module 'common.helper', []
  module.factory 'Helper', ()->
    service = {}

    service.getViewportSize = ()->
      width : window.innerWidth or document.documentElement.clientWidth or document.body.clientWidth
      height : window.innerHeight or document.documentElement.clientHeight or document.body.clientHeight

    service.colorLuminance = (hex, lum)->
      # validate hex string
      rgb = "#"
      hex = String(hex).replace(/[^0-9a-f]/gi, '')
      if (hex.length < 6)
        hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2]
      lum = lum || 0
      # convert to decimal and change luminosity
      for i in [0..2] by 1
        c = parseInt(hex.substr(i*2,2), 16)
        c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16)
        rgb += ("00"+c).substr(c.length)
      rgb

    service.parseUrlString = ()->
      str = window.location.search
      params = {}
      str.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"), ($0, $1, $2, $3) ->
        params[$1] = $3
        return
      #return object to get the key eg: params.id
      params

    service