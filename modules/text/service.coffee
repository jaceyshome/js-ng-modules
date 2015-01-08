define [
  'angular'
  'xml2json'
  ], ->
  module = angular.module 'common.text.service', []
  module.factory 'Text', ($http, $q) ->
    service = {}
    service.load = (callback) ->
      deferred = $q.defer()
      $http.get('assets/data/text.xml',
        transformResponse:(data) ->
          x2js = new X2JS
          json = x2js.xml_str2json data
          )
      .success (data, status) ->
        texts = {}
        for key, value of data.texts
          do (key, value) ->
            if(value.__cdata)
              texts[key] = value.__cdata
        service.texts = texts
        deferred.resolve texts

      if callback
        deferred.promise.then callback
      deferred.promise

    service