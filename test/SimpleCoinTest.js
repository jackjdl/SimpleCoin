const truffleAssert = require('truffle-assertions');
const SimpleCoin = artifacts.require('SimpleCoin');

contract('SimpleCoin', (accounts) => {
  let trace = false;
  let contractSimpleCoin = null;
  beforeEach(async () => {
    contractSimpleCoin = await SimpleCoin.new({from: accounts[0]});
    if (trace) console.log('SUCESSO: SimpleCoin.new({from:accounts[0]}');
  });

  it('Should fail transferOwnership(address) when NOT comply with: msg.sender == owner', async () => {
    let result = await truffleAssert.fails(
      contractSimpleCoin.transferOwnership(accounts[2], {from: accounts[9]}),
      'revert',
    );
  });
  it('Should fail acceptOwnership() when NOT comply with: msg.sender == newOwner', async () => {
    await contractSimpleCoin.transferOwnership(accounts[3], {
      from: accounts[0],
    });
    let result = await truffleAssert.fails(
      contractSimpleCoin.acceptOwnership({from: accounts[9]}),
      'revert',
    );
  });
  it('Should fail declineOwnership() when NOT comply with: msg.sender == newOwner', async () => {
    await contractSimpleCoin.transferOwnership(accounts[5], {
      from: accounts[0],
    });
    let result = await truffleAssert.fails(
      contractSimpleCoin.declineOwnership({from: accounts[9]}),
      'revert',
    );
  });
});
