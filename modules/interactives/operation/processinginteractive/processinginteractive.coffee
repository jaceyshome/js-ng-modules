define [
  'angular'
], ->
  module = angular.module 'common.interactives.operation.processing.interactive', [
    'templates'
  ]
  module.directive 'operationProcessingInteractive', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/operation/processinginteractive/processinginteractive"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentQuestion = null

      init = ()->
        $scope.dataset = Structure.getDataFromKey($scope.settings.data)
        initTopContainerHeight()
        #speed of arrows
        setInterval(update,400)

      checkAllQuestionsCompleted = ()->
        for question in $scope.dataset.questions
          return false unless question.completed is true
        return true

      initTopContainerHeight = ()->
        $scope.dataset.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      initCurrentQuestionArrowAnimation = ()->
        $scope.currentQuestion.topAnimateArrow = {
          index: $scope.currentQuestion.arrowIndexStart
        }
        $scope.currentQuestion.bottomAnimateArrow = {
          index: $scope.currentQuestion.arrowIndexStart
        }

      resetQuestions = ()->
        for question in $scope.dataset.questions
          question.selected = false
          question.topAnimateArrow = null
          question.bottomAnimateArrow = null

      setModuleCompleted = ()->
        $scope.dataset.completed = true
        $scope.settings.completed = true

      update = ()->
        updateCurrentQuestionTopArrows()
        updateCurrentQuestionBottomArrow()

      updateCurrentQuestionTopArrows = ()->
        return unless $scope.currentQuestion and $scope.currentQuestion.topAnimateArrow
        return unless $scope.currentQuestion.topArrowImages and $scope.currentQuestion.topArrowImages.length > 0
        $scope.currentQuestion.topAnimateArrow.index += 1
        if $scope.currentQuestion.topAnimateArrow.index is $scope.currentQuestion.arrowIndexTotal
          $scope.currentQuestion.topAnimateArrow.index = 0
        $scope.$apply() if !$scope.$root.$$phase?

      updateCurrentQuestionBottomArrow = ()->
        return unless $scope.currentQuestion and $scope.currentQuestion.bottomAnimateArrow
        return unless $scope.currentQuestion.bottomArrowImages and $scope.currentQuestion.bottomArrowImages.length > 0
        $scope.currentQuestion.bottomAnimateArrow.index += 1
        if $scope.currentQuestion.bottomAnimateArrow.index is $scope.currentQuestion.arrowIndexTotal
          $scope.currentQuestion.bottomAnimateArrow.index = 0
        $scope.$apply() if !$scope.$root.$$phase?

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
          question.animateArrow = null
          question.setCurrentQuestionAnimateArrow = null

      $scope.selectQuestion = (question)->
        return if question.selected is true
        resetQuestions()
        question.selected = true
        question.completed = true
        $scope.currentQuestion = question
        initCurrentQuestionArrowAnimation()
        if(checkAllQuestionsCompleted())
          setModuleCompleted()

      $timeout init, 200