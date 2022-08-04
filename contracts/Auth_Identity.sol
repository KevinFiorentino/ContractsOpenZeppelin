// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Authentication {
    mapping(address => bool) public users;

    function authenticate() public {
        users[msg.sender] = true;
    }
}

contract Identity {

    // Authentication address
    address authAddr = address(0xf8e81D47203A594245E36C48e151709F0C19fBe8);

    struct BasicInfo {
        string name;
        string email;
    }

    struct PersonalInfo {
        uint256 salary;
        string _address;
    }

    enum UserType {
        Basic,
        Personal
    }

    error UserUnauthorized(address user, UserType userType);

    BasicInfo private basicInfo;
    PersonalInfo private personalInfo;
    address private owner;

    mapping(address => bool) private basicUsers;
    mapping(address => bool) private personalUsers;

    constructor(string memory name, string memory email, uint256 salary, string memory _address) verifyAuth(msg.sender) {
        basicInfo = BasicInfo(name, email);
        personalInfo = PersonalInfo(salary, _address);
        owner = msg.sender;
    }

    // Check if address is auth in Authentication
    modifier verifyAuth(address addrToVerify) {
        (bool success, bytes memory result) = authAddr.call{ gas: 5000 } (
            abi.encodeWithSignature("users(address)", addrToVerify)
        );
        require(success, "Fallo el llamado al otro contrato.");

        bool auth = abi.decode(result, (bool));
        require(auth, "El contrato no esta autenticado.");

        _;
    }

    modifier authorizeUser(UserType userType) {
        if (msg.sender == owner || personalUsers[msg.sender]) {
            _;
        } else if (userType == UserType.Basic && basicUsers[msg.sender]) {
            _;
        } else {
            revert UserUnauthorized(msg.sender, userType);
        }
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can authorize users");
        _;
    }

    function getBasicInfo() public view authorizeUser(UserType.Basic) returns (BasicInfo memory) {
        return basicInfo;
    }

    function getPersonalInfo() public view authorizeUser(UserType.Personal) returns (PersonalInfo memory) {
        return personalInfo;
    }

    function registerUser(UserType userType, address user) public onlyOwner verifyAuth(user) {
        if (userType == UserType.Basic) {
            basicUsers[user] = true;
        } else if (userType == UserType.Personal) {
            personalUsers[user] = true;
        }
    }
}
