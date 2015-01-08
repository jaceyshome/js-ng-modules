define [
  'angular'
  'angular_resource'
], (angular) ->
  appModule = angular.module 'common.appendstyle', []
  appModule.factory "AppendStyle", ($q, Helper) ->
    #service is for creating dynamic style after page loading,
    # It can be used for ng-class or ng-style
    service = {}
    service.data = {}

    appendStyle = (style)->
      startMarker = "<style>"
      endMarker = "</style>"
      angular.element("head").append(startMarker+style+endMarker)

    setCurtButtonHoverStyles = (data)->
      curtButtonHoverStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "curtbutton-"
        if data.modules[moduleKey]?.color?
          moduleColor = Helper.colorLuminance(data.modules[moduleKey].color,-0.2)
        else
          moduleColor = defaultColor
        style = ".#{classSelector}#{moduleKey}:hover, .#{classSelector}#{moduleKey}:focus{
                color:#{moduleColor};
                background-color: #FFFFFF;
                text-decoration: none;
                }"
        appendStyle(style)
        curtButtonHoverStyles[moduleKey] = classSelector+moduleKey
      service.data.curtButtonHoverStyles = curtButtonHoverStyles

    setNavigationModuleLabelColors = (data)->
      navigationLabelStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#FFFFFF"
        classSelector = "sidenavigation-nav-module-container-"
        if data.modules[moduleKey]?.color?
          moduleColor = data.modules[moduleKey].color
        else
          moduleColor = defaultColor
        style = ".#{classSelector}#{moduleKey}:before{
                  display: block;
                  content: '';
                  width: 65px;
                  height: 3px;
                  background-color: #{moduleColor}}"
        appendStyle(style)
        navigationLabelStyles[moduleKey] = classSelector+moduleKey
      service.data.navigationLabelStyles = navigationLabelStyles

    setMultipleChoiceOptionAddOnDefaultStyles = (data)->
      multipleChoiceAddOnDefaultStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#FFFFFF"
        classSelector = "multiplechoice-add-on-default-"
        if data.modules[moduleKey]?.color?
          moduleColor = data.modules[moduleKey].color
        else
          moduleColor = defaultColor
        style = ".#{classSelector}#{moduleKey}:before{border-color:#{moduleColor} !important}"
        appendStyle(style)
        multipleChoiceAddOnDefaultStyles[moduleKey] = classSelector+moduleKey
      service.data.multipleChoiceAddOnDefaultStyles = multipleChoiceAddOnDefaultStyles

    setMultipleChoiceOptionAddOnActivatedStyles = (data)->
      multipleChoiceAddOnActivatedStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#FFFFFF"
        classSelector = "multiplechoice-add-on-activated-"
        if data.modules[moduleKey]?.color?
          moduleColor = Helper.colorLuminance(data.modules[moduleKey].color,-0.2)
        else
          moduleColor = defaultColor
        style = ".#{classSelector}#{moduleKey}:before{border-color:#{moduleColor} !important}"
        appendStyle(style)
        multipleChoiceAddOnActivatedStyles[moduleKey] = classSelector+moduleKey
      service.data.multipleChoiceAddOnActivatedStyles = multipleChoiceAddOnActivatedStyles

    service.init = (data)->
      deferred = $q.defer()
      setNavigationModuleLabelColors(data)
      setMultipleChoiceOptionAddOnDefaultStyles(data)
      setMultipleChoiceOptionAddOnActivatedStyles(data)
      setCurtButtonHoverStyles(data)
      deferred.resolve(service.data)
      deferred.promise

    service
