define [
  'angular'
  ], ->
  module = angular.module 'common.text.directive', []
  module.directive 'tntText', ($compile, Text) ->
    restrict:"A"
    scope:
      tntText:"="
      removeHtmlTags: "="
    link:($scope, element, attrs) ->
      id = null
      texts = null
      $scope.$watch "tntText", (val)->
        id = val
        update()

      $scope.$watch ->
        Text.texts
      , (val)->
        texts = val
        update()
      update = ()->
        if id? and texts?
          if Text.texts[id]
            content = Text.texts[id]
            if ($scope.removeHtmlTags)
              content = $(content).text()
            element.html content
            $compile(element.contents())($scope)
          else
            console.log "Error: No text with id '" + id + "'"
            element.html id