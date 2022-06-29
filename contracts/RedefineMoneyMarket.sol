// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./StakingContract.sol";

contract RedefineMoneyMarket is StakingContract {

    // Parameters
    
    address private _owner;
    uint256 private _locked = 0;


    // Events

    event OwnerChanged(address indexed owner);


    // Modifiers

    /**
    * @dev Only owner guard
    */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Caller is not the owner");
        _;
    }

    // Constructor

    constructor (address tokenAddress) StakingContract(tokenAddress) {
        // _asset = tokenAddress;
        _owner = msg.sender;
        emit OwnerChanged(_owner);
    }

    // Functions

    /**
    * @dev Returns the owner of the contract
    */

    function owner() public view returns (address) {
        return _owner;
    }

    /**
    * @dev Sets a new owner for the staking contract
    */
    function setOwner(address newOwner) external onlyOwner {
        _owner = newOwner;
        emit OwnerChanged(_owner);
    }

}