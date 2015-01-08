define [
  'angular'
  'raphael'
  'raphael_scale'
], ->
  module = angular.module 'common.svgmap.directive', [
    'templates'
    'common.svgmap.service'
  ]
  module.directive 'svgMap', (SVGMapService, JournalService)->
    restrict: "A"
    scope: {
      handleMouseClick:"="
      handleMouseHover:"="
      handleMouseOut:"="
    }
    templateUrl: "common/svgmap/svgmap"
    replace: true
    link: ($scope, element, attrs) ->
      locationSet = []
      waveSet = null
      bgSet = null

      init = ()->
        $scope.data = SVGMapService.data
        SVGMapService.paper = ScaleRaphael('mapHolder', SVGMapService.width, SVGMapService.height)
        setMap()

      setMap = ->
        setBackground()
        setWaves()
        setLocations()

      setBackground = ->
        bgSet = createPathSet(SVGMapService.data.svg_map)

      setWaves = ->
        waveSet = createPathSet(SVGMapService.data.svg_waves)
        anim = Raphael.animation({opacity:0}, 1000).repeat(Infinity).delay(10)
        waveSet.animate(anim)

      setLocations = ->
        locationSet = createPathSet(SVGMapService.data.svg_location2)
        data = getPathData(SVGMapService.data.svg_location2)
        registerPaperElementEventListeners(locationSet, data)

      createPathSet = (paths)->
        paper = SVGMapService.paper
        set = paper.set()
        for path in paths
          if path.type is 'path'
            attr =
              fill: path.fill
              stroke: path.stroke
            paperPath = paper.path(path.path)
            paperPath.attr(attr)
            set.push paperPath
        return set

      getPathData = (paths)->
        for journal in JournalService.journals
          if SVGMapService.data[journal.location] is paths
            return journal

      addGlow = (ele)->
        attr =
          width: 1
          fill: false
          opacity: 0.5
          offsetx: 0.5
          offsety: 0.5
          color: 'white'
        ele.glow(attr)

      registerPaperElementEventListeners = (ele, data)->
        eleGlow = null
        ele.mouseover((e)->
          element.css('cursor', 'pointer')
          eleGlow = addGlow(ele) unless eleGlow
          if(typeof $scope.handleMouseHover is 'function')
            $scope.handleMouseHover(data)
        )
        ele.mouseout((e)->
          element.css('cursor', 'default')
          eleGlow.remove() if eleGlow
          eleGlow = null
          if(typeof $scope.handleMouseOut is 'function')
            $scope.handleMouseOut(data)
        )
        ele.mouseup((e)->
          if(typeof $scope.handleMouseClick is 'function')
            $scope.handleMouseClick(data)
        )

      init()