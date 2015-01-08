define [
  'angular'
  'raphael'
  'raphael_scale'
], ->
  module = angular.module 'common.svgmap.directive', [
    'templates'
    'common.svgmap.service'
  ]
  module.directive 'svgMap', (SVGMapService)->
    restrict: "A"
    scope: {
      handleMouseClick:"="
      handleMouseHover:"="
      handleMouseOut:"="
    }
    templateUrl: "common/svgmap/svgmap"
    link: ($scope, element, attrs) ->
      console.log "here"
    #-------------------------------------------private variables
      defaultSettings =
        width: 207
        height: 200
        curMapX: 0
        curMapY: 0
      mapContainer = null
      mapPaths = []
    #-------------------------------------------public variables

    #-------------------------------------------private functions
      init = ()->
        $scope.data = SVGMapService.data
        createMap()

      createMap = ->
        mapContainer = ScaleRaphael('container', defaultSettings.width, defaultSettings.height)
        createMapPaths()
        resizeMap()

      createMapPaths = ->
        opacity = 1 #for testing, make it 1
        attributes =
          fill: '#d9d9d9',
          'fill-opacity': opacity,
          cursor: 'pointer',
          stroke: '#BF2400',
          'stroke-opacity': opacity,
          'stroke-width': 0.5,
          'stroke-linejoin': 'round'
        for path in $scope.data.paths
          mapPath = mapContainer.path(path.path)
          mapPath.attr(attributes)
          mapPath.data = {id: path.id}
          registerMapPathEventListeners(mapPath)
          mapPaths.push mapPath

      registerMapPathEventListeners = (path)->
        path.mouseover((e)->
          if(typeof $scope.handleMouseHover is 'function')
            $scope.handleMouseHover(path.data)
        )
        path.mouseout((e)->
          if(typeof $scope.handleMouseOut is 'function')
            $scope.handleMouseOut(path.data)
        )
        path.mouseup((e)->
          if(typeof $scope.handleMouseClick is 'function')
            $scope.handleMouseClick(path.data)
        )

      resizeMap = ->
        undefined

      #-------------------------------------------public functions


      #------------------------------------------- init()
      SVGMapService.init(init)
