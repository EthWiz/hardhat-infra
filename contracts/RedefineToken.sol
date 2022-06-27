// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RedefineToken is ERC20, Ownable {

    constructor (uint256 amount) ERC20("RedefineToken", "RDFN") {
        // sets owner == msg.sender
        super._mint(msg.sender, amount);
    }

}