// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RedefineMoneyMarket {

    // Parameters
    
    address private _asset;
    address private _owner;
    uint256 private _locked = 0;


    // Events

    event OwnerChanged(address indexed owner);
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);


    // Mappings

    mapping(address => uint256) public staked_balance;


    // Modifiers

    /**
    * @dev Reentrancy guard
    */
    modifier lock() {
        require(_locked == 0, "LOCKED");
        _locked = 1;
        _;
        _locked = 0;
    }

    /**
    * @dev Only owner guard
    */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Caller is not the owner");
        _;
    }

    // Constructor

    constructor (address tokenAddress) {
        
        _asset = tokenAddress;
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
    * @dev Returns the current staking asset of this contract
    */

    function asset() public view returns (address) {
        return _asset;
    }

    /**
    * @dev Sets a new owner for the staking contract
    */
    function setOwner(address newOwner) external onlyOwner {
        _owner = newOwner;
        emit OwnerChanged(_owner);
    }


    /**
    * @dev Deposits the asset into the staking protocol
    */
    function deposit(uint256 amount) external lock returns (bool success) {
        // uint256 balanceOf = IERC20(_asset).balanceOf(msg.sender);
        // require(balanceOf >= amount, "User has less than requested deposit amount");
        success = false;

        uint256 allowance = IERC20(_asset).allowance(msg.sender, address(this)); // not necessarily gas efficient
        require(allowance >= amount, "User allowed less than requested deposit amount");

        bool transferred = IERC20(_asset).transferFrom(msg.sender, address(this), amount);
        require(transferred, "Error transferring funds");
        staked_balance[msg.sender] += amount;

        emit Deposit(msg.sender, amount);
        success = true;
    }


    /**
    * @dev Withdraws the asset from the staking protocol 
    */
    function withdraw(uint256 amount) external lock returns (bool success) {
        success = false;
        require(staked_balance[msg.sender] >= amount, "Cannot withdraw more than staked balance");

        bool transferred = IERC20(_asset).transfer(msg.sender, amount);
        require(transferred, "Error transferring funds");
        staked_balance[msg.sender] -= amount;

        emit Withdraw(msg.sender, amount);
        success = true;
    }
}