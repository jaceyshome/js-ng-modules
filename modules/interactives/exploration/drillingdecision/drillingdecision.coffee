define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.exploration.drillingdecision', []
  module.directive 'drillingDecision', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/exploration/drillingdecision/drillingdecision"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- Private Variables
      rootImageSrc = "assets/images/exploration/interactives/drillingdecision/"
      # -------------------------------------------------------------------------------- $scope Variables
      $scope.screen = undefined
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.zone = undefined
      $scope.rootImageSrc = rootImageSrc
      $scope.selectedZoneId = undefined

      # -------------------------------------------------------------------------------- init
      init = () ->
        if $scope.settings.zones?
          for zone in $scope.settings.zones
            zone.selected = false
            zone.fadeIn = false
            zone.fadeOut = false
        if $scope.settings.screens?
          for screen, index in $scope.settings.screens
            screen.feedback = false
        $scope.screen = $scope.settings.screens[0]
        $timeout initTopContainerHeight, 200

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.trustAsHtml = (html) ->
        $sce.trustAsHtml html

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.getOverlaySrc = (zone) ->
        if zone.selected == true
          return rootImageSrc + zone.selectedSrc
        else
          return rootImageSrc + zone.normalSrc

      $scope.showOverlay = (zone) ->
        return true unless $scope.zone?
        if zone.id != 1
          if $scope.zone.id == 1
            if zone.fadeOut == true
              return true
            else
              return false
        true

      $scope.select = (id) ->
        return unless id?
        return unless $scope.settings.zones?
        return unless $scope.settings.zones.length > id
        for zone, index in $scope.settings.zones
          if zone.selected == true
            lastId = index
            return if lastId == id
            zone.selected = false
            break
        $scope.settings.zones[id].selected = true
        $scope.selectedZoneId = id
        $scope.settings.zones[id].fadeIn = true
        $scope.settings.zones[id].fadeOut = false
        if id != 1
          $scope.settings.zones[lastId].fadeIn = false if lastId?
          $scope.settings.zones[lastId].fadeOut = true if lastId?
        else
          $scope.settings.zones[0].originFadeOut = true
          $scope.settings.zones[2].originFadeOut = true
          $scope.settings.zones[0].fadeOut = true
          $scope.settings.zones[2].fadeOut = true
        $scope.zone = $scope.settings.zones[id]
        $scope.screen.feedback = true
        setModuleCompleted()

      $scope.reset = ()->
        $scope.selectedZoneId = undefined
        for zone in $scope.settings.zones
          zone.selected = false
          zone.fadeIn = false
          zone.fadeOut = false
        for screen, index in $scope.settings.screens
          screen.feedback = false



      # -------------------------------------------------------------------------------- Private Functions
      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      # -------------------------------------------------------------------------------- Handler Functions
      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        if $scope.screen.id == 0 && $scope.zone.id == 1 && $scope.screen.feedback == true
          $scope.settings.completed = true
          Scenario.markCurrentScenarioCompleted($scope.settings)

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      $timeout ->
        init()
      , 200