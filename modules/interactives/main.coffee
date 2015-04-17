define [
  'common/interactives/stepcharts/stepcharts'

  'common/interactives/exploration/drillingdecision/drillingdecision'
  'common/interactives/exploration/drillinginteractive/drillinginteractive'
  'common/interactives/exploration/geophysics/geophysics'
  'common/interactives/exploration/geochemistryinteractive/geochemistryinteractive'
  'common/interactives/exploration/geochemistry/geochemistry'

  'common/interactives/planning/infrastructure/infrastructure'
  'common/interactives/planning/impactscenario/impactscenario'
  'common/interactives/planning/economicsinteractive/economicsinteractive'
  'common/interactives/planning/economicsscenario/economicsscenario'
  'common/interactives/planning/workforce/workforce'
  'common/interactives/planning/workforceinteractive/workforceinteractive'

  'common/interactives/operation/processinginteractive/processinginteractive'
  'common/interactives/operation/processingscenario/processingscenario'
  'common/interactives/operation/geotechnicalscenario/geotechnicalscenario'
  'common/interactives/operation/wastescenario/wastescenario'

  'common/interactives/closure/economicsinteractive/economicsinteractive'
  'common/interactives/closure/sustainablescenario/sustainablescenario'
  'common/interactives/closure/economicsscenario/economicsscenario'
  'common/interactives/closure/chartscenario/chartscenario'

], ->
  module = angular.module 'common.interactives', [
    'common.interactives.stepcharts'

    'common.interactives.exploration.drillingdecision'
    'common.interactives.exploration.drillinginteractive'
    'common.interactives.exploration.geophysics'
    'common.interactives.exploration.geochemistryinteractive'
    'common.interactives.exploration.geochemistry'

    'common.interactives.planning.infrastructure.decision'
    'common.interactives.planning.impact.scenario'
    'common.interactives.planning.economics.interactive'
    'common.interactives.planning.economics.scenario'
    'common.interactives.planning.workforce.interactive'
    'common.interactives.planning.workforce.decision'

    'common.interactives.operation.processing.interactive'
    'common.interactives.operation.processing.scenario'
    'common.interactives.operation.geotechnical.scenario'
    'common.interactives.operation.waste.scenario'

    'common.interactives.closure.economics.interactive'
    'common.interactives.closure.sustainable.scenario'
    'common.interactives.closure.economics.scenairo'
    'common.interactives.closure.chart.scenario'
  ]