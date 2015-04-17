define [
  'angular'
], ->
  module = angular.module 'common.interactives.planning.impact.scenario', [
    'templates'
  ]
  module.directive 'planningImpactScenario', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/planning/impactscenario/impactscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentStep = null
      $scope.currentRepresentative = null
      $scope.allRespresentativeCompleted = false

      #------------- init ------------------------
      init = ()->
        initParameters()
        initTopContainerHeight()

      #------------- private functions ------------------------
      checkAllRespresentativeCompleted = ()->
        result = true
        for representative in $scope.settings.representatives
          if representative.completed isnt true
            result = false
            break
        $scope.allRespresentativeCompleted = result

      calculateIndicatorCurrentPos = (representative)->
        return if representative.completed is true
        if representative.isAgainst
          $scope.settings.indicatorCurrentPos -= $scope.settings.stepPos
        else
          $scope.settings.indicatorCurrentPos += $scope.settings.stepPos

      initParameters = ()->
        $scope.settings.indicatorCurrentPos = $scope.settings.indicatorDefaultPos
        $scope.currentStep = $scope.settings.introduction
        $scope.currentRepresentative = null
        $scope.allRespresentativeCompleted = false
        $scope.settings.completed = false

      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      resetAllRepresentatives = ()->
        for representative in $scope.settings.representatives
          representative.completed = false
          representative.selected = false

      setCurrentStep = (key)->
        if $scope.currentStep isnt $scope.settings[key]
          $scope.currentStep = $scope.settings[key]

      setModuleCompleted = ()->
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      #------------ scope functions --------------------------------
      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.checkRepresentativeAvatarNormalState = (representative)->
        result = true
        return result unless representative.completed
        if representative is $scope.currentRepresentative
          result = false
        return result

      $scope.checkRepresentativeAvatarCompletedState = (representative)->
        result = false
        return result unless representative.completed
        if representative is $scope.currentRepresentative
          result = true
        return result

      $scope.nextStep = (key)->
        $scope.currentStep = $scope.settings[key]

      $scope.reset = ()->
        initParameters()
        resetAllRepresentatives()

      $scope.goToSummary = ()->
        $scope.currentStep = $scope.settings.summary
        setModuleCompleted()

      $scope.selectRepresentative = (representative)->
        setCurrentStep('representatives')
        #NOTE: calculateIndicatorCurrentPos() must be called before it being completed
        calculateIndicatorCurrentPos(representative)
        representative.completed = true
        representative.selected = true
        $scope.currentRepresentative = representative
        checkAllRespresentativeCompleted()

      $scope.setRepresentativeButtonStyle = (representative)->
        style = {}
        if representative.completed
          if representative.isAgainst
            style['border-color'] = "#f25e5d"
          else
            style['border-color'] = Module.currentModule.color
          if representative isnt $scope.currentRepresentative
            style['background-color'] = '#eae7da'
        return style

      $scope.setRepresentativeButtonClass = (representative)->
        cssClasses = " "
        if representative.completed
          cssClasses += "completed"
          if representative isnt $scope.currentRepresentative
            cssClasses += ' unSelected'
        return cssClasses

      $scope.setIndicatorStylePos = ()->
        return {'margin-left': "#{$scope.settings.indicatorCurrentPos}%"}

      $scope.updateTopInteractiveContainerMinHeight = ()->
        return null unless $scope.settings?.currentTopInteractiveElement
        minHeight = 0
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          minHeight += $scope.settings.currentTopInteractiveElement.height()+bottomOffset
        return {"min-height":"#{minHeight}px"}

      $timeout init, 200
