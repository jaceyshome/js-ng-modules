define [
  'angular'
], ->
  module = angular.module 'common.interactives.operation.processing.scenario', [
    'templates'
  ]
  module.directive 'operationProcessingScenario', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/operation/processingscenario/processingscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentOption = null

      init = ()->
        initTopContainerHeight()

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      resetOptionsSelected = ()->
        for option in $scope.settings.options
          option.selected = false

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        return unless $scope.settings?.currentTopInteractiveElement
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.reset = ()->
        $scope.currentOption = null
        $scope.settings.completed = false
        for option in $scope.settings.options
          option.selected = false
          option.completed = false

      $scope.selectOption = (option)->
        return if option is $scope.currentOption
        $scope.currentOption = option
        resetOptionsSelected()
        option.selected = true
        if option.correct is true
          setModuleCompleted()

      $timeout init, 200