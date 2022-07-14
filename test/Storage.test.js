const { expect } = require('chai');
const { ethers } = require('hardhat');

describe('Storage Contract', function () {

  let storage;

  before(async function() {
    const Storage = await ethers.getContractFactory('Storage');
    storage = await Storage.deploy();
  });

  it('Set new writer and add number in store', async function () {

    const [owner, addr1] = await ethers.getSigners();

    await storage.addWriter(addr1.address);

    await storage.connect(addr1).store(100);

    expect(100).to.be.equal(await storage.retrieve());
    
  });

});