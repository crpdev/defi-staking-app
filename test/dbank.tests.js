const Tether = artifacts.require('Tether');
const Reward = artifacts.require('Reward');
const DBank = artifacts.require('DBank');

require('chai').use(require('chai-as-promised')).should();

contract ('DBank', ([owner, customer]) => {
    let tether, reward;

    function tokens(number) {
        return web3.utils.toWei(number, 'ether');
    }

    before(async () => {
        tether = await Tether.new();
        reward = await Reward.new();
        dBank = await DBank.new(tether.address, reward.address);
        await reward.transfer(dBank.address, tokens('1000000'));
        await tether.transfer(customer, tokens('100'), { from: owner});
    })

    describe('Tether Token Deployment', async () => {
        it('matches name successfully', async() => {
            const name = await tether.name();
            assert.equal(name, 'Tether');
        });
    });

    describe('Reward Token Deployment', async () => {
        it('matches name successfully', async() => {
            const name = await reward.name();
            assert.equal(name, 'Reward Token');
        });
    });

    describe('DBank Deployment', async () => {
        it('contract has tokens', async() => {
            let balance = await reward.balanceOf(dBank.address);
            assert.equal(balance, tokens('1000000'));
        });
    });
});