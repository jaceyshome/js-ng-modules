#	require moment.js
# npm install moment
# deal with the IE8 problem

angular.module("jsMomentService", [])
.factory "jsMomentService", () ->
		momentService = {
				UTCToLocal:(input, utcFormat, localFormat)->
						_utcFormat = utcFormat or "YYYY-MM-DD HH:mm:ss"
						_localFormat = localFormat or "hh:mm A DD/MM/YYYY"

						time = moment.utc(input, _utcFormat).local()
						timeStamp = time.format(_localFormat)
						return timeStamp.toString()
		}

		return momentService

