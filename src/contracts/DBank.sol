// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

import './Tether.sol';
import './Reward.sol';

contract DBank {
    address public owner;
    string public name = 'Decentral Bank';
    Tether public tether;
    Reward public reward;

    event Deposit(address indexed _sender, address indexed _receiver, uint256 _value);
    
    constructor(Tether _tether, Reward _reward) {
        owner = msg.sender;
        tether = _tether;
        reward = _reward;
    }

    address[] public stakers;

    modifier onlyOwner() {
        require(msg.sender == owner, 'the caller must be the owner of this contract');
        _;
    }

    // Mapping to keep track of account's staking
    mapping(address => uint256) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    // Staking function to deposit USDT tokens
    function depositTokens(uint256 _amount) public {
        emit Deposit(msg.sender, address(this), _amount);

        // Enforce condition to check if staking amount is greater than zero
        require(_amount > 0, 'staking amount cannot be zero');
        
        tether.transferFrom(msg.sender, address(this), _amount);     
        
        // Update customer's staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }

    function issueRewardTokens() public onlyOwner {
        for (uint i=0;i<stakers.length;i++){
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient] / 9;
            require(balance > 0);
            reward.transfer(recipient, balance);
        }
    }

    function unstakeTokens() public {
        uint256 balance = stakingBalance[msg.sender]; 
        require(balance > 0, 'unstaking amount cannot be zero');
        tether.transfer(msg.sender, balance);
        stakingBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;
    }
}