define [
  'angular'
  'jquery'
], ->
  module = angular.module 'common.tntprint.directive', [
  ]
  module.directive 'tntPrint', ()->
    restrict: "A"
    scope: {
      selectedElement: "="
    }
    link: ($scope, $element, $attrs) ->
      element = $($attrs.tntPrint)
      $scope.$watch "selectedElement", (val)->
        if val then element = val
      cssfile = $attrs.cssfile
      ie8cssfile = $attrs.ie8cssfile
      if cssfile is undefined
        cssfile = "assets/css/style.css"
      if ie8cssFile is undefined
        ie8cssFile = cssfile

      $element.click( ()->
        printElement(element, cssfile, ie8cssfile)
      )

      printElement = (element, cssfile, ie8cssfile)->
        htmlContent = element.html()
        htmlBody = buildHtmlBody(htmlContent)
        cssStyle = "<link type='text/css' rel='stylesheet' href='"+ cssfile  + "' charset='utf-8'/>"
        header = "<head>" + cssStyle + "</head>"
        ie8CssStyle = "<link type='text/css' rel='stylesheet' href='"+ ie8cssfile  + "' charset='utf-8'/>"
        ie8Header = "<head>" + ie8CssStyle + "</head>"
        stylesheet = cssfile
        callback = ()->
          if(document.documentMode isnt 8)
            isPopup = false
            _iframe = new Iframe()
            printWindow = _iframe.contentWindow || _iframe
            writeDoc = _iframe.doc
            writeDoc.open()
            writeDoc.write("<html>" + header  + htmlBody + "</html>")
            writeDoc.close()
          else
            #For IE 8
            isPopup = true
            printWindow = new Popup()
            writeDoc = printWindow.doc
            writeDoc.open()
            writeDoc.write("<html>" + ie8Header  + htmlBody + "</html>")
            writeDoc.close()
          printWindow.focus()
          # IE 11
          if document.documentMode is 11
            try
              printWindow.document.execCommand "print", false, null
            catch e
              printWindow.print()
          else
            printWindow.print()
          if(isPopup)
            printWindow.close()
        callback()

      buildHtmlBody = (htmlContent)->
        htmlBody = "<body>" + htmlContent + "</body>"
        return htmlBody

      Iframe = ()->
        iframeStyle = 'border:0;position:absolute;width:0px;height:0px;left:0px;top:0px;'
        try
          iframe = document.createElement('iframe')
          document.body.appendChild(iframe)
          $(iframe).attr({ style: iframeStyle, src: "" })
          iframe.doc = null
          if iframe.contentDocument
            iframe.doc = iframe.contentDocument
          else iframe.doc = ( if iframe.contentWindow then iframe.contentWindow.document else iframe.document)
        catch error
          "#{error}. iframes may not be supported in this browser."
        if ( iframe.doc == null )
          throw iframe.doc.toString()
        return iframe

      Popup = ()->
        width = 1024
        height = 680
        x = 0
        y = 0
        windowAttr = "location=yes,statusbar=no,directories=no,menubar=no,titlebar=no,toolbar=no,dependent=no"
        windowAttr += ",width=" + width + ",height=" + height
        windowAttr += ",resizable=yes,screenX=" + x + ",screenY=" + y + ",personalbar=no,scrollbars=no"
        newWin = window.open( "", "_blank",  windowAttr )
        newWin.doc = newWin.document
        return newWin
