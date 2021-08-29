const DBank = artifacts.require('DBank');

module.exports = async function issueRewards(callback) {
    let dBank = await DBank.deployed();
    await dBank.issueRewards();
    console.log("Reward tokens have been issued successfully");
    callback();
}