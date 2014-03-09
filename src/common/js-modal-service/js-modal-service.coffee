angular.module("jsModalService", [])
.factory "jsModalService", ['$modal', '$compile',($modal,$compile) ->

		modalService =

				modalDefaults :
						backdrop: true
						keyboard: true
						modalFade: true
						template :
								'<div class="modalPanel">
										<div class="modal-header">
											<h3>{{modalOptions.headerText}}</h3>
										</div>
										<div class="modal-body">[$content]</div>
										<div class="modal-footer">
										<button type="button" class="btn"
												data-ng-click="modalOptions.close()"
										>{{modalOptions.closeButtonText}}</button>
										<button class="btn btn-primary"
												data-ng-click="modalOptions.ok();"
										>{{modalOptions.actionButtonText}}</button>
										</div>
								</div>'

				modalOptions :
						closeButtonText: 'Close',
						actionButtonText: 'Save',
						headerText: '',
						bodyText: 'Modal body'


				showModal : (customModalDefaults, customModalOptions) ->
						unless customModalDefaults
								customModalDefaults = {}

						customModalDefaults.backdrop = 'static'
						return this.show(customModalDefaults, customModalOptions)

				show : (customModalDefaults, customModalOptions) ->
		#				Create temp objects to work with since
		# 			we're in a singleton service
						tempModalDefaults = {}
						tempModalOptions = {}

		#				Map angular-ui modal custom defaults to
		# 			modal defaults defined in service
						angular.extend(tempModalDefaults,this.modalDefaults, customModalDefaults)

		#				Map modal.html $scope custom properties to
		# 			defaults defined in service
						angular.extend(
								tempModalOptions,
								this.modalOptions,
								customModalOptions
						)

						tempModalDefaults.controller = ($scope, $modalInstance)->
								$scope.modalOptions = tempModalOptions
								$scope.modalOptions.ok = (result)->
										$modalInstance.close(result)
								$scope.modalOptions.close = (result)->
										$modalInstance.dismiss('cancel')

						$modal.open(tempModalDefaults).result

		return modalService
]