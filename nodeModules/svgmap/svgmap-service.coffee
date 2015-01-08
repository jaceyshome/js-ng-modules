define [
  'angular'
  'data'
], (angular, data)->
  module = angular.module 'common.svgmap.service', []
  module.factory 'SVGMapService', ($http,$q)->

    service = {}
    service.width = 1024
    service.height = 660
    service.paper = null
    service.data = data
    service