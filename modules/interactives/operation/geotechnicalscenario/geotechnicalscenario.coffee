define [
  'angular'
], ->
  module = angular.module 'common.interactives.operation.geotechnical.scenario', [
    'templates'
  ]
  module.directive 'operationGeotechnicalScenario', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/operation/geotechnicalscenario/geotechnicalscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentQuestion = null
      $scope.currentStepIndex = 0
      $scope.STEPINDEX =
        start: 0
        question1: 1
        question2: 2
        summary: 3

      # ----------------- private variables ---------------
      $topInteractiveContainer = null
      stepClasses = {}
      stepClasses[$scope.STEPINDEX.start] = 'start'
      stepClasses[$scope.STEPINDEX.question1] = 'question1'
      stepClasses[$scope.STEPINDEX.question2] = 'question2'
      stepClasses[$scope.STEPINDEX.summary] = 'summary'

      init = ()->
        $topInteractiveContainer = $element.find ".top-interactive-container"
        initParameters()
        initTopContainerHeight()

      initParameters = ()->
        $scope.currentStepIndex = 0
        $scope.currentQuestion = null

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      degradeButtonContainerZindex = ()->
        #HACK degrade the text-panel z-index for button groups container
        $buttonGroups = $topInteractiveContainer.find ".option-buttons-container"
        $buttonGroups.css("z-index", 8)
        $buttonGroups.css("pointer-events", 'none')

      resetQuestions = ()->
        resetQuestion($scope.settings.steps[$scope.STEPINDEX.question1].question)
        resetQuestion($scope.settings.steps[$scope.STEPINDEX.question2].question)

      resetQuestion = (question)->
        question.selectedOption = null
        question.completed = false
        resetQuestionOptions(question.options)

      resetQuestionOptions = (options)->
        for option in options
          option.selected = false

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.isQuestionOptionVisibile = (stepIndex, isCorrectOption)->
        return true if isCorrectOption and $scope.settings.completed
        if $scope.currentStepIndex >= stepIndex and $scope.currentQuestion?.selectedOption?
          if isCorrectOption
            return $scope.currentQuestion?.selectedOption?.correct is true
          else
            return $scope.currentQuestion?.selectedOption?.correct isnt true

      $scope.getTopContainerMinHeight = ()->
        return null unless $scope.settings?.currentTopInteractiveElement
        if $topInteractiveContainer
          $buttonGroups = $topInteractiveContainer.find ".option-buttons-container"
        minHeight = 0
        if Helper.getViewportSize().width <= 894
          offset = 0
        #For text width avatar
        else if $scope.currentQuestion and !$scope.currentQuestion?.selectedOption
          offset = -10
        #For incorrect feedback and buttons
        else if $scope.currentQuestion?.selectedOption and $scope.currentQuestion?.selectedOption?.correct isnt true
          offset = 10
        else
          offset = 0
        if $buttonGroups and $scope.currentQuestion?.completed isnt true
          minHeight += $buttonGroups.height() + offset
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          minHeight += $scope.settings.currentTopInteractiveElement.height()+bottomOffset
        return {"min-height":"#{minHeight}px"}

      $scope.getOptionButtonsContainerStyle = ()->
        result = null
        # if the window is smaller than 894, offset is 0
        if $scope.currentQuestion?.selectedOption or Helper.getViewportSize().width <= 894
          offset = 0
        else
          offset = -20
        return result unless $scope.settings?.currentTopInteractiveElement
        return result unless $scope.currentQuestion and $scope.currentQuestion?.completed isnt true
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          result = {"padding-top": "#{$scope.settings.currentTopInteractiveElement.height()+offset}px"}

      $scope.goToNextStep = (stepIndex)->
        stepIndex = $scope.currentStepIndex + 1 unless stepIndex
        $scope.currentStepIndex = stepIndex
        $scope.currentQuestion = $scope.settings.steps[stepIndex].question
        if $scope.currentStepIndex is $scope.STEPINDEX.summary
          setModuleCompleted()

      $scope.reset = ()->
        $scope.settings.completed = false
        resetQuestions()
        initParameters()
        $scope.getOptionButtonsContainerStyle()
        $scope.getTopContainerMinHeight()

      $scope.setChartContainerStepClass = ()->
        if stepClasses[$scope.currentStepIndex]
          return stepClasses[$scope.currentStepIndex]
        else
          return ' '

      $scope.setQuestionOptionBtnClass = (option)->
        result = ''
        if option.selected is true and option.correct isnt true
          result = 'button-disabled'
        else
          result = Structure.appendStyles.interactiveHoverButtonStyles[Structure.data.currentModuleKey]
        return result

      $scope.setQuestionOptionBtnStyle = (option)->
        if option.selected
          return null
        else
          return {'border-color':Module.currentModule.color}

      $scope.selectOption = (option)->
        return if option.selected
        option.selected = true
        $scope.currentQuestion.selectedOption = option
        if option.correct is true
          $scope.currentQuestion.completed = true
          degradeButtonContainerZindex()
          $scope.getOptionButtonsContainerStyle()
        $scope.getTopContainerMinHeight()
        return

      $timeout init, 200