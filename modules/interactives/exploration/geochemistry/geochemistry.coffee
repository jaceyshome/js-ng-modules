define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.exploration.geochemistry', []
  module.directive 'geoChemistry', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/exploration/geochemistry/geochemistry"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables
      $scope.screen = undefined
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.zone = undefined

      # -------------------------------------------------------------------------------- Private Variables
      imageRootSrc = "assets/images/exploration/interactives/geochemistry/"

      defaultSettings =
        startX: 0
        startY: 0
        width: 964
        height: 542


      dotSettings =
        rowNumber: 11
        columnNumber: 9
        nomralDotRadius: 3
        dotMarginX: 30
        dotMarginY: 30
        dotStartX: 9
        dotStartY: 35

      leftRangePanelSettings =
        startX: 0
        startY: 0
        width: 195
        height: defaultSettings.height
        attributes:
          fill: "#f3f2ee"
          'stroke-width': 0
        dotStartX: 38
        dotStartY: 68
        textStartX: 80

      locationASettings =
        attributes:
          'opacity': 1
          width: 86
          height: 113
          x: 416.0968
          y: 74.1936
        animateAttributes:
          'opacity': 0
          width: 329
          height: 458
          x: 232
          y: 26
        animateWithDotsAttributes:
          'opacity': 1
          width: 329
          height: 458
          x: 232
          y: 26

      locationBSettings =
        attributes:
          'opacity': 1
          width: 86
          height: 113
          x: 521.2258
          y: 219.871
        animateAttributes:
          'opacity': 0
          width: 329
          height: 458
          x: 599
          y: 26
        animateWithDotsAttributes:
          'opacity': 1
          width: 329
          height: 458
          x: 599
          y: 26

      rangeSettings = [
        {
          id: 0
          text: "0"
          attributes:
            r: dotSettings.nomralDotRadius,
            fill: 'none',
            stroke: '#bfbfbd',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
        {
          id: 1
          text: "0-5"
          attributes:
            r: 4,
            fill: '#8c5ff0',
            'fill-opacity': 0,
            stroke: '#8c5ff0',
            'stroke-width': 1,
            'stroke-opacity': 0
        },
        {
          id: 2
          text: "5-10"
          attributes:
            r: 6,
            fill: '#72a8f2',
            stroke: '#72a8f2',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
        {
          id: 3
          text: "10-20"
          attributes:
            r: 9,
            fill: '#9ee146',
            stroke: '#9ee146',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
        {
          id: 4
          text: "20-50"
          attributes:
            r: 11,
            fill: '#ebd833',
            stroke: '#ebd833',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
        {
          id: 5
          text: "50-100"
          attributes:
            r: 14,
            fill: '#edad63',
            stroke: '#edad63',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
        {
          id: 6
          text: "100-500"
          attributes:
            r: 17,
            fill: '#f25e5e',
            stroke: '#f25e5e',
            'stroke-width': 1,
            'fill-opacity': 0,
            'stroke-opacity': 0
        },
      ]

      textSettings =
        attributes:
          "font-family": "MyriadProSemibold"
          "font-size": "14px"
          "text-anchor": "start"

      leftBottomTextSettings =
        attributes:
          "font-family": "MyriadProSemibold"
          "font-size": "14px"
          "text-anchor": "middle"
          "fill": "#008396"

      dotsPanelSettings =
        attributes:
          fill: '#e8e6de'
          'stroke-width': 0
          'fill-opacity': 0

      dotsBgSettings =
        attributes:
          fill: '#e8e6de'
          'stroke-width': 0
          'fill-opacity': 0

      dotsChangeSettings =
        attributes:
          'stroke-opacity': 1
          'fill-opacity': 1
          
      imageContainer = undefined
      bgImage = undefined
      borderImage = undefined
      locationA = undefined
      locationB = undefined
      locationAWithDots = undefined
      locationBWithDots = undefined
      dotsPanel = undefined
      leftDotsPanel = undefined
      dots = []
      leftDots = []
      rightDots = []
      leftDotsBg = undefined
      rightDotsBg = undefined
      locationAText = undefined
      locationBText = undefined
      locationATextBorder = undefined
      locationBTextBorder = undefined
      leftRangePanel = undefined
      leftPanelContent = []
      leftBottomText1 = undefined
      leftBottomText2 = undefined


      # -------------------------------------------------------------------------------- init
      init = () ->
        if $scope.settings.zones?
          for zone in $scope.settings.zones
            zone.hover = false
            zone.selected = false
        if $scope.settings.screens?
          for screen, index in $scope.settings.screens
            screen.feedback = false
        $scope.screen = $scope.settings.screens[0]
        createMap()
        createImageContainerImages()
        createDotsPanel()
        $timeout initTopContainerHeight, 200
        #createRightDotsPanel()

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.goToChemistryView = () ->
        $scope.screen = $scope.settings.screens[1]
        animateImages()

      $scope.reset = () ->
        if $scope.settings.zones?
          for zone in $scope.settings.zones
            zone.hover = false
            zone.selected = false
            zone.image.remove()
        if $scope.settings.screens?
          for screen, index in $scope.settings.screens
            screen.feedback = false
        $scope.screen = $scope.settings.screens[0]
        callbackForLocationResetAnimation = () ->
          borderImage.show()
          locationAText.remove()
          locationBText.remove()
          locationATextBorder.remove()
          locationBTextBorder.remove()
          leftBottomText1.remove()
          leftBottomText2.remove()
        callbackForResetAnimation = () ->
          this.remove()
        $timeout ->
          locationA.show()
          locationB.show()
          locationA.animate locationASettings.attributes, 1200, "ease-in-out", callbackForLocationResetAnimation
          locationB.animate locationBSettings.attributes, 1200, "ease-in-out"
          locationAWithDots.animate locationASettings.attributes, 1200, "ease-in-out", callbackForResetAnimation
          locationBWithDots.animate locationBSettings.attributes, 1200, "ease-in-out", callbackForResetAnimation
          dotsPanel.animate {'fill-opacity': 0}, 1200, "ease-in-out"
          bgImage.show()
          leftRangePanel.remove()
          for item in leftPanelContent
            item.remove()
        , 50

      # -------------------------------------------------------------------------------- Private Functions
      createMap = () ->
        imageContainer = new Raphael('geochemistry-svg-container'+$scope.$id, defaultSettings.width, defaultSettings.height)
        imageContainer.setViewBox(defaultSettings.startX, defaultSettings.startY, defaultSettings.width, defaultSettings.height, true)

      createDotsPanel = () ->
        dotsPanel = imageContainer.rect(defaultSettings.startX, defaultSettings.startY, defaultSettings.width, defaultSettings.height)
        dotsPanel.attr dotsPanelSettings.attributes

      createRightDotsPanel = () ->
        createDots($scope.settings.matrix.locationA.rows, 'left')
        createDots($scope.settings.matrix.locationB.rows, 'right')

      createDots = (rows, side) ->
        startX = 0
        startY = locationASettings.animateWithDotsAttributes.y
        if side == 'right'
          startX = locationBSettings.animateWithDotsAttributes.x
        else
          startX = locationASettings.animateWithDotsAttributes.x
        for row, rowIndex in rows
          dotsRow = []
          for item, columnIndex in row.array
            dotX = dotSettings.dotStartX + columnIndex*(dotSettings.dotMarginX + 2*(dotSettings.nomralDotRadius+1)) + startX
            dotY = startY + dotSettings.dotStartY + rowIndex*(dotSettings.dotMarginY + 2*(dotSettings.nomralDotRadius+1))
            dot = imageContainer.circle(dotX, dotY, dotSettings.nomralDotRadius)
            dot.attr rangeSettings[item].attributes
            dotsRow.push dot
          if side == 'right'
            rightDots.push dotsRow
          else
            leftDots.push dotsRow

      drawZones = () ->
        for zone in $scope.settings.zones
          zone.image = imageContainer.image(imageRootSrc+zone.normalSrc, zone.x, zone.y, zone.width, zone.height)
          zone.image.attr {cursor: 'pointer'}
          registerMapPathEventListeners(zone)

      drawRightPanelTexts = () ->
        locationAText = imageContainer.text(350, 516, "Location A")
        locationBText = imageContainer.text(350+367, 516, "Location B")
        locationAText.attr textSettings.attributes
        locationBText.attr textSettings.attributes
        locationATextBorder = imageContainer.path("M317,491h156H317z")
        locationATextBorder.attr {stroke: '#bfbfbd'}
        locationBTextBorder = imageContainer.path("M683,491h155H683z")
        locationBTextBorder.attr {stroke: '#bfbfbd'}

      createLeftPanel = () ->
        leftRangePanel = imageContainer.rect(leftRangePanelSettings.startX, leftRangePanelSettings.startY, leftRangePanelSettings.width, leftRangePanelSettings.height)
        leftRangePanel.attr leftRangePanelSettings.attributes
        for range, index in rangeSettings
          continue if index == 0
          rangeDotX = leftRangePanelSettings.dotStartX
          rangeDotY = leftRangePanelSettings.dotStartY + (index-1)*62
          rangeDot = imageContainer.circle(rangeDotX, rangeDotY, dotSettings.nomralDotRadius)
          rangeDot.attr range.attributes
          rangeDot.attr dotsChangeSettings.attributes
          leftPanelContent.push rangeDot
          textForDot = imageContainer.text(leftRangePanelSettings.textStartX, rangeDotY, range.text)
          textForDot.attr textSettings.attributes
          leftPanelContent.push textForDot
        leftBottomText1 = imageContainer.text(90, 480, "Presence of gold")
        leftBottomText2 = imageContainer.text(90, 480+30, "PPB")
        leftBottomText1.attr leftBottomTextSettings.attributes
        leftBottomText2.attr leftBottomTextSettings.attributes

      createImageContainerImages = () ->
        opacity = 1 #for testing, make it 1
        ###attributes =
          fill: '#FFFFFF',
          'fill-opacity': opacity,
          cursor: 'pointer',
          stroke: '#FFFFFF',
          'stroke-opacity': opacity,###
        bgImage = imageContainer.image("assets/images/exploration/interactives/geochemistry/magnetic_background.jpg", defaultSettings.startX, defaultSettings.startY, defaultSettings.width, defaultSettings.height)
        borderImage = imageContainer.image("assets/images/exploration/interactives/geochemistry/border.png", 256.3871, -4, 528, 539)
        locationA = imageContainer.image("assets/images/exploration/interactives/geochemistry/location_a.png", 416.0968, 74.1936, 86, 113)
        locationB = imageContainer.image("assets/images/exploration/interactives/geochemistry/location_b.png", 521.2258, 219.871, 86, 113)

      animateImages = () ->
        callbackForLocationAnimation = () ->
          this.hide()
        callbackForLocationAWithDotsAnimation = () ->
          for row in leftDots
            for item in row
              item.attr dotsChangeSettings.attributes
          bgImage.hide()
          #this.hide()
        callbackForLocationBWithDotsAnimation = () ->
          for row in rightDots
            for item in row
              item.attr dotsChangeSettings.attributes
          #this.hide()
          drawZones()
          drawRightPanelTexts()
          createLeftPanel()

        ###locationA.attr {src: "assets/images/exploration/interactives/geochemistry/location_a_for_transition.png", width: 72, height: 110}
        locationB.attr {src: "assets/images/exploration/interactives/geochemistry/location_b_for_transition.png", width: 72, height: 110}###

        locationAWithDots = imageContainer.image("assets/images/exploration/interactives/geochemistry/location_a_dots.png", 416.0968, 74.1936, 72, 100)
        locationAWithDots.attr('opacity': 0)
        locationBWithDots = imageContainer.image("assets/images/exploration/interactives/geochemistry/location_b_dots.png", 521.2258, 219.871, 72, 100)
        locationBWithDots.attr('opacity': 0)
        $timeout ->
          borderImage.hide()
          locationA.animate locationASettings.animateAttributes, 1200, "ease-in-out", callbackForLocationAnimation
          locationB.animate locationBSettings.animateAttributes, 1200, "ease-in-out", callbackForLocationAnimation
          locationAWithDots.animate locationASettings.animateWithDotsAttributes, 1200, "ease-in-out", callbackForLocationAWithDotsAnimation
          locationBWithDots.animate locationBSettings.animateWithDotsAttributes, 1200, "ease-in-out", callbackForLocationBWithDotsAnimation
          dotsPanel.animate {'fill-opacity': 1}, 1200, "ease-in-out"
        , 50

      registerMapPathEventListeners = (zone)->
        zone.image.mouseover((e)->
          if zone.selected == false
            this.attr {src: imageRootSrc+zone.hoverSrc}
        )
        zone.image.mouseout((e)->
          if zone.selected == false
            this.attr {src: imageRootSrc+zone.normalSrc}
        )
        zone.image.mouseup((e)->
          if zone.selected == false
            this.attr {src: imageRootSrc+zone.normalSrc}
        )
        zone.image.mousedown((e)->
          for iZone in $scope.settings.zones
            iZone.selected = false
            if iZone.id != zone.id
              iZone.image.attr {src: imageRootSrc+iZone.normalSrc}
          $scope.settings.zones[zone.id].selected = true
          $scope.zone = $scope.settings.zones[zone.id]
          $scope.screen.feedback = true
          this.attr {src: imageRootSrc+zone.selectedSrc}
          handleCompletedState()
        )

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      # -------------------------------------------------------------------------------- Handler Functions
      handleCompletedState = ()->
        return if $scope.settings.completed is true
        if $scope.screen.id == 1 && $scope.zone.id == 1 && $scope.screen.feedback == true
          $scope.settings.completed = true
          Scenario.markCurrentScenarioCompleted($scope.settings)

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      $timeout ->
        init()
      , 200