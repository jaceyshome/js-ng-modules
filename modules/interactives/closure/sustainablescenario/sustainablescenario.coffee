define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.closure.sustainable.scenario', [
    'templates'
  ]
  module.directive 'closureSustainableScenario', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/closure/sustainablescenario/sustainablescenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentOption = null
      $scope.currentZoomInOption = null

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

      $topInteractiveContainer = null

#      ================== private functions ==================
      init = ()->
        $topInteractiveContainer = $element.find ".top-interactive-container"
        createSvgButtonLayers()
        initTopContainerHeight()

      createSvgButtonLayers = ()->
        width = 964
        height = 542
        svgButtonLayerContainer = Raphael('svgButtonLayerContainer', width, height)
        svgButtonLayerContainer.setViewBox(0, 0, width, height, true)
        createSiteSvgButtons()
        return

      createSiteSvgButtons = ()->
        for option in $scope.settings.options
          optionSvgBtn = svgButtonLayerContainer.path(option.svgPath)
          optionSvgBtn.attr(svgDefaultAttr)
          registerSvgButtonEventListeners(optionSvgBtn, option)
          option.svgButton = optionSvgBtn

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
          return if option.selected is true
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
          option.zoomOut = false

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

#      ================== $scope functions ========================
      $scope.answerCurrentOption = ()->
        if $scope.currentOption.correct is true
          setModuleCompleted()
        $scope.getOptionButtonsContainerStyle()
        $scope.getTopContainerMinHeight()
        $scope.currentOption.selected = true

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.goBackToFirstScreen = ()->
        $scope.currentZoomInOption.zoomOut = true
        if $scope.currentOption and $scope.currentOption.selected is true
          $scope.currentOption.completed = true
        $scope.currentOption = null
        $scope.currentZoomInOption = null
        degradeButtonGroupsContainerZIndex()
        enableAllOptionHover()
        #------ animation -------------
        zoomOutBgWorldMap()
        #------------------------------
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

      $scope.getCurrentOptionZoomInForWorldMapClass = ()->
        return unless $scope.currentOption
        classes = $scope.currentOption.className
        if $scope.currentZoomInOption isnt null and $scope.currentZoomInOption is $scope.currentOption
          classes += ' zoomIn'
        return classes

      $scope.getSiteMapContainerClasses = (option)->
        classes = ''
        if option.selected is true
          classes = 'selected'
        if $scope.currentZoomInOption
          if $scope.currentZoomInOption is option
            classes += ' zoomIn'
          else
            classes += ' hideContainer'
        return classes

      $scope.reset = ()->
        zoomOutBgWorldMap()
        resetOptions()
        enableAllOptionHover()
        degradeButtonGroupsContainerZIndex()
        $scope.currentOption = null
        $scope.currentZoomInOption = null
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
        return if $scope.currentOption
        $scope.currentOption = option
        $scope.currentOption.svgButton.attr({'cursor': 'pointer'})
        disableOtherOptionsHover()
        $scope.currentZoomInOption = option
        #----- animation ------
        zoomInBgWorldMap()
        return

      #======================= animation functions ===============
      #--------------------- bg world map ------------------------
      zoomInBgWorldMap = (cb)->
        return unless $scope.currentOption?.animation?.bgWorldMap?.zoomIn
        $bgWorldMap = $element.find ".bg-world-map-container"
        options = {
          easing: 'ease-out'
          duration: 800
          complete: cb
          delay: 0
        }
        $bgWorldMap.velocity(
          $scope.currentOption.animation.bgWorldMap.zoomIn,
          options
        )
        return

      zoomOutBgWorldMap = (cb)->
        options = {
          easing: 'ease-out'
          duration: 800
          complete: cb
          delay: 0
        }
        $bgWorldMap = $element.find ".bg-world-map-container"
        $bgWorldMap.velocity(
          {
            opacity: 1
            scaleX: 1
            scaleY: 1
            top: 0
            left: 0
            queue: false
          }, options
        )
        return

      #======================= init() ============================
      $timeout init, 200