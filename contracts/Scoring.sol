pragma solidity ^0.4.24;

contract Scoring {

    event _newApp(bytes32 _appKey, address sender);
    event _newScorer(bytes32 _appKey, bytes32 scorerId, address sender);
    event _newResource(bytes32 _appKey, bytes32 resourceId, address sender);

    struct Scorer {
        string metadata;
    }

    struct Resource {
        string metadata;
        uint averageScore;
    }

    struct ScoringOptions {
        uint min;
        uint max;
    }

    struct Score {
        uint sender;
        uint receiver;
        uint originalValue;
        uint weight;
        uint resultingValue;
    }

    struct Organization {
        ScoringOptions scoring;
        mapping (uint => Scorer) scorers; // Authorized scorers
        mapping (uint => Resource) resources; // Authorized resources to reveice score
        mapping (uint => Score[]) scoresGiven; // Scores given by an scorer
        mapping (uint => Score[]) scoresReceived; // Scores received by a resource
        Score[] scores; // List of all scores
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

    function registerApp(bytes32 _appKey, uint _min, uint _max) public {
        organizations[_appKey].scoring = ScoringOptions(_min, _max);
        emit _newApp(_appKey, msg.sender);
    }

    function registerScorer(bytes32 _appKey, string metadata) public returns (bytes32) {
        bytes32 scorerId = _getHash();
        organizations[_appKey].scorers[scorerId] = Scorer(metadata);
        emit _newScorer(_appKey, scorerId, msg.sender);
        return scorerId;
    }

    function registerResource(bytes32 _appKey, string metadata) public returns (bytes32) {
        bytes32 resourceId = _getHash();
        organizations[_appKey].resources[resourceId] = Resource(metadata, 0);
        emit _newResource(_appKey, resourceId, msg.sender);
        return resourceId;
    }
}
