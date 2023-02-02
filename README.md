# Smart-Contract

Assignment from <b>Blockchain</b> course.<br>
This repository includes two contracts:

## BlindAuction.sol

This smart contract implements <a href="https://en.wikipedia.org/wiki/Vickrey_auction">Vickrey auction</a>.<br>
Most of the code is taken from <a href="https://docs.soliditylang.org/en/v0.8.10/solidity-by-example.html#id2">Soldity by Example</a> in blind auction.<br>
I modified the code to support the Vickrey auction.


## RockPaperScissors.sol

### Problem Statement

A tie between two participants happened in a competition, and a mechanism is needed to distribute the reward. The two participants agreed to use a <a href = "https://en.wikipedia.org/wiki/Rock_paper_scissors">rock-paper-scissors</a> game to decide whether one of them should take the reward, or distribute it equally among them. However, the participants were not at the same place to run this.
Write a smart contract that would enable the participants to run the protocol. Assume that the two participants have known addresses in advance, and that the contest manager is the creator of the contract. The contract creator will deposit the reward to the contract at the beginning as well.

### Explanation and Assumptions:

1) The manager deploys the contract and he pays the prize of the game and indicates the commitment period (picking phase) and the revealing period (both periods are specified in <b>MINUTES</b>) and the addresses of both user A and user B which are the competitors (They must be different).
2) The commitment phase begins where user A and user B are allowed to commit their picks where they pick rock, paper or scissors and they concatenate a nonce used for hiding and bidding properties.
3) Each user is allowed to pick only once and can’t change his commitment anytime after that.
4) Each user must pick either <b>“rock”</b>, <b>“paper”</b> or <b>“scissors”</b> and concatenate the nonce to it. Please consider the following assumptions:<br>
    * If the user committed anything else than the three bolded picks above and revealed it later he will lose the prize in the last phase. The strings here are <b>CASE SENSITIVE</b>.
    * If both users have committed wrong picks (as described above) the money will be distributed equally between them.
    * The picks and the nonce are both <b>strings</b>.
5) The commitment phase ends. No user is allowed to commit either if he didn’t commit before.
6) If a user didn’t commit he won’t be able to reveal anything.
7) The revealing phase begins, The users are allowed to reveal their picks.
8) If a user didn’t reveal his pick he would lose in the last phase and if both of them did that. The prize will be distributed evenly between them.
9) The user must provide the correct pick and nonce he picked so that his pick is saved and he’s considered as he has revealed.
10) The revealing phase ends and announcing the result phase begins.
11) User A, User B and the Manager are allowed to announce the result and the winner would get the prize and this will only execute <b>ONCE</b>.
12) The logic of deciding the winner is simple:
    * It checks that the game hasn’t already ended.
    * It checks that both users have already revealed and if not it will act as described in 8. (even if the other user revealed wrong typed pick)
    * It will check that the inputs are correct as described in 4.
    * If the first two checks have passed successfully it will decide the winner using the rules of the rock paper scissors game. (If both users picked the same pick.      the money would be divided evenly between them)
