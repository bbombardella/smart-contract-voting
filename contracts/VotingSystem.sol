// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Voting System
 * @dev Smart contract for a secure voting system where each voter can only vote once
 * @author ;)
 */
contract VotingSystem {
    
    // Structure to represent a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    
    // State variables
    address public administrator; // Administrator address
    mapping(uint => Candidate) public candidates; // Mapping of candidates
    mapping(address => bool) public hasVoted; // Check if a voter has already voted
    mapping(address => bool) public authorizedVoters; // List of authorized voters
    uint public candidateCount; // Total number of candidates
    uint public totalVotes; // Total number of votes
    bool public votingOpen; // Voting status (open/closed)
    
    // Events
    event CandidateAdded(uint indexed candidateId, string name);
    event VoteCast(uint indexed candidateId, address indexed voter);
    event VoterAuthorized(address indexed voter);
    event VotingOpened();
    event VotingClosed();
    
    // Modifiers
    modifier onlyAdministrator() {
        require(msg.sender == administrator, "Only administrator can execute this function");
        _;
    }
    
    modifier votingInProgress() {
        require(votingOpen, "Voting is not open");
        _;
    }
    
    modifier authorizedVoter() {
        require(authorizedVoters[msg.sender], "You are not authorized to vote");
        _;
    }
    
    modifier hasNotVoted() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }
    
    /**
     * @dev Constructor - sets the administrator of the vote
     */
    constructor() {
        administrator = msg.sender;
        votingOpen = false;
    }
    
    /**
     * @dev Add a candidate (administrator only)
     * @param _name The name of the candidate
     */
    function addCandidate(string memory _name) external onlyAdministrator {
        require(!votingOpen, "Cannot add candidates during voting");
        require(bytes(_name).length > 0, "Candidate name cannot be empty");
        
        candidates[candidateCount] = Candidate(candidateCount, _name, 0);
        emit CandidateAdded(candidateCount, _name);
        candidateCount++;
    }
    
    /**
     * @dev Authorize a voter (administrator only)
     * @param _voter The address of the voter to authorize
     */
    function authorizeVoter(address _voter) external onlyAdministrator {
        require(_voter != address(0), "Invalid address");
        require(!authorizedVoters[_voter], "Voter already authorized");
        
        authorizedVoters[_voter] = true;
        emit VoterAuthorized(_voter);
    }
    
    /**
     * @dev Authorize multiple voters at once
     * @param _voters Array of addresses to authorize
     */
    function authorizeMultipleVoters(address[] memory _voters) external onlyAdministrator {
        for(uint i = 0; i < _voters.length; i++) {
            if(_voters[i] != address(0) && !authorizedVoters[_voters[i]]) {
                authorizedVoters[_voters[i]] = true;
                emit VoterAuthorized(_voters[i]);
            }
        }
    }
    
    /**
     * @dev Open the voting (administrator only)
     */
    function openVoting() external onlyAdministrator {
        require(candidateCount > 0, "Need at least one candidate to open voting");
        require(!votingOpen, "Voting is already open");
        
        votingOpen = true;
        emit VotingOpened();
    }
    
    /**
     * @dev Close the voting (administrator only)
     */
    function closeVoting() external onlyAdministrator {
        require(votingOpen, "Voting is already closed");
        
        votingOpen = false;
        emit VotingClosed();
    }
    
    /**
     * @dev Vote for a candidate
     * @param _candidateId The ID of the chosen candidate
     */
    function vote(uint _candidateId) external votingInProgress authorizedVoter hasNotVoted {
        require(_candidateId < candidateCount, "Candidate does not exist");
        
        // Record the vote
        candidates[_candidateId].voteCount++;
        hasVoted[msg.sender] = true;
        totalVotes++;
        
        emit VoteCast(_candidateId, msg.sender);
    }
    
    /**
     * @dev Get candidate information
     * @param _candidateId The ID of the candidate
     * @return id, name, voteCount
     */
    function getCandidate(uint _candidateId) external view returns (uint, string memory, uint) {
        require(_candidateId < candidateCount, "Candidate does not exist");
        Candidate memory candidate = candidates[_candidateId];
        return (candidate.id, candidate.name, candidate.voteCount);
    }
    
    /**
     * @dev Get all results
     * @return Arrays of IDs, names and votes of all candidates
     */
    function getResults() external view returns (uint[] memory, string[] memory, uint[] memory) {
        uint[] memory ids = new uint[](candidateCount);
        string[] memory names = new string[](candidateCount);
        uint[] memory votes = new uint[](candidateCount);
        
        for(uint i = 0; i < candidateCount; i++) {
            ids[i] = candidates[i].id;
            names[i] = candidates[i].name;
            votes[i] = candidates[i].voteCount;
        }
        
        return (ids, names, votes);
    }
    
    /**
     * @dev Get the winner ID (candidate with most votes)
     * @return winnerId_ The winner's ID
     * @return winnerName_ The winner's name
     */
    function getWinner() external view returns (uint winnerId_, string memory winnerName_) {
        require(candidateCount > 0, "No candidates");
        
        uint maxVotes = candidates[0].voteCount;
        for(uint i = 1; i < candidateCount; i++) {
            if(candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId_ = i;
                winnerName_ = candidates[winnerId_].name;
            }
        }
    }
    
    /**
     * @dev Check if an address has already voted
     * @param _voter The address to check
     * @return true if the voter has voted, false otherwise
     */
    function hasAlreadyVoted(address _voter) external view returns (bool) {
        return hasVoted[_voter];
    }
    
    /**
     * @dev Check if an address is authorized to vote
     * @param _voter The address to check
     * @return true if the voter is authorized, false otherwise
     */
    function isAuthorizedToVote(address _voter) external view returns (bool) {
        return authorizedVoters[_voter];
    }
    
    /**
     * @dev Get general voting statistics
     * @return candidateCount, totalVotes, votingOpen
     */
    function getStatistics() external view returns (uint, uint, bool) {
        return (candidateCount, totalVotes, votingOpen);
    }
}