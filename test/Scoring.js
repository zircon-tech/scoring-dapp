var Scoring = artifacts.require("./Scoring");

// test suite
contract('Scoring', function (accounts) {



    it('should be initialized with empty values', function () {
        return Scoring.deployed().then(function (instance) {
            return instance.getAppKey();
        }).then(function (data) {
            assert.equal(data[0], undefined,  "scorer must be undef");
        })
    });

});