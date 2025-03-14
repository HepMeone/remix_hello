//SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GLDToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Gold", "GD") {
        _mint(msg.sender, initialSupply); //只要msg.sender不是address(0),就可以得到从零地址得到的initialSupply数量token
    }

    function mint(uint amount) external {
        
    }
}