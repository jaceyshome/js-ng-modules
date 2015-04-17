define [
  'angular'
  'bootstrap'
], ->
  module = angular.module 'common.tntcarousel', [
  ]
  module.directive 'tntCarousel', ($sce, $timeout) ->
    restrict: "A"
    scope: {
      slides:"="
    }
    templateUrl: "common/carousel/carousel"
    link: ($scope, $element, $attrs) ->
      # -------------------------------------------------------------------------------- $scope Variables

      # -------------------------------------------------------------------------------- Private Variables
      changingSlide = false
      $carousel = $element.find(".carouselContainer")

      # -------------------------------------------------------------------------------- init
      init = () ->
        $scope.slides[0].active = true
        $scope.slides[0].current = true
        $carousel.carousel({
          interval: false
        })

      # -------------------------------------------------------------------------------- $scope Functions
      $scope.$watch ()->
        $scope.slides
      , (val)->
        if val?
          for each_slide in $scope.slides
            each_slide.active = false
            each_slide.current = false
          $scope.slides[0].active = true
          $scope.slides[0].current = true

      $scope.findSlideHeading = (slide) ->
        $sce.trustAsHtml slide.heading

      $scope.findActiveSlide = (slide) ->
        index = $scope.slides.indexOf slide
        resultElement = $($carousel.find(".item").get(index))
        result = resultElement.hasClass "active"
        return result

      $scope.bindHtmlSoruce = (content)->
        $sce.trustAsHtml content

      $scope.goToNextSlide = () ->
        $carousel.carousel('next')
        currentIndex = findCurrentSlideIndex()
        return if (currentIndex == -1 or currentIndex == ($scope.slides.length - 1))
        $scope.slides[currentIndex].current = false
        $scope.slides[currentIndex+1].current = true

      $scope.goToPreviousSlide = () ->
        $carousel.carousel('prev')
        currentIndex = findCurrentSlideIndex()
        return if (currentIndex == -1 or currentIndex == 0)
        $scope.slides[currentIndex].current = false
        $scope.slides[currentIndex-1].current = true

      $scope.showNextButton = () ->
        currentIndex = findCurrentSlideIndex()
        return false if (currentIndex == -1 or currentIndex == ($scope.slides.length - 1))
        true

      $scope.showPreviousButton = () ->
        currentIndex = findCurrentSlideIndex()
        return false if (currentIndex == -1 or currentIndex == 0)
        true

      $scope.showMore = (slide, index) ->
        return if slide.showMore == true
        slide.showMore = true

      $scope.hideMore = (slide, index) ->
        return if slide.showMore == false
        slide.showMore = false

      $scope.goToSlide = (index) ->
        $carousel.carousel(index)
        currentIndex = findCurrentSlideIndex()
        return if (currentIndex == -1 or !index? or index == currentIndex)
        $scope.slides[currentIndex].showMore = false
        if index > currentIndex
          $scope.slides[currentIndex].current = false
          $scope.slides[index].current = true
        else
          if index < currentIndex
            $scope.slides[currentIndex].current = false
            $scope.slides[index].current = true

      # -------------------------------------------------------------------------------- Private Functions
      findCurrentSlideIndex = () ->
        return -1 unless $scope.slides?
        for slide, index in $scope.slides
          return index if slide.current == true
        -1

      init()