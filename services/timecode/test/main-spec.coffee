define [
  "should"
  "angular_mocks"
  "common/timecode/main"
  ], ()->
  describe 'filter', ()->
    beforeEach angular.mock.module "common.timecode"
    describe "timecode", ->
      it 'should have a timecode filter', inject ($filter)->
        ($filter("timecode")).should.not.equal null

      it "should return 0 as 00:00:00", inject ($filter) ->
        ($filter("timecode")(0)).should.equal "00:00:00"
