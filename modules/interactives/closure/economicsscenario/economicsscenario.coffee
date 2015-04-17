define [
  'angular'
], ->
  module = angular.module 'common.interactives.closure.economics.scenairo', [
    'templates'
  ]
  module.directive 'clousreEconomicsScenairo', ($sce, Module, Structure, Scenario, $timeout)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/closure/economicsscenario/economicsscenario"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.screen = undefined
      $scope.currentOption = undefined

      init = ()->
        $scope.screen = $scope.settings.screens[0]
        getTopInteractiveContainerElement()


      getTopInteractiveContainerElement = ()->
        $scope.settings.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?


      handleAllQuestionsCompleted = ()->
        return if $scope.settings.completed is true
        $scope.settings.completed = true
        Scenario.markCurrentScenarioCompleted($scope.settings)

      $scope.goToScreen = (id)->
        return unless id?
        return if id > ($scope.settings.screens.length - 1)
        $scope.screen = $scope.settings.screens[id]

      $scope.selectOption = (option) ->
        if option.id == 0
          handleAllQuestionsCompleted()
        $scope.screen = undefined
        option.selected = true
        $scope.currentOption = option

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        if $scope.settings.currentTopInteractiveElement and $scope.settings.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.settings.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.reset = ()->
        for option in $scope.settings.options
          option.selected = false
        $scope.currentOption = undefined
        $scope.goToScreen(0)

      $timeout init, 200

