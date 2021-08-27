// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

contract Migrations {
    address public owner;
    uint public last_completed_migration;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function setCompleted(uint completed) public onlyOwner {
        last_completed_migration = completed;
    }

    function upgrade(address newAddress) public onlyOwner {
        Migrations upgraded = Migrations(newAddress);
        upgraded.setCompleted(last_completed_migration);
    }
}