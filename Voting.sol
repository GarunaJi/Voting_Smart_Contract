
// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.4;

contract Voting {
    address public election_Commission;
    address public winner;

    struct voter {
        string name;
        uint voterId;
        uint age;
        string gender;
        uint voteCandidateId;
        address voterAddress;
    }

    struct candidate {
        string name;
        string party;
        uint age;
        string gender;
        uint candidateId;
        address candidateAddress;
        uint votes;
    }

    uint nextVoterId = 1;
    uint nextCandidateId = 1;

    mapping(uint => candidate) candidates;
    mapping(uint => voter) voters;
    bool stopVoting; // used to stop voting in the middle  

    constructor() {
        election_Commission = msg.sender;
    }

    modifier isVotingOver() {
        require(block.timestamp > endTime || stopVoting == true, "Voting is not over");
        _;
    }

    modifier onlyCommissioner() {
        require(election_Commission == msg.sender, "Only the Commissioner can perform this action");
        _;
    }

    uint startTime;
    uint endTime;

    function candidateRegistration(
        string calldata _name,
        string calldata _party,
        uint  _age,
        string calldata _gender
    ) external {
        require(msg.sender != election_Commission, "Election Commission can't be a candidate"); 
        require(candidateVerification(msg.sender), "Candidate already registered");
        require(_age >= 18, "Candidate is underage");
        require(nextCandidateId < 3, "Candidate registration is full");
          
        candidates[nextCandidateId] = candidate(_name, _party, _age, _gender, nextCandidateId, msg.sender, 0);
        nextCandidateId++;
    }

    function candidateVerification(address _person) internal view returns(bool) {
        for (uint i = 1; i < nextCandidateId; i++) {
            if (candidates[i].candidateAddress == _person) {
                return false;
            }
        }
        return true;
    }

    function candidateList() public view returns (candidate[] memory) {
        candidate[] memory array = new candidate[](nextCandidateId - 1);
        for (uint i = 1; i < nextCandidateId; i++) { 
            array[i - 1] = candidates[i];  
        }
        return array;
    }

    function voterRegister(string calldata _name, uint _age, string calldata _gender) public {
        require(_age >= 18, "You are not eligible, underage!");
        require(!voterVerification(msg.sender), "You have already registered");
        voters[nextVoterId] = voter(_name, nextVoterId, _age, _gender, 0, msg.sender);  
        nextVoterId++;   
    }
     
    function voterVerification(address _address) public view returns(bool) {
        for (uint i = 1; i < nextVoterId; i++) {
            if (voters[i].voterAddress == _address) {
                return true;
            }
        }
        return false;
    } 

    function voterList() public view returns (voter[] memory) {
        voter[] memory array = new voter[](nextVoterId - 1);
        for (uint i = 1; i < nextVoterId; i++) {
            array[i - 1] = voters[i];
        }
        return array;
    }

    function vote(uint _voterId, uint _candidateId) public isVotingOver {
        require(voters[_voterId].voteCandidateId == 0, 'You have already voted');
        require(voters[_voterId].voterAddress == msg.sender, "You are not a registered voter");
        require(startTime != 0, "Voting not started yet");
        require(nextCandidateId == 3, "Candidates have not registered");

        voters[_voterId].voteCandidateId = _candidateId;
        candidates[_candidateId].votes++;
    }

    function voteTime(uint _startTime, uint _endTime) public onlyCommissioner {
        startTime = block.timestamp + _startTime;
        endTime = startTime + _endTime;
    }

    function votingStatus() public view returns (string memory) {    
        if (startTime == 0) {
            return "Voting has not started";
        } else if (block.timestamp < endTime && !stopVoting) {
            return "Voting is in progress";
        } else {
            return "Voting has ended";
        }
    }

    function result() public view onlyCommissioner returns (string memory) {
        if (candidates[1].votes > candidates[2].votes) {
            return "Candidate 1 won";
        } else if (candidates[1].votes == candidates[2].votes) {
            return "Votes are equal";
        } else {
            return "Candidate 2 won";
        }
    }

    function emergency() public onlyCommissioner {
        stopVoting = true;
    }
}
