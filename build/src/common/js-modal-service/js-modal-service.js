angular.module("jsModalService", []).factory("jsModalService", [
  '$modal', '$compile', function($modal, $compile) {
    var modalService;
    modalService = {
      modalDefaults: {
        backdrop: true,
        keyboard: true,
        modalFade: true,
        template: '<div class="modalPanel">\
										<div class="modal-header">\
											<h3>{{modalOptions.headerText}}</h3>\
										</div>\
										<div class="modal-body">[$content]</div>\
										<div class="modal-footer">\
										<button type="button" class="btn"\
												data-ng-click="modalOptions.close()"\
										>{{modalOptions.closeButtonText}}</button>\
										<button class="btn btn-primary"\
												data-ng-click="modalOptions.ok();"\
										>{{modalOptions.actionButtonText}}</button>\
										</div>\
								</div>'
      },
      modalOptions: {
        closeButtonText: 'Close',
        actionButtonText: 'Save',
        headerText: '',
        bodyText: 'Modal body'
      },
      showModal: function(customModalDefaults, customModalOptions) {
        if (!customModalDefaults) {
          customModalDefaults = {};
        }
        customModalDefaults.backdrop = 'static';
        return this.show(customModalDefaults, customModalOptions);
      },
      show: function(customModalDefaults, customModalOptions) {
        var tempModalDefaults, tempModalOptions;
        tempModalDefaults = {};
        tempModalOptions = {};
        angular.extend(tempModalDefaults, this.modalDefaults, customModalDefaults);
        angular.extend(tempModalOptions, this.modalOptions, customModalOptions);
        tempModalDefaults.controller = function($scope, $modalInstance) {
          $scope.modalOptions = tempModalOptions;
          $scope.modalOptions.ok = function(result) {
            return $modalInstance.close(result);
          };
          return $scope.modalOptions.close = function(result) {
            return $modalInstance.dismiss('cancel');
          };
        };
        return $modal.open(tempModalDefaults).result;
      }
    };
    return modalService;
  }
]);
