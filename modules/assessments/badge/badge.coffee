define [
  'angular'
  'common/text/main'
], ->
  module = angular.module 'common.assessments.badge', [
    'templates'
  ]
  module.directive 'assessmentBadge', (Assessment, Module)->
    restrict: "A"
    scope:
      settings: "="
    templateUrl: "common/assessments/badge/badge"
    link: ($scope, $element, $attrs) ->
      $scope.Module = Module
      $scope.getAssessmentResult = ()->
        return Assessment.getCurrentModuleAssessmentsState().completedTotal+'/'+Assessment.getCurrentModuleAssessmentsState().assessmentTotal

      $scope.handleReview = ()->
        if typeof $scope.settings.handleReview is 'function'
          $scope.settings.handleReview()