pragma solidity ^0.4.17;

contract System{
    //the person who is admin
    address public admin;
    // topic of election
    string public topic; 
    //bounds of the election
    uint public startTime;
    uint public endTime;

    //structure of the candidate
    struct Candidate{
        //starts from index 1
        uint candidateId; 
        string name;
    }

    //vote count at each index
    mapping(uint => uint) private voteCount;

    uint public candidateCount;

    //mapping of each Candiate to its id
    mapping(uint => Candiate) public candidates;

    //structure of the voter
    struct Voter {
        address voterAddress;
        string name;
        //security parameter
        bool voted;
        bool registered;
        //whom voter has voted
        uint candidateId;
    }

    
    uint private votersCount;
    //so we can check if the voter is registered or not
    //voted or not
    mapping(address => Voter) private voters;

    function System() public{
        admin = msg.sender;
        startTime = now;
        endTime = startTime + 5 minutes;
        topic = "class elections div B";
        candidates[1] = Candidate(1, 'Pratik Pawar');
        candidates[2] = Candidate(2, 'Swaraj Patil');
        candidates[3] = Candidate(3, 'Sumit Sawant');
        candidates[4] = Candidate(4, 'Aman Sabale');
        candidateCount = 4;
    }

    //SECURITY MEASURES

    //tells only admin can call this method
    modifier adminOnly(){
        require(admin = msg.sender);
        _;
    }

    //tells only registered voter can call this method
    modifier registeredVotersOnly(){
        require(voters[msg.send].registered);
        _;
    }

    //voting time bounds
    modifier withinTimeLimit(){
        require(now < endTime);
        _;
    }

    modifier afterTimeLimit(){
        require(now > endTime);
        _;
    }


    //events
    event voterRegistered(address _voterAddress);

    event votedCasted(address _voterAddress);

    function isAdmin() public view returns(bool){
        return (msg.sender == admin);
    }

    function isVoterRegistered() public view returns(bool){
        return (voters[msg.sender].registered);
    }

    function getCurrentVoter() public view returns (address, string memory, bool, bool, uint){
        Voter memory voter = voters[msg.sender];

        return (voter.voterAddress, voter.name, voter.voted, voter.registered, voter.candidateId);
    }

    function addVoter(string memory _name) public {
        votersCount++;
        voters[msg.sender] = Voter(msg.sender, _name, false, true, 0);
        emit voterRegistered(msg.sender); 
    }

    //main voting function
    function vote(uint _candidateId) public registeredVotersOnly withinTimeLimit{
        require(!voters[msg.sender].voted);
        voteCount[_candidateId]++;
        voters[msg.sender].voted = true;
        voters[msg.sender].candidateId = _candidateId;
        emit voteCasted(msg.sender);
    }

    fucntion getVoteCountFor(uint _candidateId) public view afterTimeLimit returns(uint, string memory){
        return (voteCount[_candidateId], candidates[_candidateId].name);
    }

    function getWinningCandiate() public view afterTimeLimit returns (uint, string memmory, uint){
        uint maxvote = 0;
        uint maxVoteCandidateId = 0;

        for(uint i = 0; i < candidatesCount; i++){
            if(maxVote < voteCount[i]){
                maxVote = voteCount[i];
                maxVoteCandidateId = i;
            }
        }

        return (maxVoteCandidateId, candidiate[maxVoteCandidateId].name, maxVote);
    }




}