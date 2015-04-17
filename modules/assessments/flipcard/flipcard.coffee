define [
  'angular'
  'bowser'
], (angular, bowser)->
  module = angular.module 'common.assessments.flipcard', [
    'templates'
  ]
  module.directive 'assessmentFlipcard', ($sce, Structure, Module, Assessment, Helper)->
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
        $scope.data.badge.handleReview = handleReview
        initCurrentQuestion()

      handleReview = ()->
        $scope.settings.review = true
        $scope.settings.currentQuestionIndex = 0
        setCurrentQuestion()
        return

      initCurrentQuestion = ()->
        unless $scope.settings.currentQuestionIndex
          $scope.settings.currentQuestionIndex = 0
        setCurrentQuestion()

      $scope.trustAsHtml = (html) ->
        $sce.trustAsHtml html

      $scope.handleNext = ()->
        return unless $scope.currentQuestion?.completed? is true
        if $scope.settings.review and $scope.settings.currentQuestionIndex < $scope.data?.questions.length-1
          setNextQuestion()
          return
        $scope.settings.review = false
        if checkAllQuestionsCompleted() then return handleQuestionCompleted()
        setNextQuestion()

      $scope.selectOption = (option)->
        option.flipped = !option.flipped
        option.selected = true
        $scope.currentQuestion.completed = checkAllOptionsCompleted()

      $scope.setFlipItemContainerClass = (question,option)->
        classes = if bowser.msie is true then 'ie' else 'default'
        classes += ' flipped' if option.flipped
        return classes

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

      $scope.showBadgePanel = ()->
        if $scope.settings?.review
          return false
        if $scope.settings.completed
          return true
        else
          return false

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
