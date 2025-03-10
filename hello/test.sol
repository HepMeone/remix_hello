// this is a test
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Test {
    string private  greeting = "hello";  // this is a test
    function getGreeting() public view returns (string memory) {
            return greeting;
    }
    function setGreeting(string memory _greeting) public  {
            greeting = _greeting ;
    }
    function addGreeting()public view returns (string memory){
        return  string.concat(greeting," from this contract");
    }

    
}
