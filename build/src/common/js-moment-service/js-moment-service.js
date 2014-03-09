angular.module("jsMomentService", []).factory("jsMomentService", function() {
  var momentService;
  momentService = {
    UTCToLocal: function(input, utcFormat, localFormat) {
      var time, timeStamp, _localFormat, _utcFormat;
      _utcFormat = utcFormat || "YYYY-MM-DD HH:mm:ss";
      _localFormat = localFormat || "hh:mm A DD/MM/YYYY";
      time = moment.utc(input, _utcFormat).local();
      timeStamp = time.format(_localFormat);
      return timeStamp.toString();
    }
  };
  return momentService;
});
