const Tether = artifacts.require('Tether');
const Reward = artifacts.require('Reward');
const DBank = artifacts.require('DBank');

module.exports = async function(deployer, networrk, accounts) {
    await deployer.deploy(Tether);
    const tether = await Tether.deployed();

    await deployer.deploy(Reward);
    const reward = await Reward.deployed();

    await deployer.deploy(DBank, reward.address, tether.address);
    const dBank = await DBank.deployed();
    await reward.transfer(dBank.address,'1000000000000000000000000');

    await tether.transfer(accounts[1], '1000000000000000000');   
};