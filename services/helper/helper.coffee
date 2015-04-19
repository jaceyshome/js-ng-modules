define [
  'angular'
], (angular)->
  module = angular.module 'common.helper', []
  module.factory 'Helper', ()->
    service = {}

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

    service.getViewportSize = ()->
      width : window.innerWidth or document.documentElement.clientWidth or document.body.clientWidth
      height : window.innerHeight or document.documentElement.clientHeight or document.body.clientHeight

    service.hex2rgb = (hex)->
      # Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
      shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i
      hex = hex.replace(shorthandRegex, (m, r, g, b) ->
        r + r + g + g + b + b
      )
      result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
      if result
        return "rgb("+parseInt(result[1], 16) + "," + parseInt(result[2], 16) + "," + parseInt(result[3], 16)+")"
      else
        return null

    service.rbg2hex = (r,g,b)->
      componentToHex = (c) ->
        hex = c.toString(16)
        if hex.length == 1 then '0' + hex else hex
      return '#' + componentToHex(r) + componentToHex(g) + componentToHex(b)

    service.rgb2rgba = (rgb,alpha)->
      return null unless rgb
      alpha = alpha || 1
      rgba = rgb.replace(/rgb/i, "rgba")
      return rgba.replace(/\)/i,",#{alpha})")

    service.getUrlQueryParams = ()->
      str = window.location.search
      params = {}
      str.replace new RegExp("([^?=&]+)(=([^&]*))?", "g"), ($0, $1, $2, $3) ->
        params[$1] = $3
        return
      #return object to get the key eg: params.id
      params

    service