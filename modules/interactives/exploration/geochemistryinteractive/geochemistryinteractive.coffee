define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.exploration.geochemistryinteractive', []
  module.directive 'geoChemistryInteractive', ($sce, Module, Structure, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/exploration/geochemistryinteractive/geochemistryinteractive"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables
      $scope.showFirstTooltip = true
      $scope.showOverlay = false
      $scope.Module = Module
      $scope.Structure = Structure

      # -------------------------------------------------------------------------------- Private Variables
      defaultSettings =
        startX: 0
        startY: 0
        width: 602
        height: 542

      dotSettings =
        rowNumber: 12
        columnNumber: 14
        nomralDotRadius: 3
        dotMarginX: 32
        dotMarginY: 32
        dotStartX: 38
        dotStartY: 51

      overlayPath = "M 49.8,407.6 182.7,537.4 464.1,251.1 331.2,120.6 z"

      rangeSettings = [
        {
          id: 0
          r: dotSettings.nomralDotRadius,
          attributes:
            fill: 'none',
            stroke: '#dddddd',
            'stroke-width': 1
        },
        {
          id: 1
          r: 4,
          attributes:
            fill: '#8c5ff0',
            stroke: '#8c5ff0',
            'stroke-width': 1
        },
        {
          id: 2
          r: 6,
          attributes:
            fill: '#72a8f2',
            stroke: '#72a8f2',
            'stroke-width': 1
        },
        {
          id: 3
          r: 9,
          attributes:
            fill: '#9ee146',
            stroke: '#9ee146',
            'stroke-width': 1
        },
        {
          id: 4
          r: 11,
          attributes:
            fill: '#ebd833',
            stroke: '#ebd833',
            'stroke-width': 1
        },
        {
          id: 5
          r: 14,
          attributes:
            fill: '#edad63',
            stroke: '#edad63',
            'stroke-width': 1
        },
        {
          id: 6
          r: 17,
          attributes:
            fill: '#f25e5e',
            stroke: '#f25e5e',
            'stroke-width': 1
        },
      ]
          
      container = null
      dots = []
      overlayImage = undefined


      # -------------------------------------------------------------------------------- init
      init = () ->
        createMap()
        createMapPaths()
        if $scope.settings.ranges?
          for range in $scope.settings.ranges
            range.selected = false


      # -------------------------------------------------------------------------------- $scope Functions
      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.showRangeDots = (range) ->
        $scope.showFirstTooltip = false if $scope.showFirstTooltip == true
        if range.selected != true
          for row, rowIndex in $scope.settings.matrix.rows
            for number, columnIndex in row.array
              if number == range.id + 1
                dots[rowIndex][columnIndex].attr rangeSettings[number].attributes
                dots[rowIndex][columnIndex].animate {"r": rangeSettings[number].r}, 500, "ease-in-out"
          range.selected = true
        else
          for row, rowIndex in $scope.settings.matrix.rows
            for number, columnIndex in row.array
              if number == range.id + 1
                callback = () ->
                  this.attr rangeSettings[0].attributes
                dots[rowIndex][columnIndex].animate {"r": rangeSettings[0].r}, 300, "ease-in-out", callback
          range.selected = false
        for iRange in $scope.settings.ranges
          if iRange.selected == false
            $scope.showOverlay = false
            overlayImage.animate {"opacity": 0}, 500, "ease-in-out"
            return
        $scope.showOverlay = true
        overlayImage.animate {"opacity": 1}, 500, "ease-in-out"
        handleCompletedState()
        return

      $scope.reset = () ->
        $scope.showOverlay = false
        overlayImage.animate {"opacity": 0}, 500, "ease-in-out"
        if $scope.settings.ranges?
          for range in $scope.settings.ranges
            for row, rowIndex in $scope.settings.matrix.rows
              for number, columnIndex in row.array
                if number == range.id + 1
                  callback = () ->
                    this.attr rangeSettings[0].attributes
                  dots[rowIndex][columnIndex].animate {"r": rangeSettings[0].r}, 300, "ease-in-out", callback
            range.selected = false


      

      # -------------------------------------------------------------------------------- Private Functions
      createMap = () ->
        container = new Raphael('geochemistry-interactive-svg-container'+$scope.$id, defaultSettings.width, defaultSettings.height)
        container.setViewBox(defaultSettings.startX, defaultSettings.startY, defaultSettings.width, defaultSettings.height, true)

      createMapPaths = () ->
        for i in [0..dotSettings.rowNumber-1]
          dotsRow = []
          for j in [0..dotSettings.columnNumber-1]
            dotX = dotSettings.dotStartX + j*(dotSettings.dotMarginX + 2*(dotSettings.nomralDotRadius+1))
            dotY = dotSettings.dotStartY + i*(dotSettings.dotMarginY + 2*(dotSettings.nomralDotRadius+1))
            dot = container.circle(dotX, dotY, dotSettings.nomralDotRadius)
            dot.attr rangeSettings[0].attributes
            dotsRow.push dot
          dots.push dotsRow
        overlayImage = container.image("assets/images/exploration/interactives/geochemistryinteractive/overlay.png", 0, 0, defaultSettings.width, defaultSettings.height)
        overlayImage.attr('opacity': 0)

      handleCompletedState = ()->
        return if $scope.settings.completed is true
        for range in $scope.settings.ranges
          return if range.selected isnt true
        $scope.settings.completed = true

      ###registerMapPathEventListeners = (zone)->
        zone.path.mouseover((e)->
          console.log "mouseover"
        )
        zone.path.mouseout((e)->
          console.log "mouseout"
        )
        zone.path.mouseup((e)->
          console.log "mouseup"
        )###

      # -------------------------------------------------------------------------------- Handler Functions

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      $timeout ->
        init()
      , 200