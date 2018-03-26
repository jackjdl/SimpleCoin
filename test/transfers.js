var SimpleCoin = artifacts.require("SimpleCoin");

contract('SimpleCoin', accounts => {
    it("should have the name Simple Coin", () => {

        return SimpleCoin.deployed().then(instance => {
            return instance.name.call();
        }).then(name => {
            assert.equal(name.valueOf(), "Simple Coin", "Simple coin isn't the name")
        });

    });

    it("should have the symbol XSC", () => {

        return SimpleCoin.deployed().then(instance => {
            return instance.symbol.call();
        }).then(symbol => {
            assert.equal(symbol.valueOf(), "XSC", "XSC isn't the symbol");
        });

    });

    it("should have a total supply of 1000000", () => {

        return SimpleCoin.deployed().then(instance => {
            return instance.totalSupply.call();
        }).then(totalSupply => {
            assert.equal(totalSupply.valueOf(), 1000000, "1000000 isn't the total supply");
        });

    });

});
