// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
// Smart contract which implements RockPaperScissors
contract RockPaperScissors {
    // userA & userB are the two participants
    address payable public userA;
    address payable public userB;
    // manager is the contest 
    address public manager;
    // Game prize
    uint public prize;
    // Flags to detect whether userA and userB has decided their picks
    bool public hasPickedA;
    bool public hasPickedB;
    // Commitments of userA & user B
    bytes32 commitmentA;
    bytes32 commitmentB;

    // Errors which can occur

    /// User have already commited before.
    error userAlreadyCommited();
    /// User doesn't have the right to pick.
    error noRightToPick();

    // Modifiers to validate the inputs

    // Validetes that user has right to pick by doing:
    //   i) Checks that the user is either A or B.
    //  ii) Checks that neither of them has commited before. 
    modifier onlyHaveRightToPick(address user) {
        if (user != userA && user != userB) revert noRightToPick();
        if (user == userA && hasPickedA == true) revert userAlreadyCommited();
        if (user == userB && hasPickedB == true) revert userAlreadyCommited();
        _;
    }

    // Constructor for the contract
    constructor(
        address payable userA_in,
        address payable userB_in
    ) payable {
        userA = userA_in;
        userB = userB_in;
        prize = msg.value;
        manager = msg.sender;
        hasPickedA = false;
        hasPickedB = false;
    }
    
    // This function is called by the user when he picks the 
    function pick(bytes32 userPick) external 
        onlyHaveRightToPick(msg.sender) {

        if (msg.sender == userA) {
            hasPickedA = true;
            commitmentA = userPick;
        }
        else {
            hasPickedB = true;
            commitmentB = userPick;
        }
    }
}