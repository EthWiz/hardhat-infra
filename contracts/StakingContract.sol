// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract StakingContract is ReentrancyGuard {

    // Parameters
    
    address internal _asset;


    // Events

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);


    // Mappings

    mapping(address => uint256) public staked_balance;

    // Constructor

    constructor (address tokenAddress) {
        _asset = tokenAddress;
    }

    // Functions

    /**
    * @dev Returns the current staking asset of this contract
    */

    function asset() public view returns (address) {
        return _asset;
    }


    /**
    * @dev Deposits the asset into the staking protocol
    */
    function deposit(uint256 amount) external nonReentrant returns (bool success) {
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
    function withdraw(uint256 amount) external nonReentrant returns (bool success) {
        success = false;
        require(staked_balance[msg.sender] >= amount, "Cannot withdraw more than staked balance");

        bool transferred = IERC20(_asset).transfer(msg.sender, amount);
        require(transferred, "Error transferring funds");
        staked_balance[msg.sender] -= amount;

        emit Withdraw(msg.sender, amount);
        success = true;
    }
}