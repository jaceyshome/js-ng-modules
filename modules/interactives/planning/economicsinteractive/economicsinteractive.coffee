define [
  'angular'
], ->
  module = angular.module 'common.interactives.planning.economics.interactive', [
    'templates'
  ]
  module.directive 'planningEconomicsInteractive', ($sce, Module, Structure, Scenario, $timeout, Helper)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/interactives/planning/economicsinteractive/economicsinteractive"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.Structure = Structure
      $scope.currentStepIndex = 0

      init = ()->
        $scope.dataset = Structure.getDataFromKey($scope.settings.data)
        $timeout initTopContainerHeight, 100

      initTopContainerHeight = ()->
        $scope.dataset.currentTopInteractiveElement = $element.find ".topContainerFirstElement"
        $scope.$apply() if !$scope.$root.$$phase?

      $scope.reset = ()->
        $scope.currentStepIndex = 0

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.getTopContainerMinHeight = ()->
        result = undefined
        return unless $scope.dataset?.currentTopInteractiveElement
        if $scope.dataset.currentTopInteractiveElement and $scope.dataset.currentTopInteractiveElement.height() > 0
          bottomOffset = Structure.data.config.interactiveConfig.topContainerBottomOffset
          result = {"min-height":"#{$scope.dataset.currentTopInteractiveElement.height()+bottomOffset}px"}
        return result

      $scope.nextStep = (index)->
        if index is $scope.dataset.steps.length
          $scope.reset()
        else
          $scope.currentStepIndex = index

      $timeout init, 200