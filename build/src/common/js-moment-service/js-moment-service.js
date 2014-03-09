angular.module("jsMomentService", []).factory("jsMomentService", function() {
  var momentService;
  momentService = {
    convertUTCToLocalDateTime: function(input, utcFormat, localFormat) {
      var time, timeStamp;
      if (!angular.isDefined(utcFormat)) {
        utcFormat = "YYYY-MM-DD HH:mm:ss";
      }
      if (!angular.isDefined(localFormat)) {
        utcFormat = "hh:mm A DD/MM/YYYY";
      }
      time = moment.utc(input, format).local();
      timeStamp = time.format(utcFormat);
      return timeStamp.toString();
    }
  };
  return momentService;
});
