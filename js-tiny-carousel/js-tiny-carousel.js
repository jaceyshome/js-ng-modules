define([
	'angular',
	'jquery'
], function() {
	var appModule = angular.module('lls.directive.tinyCarousel', []);

	return appModule.directive('jsTinyCarousel', ['$modalModel', function($modalModel) {

		return {

			scope: {
				interval: "=",
				slides: "=",
				imageShownNumber: "=",
				imageWidth: "=",
				imageMarginLeft: "=",
				imageMarginRight: "=",
				isImageBtn:"=",
				onClick: '='
			},

			template:
					'<div class="tinyCarouselSlider">' +
						'<a href="javascript:void(0)" onclick="return false;" class="buttonLeft" data-ng-class="{disable:carouselPanelX >= 0}" data-ng-click="onClickButtonBack($event)" title="previous group"><span class="llsScreenReaderText">back</span></a>' +
						'<div class="tinyCarouselContainer">' +
							'<div class="viewport">' +
								'<ul class="viewportList">' +
									'	<li class="imagePanelContainer" data-ng-repeat="slide in slides">' +

											/*'<div class="imagePanel" data-ng-show="!isImageBtn && !slide.underOverlay">' +*/
											'<div class="imagePanel" data-ng-show="!isImageBtn && !slide.underOverlay">' +
												'<div class="carouselImageContainer">' +
													'<a class="imagePanelHoverButton" href="javascript:void(0)" data-slide-index="{{$index}}" ' +
															'data-ng-focus-in="onMouseOverImage(slide, $index)"' +
															'onclick="return false;" data-ng-mouseover="onMouseOverImage(slide, $index)" ' +
															'title="hover to show overlay panel for {{slide.title}}">' +
														'<img class="viewportImage" src="" data-ng-src="{{slide.imageLink}}" alt="banner image for {{slide.title}}" >' +
													'</a>' +
												'</div>' +
												'<p class="slideTitle">{{slide.title}}</p>		' +
											'</div>' +

											'<div class="overlay overlay{{$index}}" data-ng-mouseleave="onMouseLeaveImage($index)"' +
													'data-ng-hide="slide.underOverlay">' +
												'<div class="overlayInner-block">' +
													'<div class="overlayInner">' +
														'<a class="buttonViewVideo" href="javascript:void(0)" onclick="return false;" ' +
																'title="This opens in a new window to view video of {{slide.title}}" data-ng-show="slide.videoLink" ' +
																'data-ng-click="launchVideo(slide.videoLink)">view video</a>' +
														'<a class="buttonViewFile" href="" data-ng-href="{{slide.fileLink}}"  ' +
																'title="This opens in a new window to view pdf of {{slide.title}}" data-ng-show="slide.fileLink" target="_blank"' +
																'data-ng-focus-out="onMouseLeaveImage($index)"' +
																'data-ng-focus-out="onMouseLeaveImage($index)">view pdf</a>' +
													'</div>' +
												'</div>' +
											'</div>' +

											'<div class="imagePanel" data-ng-show="isImageBtn && !slide.underOverlay">' +
												'<a class="imagePanelBtn" href="javascript:void(0)" onclick="return false;" data-ng-click="onClickImageBtnPanel(slide)" title="select the badge {{$index}}">' +
													'<img class="viewportImage" src="" data-ng-src="{{slide.imageLink}}" alt="banner image {{$index}}" >' +
												'</a>' +
											'</div>' +

									'</li>' +
								'</ul>' +
								'<div class="clear"></div>' +
							'</div>' +
						'</div>' +
						'<a href="javascript:void(0)" onclick="return false;" data-ng-class="{disable:isLastGroup()}"  class="buttonRight" data-ng-click="onClickButtonNext($event)" title="next group"><span class="llsScreenReaderText">next</span></a>' +
					'</div>',

			replace: true,

			link:function ($scope, $element, $attrs){
				// ------------------------------------------------------------------- Init
				var imageShowingTotal ;
				var imageWidth ;
				var marginRight ;
				var marginLeft ;
				var currentShowingNumber ;
				var imagePanelWidth ;
				var xOffset ;

				// ------------------------------------------------------------------- Scope Variables
				$scope.carouselPanelX = 0;
				$scope.carouselPanelWidth = 0;
				$scope.isOnAnimation = false;
				$scope.currentHoverSlide = undefined;

				// -------------------------------------------------------------------- Init
				var init = function init () {
					initParameters();
					resizePanel();
					addWatchers();
					addListeners();
				};

				// ---------------------------------------------------------------------------- Private Functions
				var initParameters = function(){
					imageShowingTotal = $scope.imageShownNumber || 4;
					imageWidth = $scope.imageWidth || 200;
					marginRight = $scope.imageMarginRight || 18;
					marginLeft = $scope.imageMarginLeft || 0;
					currentShowingNumber = $scope.imageShownNumber || 4;

					imagePanelWidth = marginLeft + imageWidth + marginRight;
					xOffset = imagePanelWidth * imageShowingTotal;
				};

				var resizeImagePage = function(newShowingImageNumber){
					var pageIndex;
					xOffset = imagePanelWidth * newShowingImageNumber;
					pageIndex = Math.floor($scope.carouselPanelX / xOffset);
					$scope.carouselPanelX =  pageIndex * xOffset;
				};

				var resizePanel = function(){
					var i, newContainerWidth, offsetShowingNumber;

					for(i=imageShowingTotal; i > 0; i--){
						var showingImageGroupWidth = imagePanelWidth * i - (marginLeft + marginRight);
						var carouselContainerWidth = $('.bleed-container-inner-block').width() * 0.9;

						if( Math.floor(carouselContainerWidth /  showingImageGroupWidth)==1){
							newContainerWidth = imagePanelWidth * i - (marginLeft + marginRight) + (marginLeft + marginRight);
							$element.find('.tinyCarouselContainer').css({"width":newContainerWidth + "px"});
							if(i!= currentShowingNumber){
								offsetShowingNumber = i - currentShowingNumber ;
								currentShowingNumber = i;
								resizeImagePage(i);
								reviewOverLaySlidesVisible(offsetShowingNumber);
							}
							break;
						}
					}

					$scope.isLastGroup();
				};

				var reviewOverLaySlidesVisible = function(offsetShowingNumber){
					if(!$scope.slides) return;

					if(offsetShowingNumber >= 0){
						getSlidesOutOfOverlay(offsetShowingNumber);
					}else{
						addSlidesUnderOverlay(-offsetShowingNumber);
					}
					setTimeout(function(){$scope.$apply();}, 100);

				};

				var getSlidesOutOfOverlay = function(total){
					//set slide.UnderOverlay = false
					var i,startIndex = NaN, endIndex = NaN;

					for( i = 0; i < $scope.slides.length; i++){
						if(!$scope.slides[i].underOverlay){
							if(!startIndex){
								startIndex = i;
							}
						}
						if(startIndex && $scope.slides[i].underOverlay){
							startIndex = i;
							endIndex = startIndex + total;
						}
						if(endIndex && total >= 0 && $scope.slides[i].underOverlay){
							$scope.slides[i].underOverlay = false;
							total--;
						}
						if(total <= 0 || endIndex == i){
							break;
						}
					}
				};

				var addSlidesUnderOverlay = function(total){
					//set slide.UnderOverlay = true
					var i, startIndex = NaN, endIndex = NaN;

					for( i = $scope.slides.length - 1; i >= 0 ; i--){
						if(!$scope.slides[i].underOverlay){
							if(!startIndex){
								startIndex = i;
								endIndex = startIndex - total;
							}
						}
						if(endIndex && startIndex && !$scope.slides[i].underOverlay){
							//console.log("addSlidesUnderOverlay = true", i);
							$scope.slides[i].underOverlay = true;
							total--;
						}
						if(total <= 0){
							break;
						}
					}
				};

				var setOverlaySlidesVisible = function(){

					if(!$scope.slides) return;

					var viewAreaWidth = $element.find(".tinyCarouselContainer").width();
					var i;
					var currentSlideX = 0;
					var viewAreaStartX = 0;
					var viewAreaEndX = viewAreaWidth + viewAreaStartX;

					for( i = 0; i < $scope.slides.length; i++){
						currentSlideX = $scope.carouselPanelX + (i + 1) * imageWidth;
						$scope.slides[i].underOverlay = (currentSlideX < viewAreaStartX || currentSlideX > viewAreaEndX);
					}
				};

				var showAllSlides = function(callback){
					var slide = {};
					$scope.slides.forEach(function(slide){
							slide.underOverlay = false;
						}
					);
					if(callback){	callback();}

				};

				var animateSlideList = function(offset){
					var offsetX = offset || 0;
					$scope.isOnAnimation = true;

					$element.find( ".viewportList" )
					.animate({
						left: offsetX
					}, 1000, function() {
						$scope.isOnAnimation = false;
						setOverlaySlidesVisible();
						$scope.$apply();
					});
				};

				var addWatchers = function addWatchers () {
					$scope.$watch('slides', function(val){
						if (!val) return;
						$scope.carouselPanelWidth = $scope.slides.length * imagePanelWidth;
						$element.find(".viewportList").css({"width":$scope.carouselPanelWidth + "px"});
						setOverlaySlidesVisible();
					});
				};

				var addListeners = function addListeners () {
					$scope.$on('$destroy', removeListeners);
					$element.find(".buttonLeft").on("focusin", handleButtonLeftFocusIn);
					$element.find(".buttonRight").on("focusin", handleButtonRightFocusIn);
					$element.find(".buttonLeft").on("focusout", handleButtonLeftFocusOut);
					$element.find(".buttonRight").on("focusout", handleButtonRightFocusOut);
				};

				var removeListeners = function removeListeners () {
					$element.find(".buttonLeft").off("focusin", handleButtonLeftFocusIn);
					$element.find(".buttonRight").off("focusin", handleButtonRightFocusIn);
					$element.find(".buttonLeft").off("focusout", handleButtonLeftFocusOut);
					$element.find(".buttonRight").off("focusout", handleButtonRightFocusOut);
				};

				// ---------------------------------------------------------------------------- $scope Functions
				$scope.launchVideo = function launchVideo (mediaId) {
					var template = '<iframe class="llsCarouselIFrame" name="Framename" src="iframeembedvideo?mediaid=' + mediaId + '" width="740" height="420" frameborder="0" scrolling="no" class="data-ng-scope"> </iframe>';
					$modalModel.content = template;
					$modalModel.visible = true;
				};

				$scope.isLastGroup = function (){
					currentLength = Math.abs($scope.carouselPanelX) + xOffset;
					return ( (currentLength) >= $scope.carouselPanelWidth );
				};

				// ---------------------------------------------------------------------------- event Handler Functions
				var handleButtonLeftFocusIn = function handleButtonLeftFocusIn(e){
					e.target.focus();
				};

				var handleButtonRightFocusIn = function handleButtonRightFocusIn(e){
					e.target.focus();
				};

				var handleImagePanelHoverButtonFocusIn = function handleImagePanelHoverButtonFocusIn(e){
					console.log(e.attr);
					e.target.focus();
				};

				var handleButtonLeftFocusOut = function handleButtonLeftFocusOut(e){
					e.target.blur();
				};

				var handleButtonRightFocusOut = function handleButtonRightFocusOut(e){
					e.target.blur();
				};

				var handleImagePanelHoverButtonFocusOut = function handleImagePanelHoverButtonFocusOut(e){
					e.target.blur();
				};

				$scope.onClickImageBtnPanel = function(slide){
					
					if($scope.onClick){
						$scope.onClick(slide);
					}
				};

				$scope.onMouseOverImage = function(slide, index){
					$element.find(".overlay").hide();
					$element.find(".overlay" + index).show("blind", "fast");
					$scope.currentHoverSlide = slide;
				};

				$scope.onMouseLeaveImage = function(index){
					$element.find(".overlay" + index).hide("blind", "fast");
					$scope.currentHoverSlide = undefined;
				};

				$scope.onClickButtonBack = function(event){
					event.target.blur();
					if($scope.isOnAnimation || $scope.carouselPanelX >= 0) return;
					showAllSlides(function(){
						(animateSlideList.call(null, ($scope.carouselPanelX += xOffset) ));
					});
				};

				$scope.onClickButtonNext = function(event){
					event.target.blur();
					if($scope.isOnAnimation || $scope.isLastGroup()) return;
					showAllSlides(function(){
						(animateSlideList.call(null, ($scope.carouselPanelX -= xOffset) ));
					});

				};

				// ---------------------------------------------------------------------------- Utility Functions

				$(window).resize(function(){
					resizePanel();
				});

				init();
			}
		};
	}]);
});