define [
  'common/popup/popupimage/popupimage'
  'common/popup/popupyoutuvideo/popupyoutuvideo'
  ], ->
  module = angular.module 'common.popup', [
    "common.popupyoutuvideo"
    "common.popupimage"
  ]