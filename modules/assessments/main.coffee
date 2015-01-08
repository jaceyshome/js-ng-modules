define [
  'common/assessments/flipcard/flipcard'
  'common/assessments/badge/badge'
  'common/assessments/multiplechoice/multiplechoice'
  'common/assessments/service'
  ], ->
  module = angular.module 'common.assessments', [
    "common.assessments.service"
    "common.assessments.badge"
    "common.assessments.multiplechoice"
    "common.assessments.flipcard"
  ]