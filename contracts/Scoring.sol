pragma solidity ^0.4.24;

contract Scoring {

    address public owner = msg.sender;

    event _newOrganization(bytes32 appKey, address sender);
    event _newScorer(bytes32 appKey, bytes32 scorerId, address sender);
    event _newResource(bytes32 appKey, bytes32 resourceId, address sender);
    event _newScore(bytes32 appKey, bytes32 scorerId, bytes32 resourceId, uint value);

    struct Scorer {
        bool proof;
    }

    struct Resource {
        bool proof;
        uint totalScore;
        uint averageScore;
        uint overallScore;
    }

    struct ScoringOptions {
        uint min;
        uint max;
    }

    struct Score {
        bytes32 sender;
        bytes32 receiver;
        uint originalValue;
        uint weight;
    }

    struct Organization {
        bool proof;
        ScoringOptions scoring;
        mapping (bytes32 => Scorer) scorers; // Authorized scorers
        mapping (bytes32 => Resource) resources; // Authorized resources to reveice score
        mapping (bytes32 => Score[]) scoresGiven; // Scores given by an scorer
        mapping (bytes32 => Score[]) scoresReceived; // Scores received by a resource
    }

    mapping (bytes32 => Organization) organizations;

    modifier ownerOnly {
        if (msg.sender == owner) _;
    }

    function _getTotalScore(bytes32 _appKey, bytes32 _resourceId, uint _value) internal view returns (uint) {
        return organizations[_appKey].resources[_resourceId].totalScore + _value;
    }

    function _getAverageScore(bytes32 _appKey, bytes32 _resourceId, uint _value) internal view returns (uint) {
        // (Overall score + New score) / Count Scores
        uint countScores = organizations[_appKey].scoresReceived[_resourceId].length + 1;
        return (organizations[_appKey].resources[_resourceId].averageScore + _value) / countScores;
    }

    function _getOverallScore(bytes32 _appKey, bytes32 _resourceId, uint _value) internal view returns (uint) {
        // ((Average Rating * Total Rating) + new Rating) / (Total Rating + 1)
        uint average = organizations[_appKey].resources[_resourceId].averageScore;
        uint total = organizations[_appKey].resources[_resourceId].totalScore;
        return ((average * total) + _value) / (total + 1);
    }

    function registerOrganization(bytes32 _appKey, uint _min, uint _max) public ownerOnly {
        organizations[_appKey].proof = true;
        organizations[_appKey].scoring = ScoringOptions(_min, _max);
        emit _newOrganization(_appKey, msg.sender);
    }

    function registerScorer(bytes32 _appKey, bytes32 scorerId, string _metadata) public ownerOnly {
        require(organizations[_appKey].proof == true, "App not found");

        organizations[_appKey].scorers[scorerId] = Scorer(true, _metadata);
        emit _newScorer(_appKey, scorerId, msg.sender);
    }

    function registerResource(bytes32 _appKey, bytes32 resourceId, string _metadata) public returns (bytes32) ownerOnly {
        require(organizations[_appKey].proof == true, "App not found");

        organizations[_appKey].resources[resourceId] = Resource(true, _metadata, 0, 0, 0);
        emit _newResource(_appKey, resourceId, msg.sender);
    }

    function sendScore(bytes32 _appKey, bytes32 _scorerId, bytes32 _resourceId, uint _value, uint _weight) public ownerOnly {
        require(organizations[_appKey].proof == true, "App not found");
        require(organizations[_appKey].scorers[_scorerId].proof == true, "Scorer not found");
        require(organizations[_appKey].resources[_resourceId].proof == true, "Resource not found");

        uint w = _weight;
        if (w == 0) {
            w = 1;
        }

        Score memory score = Score({ sender: _scorerId, receiver: _resourceId, originalValue: _value, weight: w });
        organizations[_appKey].scoresGiven[_scorerId].push(score);
        organizations[_appKey].scoresReceived[_resourceId].push(score);

        organizations[_appKey].resources[_resourceId].totalScore = _getTotalScore(_appKey, _resourceId, _value * w);
        organizations[_appKey].resources[_resourceId].averageScore = _getAverageScore(_appKey, _resourceId, _value * w);
        organizations[_appKey].resources[_resourceId].overallScore = _getOverallScore(_appKey, _resourceId, _value * w);

        emit _newScore(_appKey, _scorerId, _resourceId, _value * w);
    }

    function getScore(bytes32 _appKey, bytes32 _resourceId) public view returns (uint, uint, uint) ownerOnly {
        require(organizations[_appKey].proof == true, "App not found");
        require(organizations[_appKey].resources[_resourceId].proof == true, "Resource not found");

        uint totalScore = organizations[_appKey].resources[_resourceId].totalScore;
        uint averageScore = organizations[_appKey].resources[_resourceId].averageScore;
        uint overallScore = organizations[_appKey].resources[_resourceId].overallScore;
        return (totalScore, averageScore, overallScore);
    }
}

// orgid = 0xa8d99fc0290d7bc1fe5a8f2db41158c66a6ee3c3f6a89cfa0fe30af78622a917
// resourceid = 0xa8d99fc0290d7bc1fe5a8f2db41158c66a6ee3c3f6a89cfa0fe30af78622a918
// scorerid = 0xa8d99fc0290d7bc1fe5a8f2db41158c66a6ee3c3f6a89cfa0fe30af78622a919