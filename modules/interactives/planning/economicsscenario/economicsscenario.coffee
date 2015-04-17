define [
  'angular'
], ->
  module = angular.module 'common.interactives.planning.economics.scenario', [
    'templates'
  ]
  module.directive 'planningEconomicsScenario', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/planning/economicsscenario/economicsscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentStepIndex = 0
      $scope.selectedOption = null
      $topInteractiveContainer = null

      init = ()->
        $topInteractiveContainer = $element.find ".top-interactive-container"
        initTopContainerHeight()

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.getOptionButtonsContainerStyle = ()->
        result = null
        return result unless $scope.settings?.currentTopInteractiveElement
        return result if $scope.settings.completed is true
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          result = {"padding-top": "#{$scope.settings.currentTopInteractiveElement.height()}px"}

      $scope.nextStep = (index)->
        $scope.currentStepIndex = index

      $scope.reset = ()->
        $scope.currentStepIndex = 0
        $scope.selectedOption = null
        $scope.settings.steps[1].options[0].selected = false
        $scope.settings.steps[1].options[1].selected = false
        $scope.settings.completed = false

      $scope.selectOption = (option)->
        return if option.selected
        $scope.selectedOption = option
        option.selected = true
        if option.correct is true
          setModuleCompleted()
          $scope.getOptionButtonsContainerStyle()
        $scope.updateTopInteractiveContainerMinHeight()
        return

      $scope.setIncorrectButtonClass = (option)->
        result = ''
        if option.selected
          result = 'button-disabled'
        else
          result = Structure.appendStyles.interactiveHoverButtonStyles[Structure.data.currentModuleKey]
        return result

      $scope.setIncorrectButtonStyle = (option)->
        if option.selected
          return null
        else
          return {'border-color':Module.currentModule.color}

      $scope.updateTopInteractiveContainerMinHeight = ()->
        return null unless $scope.settings?.currentTopInteractiveElement
        if $topInteractiveContainer
          $buttonGroups = $topInteractiveContainer.find ".option-buttons-container"
        minHeight = 0
        if $buttonGroups and $scope.settings.completed isnt true
          minHeight += $buttonGroups.height()
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          minHeight += $scope.settings.currentTopInteractiveElement.height()+bottomOffset
        return {"min-height":"#{minHeight}px"}

      $timeout init, 200