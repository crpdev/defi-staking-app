// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.7.0 <0.9.0;

import './Tether.sol';
import './Reward.sol';

contract DBank {
    address public owner;
    string public name = 'Decental Bank';
    Tether public tether;
    Reward public reward;
    
    constructor(Tether _tether, Reward _reward) {
        tether = _tether;
        reward = _reward;
    }

}