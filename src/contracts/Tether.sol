// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.8.0 <0.9.0;

contract Tether {
    string public name = 'Tether';
    string public symbol = 'USDT';
    uint256 public totalSupply = 1000000000000000000000000; // Total supply of 1 million tokens
    uint8 public decimals = 18;

    // indexed allows the key to be searchable
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event TransferCall(address indexed _from, address indexed _to, uint256 _value);

    event Approve(address indexed _sender, address indexed _receiver, uint256 _value);

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    error insufficientBalance(uint256 available, uint256 requested);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balanceOf[msg.sender] < _value) {
            revert insufficientBalance({
                requested: _value,
                available: balanceOf[msg.sender]
            });
        }
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        emit TransferCall(_from, _to, _value);
        if (balanceOf[_from] < _value && allowance[_from][msg.sender] < _value) {
            revert insufficientBalance({
                requested: _value,
                available: balanceOf[_from]
            });
        }
        balanceOf[_to] += _value;
        balanceOf[_from] -= _value;
        allowance[msg.sender][_from] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approve(msg.sender, _spender, _value);
        return true;
    }
}