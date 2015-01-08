define [
  'angular'
], (angular)->
  module = angular.module 'common.assessments.service', []
  module.factory 'Assessment', (Module, $rootScope)->
    service = {}

    service.setIndicatorStyle = (currentIndex, index)->
      if index <= currentIndex
        return {
        'border-color': Module.currentModule.color
        'background-color': Module.currentModule.color
        }
      else
        return {
          'border-color': Module.currentModule.color
          }

    service.handleAssessmentStateChange = ()->
      Module.saveCurrentModuleState()

    service.getCurrentModuleAssessmentsState = ()->
      return unless Module.currentModule.assessments?.length > 0
      result = {
        assessmentTotal: Module.currentModule.assessments.length
        completedTotal: 0
      }
      for assessment in Module.currentModule.assessments
        if assessment.completed
          result.completedTotal += 1
      result

    service