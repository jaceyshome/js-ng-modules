define [
  'angular'
], ->
  module = angular.module 'common.interactives.planning.workforce.interactive', [
    'templates'
  ]
  module.directive 'planningWorkforceInteractive', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/planning/workforceinteractive/workforceinteractive"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentQuestion = null

      init = ()->
        $scope.dataset = Structure.getDataFromKey($scope.settings.data)
        initTopContainerHeight()

      checkAllQuestionsCompleted = ()->
        for question in $scope.dataset.questions
          return false unless question.completed is true
        return true

      initTopContainerHeight = ()->
        $scope.dataset.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      resetQuestionsSelected = ()->
        for question in $scope.dataset.questions
          question.selected = false

      setModuleCompleted = ()->
        $scope.dataset.completed = true
        $scope.settings.completed = true

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        return unless $scope.dataset?.currentTopInteractiveElement
        if $scope.dataset.currentTopInteractiveElement and $scope.dataset.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.dataset.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.getQuestionButtonClass = (question)->
        if question.selected
          return 'button-disabled'
        else
          return Structure.appendStyles.interactiveHoverButtonStyles[Structure.data.currentModuleKey]

      $scope.getQuestionButtonStyle = (question)->
        if question.selected
          {'border-color':'#777674'}
        else
          return {'border-color':Module.currentModule.color}

      $scope.reset = ()->
        $scope.currentQuestion = null
        $scope.dataset.completed = false
        for question in $scope.dataset.questions
          question.selected = false
          question.completed = false

      $scope.selectQuestion = (question)->
        return if question.selected is true
        resetQuestionsSelected()
        question.selected = true
        question.completed = true
        $scope.currentQuestion = question
        if(checkAllQuestionsCompleted())
          setModuleCompleted()

      $timeout init, 200