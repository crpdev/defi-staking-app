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
        console.log("DBank Deployed Address: ", await dBank.address);
        console.log("DBank Owner address: ", await dBank.owner());
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

    describe('Staking Tokens', async () => {
        it('rewards tokens for staking', async() => {
            let result;
            // Check customer balance
            result = await tether.balanceOf(customer);
            console.log("Customer balance: ", result.toString());
            assert.equal(result.toString(), tokens('100'),'customer token balance before staking');
            await tether.approve(dBank.address, tokens('100'), {from: customer});
            await dBank.depositTokens(tokens('100'), {from: customer});
            result = await tether.balanceOf(customer);
            console.log("Customer balance: ", result.toString());
            assert.equal(result.toString(), tokens('0'),'customer token balance after staking');
            result = await tether.balanceOf(dBank.address);
            console.log("Dbank balance: ", result.toString());
            assert.equal(result.toString(), tokens('100'),'DBank token balance before staking');
            result = await dBank.isStaking[customer];
            assert.equal(result.toString(), 'true','Customer\'s staking status after staking');

            await dBank.issueTokens({from: owner});

            await dBank.issueTokens({from: customer}).should.be.rejected;
        });
    });
});