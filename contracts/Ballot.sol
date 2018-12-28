pragma solidity ^0.4.23;

/// @title Ballot System
/// @author Linwh
/// @notice The contract of ballot system
contract Ballot {
    
    // In this system, we save the voter's info as follows
    struct Voter {
        address addr;
        uint ticketBalanced;
        uint[] ticketVotedForCandidate;
    }
    
    // Two mapping for voter and candidate
    mapping(address => Voter) public voterInfo;
    mapping(bytes32 => uint) public candidateResult;
    
    // other variables in the contract
    address private ownerAddr;
    bytes32[] public candidatesList;
    address[] public voterList;
    bytes32[] public winner;
    uint public ticketPerPerson;
    uint public totalTickets;
    uint public balanceTickets;
    uint public voteToSamePersonLimit;
    
    // modifier to limit the user
    // modifier onlyOwner() {
    //     require(msg.sender == ownerAddr);
    //     _;
    // }
    
    constructor () public {
        ticketPerPerson = 1;
        ownerAddr = msg.sender;
        totalTickets = 100;
        balanceTickets = 100;
        voteToSamePersonLimit = 1;
    }
    
    // owner authority
    
    /// @dev A function to set totalTickets
    function setTotalTickets(uint _totalTickets) public {
        totalTickets = _totalTickets;
    }
    
    /// @dev A funtion to set ticketPerPerson
    function setTicketPerPerson(uint _ticketPerPerson) public {
        ticketPerPerson = _ticketPerPerson;
    }
    
    /// @dev A function to set voteToSamePersonLimit
    function setVoteToSamePersonLimit(uint _voteToSamePersonLimit) public {
        voteToSamePersonLimit = _voteToSamePersonLimit;
    }
    
    /// @dev A function to transfer the ownership to others
    function transferOwnership(address _newOwner) public {
        ownerAddr = _newOwner;
    }
    
    /// @dev A function to give voting right to address
    function addVoter(address _addr) public {
        // prevent from the same
        require(_indexOfVoter(_addr) == uint(-1));
        voterList.push(_addr);
        voterInfo[_addr].addr = _addr;
        if (balanceTickets < ticketPerPerson) {
            totalTickets += ticketPerPerson*10;
            balanceTickets += ticketPerPerson*10;
        }
        voterInfo[_addr].ticketBalanced = ticketPerPerson;
        balanceTickets -= ticketPerPerson;
    }
    
    /// @dev A function to add new candidates
    function addCandidate(bytes32 _candidateName) public {
        // prevent from the same
        require(_indexOfCandidate(_candidateName) == uint(-1));
        candidatesList.push(_candidateName);
        candidateResult[_candidateName] = 0;
    }
    
    // basic function
    
    /// @dev A function to get the owner address
    function getOwnerAddr() public view returns (address){
        return ownerAddr;
    }

    /// @dev A function to get the tickets of the candidate
    function totalTicketsOf(bytes32 _candidateName) public view returns (uint) {
        return candidateResult[_candidateName];
    }
    
    /// @dev A function to get all candidates
    function getAllCandidates() public view returns (bytes32[]) {
        return candidatesList;
    }
    
    /// @dev A function to get all voters 
    function getAllVoters() public view returns (address[]) {
        return voterList;
    }
    
    /// @dev A function to get Voter Info
    function getVoter(address _addr) public view returns (uint, uint[]) {
        return (voterInfo[_addr].ticketBalanced, voterInfo[_addr].ticketVotedForCandidate);
    }
    
    /// @dev A function to get Winner
    function getWinner() public returns (bytes32[]) {
        winCandidate();
        return winner;
    }
    
    /// @dev A function to get the number of voter
    function getVoterNum() public view returns (uint) {
        return voterList.length;
    }
    
    /// @dev A function to get the number of candidate
    function getCandidateNum() public view returns (uint) {
        return candidatesList.length;
    }
    
    /// @dev A function to vote for the candidates
    function voteFor(bytes32 _candidateName) public {
        uint index = _indexOfCandidate(_candidateName);
        require(index != uint(-1));
        require(_indexOfVoter(msg.sender) != uint(-1));
        require(voterInfo[msg.sender].ticketBalanced >= uint(1));
        if (voterInfo[msg.sender].ticketVotedForCandidate.length == 0) {
            for (uint i = 0; i < candidatesList.length; i++) {
                voterInfo[msg.sender].ticketVotedForCandidate.push(0);
            }
        }
        require(voterInfo[msg.sender].ticketVotedForCandidate[index] < voteToSamePersonLimit);
        voterInfo[msg.sender].ticketBalanced--;
        candidateResult[_candidateName]++;
        voterInfo[msg.sender].ticketVotedForCandidate[index]++;
    }
    
    
    // private function

    /// @dev A function to calculate the highest tickets
    function winCounts() public view returns (uint) {
        uint counts = 0;
        for (uint i = 0; i < candidatesList.length; i++) {
            if (candidateResult[candidatesList[i]] > counts) {
                counts = candidateResult[candidatesList[i]];
            }
        }
        return counts;
    }

    /// @dev A function to get the winner and save it into winner array
    function winCandidate() private {
        uint counts = winCounts();
        for (uint j = 0; j < candidatesList.length; j++) {
            if (candidateResult[candidatesList[j]] == counts) {
                winner.push(candidatesList[j]);
            }
        }
    }    

    /// @dev A function to return the index of the candidate
    function _indexOfCandidate(bytes32 _candidateName) private view returns (uint) {
        for (uint i = 0; i < candidatesList.length; i++) {
            if (candidatesList[i] == _candidateName) {
                return i;
            }
        }
        return uint(-1);
    }
    
    /// @dev A function to return the index of the voter
    function _indexOfVoter(address _addr) private view returns (uint) {
        for (uint i = 0; i < voterList.length; i++) {
            if (voterList[i] == _addr) {
                return i;
            }
        }
        return uint(-1);
    }
    
    
}