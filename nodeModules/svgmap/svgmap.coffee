define [
  'angular'
  'common/svgmap/svgmap-directive'
  'common/svgmap/svgmap-service'
], ()->
  module = angular.module 'common.svgmap', [
    'templates'
    'common.svgmap.service'
    'common.svgmap.directive'
  ]
