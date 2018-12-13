pragma solidity ^0.4.24;

contract Scoring {

    event _newApp(bytes32 appKey, address sender);
    event _newScorer(bytes32 appKey, bytes32 scorerId, address sender);
    event _newResource(bytes32 appKey, bytes32 resourceId, address sender);
    event _newScore(bytes32 appKey, bytes32 scorerId, bytes32 resourceId, uint value);

    struct Scorer {
        bool proof;
        string metadata;
    }

    struct Resource {
        bool proof;
        string metadata;
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

    uint keyGen;
    mapping (bytes32 => Organization) public organizations;

    function _getHash() internal returns (bytes32) {
        keyGen++;
        return keccak256(abi.encodePacked(keyGen));
    }

    function getAppKey() public returns (bytes32) {
        return _getHash();
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

    function registerApp(bytes32 _appKey, uint _min, uint _max) public {
        organizations[_appKey].proof = true;
        organizations[_appKey].scoring = ScoringOptions(_min, _max);
        emit _newApp(_appKey, msg.sender);
    }

    function registerScorer(bytes32 _appKey, string _metadata) public returns (bytes32) {
        require(organizations[_appKey].proof == true, "App not found");

        bytes32 scorerId = _getHash();
        organizations[_appKey].scorers[scorerId] = Scorer({ proof: true, metadata: _metadata });
        emit _newScorer(_appKey, scorerId, msg.sender);
        return scorerId;
    }

    function registerResource(bytes32 _appKey, string _metadata) public returns (bytes32) {
        require(organizations[_appKey].proof == true, "App not found");

        bytes32 resourceId = _getHash();
        organizations[_appKey].resources[resourceId] = Resource({
            proof: true,
            metadata: _metadata,
            totalScore: 0,
            averageScore: 0,
            overallScore: 0
        });
        emit _newResource(_appKey, resourceId, msg.sender);
        return resourceId;
    }

    function sendScore(bytes32 _appKey, bytes32 _scorerId, bytes32 _resourceId, uint _value, uint _weight) public {
        require(organizations[_appKey].proof == true, "App not found");
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

    function getScore(bytes32 _appKey, bytes32 _resourceId, int _scoreType) public view returns (uint) {
        require(organizations[_appKey].proof == true, "App not found");

        // scoreType 1 -> averageScore
        // scoreType 2 -> overallScore
        // scoreType n -> totalScore
        if (_scoreType == 1) {
            return organizations[_appKey].resources[_resourceId].averageScore;
        } else if (_scoreType == 2) {
            return organizations[_appKey].resources[_resourceId].overallScore;
        }
        return organizations[_appKey].resources[_resourceId].totalScore;
    }
}
