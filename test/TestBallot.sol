pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Ballot.sol";

contract TestBallot {
    Ballot ballot = Ballot(DeployedAddresses.Ballot());

    function testGetOwnerAddr() public {
        address owner = ballot.getOwnerAddr();
        address expected = msg.sender;
        Assert.equal(owner, expected, "Get Ownner Address wrong!");
    }
    
    function testSetTotalTickets() public {
        uint _totalTickets = 110;
        ballot.setTotalTickets(_totalTickets);
        Assert.equal(_totalTickets, ballot.totalTickets(), "Setting totalTicket wrong!");
    }

    function testSetTicketPerPerson() public {
        uint _ticketPerPerson = 2;
        ballot.setTicketPerPerson(_ticketPerPerson);
        Assert.equal(_ticketPerPerson, ballot.ticketPerPerson(), "Setting ticketPerPerson wrong!");
    }

    function testSetVoteToSamePersonLimit() public {
        uint _voteToSamePersonLimit = 2;
        ballot.setVoteToSamePersonLimit(_voteToSamePersonLimit);
        Assert.equal(_voteToSamePersonLimit, ballot.voteToSamePersonLimit(), "Setting voteToSamePersonLimit wrong!");
    }

    function testAddVoterAndGetVoterNum() public {
        ballot.addVoter(address(0xedb7475f5d48caA77282109b4ab31fc55194e868));
        ballot.addVoter(address(0xF7F00b7503b8a52CbE54A09c43A0AbBa6CAFbef2));
        Assert.equal(2, ballot.getVoterNum(), "Add voter failed!");
    }

    function testAddCandidateAndGetCandidateNum() public {
        ballot.addCandidate("0xaaaaaa");
        ballot.addCandidate("0xbbbbbb");
        Assert.equal(2, ballot.getCandidateNum(), "Add candidate failed!");
    }

    function testGetAllCandidates() public {
        bytes32[] memory candidateList = ballot.getAllCandidates();
        Assert.equal(2, candidateList.length, "Get all candidates wrong!");
    }

    function testGetAllVoters() public {
        address[] memory voterList = ballot.getAllVoters();
        Assert.equal(2, voterList.length, "Get all voters wrong!");
    }

    function testGetVoter() public {
        uint balance;
        (balance, ) = ballot.getVoter(address(0xedb7475f5d48caA77282109b4ab31fc55194e868));
        Assert.equal(2, balance, "Get voter wrong!");
    } 

    // function testVoteFor() public {
    //     ballot.voteFor("0xaaaaaa");
    //     uint balance;
    //     (balance, ) = ballot.getVoter(address(0xedb7475f5d48caA77282109b4ab31fc55194e868));
    //     Assert.equal(1, balance, "Vote failed!");
    // }

    function testTotalTicketsOf() public {
        uint num = ballot.totalTicketsOf("0xaaaaaa");
        Assert.equal(0, num, "Get total tickets of voter wrong!");
    }

    function testGetWinner() public {
        bytes32[] memory winner = ballot.getWinner();
        Assert.equal("0xaaaaaa", winner[0], "Get Winer wrong!");
    }
    
}