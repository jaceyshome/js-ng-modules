define [
  'angular'
  'moment'
  ], ->
  module = angular.module 'common.timecode', []
  module.filter 'timecode', ->
    filter = (milliseconds) ->
      milliseconds = 0 unless milliseconds?
      duration = moment.duration milliseconds
      hr = duration.hours().toString()
      hr = "0"+hr if hr.length is 1
      min = duration.minutes().toString()
      min = "0"+min if min.length is 1
      sec = duration.seconds().toString()
      sec = "0"+sec if sec.length is 1
      hr + ":" + min + ":" + sec