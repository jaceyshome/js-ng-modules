var IframePrintTemplate = function () {
	var error, iframe, iframeStyle;
	iframeStyle = 'border:0;position:absolute;width:0px;height:0px;left:0px;top:0px;';
	try {
		iframe = document.createElement('iframe');
		document.body.appendChild(iframe);
		$(iframe).attr({
			style: iframeStyle,
			src: ""
		});
		iframe.doc = null;
		iframe.doc = iframe.contentDocument ? iframe.contentDocument : (iframe.contentWindow ? iframe.contentWindow.document : iframe.document);
	} catch (_error) {
		error = _error;
		console.log("" + error + ". iframes may not be supported in this browser.");
	}
	if (iframe.doc === null) {
		throw "Cannot find document.";
	}
	return iframe;
};

var PopupPrintTemplate = function () {
	var height, newWin, width, windowAttr, x, y;
	width = 1024;
	height = 680;
	x = 0;
	y = 0;
	windowAttr = "location=yes,statusbar=no,directories=no,menubar=no,titlebar=no,toolbar=no,dependent=no";
	windowAttr += ",width=" + width + ",height=" + height;
	windowAttr += ",resizable=yes,screenX=" + x + ",screenY=" + y + ",personalbar=no,scrollbars=no";
	newWin = window.open("", "_blank", windowAttr);
	newWin.doc = newWin.document;
	return newWin;
};

angular.module("jsPrint", []).directive("jsPrint", function() {

	return {
		restrict: "A",

		scope: {
			cssfile: "@",
			ie8cssfile: "@",
			printTarget: "@"
		},

		link: function ($scope, $element, $attrs) {
			var isIE8;
			var deregisterDestroyListener;

			var init = function () {
				isIE8 = (document.documentMode === 8);

				addEventHandlers();
			};

			var addEventHandlers = function () {
				$element.on('click', handleClick);
				deregisterDestroyListener = $scope.$on('$destroy',removeEventHandlers);
			};

			var removeEventHandlers = function () {
				$element.off('click', handleClick);
				deregisterDestroyListener();
			};

			var createPrintFile = function(element, cssfile) {
				var head, body;
				if (element == null) {
					return;
				}
				head = "<head>" +
					((cssfile != null) ? "<link type='text/css' rel='stylesheet' href='" + cssfile + "' charset='utf-8'/>" : "") +
					"</head>";
				body = "<body>" + element.html() + "</body>";

				return	"<!DOCTYPE html>" + "<html>" + head + body + "</html>";
			};

			var print = function (html) {
				var printWindow, writeDoc, _iframe;

				if (isIE8) {
					printWindow = new PopupPrintTemplate();
					writeDoc = printWindow.doc;
				} else {
					_iframe = new IframePrintTemplate();
					printWindow = _iframe.contentWindow || _iframe;
					writeDoc = _iframe.doc;
				}
				writeDoc.open();
				writeDoc.write(html);
				writeDoc.close();
				printWindow.focus();
				printWindow.print();

				if (isIE8) {
					// Close IE8 popup
					printWindow.close();
				}
			};

			// ------------------------------ Handler Functions
			var handleClick = function () {
				var element,
					cssfile;

				element = $($scope.printTarget);

				cssfile = $scope.cssfile;
				if (isIE8 && $scope.ie8cssfile!= null) {
					cssfile = $scope.ie8cssfile;
				}

				print(createPrintFile(element, cssfile));
			};

			init();
		}
	};
});
