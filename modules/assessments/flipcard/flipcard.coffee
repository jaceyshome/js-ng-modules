define [
  'angular'
], ->
  module = angular.module 'common.assessments.flipcard', [
    'templates'
  ]
  module.directive 'assessmentFlipcard', (Structure, Module, Assessment, Helper)->
    restrict: "A"
    scope:{
      settings: "="
    }
    templateUrl: "common/assessments/flipcard/flipcard"
    link: ($scope, $element, $attrs) ->
      $scope.data = null
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.Assessment = Assessment
      $scope.currentQuestion = null

      init = ->
        $scope.data = Structure.getDataFromKey($scope.settings.data)
#        console.log "$scope.data", $scope.data
        initCurrentQuestion()

      initCurrentQuestion = ()->
        unless $scope.settings.currentQuestionIndex
          $scope.settings.currentQuestionIndex = 0
        setCurrentQuestion()

      $scope.handleNext = ()->
        if checkAllQuestionsCompleted()
          return handleQuestionCompleted()
        else
          return setNextQuestion()

      $scope.selectOption = (option)->
        option.flipped = !option.flipped
        option.selected = true
        $scope.currentQuestion.completed = checkAllOptionsCompleted()

      $scope.setFlipItemContainerClass = (question,option)->
        if option.flipped
          return 'flipped'
        else
          return ' '

      $scope.setCardFrontStyle = (option)->
        if option.front?.image?
          return {'background-image': "url('#{option.front.image}')"}

      $scope.setCardBackStyle = (option)->
        classes = {}
        if option.correct
          classes['border-color'] = Helper.colorLuminance(Module.currentModule.color, -0.2)
          classes['background-color'] = Module.currentModule.color
        classes

      $scope.setTextBorderStyle = (option)->
        if option.correct
          return {
            'background-color': Helper.colorLuminance(Module.currentModule.color, -0.1)
          }

      #----------------------------- helpers ----------------------------------
      setNextQuestion = ()->
        $scope.settings.currentQuestionIndex++
        setCurrentQuestion()

      setCurrentQuestion = ()->
        return unless $scope.data?.questions?
        index = $scope.settings.currentQuestionIndex
        $scope.currentQuestion = $scope.data.questions[index]

      checkAllOptionsCompleted = ()->
        for option in $scope.currentQuestion.options
          if !option.selected and option.correct
            return false
        return true

      checkAllQuestionsCompleted = ()->
        for question in $scope.data.questions
          return false unless question.completed
        return true

      handleQuestionCompleted = ()->
        $scope.settings.completed = true
        Assessment.handleAssessmentStateChange()

      init()
