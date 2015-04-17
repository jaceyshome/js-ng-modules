define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.exploration.geophysics', []
  module.directive 'geoPhysics', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/exploration/geophysics/geophysics"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables
      $scope.screen = undefined
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.zone = undefined
      $scope.changingFirstScreen = undefined
      $scope.keepSecondScreen = undefined
      $scope.changingSecondScreen = undefined

      # -------------------------------------------------------------------------------- Private Variables
      iOS = /(iPad|iPhone|iPod)/g.test( navigator.userAgent )

      # -------------------------------------------------------------------------------- init
      init = () ->
        if $scope.settings.zones?
          for zone in $scope.settings.zones
            zone.hover = false
            zone.selected = false
            zone.selectedNumber = 0
        if $scope.settings.screens?
          for screen, index in $scope.settings.screens
            screen.feedback = false
            screen.disabled = false
        $scope.changingFirstScreen = false
        $scope.keepSecondScreen = false
        $scope.changingSecondScreen = false
        $scope.screen = $scope.settings.screens[0]
        $scope.zone = undefined
        $timeout initTopContainerHeight, 100

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.mouseEnter = (id) ->
        return if iOS == true
        return if $scope.screen.id == 0
        return if $scope.screen.disabled == true
        return unless id?
        return unless $scope.settings.zones?
        return unless $scope.settings.zones.length > id

        $scope.settings.zones[id].hover = true

      $scope.mouseLeave = (id) ->
        return if iOS == true
        return if $scope.screen.id == 0
        return if $scope.screen.disabled == true
        return unless id?
        return unless $scope.settings.zones?
        return unless $scope.settings.zones.length > id
        $scope.settings.zones[id].hover = false

      $scope.goToMageneticView = () ->
        $scope.screen = $scope.settings.screens[1]
        $scope.changingFirstScreen = true
        $timeout ->
          $scope.changingFirstScreen = false
        , 600

      $scope.goToGravityView = () ->
        $scope.screen = $scope.settings.screens[2]
        $scope.screen.feedback = false
        $scope.changingSecondScreen = true
        $scope.keepSecondScreen = true
        $timeout ->
          $scope.keepSecondScreen = false
          $scope.changingSecondScreen = false
        , 600
        return unless $scope.settings.zones?
        for zone in $scope.settings.zones
          zone.selected = false

      $scope.select = (id) ->
        return if $scope.screen.id == 0
        return unless id?
        return if $scope.screen.disabled == true
        return unless $scope.settings.zones?
        return unless $scope.settings.zones.length > id
        #return if $scope.settings.zones[id].selectedNumber > 0

        for zone, index in $scope.settings.zones
          zone.selected = false
        $scope.settings.zones[id].selected = true
        $scope.settings.zones[id].selectedNumber++
        $scope.zone = $scope.settings.zones[id]
        $scope.screen.feedback = true
        if $scope.screen.id == 2 && id == 1
          $scope.screen.disabled = true
        handleCompletedState()

      $scope.reset = () ->
        init()


      # -------------------------------------------------------------------------------- Private Functions
      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      # -------------------------------------------------------------------------------- Handler Functions
      handleCompletedState = ()->
        return if $scope.settings.completed is true
        if $scope.screen.id == 2 && $scope.zone.id == 1 && $scope.screen.feedback == true
          $scope.settings.completed = true
          Scenario.markCurrentScenarioCompleted($scope.settings)

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      $timeout init, 200
