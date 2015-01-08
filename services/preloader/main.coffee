define [
  'angular'
  'preload'
  'underscore'
  ], ->
  module = angular.module 'common.preloader', [
  ]
  module.factory 'Preloader', ($q, $rootScope)->
    loadedFiles = []
    currentQueue = null
    extensions:[
      ".jpg"
      ".jpeg"
      ".png"
    ]
    load:(object)->
      queue = new createjs.LoadQueue()

      queue.on "complete", ()->
        # console.log "complete", event
        currentQueue = null
      , @
      queue.on "error", ()->
        console.log "Preload error:", event
      , @
      queue.on "fileload", (event)->
        return if _.contains loadedFiles, event.item.id
        loadedFiles.push event.item.id
        $rootScope.$apply()
        # console.log "  file loaded", event.item.id
      , @

      if currentQueue?
        currentQueue.setPaused true
        queue.next = currentQueue
      currentQueue = queue
      queuedObjects = []
      parsedObjects = []

      loadables = @getLoadables(object, @extensions)
      for loadable in loadables
        unless _.contains(loadedFiles, loadable) or _.contains(queuedObjects, loadable)
          queue.loadFile loadable
          queuedObjects.push loadable

    getLoaded:(path)->
      return _.contains loadedFiles, path

    #get if all loadable files in an object tree have been loaded
    getStructureLoaded:(object)->
      loadables = @getLoadables(object)
      for loadable in loadables
        return false unless _.contains loadedFiles, loadable
      return true

    getLoadables:(object, extentions)->
      loadables = []
      parsedObjects = []

      parseObject = (o, exts, loads, parsed)->
        return if _.contains parsed, o
        parsed.push o

        for k, v of o
          if typeof v is 'string' and contains(v, exts)
            unless _.contains(loads, v)
              loads.push(v)

          if v instanceof Array or v instanceof Object
            parseObject(v, exts, loads, parsed)

      contains = (filepath, extensions) ->
        file = filepath.toLowerCase()
        for ext in extensions
          return true if file.lastIndexOf(ext) isnt -1
        return false

      parseObject(object, extentions, loadables, parsedObjects)
      return loadables
