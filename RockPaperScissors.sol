// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;
// Smart contract which implements RockPaperScissors
contract RockPaperScissors {
    // userA & userB are the two participants
    address payable public userA;
    address payable public userB;
    address public manager;
    // Game prize
    uint public prize;
    // Flags to detect whether userA and userB has decided their picks
    bool public hasPickedA;
    bool public hasPickedB;
    // Commitments of userA & userB
    bytes32 commitmentA;
    bytes32 commitmentB;
    // Flags to detect whether userA and userB has already revealed or not
    bool public hasRevealedA;
    bool public hasRevealedB;
    // Picks of the users hashes
    bytes32 public pickA;
    bytes32 public pickB;
    // Flag to detect if the game has ended
    bool public ended; 

    // Errors which can occur

    /// User have already commited before.
    error userAlreadyCommited();
    /// User doesn't have the right to pick.
    error noRightToPick();
    /// User have already revealed before.
    error userAlreadyRevealed();
    /// User doesn't have the right to reveal.
    error noRightToReveal();
    /// User has entered wrong data while revealing
    error wrongData();
    /// The game has already ended.
    error gamedEnded();
    /// User has no right to announce the result.
    error noRightToAnnounceTheResult();

    // Modifiers to validate the inputs

    // Validetes that user has right to pick by doing:
    //   i) Checks that the user is either A or B.
    //  ii) Checks that neither of them have commited before. 
    modifier onlyHaveRightToPick(address user) {
        if (user != userA && user != userB) revert noRightToPick();
        if (user == userA && hasPickedA == true) revert userAlreadyCommited();
        if (user == userB && hasPickedB == true) revert userAlreadyCommited();
        _;
    }
    // Validetes that user has right to reveal by doing: (same as above)
    //   i) Checks that the user is either A or B.
    //  ii) Checks that neither of them have revealed before. 
    modifier onlyHaveRightToReveal(address user) {
        if (user != userA && user != userB) revert noRightToReveal();
        if (user == userA && hasRevealedA == true) revert userAlreadyRevealed();
        if (user == userB && hasRevealedB == true) revert userAlreadyRevealed();
        _;
    }

    // Constructor for the contract
    constructor(
        address payable userA_in,
        address payable userB_in
    ) payable {
        userA = userA_in;
        userB = userB_in;
        manager = msg.sender;
        prize = msg.value;
        hasPickedA = false;
        hasPickedB = false;
        hasRevealedA = false;
        hasRevealedB = false;
        ended = false;
    }
    
    // This function is called by the user in the pick phase.
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

    // This function is called by the user in the revealing phase.
    function reveal(string calldata pick, string calldata nonce) external
        onlyHaveRightToReveal(msg.sender) {

        if (msg.sender == userA && hasPickedA == true && commitmentA == keccak256(abi.encodePacked(pick, nonce))) {
            hasRevealedA = true;
            pickA = keccak256(bytes(pick));
        }
        else if (hasPickedB == true && commitmentB == keccak256(abi.encodePacked(pick, nonce))) {
            hasRevealedB = true;
            pickB = keccak256(bytes(pick));
        }
        else revert wrongData();
    }

    // This function is called by the manager or userA or userB
    // to announce the winner so he gets his prize.
    function announceResult() external {
        if (ended == true) revert gamedEnded();
        if (msg.sender != manager && msg.sender != userA && msg.sender != userB)
            revert noRightToAnnounceTheResult();
        ended = true;
        prize = 0;
        if (hasRevealedA == true && hasRevealedB == true) { // Both revealed
            uint stateA = parseUserPick(pickA);
            uint stateB = parseUserPick(pickB);
            if (stateA > 0 && stateB > 0) { // Both inputs are correct
                // Implementing rock paper scissors rules.
                // (1,rock) (2,papper) (3,scissors)
                if (stateA == 1) {
                    if (stateB == 1) {
                        userA.transfer((prize/2));
                        userB.transfer((prize/2));
                    }
                    else if (stateB == 2) userB.transfer(prize);
                    else userA.transfer(prize);
                }
                else if (stateA == 2) {
                    if (stateB == 1) userA.transfer(prize);
                    else if (stateB == 2) {
                        userA.transfer((prize/2));
                        userB.transfer((prize/2));
                    }
                    else userB.transfer(prize);
                }
                else {
                    if (stateB == 1) userB.transfer(prize);
                    else if (stateB == 2) userA.transfer((prize/2));
                    else {
                        userA.transfer((prize/2));
                        userB.transfer((prize/2));
                    }
                }
            }
            else if (stateA > 0 && stateB == 0) userA.transfer(prize);
            else if (stateA == 0 && stateB > 0) userB.transfer(prize);
            else  { // Both are incorrect
                userA.transfer((prize/2));
                userB.transfer((prize/2));
            }
        }
        else if (hasRevealedA == true && hasRevealedB == false) userA.transfer(prize);
        else if (hasRevealedA == false && hasRevealedB == true) userB.transfer(prize);
        else { // Both didn't reveal
            userA.transfer((prize/2));
            userB.transfer((prize/2));
        }
    }

    // Private helper functions

    // Returns integer which represent the state of the pick of certain user
    // 0 -> Wrong pick || 1 -> Rock || 2 -> Papper || 3 -> Scissors
    function parseUserPick(bytes32 pick) internal pure returns (uint state) {
        if (pick == keccak256("rock")) return 1;
        else if (pick == keccak256("paper")) return 2;
        else if (pick == keccak256("scissors")) return 3;
        return 0;
    }
}