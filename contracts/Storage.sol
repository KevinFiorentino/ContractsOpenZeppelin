// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Storage is AccessControl {

    bytes32 public constant ROL_ADMIN = keccak256("ROL_ADMIN");
    bytes32 public constant ROL_WRITER = keccak256("ROL_WRITER");

    uint256 number;

    constructor() {
        _grantRole(ROL_ADMIN, msg.sender);
    }

    modifier onlyAdmin {
        require(hasRole(ROL_ADMIN, msg.sender), "To add a new writer, you need to be a Admin for this project.");
        _;
    }

    modifier onlyWriter {
        require(hasRole(ROL_WRITER, msg.sender), "You need to be a Writer to use this function.");
        _;
    }

    function store(uint256 num) public onlyWriter {
        number = num;
    }

    function retrieve() public view returns (uint256){
        return number;
    }

    function addWriter(address account) public onlyAdmin {
        _grantRole(ROL_WRITER, account);
    }
}