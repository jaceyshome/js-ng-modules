define [
  'angular'
], ->
  module = angular.module 'common.interactives.stepcharts', [
    'templates'
  ]
  module.directive 'stepCharts', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
      settingsKey: "="
    templateUrl: "common/interactives/stepcharts/stepcharts"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure

      $scope.currentArrowIndex = 0

      init = ()->
        initTopContainerHeight()
        setInterval(updateArrows,400)

      #-------------------- $scope function -------------------------
      $scope.goToStep = (index)->
        $scope.settings.currentStepIndex = index

      $scope.goToCompletedStep = (index)->
        $scope.settings.currentStepIndex = index
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.reset = ()->
        $scope.settings.currentStepIndex = 0
        $scope.currentArrowIndex = 0

      #--------------------- private functions -------------------
      initTopContainerHeight = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      updateArrows = ()->
        return unless $scope.settings.currentStepIndex is 4
        $scope.currentArrowIndex += 1
        if $scope.currentArrowIndex is $scope.settings.arrowImages.length
          $scope.currentArrowIndex = 0
        $scope.$apply() if !$scope.$root.$$phase?

      #--------------------- init() ----------------------------
      $timeout init, 10
