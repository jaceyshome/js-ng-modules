define [
  'angular'
  'angular_resource'
], (angular) ->
  appModule = angular.module 'common.appendstyle', []
  appModule.factory "AppendStyle", ($q, Helper) ->
    #service is for creating dynamic style after page loading,
    # It can be used for ng-class or ng-style or using class name directly
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

    setInteractiveButtonHoverStyles = (data)->
      interactiveHoverButtonStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "interactivate-button-"
        if data.modules[moduleKey]?.color?
          moduleColor = data.modules[moduleKey].color
        else
          moduleColor = defaultColor
        style = ".#{classSelector}#{moduleKey}:hover, .#{classSelector}#{moduleKey}:focus{
                background-color:#{moduleColor} !important;
                color: #FFFFFF !important;
                text-decoration: none;
                }"
        appendStyle(style)
        interactiveHoverButtonStyles[moduleKey] = classSelector+moduleKey
      service.data.interactiveHoverButtonStyles = interactiveHoverButtonStyles

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

    setModuleDefaultStyle = (data)->
      # Module default style: title
      moduleDefaultStyles = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-default-style-"
        if data.modules[moduleKey]?.color?
          moduleColour = data.modules[moduleKey].color
        else
          moduleColour = defaultColor
        # title h2 color is the module colour
        style = ".#{classSelector}#{moduleKey} h2{color: #{moduleColour};}"
        style += ".#{classSelector}#{moduleKey} h3{color: #{moduleColour};}"
        appendStyle(style)
        moduleDefaultStyles[moduleKey] = classSelector+moduleKey
      service.data.moduleDefaultStyles = moduleDefaultStyles

    setModuleBgColours = (data)->
      moduleBgColours = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-bg-colour-"
        if data.modules[moduleKey]?.color?
          moduleColour = data.modules[moduleKey].color
        else
          moduleColour = defaultColor
        style = ".#{classSelector}#{moduleKey}{background-color: #{moduleColour};}"
        appendStyle(style)
        moduleBgColours[moduleKey] = classSelector+moduleKey
      service.data.moduleBgColours = moduleBgColours

    setModuleBorderColours = (data)->
      moduleBorderColours = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-border-colour-"
        if data.modules[moduleKey]?.color?
          moduleColour = data.modules[moduleKey].color
        else
          moduleColour = defaultColor
        style = ".#{classSelector}#{moduleKey}{border-color: #{moduleColour};}"
        appendStyle(style)
        moduleBorderColours[moduleKey] = classSelector+moduleKey
      service.data.moduleBorderColours = moduleBorderColours

    setModuleFontHoverColours = (data)->
      moduleFontHoverColours = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-font-hover-colour-"
        if data.modules[moduleKey]?.color?
          moduleColour = data.modules[moduleKey].color
        else
          moduleColour = defaultColor
        style = ".#{classSelector}#{moduleKey}:hover, .#{classSelector}#{moduleKey}:focus{
                  color: #{moduleColour};
                }"
        appendStyle(style)
        moduleFontHoverColours[moduleKey] = classSelector+moduleKey
      service.data.moduleFontHoverColours = moduleFontHoverColours

    setModuleFontColours = (data)->
      moduleFontColours = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-font-colour-"
        if data.modules[moduleKey]?.color?
          moduleColour = data.modules[moduleKey].color
        else
          moduleColour = defaultColor
        style = ".#{classSelector}#{moduleKey}{color: #{moduleColour};}"
        appendStyle(style)
        moduleFontColours[moduleKey] = classSelector+moduleKey
      service.data.moduleFontColours = moduleFontColours

    setModuleInnerShadows = (data)->
      moduleInnerShadows = {}
      for moduleKey in data.moduleKeys
        defaultColor = "#000000"
        classSelector = "module-inner-shadow-"
        if data.modules[moduleKey]?.color?
          moduleColor = data.modules[moduleKey].color
        else
          moduleColor = defaultColor
        rgb = Helper.hex2rgb(moduleColor,0)
        rgba = Helper.rgb2rgba(rgb,0.6)
        style = ".#{classSelector}#{moduleKey}{
          -webkit-box-shadow: inset 0 0 15px #{rgba};
          -moz-box-shadow: inset 0 0 15px #{rgba};
          box-shadow: inset 0 0 15px #{rgba};}"
        appendStyle(style)
        moduleInnerShadows[moduleKey] = classSelector+moduleKey
      service.data.moduleInnerShadows = moduleInnerShadows

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

    service.appendModuleSideBarStyle = (moduleKey, percentage)->
      return unless moduleKey and percentage
      unless service.data.navigationSideBarStyles
        service.data.navigationSideBarStyles = {}
      return if service.data.navigationSideBarStyles.hasOwnProperty moduleKey
      classSelector = ".side-bar-marker-holder-module-#{moduleKey}"
      style = "#{classSelector}{height: #{percentage}}"
      appendStyle(style)
      service.data.navigationSideBarStyles[moduleKey] = classSelector

    service.init = (data)->
      deferred = $q.defer()
      setCurtButtonHoverStyles(data)
      setInteractiveButtonHoverStyles(data)
      setNavigationModuleLabelColors(data)
      setModuleDefaultStyle(data)
      setModuleInnerShadows(data)
      setModuleFontColours(data)
      setModuleFontHoverColours(data)
      setModuleBgColours(data)
      setModuleBorderColours(data)
      setMultipleChoiceOptionAddOnDefaultStyles(data)
      setMultipleChoiceOptionAddOnActivatedStyles(data)
      deferred.resolve(service.data)
      deferred.promise

    service
