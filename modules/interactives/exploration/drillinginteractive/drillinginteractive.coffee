define [
  'angular'
  'raphael'
], ->
  module = angular.module 'common.interactives.exploration.drillinginteractive', []
  module.directive 'drillingInteractive', ($sce, Module, Structure, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/exploration/drillinginteractive/drillinginteractive"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables
      $scope.screen = undefined
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.rootImageSrc = "assets/images/exploration/interactives/drillinginteractive/"

      # -------------------------------------------------------------------------------- Private Variables

      # -------------------------------------------------------------------------------- init
      init = () ->
        if $scope.settings.options?
          for option in $scope.settings.options
            option.selected = false
        if $scope.settings.screens?
          for screen, index in $scope.settings.screens
            screen.feedback = false
        $scope.screen = $scope.settings.screens[0]
        $scope.currentOption = undefined

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.trustAsHtml = (html) ->
        $sce.trustAsHtml html

      $scope.select = (id) ->
        return unless id?
        return unless $scope.settings.options?
        return unless $scope.settings.options.length > id
        $scope.screen.feedback = true
        if $scope.settings.options[id].selected != true
          $scope.settings.options[id].selected = true
          $scope.currentOption = angular.copy $scope.settings.options[id]
        else
          $scope.currentOption = undefined
          $scope.settings.options[id].selected = false
        handleCompletedState()

      $scope.reset = ()->
        for option in $scope.settings.options
          option.selected = false

      # -------------------------------------------------------------------------------- Private Functions

      # -------------------------------------------------------------------------------- Handler Functions
      handleCompletedState = ()->
        return if $scope.settings.completed is true
        for option in $scope.settings.options
          return unless option.selected is true
        $scope.settings.completed = true

      # -------------------------------------------------------------------------------- Helper Functions

      # -------------------------------------------------------------------------------- init()
      $timeout ->
        init()
      , 200