// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract RedefineMoneyMarket {
    address private _owner;
    uint256 private _locked = 0;

    modifier lock() {
        require(_locked == 0, "LOCKED");
        _locked = 1;
        _;
        _locked = 0;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Caller is not the owner");
        _;
    }

    constructor () {
        _owner = msg.sender;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function setOwner(address _newOwner) external onlyOwner {
        _owner = _newOwner;
    }


}