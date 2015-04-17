define [
  'angular'
], ->
  module = angular.module 'common.interactives.closure.chart.scenario', [
    'templates'
  ]
  module.directive 'closureChartScenario', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/closure/chartscenario/chartscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.selectedOption = null
      $scope.currentStep = null
      $scope.currentStepIndex = null

      init = ()->
        $scope.currentStepIndex = 0
        $scope.currentStep = $scope.settings.steps[$scope.currentStepIndex]
        getTopInteractiveContainerElement()

      getTopInteractiveContainerElement = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      handleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.goToStepByIndex = (stepIndex)->
        return unless $scope.settings.steps?.length > stepIndex
        $scope.currentStepIndex = stepIndex
        $scope.currentStep = $scope.settings.steps[stepIndex]

      $scope.selectOption = (option)->
        option.selected = true
        $scope.selectedOption = option
        if option.correct is true
          handleCompleted()

      $scope.setOptionButtonBgColor = (option)->
        return null unless option.selected
        return Module.getQuestionOptionFeedbackBgStyle(option)

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.reset = ()->
        for step in $scope.settings.steps
          continue unless step.options?.length > 0
          for option in step.options
            option.selected = false
        $scope.selectedOption = null
        $scope.currentStepIndex = 0
        $scope.currentStep = $scope.settings.steps[$scope.currentStepIndex]
        $scope.settings.completed = false

      $timeout init, 200

