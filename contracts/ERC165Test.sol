// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC165Test {

    using ERC165Checker for address;

    constructor() {}

    modifier onlyERC20(address _address) {
        require(_address.supportsInterface(type(IERC20).interfaceId), "The address isn't compatible with an ERC20 Token.");
        _;
    }

    modifier onlyERC721(address _address){
        require(_address.supportsInterface(type(IERC721).interfaceId), "The address isn't compatible with an ERC721 Token.");
        _;
    }

    function verifyERC20(address _address) onlyERC20(_address) public view returns(string memory) {
        return "The address is compatible with an ERC20 Token.";
    }

    function verifyERC721(address _address) onlyERC721(_address) public view returns(string memory) {
        return "The address is compatible with an ERC721 Token.";
    }

}
