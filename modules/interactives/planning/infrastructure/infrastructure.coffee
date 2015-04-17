define [
  'angular'
], ->
  module = angular.module 'common.interactives.planning.infrastructure.decision', [
    'templates'
  ]
  module.directive 'infrastructureDecision', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/planning/infrastructure/infrastructure"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentQuestion = null
      $scope.isStarted = false

      init = ()->
        initTopContainerHeight()
        getQuestionCorrectOption()

      checkAllQuestionsCompleted = ()->
        return if $scope.settings.completed is true
        for question in $scope.settings.questions
          return unless question.completed
        setModuleCompleted()

      getQuestionCorrectOption = ()->
        for question in $scope.settings.questions
          for option in question.options
            if option.correct
              question.correctOption = option
              break

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      setModuleCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.backToFirstScreen = ()->
        $scope.currentQuestion = null

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.getBarLevelClass = (option, conditionIndex)->
        condition = option.conditions[conditionIndex]
        return "level#{condition.level}"

      $scope.getBarProgressWidth = (option, conditionIndex)->
        condition = option.conditions[conditionIndex]
        return condition.value*100

      $scope.getConditionLabel = (option, defaultLabel)->
        if option.specialLabel
          return option.specialLabel
        else
          return defaultLabel

      $scope.reset = ()->
        $scope.isStarted = false
        for question in $scope.settings.questions
          question.completed = false
          question.selectedOption = null
          for option in question.options
            option.selected = false
        $scope.settings.completed = false
        $scope.backToFirstScreen()

      $scope.selectQuestion = (question)->
        $scope.isStarted = true
        $scope.currentQuestion = question

      $scope.selectOption = (option)->
        return if option is $scope.currentQuestion.selectedOption
        option.selected = true
        $scope.currentQuestion.selectedOption = option
        if option.correct is true
          $scope.currentQuestion.completed = true
          checkAllQuestionsCompleted()

      $scope.setOptionStyle = (option)->
        if option.image?
          return {'background-image': "url('#{option.image}')"}

      $scope.setOptionOverlayStyle = (option)->
        result = null
        if option.correct isnt true and option.selected is true
          result = {
            'border-color':'#9a9a9a'
            'background-color': 'rgba(0,0,0,0.15)'
          }
        if option.correct is true and option.selected is true
          result = {
            'border-color': Module.currentModule.color
          }
        return result

      $scope.setAnswerBtnClass = (option)->
        if option.correct isnt true and option.selected is true
          return 'incorrect'
        if option.correct is true and option.selected is true
          return 'correct'+' '+Structure.appendStyles.moduleInnerShadows[Structure.data.currentModuleKey]
        return null

      $timeout init, 200

