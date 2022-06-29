// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import "./StakingContract.sol";
import "./RedefineMoneyMarketProxy.sol";

contract RedefineMoneyMarketUpgrade is RedefineMoneyMarketProxy {
    uint256 private _count;


    // Constructor

    // constructor (address tokenAddress) StakingContract(tokenAddress) {}
    

    // Functions 

    function count() public view returns (uint256) {
        return _count;
    }
}