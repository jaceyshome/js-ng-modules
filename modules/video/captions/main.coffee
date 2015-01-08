define [
  'angular'
  'angular_sanitize'
  ], ->
  module = angular.module 'common.captions', ['templates', 'ngSanitize']
  module.directive 'tntCaptions', ($http, $sanitize)->
    restrict:"A"
    scope:
      src:"="
      currentTime:"="
    templateUrl:"common/captions/main"
    link:($scope, element, attrs) ->
      captions = null
      $scope.$watch "src", (val)->
        #console.log "src", val
        captions = null
        $scope.caption = null
        if val?
          $http({method: 'GET', url: val, cache: true}).then (result)->
            #console.log "result", result
            cue = undefined
            time = undefined
            text = undefined
            lines = result.data.split("\n")
            line = ""
            id = undefined
            i = 1
            j = lines.length
            captions = []
            while i < j
              # Line 0 should be 'WEBVTT', so skipping i=0
              line = vjs.trim(lines[i]) # Trim whitespace and linebreaks
              if line # Loop until a line with content
                
                # First line could be an optional cue ID
                # Check if line has the time separator
                if line.indexOf("-->") is -1
                  id = line
                  
                  # Advance to next line for timing.
                  line = vjs.trim(lines[++i])
                else
                  id = captions.length
                
                # First line - Number
                cue =
                  id: id # Cue Number
                  index: captions.length # Position in Array

                
                # Timing line
                time = line.split(" --> ")
                cue.startTime = parseCueTime(time[0])
                cue.endTime = parseCueTime(time[1])
                
                # Additional lines - Cue Text
                text = []
                
                # Loop until a blank line or end of lines
                # Assumeing trim('') returns false for blank lines
                text.push line  while lines[++i] and (line = vjs.trim(lines[i]))
                cue.text = text.join("<br/>")
                
                # Add this cue
                captions.push cue
              i++
            #console.log "captions", captions
            updateCaption()

      parseCueTime = (timeText) ->
        #console.log "parseCueTime", timeText
        parts = timeText.split(":")
        time = 0
        hours = undefined
        minutes = undefined
        other = undefined
        seconds = undefined
        ms = undefined
        
        # Check if optional hours place is included
        # 00:00:00.000 vs. 00:00.000
        if parts.length is 3
          hours = parts[0]
          minutes = parts[1]
          other = parts[2]
        else
          hours = 0
          minutes = parts[0]
          other = parts[1]
        
        # Break other (seconds, milliseconds, and flags) by spaces
        # TODO: Make additional cue layout settings work with flags
        other = other.split(/\s+/)
        
        # Remove seconds. Seconds is the first part before any spaces.
        seconds = other.splice(0, 1)[0]
        
        # Could use either . or , for decimal
        seconds = seconds.split(/\.|,/)
        
        # Get milliseconds
        ms = parseFloat(seconds[1])
        seconds = seconds[0]
        
        # hours => seconds
        time += parseFloat(hours) * 3600
        
        # minutes => seconds
        time += parseFloat(minutes) * 60
        
        # Add seconds
        time += parseFloat(seconds)
        
        # Add milliseconds
        time += ms / 1000  if ms
        time

      trim = (str)->
        str.toString().replace(/^\s+/, '').replace(/\s+$/, '')

      $scope.$watch "currentTime", (val)->
        updateCaption()

      updateCaption = ()->
        if $scope.currentTime? and captions?
          #console.log "$scope.currentTime", $scope.currentTime
          $scope.caption = null
          for caption in captions
            if caption.startTime <= $scope.currentTime and caption.endTime >= $scope.currentTime
              $scope.caption = caption.text
              break
          
