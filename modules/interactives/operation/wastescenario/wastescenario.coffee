define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.operation.waste.scenario', [
    'templates'
  ]
  module.directive 'operationWasteScenario', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/operation/wastescenario/wastescenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentOption = null

      currentZoomInPoint = ' '
      $topInteractiveContainer = null
      svgButtonLayerContainer = null
      svgDefaultAttr = {
        fill: '#000000'
        'fill-opacity': 0,
        stroke: '#000000'
        "stroke-miterlimit": 10
        'stroke-width': 0
        'stroke-opacity': 0
        'cursor': 'pointer'
      }
      zoomInPoints = {
        siteA : 'siteAPoint'
        siteB : 'siteBPoint'
        siteC : 'siteCPoint'
      }

      init = ()->
        $topInteractiveContainer = $element.find ".top-interactive-container"
        createSvgButtonLayers()
        initTopContainerHeight()

      createSvgButtonLayers = ()->
        width = 1592
        height = 895
        svgButtonLayerContainer = Raphael('svgButtonLayerContainer', width, height)
        svgButtonLayerContainer.setViewBox(0, 0, width, height, true)
        createSiteASvgButton()
        createSiteBSvgButton()
        createSiteCSvgButton()
        return

      createSiteASvgButton = ()->
        svg_site_a = svgButtonLayerContainer.rect(249.954, 296.286, 225.964, 226.157)
        svg_site_a.attr({
          x: '249.954'
          y: '296.286'
        })
        svg_site_a.attr(svgDefaultAttr)
        svg_site_a.transform("m0.9461 -0.324 0.324 0.9461 -113.0475 139.6576").data('id', 'svg_site_a')
        registerSvgButtonEventListeners(svg_site_a, $scope.settings.options[0])
        $scope.settings.options[0].svgButton = svg_site_a

      createSiteBSvgButton = ()->
        svg_site_b = svgButtonLayerContainer.rect(872.245, 223.172, 236.734, 178.571)
        svg_site_b.attr({
          x: '872.245'
          y: '223.172'
        })
        svg_site_b.attr(svgDefaultAttr)
        registerSvgButtonEventListeners(svg_site_b, $scope.settings.options[1])
        $scope.settings.options[1].svgButton = svg_site_b

      createSiteCSvgButton = ()->
        svg_site_c = svgButtonLayerContainer.rect(1051.878, 580.081, 179.592, 223.47)
        svg_site_c.attr({
          x: '1051.878'
          y: '580.081'
        })
        svg_site_c.attr(svgDefaultAttr)
        registerSvgButtonEventListeners(svg_site_c, $scope.settings.options[2])
        $scope.settings.options[2].svgButton = svg_site_c

      disableOtherOptionsHover = ()->
        for option in $scope.settings.options
          if option isnt $scope.currentOption
            option.svgButton.attr({'cursor': 'default'})

      degradeButtonGroupsContainerZIndex = ()->
        #HACK degrade the text-panel z-index for button groups container
        $buttonGroups = $topInteractiveContainer.find ".option-buttons-container"
        $buttonGroups.css("z-index", 8)
        $buttonGroups.css("pointer-events", 'none')

      enableAllOptionHover = ()->
        for option in $scope.settings.options
          option.svgButton.attr({'cursor': 'pointer'})

      registerSvgButtonEventListeners =(svgBtn, option)->
        svgBtn.mouseover((e)->
          return if $scope.currentOption isnt null and $scope.currentOption isnt option
          $scope.settings.hoverOption = option
          $scope.$apply() if !$scope.$root.$$phase?
        )
        svgBtn.mouseout((e)->
          return if $scope.currentOption isnt null and $scope.currentOption isnt option
          $scope.settings.hoverOption = null
          $scope.$apply() if !$scope.$root.$$phase?
        )
        svgBtn.mouseup((e)->
          return if $scope.currentOption isnt null and $scope.currentOption isnt option
          if $scope.currentOption isnt option
            $scope.setCurrentOption(option)
            $scope.$apply() if !$scope.$root.$$phase?
            return
          if $scope.currentOption is option and option.selected isnt true
            $scope.answerCurrentOption()
            $scope.$apply() if !$scope.$root.$$phase?
            return
        )

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      resetOptions = ()->
        for option in $scope.settings.options
          option.selected = false
          option.completed = false

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.answerCurrentOption = ()->
        if $scope.currentOption.correct is true
          setModuleCompleted()
        $scope.getOptionButtonsContainerStyle()
        $scope.getTopContainerMinHeight()
        $scope.currentOption.selected = true

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.goBackToFirstScreen = ()->
        if $scope.currentOption and $scope.currentOption.selected is true then $scope.currentOption.completed = true
        $scope.currentOption = null
        degradeButtonGroupsContainerZIndex()
        enableAllOptionHover()
        $scope.getOptionButtonsContainerStyle()
        $scope.getTopContainerMinHeight()

      $scope.getTopContainerMinHeight = ()->
        return null unless $scope.settings?.currentTopInteractiveElement
        if $topInteractiveContainer
          $buttonGroups = $topInteractiveContainer.find ".option-buttons-container"
        minHeight = 0
        if $buttonGroups and $scope.currentOption and $scope.settings.completed isnt true
          minHeight += $buttonGroups.height()
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          minHeight += $scope.settings.currentTopInteractiveElement.height()+bottomOffset
        return {"min-height":"#{minHeight}px"}

      $scope.getOptionButtonsContainerStyle = ()->
        result = {"padding-top": "0"}
        return result unless $scope.settings?.currentTopInteractiveElement
        return result unless $scope.currentOption
        return result if $scope.settings.completed is true
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          result = {"padding-top": "#{$scope.settings.currentTopInteractiveElement.height()}px"}

      $scope.reset = ()->
        resetOptions()
        enableAllOptionHover()
        $scope.currentOption = null
        $scope.settings.hoverOption = null
        $scope.settings.completed = false

      $scope.setCurrentOptionBtnClass = ()->
        result = ''
        if $scope.currentOption.selected is true and $scope.currentOption.correct isnt true
          result = 'button-disabled'
        else
          result = Structure.appendStyles.interactiveHoverButtonStyles[Structure.data.currentModuleKey]
        return result

      $scope.setCurrentOptionBtnStyle = ()->
        if $scope.currentOption.selected is true and $scope.currentOption.correct isnt true
          return null
        else
          return {'border-color': Module.currentModule.color}

      $scope.setCurrentOption = (option)->
        $scope.currentOption = option
        $scope.currentOption.svgButton.attr({'cursor': 'pointer'})
        disableOtherOptionsHover()
        currentZoomInPoint = zoomInPoints[option.className]

      $scope.setZoomInOptionClass = ()->
        classes = ' '
        if currentZoomInPoint then classes += currentZoomInPoint + ' '
        if currentZoomInPoint then classes += 'setTransform' + ' '
        if $scope.currentOption then classes += $scope.currentOption.className
        return classes

      $timeout init, 200