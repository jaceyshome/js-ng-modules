angular.module("jsMomentService", [])
.factory "jsMomentService", () ->
		momentService = {
				convertUTCToLocalDateTime:(input, utcFormat, localFormat)->
						unless angular.isDefined utcFormat
								utcFormat = "YYYY-MM-DD HH:mm:ss"

						unless angular.isDefined localFormat
								utcFormat = "hh:mm A DD/MM/YYYY"

						time = moment.utc(input, format).local()
						timeStamp = time.format(utcFormat)
						return timeStamp.toString()
		}

		return momentService

