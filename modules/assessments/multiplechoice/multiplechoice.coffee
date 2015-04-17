define [
  'angular'
], ->
  module = angular.module 'common.assessments.multiplechoice', [
    'templates'
    'common.topicmarker'
  ]
  module.directive 'assessmentMultiplechoice', (Structure, Assessment, $sce, Module)->
    restrict: "A"
    scope:{
      settings: "="
    }
    templateUrl: "common/assessments/multiplechoice/multiplechoice"
    link: ($scope, $element, $attrs) ->
      $scope.data = null
      $scope.Module = Module
      $scope.Assessment = Assessment

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

      $scope.selectedOption = (question, option)->
        question.currentOption = option
        option.selected = true
        if option.correct
          question.completed = true
        return

      $scope.handleOptionResult = (question, option)->
        if question.options[question.selectedIndex] is option
          if option.correct
            question.completed = true
            return 'correct'
          else
            return 'incorrect'

      $scope.handleOptionStyleResult = (question, option)->
        if question.options[question.selectedIndex] is option
          return Module.getQuestionOptionFeedbackBgStyle(option)
        else
          return undefined

      $scope.handleSelectedOptionMarker = (option)->
        if option.selected
          if option.correct
            return 'selected correct'
          else
            return 'selected incorrect'
        else
          return ''

      $scope.handleOptionAddOnStyle = (question, option)->
        moduleKey = Structure.data.currentModuleKey
        if question.options[question.selectedIndex] is option
          if option.correct
            return Structure.appendStyles.multipleChoiceAddOnActivatedStyles[moduleKey]
          else
            return undefined
        else
          return Structure.appendStyles.multipleChoiceAddOnDefaultStyles[moduleKey]

      $scope.setIndicatorStyle = (question)->
        if question.completed
          return {
            'border-color': Module.currentModule.color
            'background-color': Module.currentModule.color
          }
        else
          return {
            'border-color': Module.currentModule.color
          }

      $scope.showBadgePanel = ()->
        if $scope.settings?.review
          return false
        if $scope.settings.completed
          return true
        else
          return false

      $scope.handleNext = ()->
        return unless $scope.currentQuestion?.completed? is true
        if $scope.settings.review and $scope.settings.currentQuestionIndex < $scope.data?.questions.length-1
          setNextQuestion()
          return
        $scope.settings.review = false
        if checkAllCompleted() then return handleQuestionCompleted()
        setNextQuestion()

      #----------------------------- helpers ----------------------------------
      shuffle = (array) ->
        return unless array
        currentIndex = array.length
        temporaryValue = undefined
        randomIndex = undefined

        # While there remain elements to shuffle...
        while 0 isnt currentIndex

          # Pick a remaining element...
          randomIndex = Math.floor(Math.random() * currentIndex)
          currentIndex -= 1

          # And swap it with the current element.
          temporaryValue = array[currentIndex]
          array[currentIndex] = array[randomIndex]
          array[randomIndex] = temporaryValue
        array

      setNextQuestion = ()->
        $scope.settings.currentQuestionIndex++
        setCurrentQuestion()

      setCurrentQuestion = ()->
        return unless $scope.data?.questions?
        index = $scope.settings.currentQuestionIndex
        $scope.currentQuestion = $scope.data.questions[index]
        return unless $scope.currentQuestion.options
        if $scope.settings.type == "multiplechoice" && $scope.currentQuestion.shuffle != true
          $scope.currentQuestion.options = shuffle $scope.currentQuestion.options
          $scope.currentQuestion.shuffle = true

      checkAllCompleted = ()->
        for question in $scope.data.questions
          return false unless question.completed
        return true

      handleQuestionCompleted = ()->
        $scope.settings.completed = true
        Assessment.handleAssessmentStateChange()

      init()
