// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FoudToken{
    string public tokenName;
    string public tokenSymbol;
    uint256 public tokenTotalSupply;
    address public owner;
    mapping(address => uint256) public balances;

    constructor(string memory _tokenName, string memory _tokenSymbol){
        tokenName = _tokenName;
        tokenSymbol =  _tokenSymbol;
        owner=msg.sender;
     }
     
     //get token
   function mint(uint256 amount) public{
        require(owner == msg.sender,"only the owner of token can call this method");
        balances[msg.sender] +=amount;
        tokenTotalSupply+=amount;
    }

    //transfer token
    function transfer( uint256 amount, address payee)public {
        require(balances[msg.sender] >= amount,"not enough balance");
        balances[payee] += amount;
        balances[msg.sender] -= amount;
    }

}