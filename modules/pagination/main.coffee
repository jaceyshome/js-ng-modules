define [
  'angular'
  ], ->
  module = angular.module 'common.pagination', [
    'templates'
  ]
  module.directive 'tntPagination', () ->
    restrict:"A"
    scope:{
      index:"="
      limit:"="
      max:"="
      pageLimit:"=?"
    }
    templateUrl: "common/pagination/main"
    link:($scope, element, attrs) ->
      update = ()->
        pages = []
        #console.log "$scope.index", $scope.index
        for i in [0..$scope.max] by $scope.limit
          page = {
            index:pages.length
            first:pages.length*$scope.limit
            last:(pages.length*$scope.limit)+($scope.limit-1)
          }
          #console.log "page.index", page.index
          #console.log "page.first", page.first
          #console.log "page.last", page.last
          #console.log "(page.first >= $scope.index)", (page.first >= $scope.index)
          #console.log "(page.last <= $scope.index)", (page.last <= $scope.index)
          page.current = (page.first <= $scope.index) and (page.last >= $scope.index)
          $scope.current = page if page.current
          pages.push page
        #console.log "pages", pages
        $scope.pages = pages
        $scope.lastPage = pages[pages.length-1]
        if pages.length <= $scope.pageLimit
          $scope.displayPages = pages
        else
          first = Math.round(($scope.index/$scope.limit)-($scope.pageLimit/2))
          #console.log "first", first
          first = 0 if first<0
          if first >= pages.length - $scope.pageLimit
            first = pages.length - $scope.pageLimit
          else
            last = first+($scope.pageLimit-1)
          #console.log "last", last
          displayPages = []
          for i in [first..first+($scope.pageLimit-1)]
            #console.log "i", i
            displayPages.push pages[i]
          $scope.displayPages = displayPages


      $scope.$watch "index", update
      $scope.$watch "limit", update
      $scope.$watch "max", update
      $scope.$watch "pageLimit", update

      $scope.first = ()->
        $scope.goPage $scope.pages[0]
      $scope.previous = ()->
        $scope.goPage $scope.pages[$scope.current.index-1]
      $scope.next = ()->
        $scope.goPage $scope.pages[$scope.current.index+1]
      $scope.last = ()->
        $scope.goPage $scope.pages[$scope.pages.length-1]
      $scope.goPage = (page)->
        $scope.index = page.first


      #$scope.index = 0
      $scope.pageLimit = 5
      #$scope.limit = 10
      #$scope.max = 64
