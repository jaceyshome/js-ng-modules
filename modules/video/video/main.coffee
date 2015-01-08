define [
  'common/video/service'
  'common/video/directive'
  ], ->
  module = angular.module 'common.video', ["common.video.directive", "common.video.service"]