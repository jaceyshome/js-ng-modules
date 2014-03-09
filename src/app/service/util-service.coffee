angular.module("utilService", [])
.factory "utilService", () ->
		utilService = {
				closeAllPopup:undefined
				openEditPanel:undefined
		}

		return utilService

