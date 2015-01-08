define [
  'angular'
  'common/tinycarousel/slide/slide'
], ->
  module = angular.module 'common.tinycarousel', [
    'common.tinycarousel.slide'
  ]
  module.directive 'tinyCarousel', () ->
    restrict: "A"
    scope: {
      slides:"="
      handleClick:"="
      imageShownNumber:"="
      imageWidth:"="
      imageMarginRight:"="
      imageMarginLeft:"="
    }
    templateUrl: "common/tinycarousel/tinycarousel"
    link: ($scope, $element, $attrs) ->
      imageShowingTotal = undefined
      imageWidth = undefined
      marginRight = undefined
      marginLeft = undefined
      currentShowingNumber = undefined
      imagePanelWidth = undefined
      xOffset = undefined

      $scope.carouselPanelX = 0
      $scope.carouselPanelWidth = 0
      $scope.isOnAnimation = false
      $scope.currentHoverSlide = null

      init = ->
        initParameters()
        resizePanel()
        addWatchers()
        addListeners()
        return

      initParameters = ->
        imageShowingTotal = $scope.imageShownNumber or 4
        imageWidth = $scope.imageWidth or 200
        marginRight = $scope.imageMarginRight or 18
        marginLeft = $scope.imageMarginLeft or 0
        currentShowingNumber = $scope.imageShownNumber or 4
        imagePanelWidth = marginLeft + imageWidth + marginRight
        xOffset = imagePanelWidth * imageShowingTotal
        return

      resizePanel = ->
        i = undefined
        newContainerWidth = undefined
        offsetShowingNumber = undefined
        i = imageShowingTotal
        while i > 0
          showingImageGroupWidth = imagePanelWidth * i - (marginLeft + marginRight)
          carouselContainerWidth = $element.width() * 0.9
          if Math.floor(carouselContainerWidth / showingImageGroupWidth) is 1
            newContainerWidth = imagePanelWidth * i - (marginLeft + marginRight) + (marginLeft + marginRight)
            $element.find(".tinyCarouselContainer").css width: newContainerWidth + "px"
            unless i is currentShowingNumber
              offsetShowingNumber = i - currentShowingNumber
              currentShowingNumber = i
              resizeImagePage i
            break
          i--
        $scope.isLastGroup()
        return

      resizeImagePage = (newShowingImageNumber) ->
        pageIndex = undefined
        xOffset = imagePanelWidth * newShowingImageNumber
        pageIndex = Math.floor($scope.carouselPanelX / xOffset)
        $scope.carouselPanelX = pageIndex * xOffset
        return

      setOverlaySlidesVisible = ->
        return  unless $scope.slides
        viewAreaWidth = $element.find(".tinyCarouselContainer").width()
        currentSlideX = 0
        viewAreaStartX = 0
        viewAreaEndX = viewAreaWidth + viewAreaStartX
        i = 0
        while i < $scope.slides.length
          currentSlideX = $scope.carouselPanelX + (i + 1) * imageWidth
          $scope.slides[i].underOverlay = (currentSlideX < viewAreaStartX or currentSlideX > viewAreaEndX)
          i++
        return

      showAllSlides = (callback) ->
        slide = {}
        $scope.slides.forEach (slide) ->
          slide.underOverlay = false
          return
        callback()  if callback
        return

      animateSlideList = (offset) ->
        offsetX = offset or 0
        $scope.isOnAnimation = true
        $element.find(".viewportList").animate
          left: offsetX
        , 1000, ->
          $scope.isOnAnimation = false
          setOverlaySlidesVisible()
          $scope.$apply()
          return
        return

      addWatchers = ->
        $scope.$watch "slides", (val) ->
          return unless val
          $scope.carouselPanelWidth = $scope.slides.length * imagePanelWidth
          $element.find(".viewportList").css width: $scope.carouselPanelWidth + "px"
          setOverlaySlidesVisible()
          return
        return

      addListeners = ->
        $scope.$on "$destroy", removeListeners
        $element.find(".buttonLeft").on "focusin", handleButtonLeftFocusIn
        $element.find(".buttonRight").on "focusin", handleButtonRightFocusIn
        $element.find(".buttonLeft").on "focusout", handleButtonLeftFocusOut
        $element.find(".buttonRight").on "focusout", handleButtonRightFocusOut
        return

      removeListeners = ->
        $element.find(".buttonLeft").off "focusin", handleButtonLeftFocusIn
        $element.find(".buttonRight").off "focusin", handleButtonRightFocusIn
        $element.find(".buttonLeft").off "focusout", handleButtonLeftFocusOut
        $element.find(".buttonRight").off "focusout", handleButtonRightFocusOut
        return

      handleButtonLeftFocusIn = (e) ->
        e.target.focus()
        return

      handleButtonRightFocusIn = (e) ->
        e.target.focus()
        return

      handleButtonLeftFocusOut = (e) ->
        e.target.blur()
        return

      handleButtonRightFocusOut = (e) ->
        e.target.blur()
        return

      $scope.isLastGroup = ->
        currentLength = Math.abs($scope.carouselPanelX) + xOffset
        (currentLength) >= $scope.carouselPanelWidth

      $scope.onClickImageBtnPanel = (slide) ->
        $scope.onClick slide  if $scope.onClick
        return

      $scope.onMouseOverImage = (slide, index) ->
        $element.find(".overlay").hide()
        $element.find(".overlay" + index).show "blind", "fast"
        $scope.currentHoverSlide = slide
        return

      $scope.onMouseLeaveImage = (index) ->
        $element.find(".overlay" + index).hide "blind", "fast"
        $scope.currentHoverSlide = null
        return

      $scope.onClickButtonBack = (event) ->
        event.target.blur()
        return  if $scope.isOnAnimation or $scope.carouselPanelX >= 0
        showAllSlides ->
          animateSlideList.call null, ($scope.carouselPanelX += xOffset)
          return
        return

      $scope.onClickButtonNext = (event) ->
        event.target.blur()
        return  if $scope.isOnAnimation or $scope.isLastGroup()
        showAllSlides ->
          animateSlideList.call null, ($scope.carouselPanelX -= xOffset)
          return
        return

      $(window).resize(resizePanel)

      init()