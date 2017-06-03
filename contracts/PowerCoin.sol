pragma solidity ^0.4.8;


contract PowerCoin {

    address public owner;

    uint256 public last_reading_value;
	uint256 public last_reading_time;

    uint256 public power_debit;
	uint256 public power_credit;

}

contract Meter {
    address public owner;
    // @Dev changed bool feed_in -> bool electricity_feed_in
    bool public electricity_feed_in;

    uint256 public last_reading_value;
    uint256 public last_reading_time;

    uint256 public power_debit;
    uint256 public power_credit;

    function Meter (uint256 _initial_value, bool _is_feeding) {
        owner = msg.sender;
        last_reading_value = _initial_value;
        last_reading_time = now;
        power_debit = 0;
        power_credit = 0;
        electricity_feed_in = _is_feeding;
    }

    function setFeedIn(bool _is_feeding) {
        if (msg.sender!= owner) throw;
        electricity_feed_in = _is_feeding;
    }

    function updateReading(uint256 _value,uint256 _time,uint256 _add_debit,uint256 _add_credit) {
        //if(Metering(msg.sender)!=metering) throw;
        if (msg.sender != owner) throw;
        if (_time < last_reading_time) throw;
        if (_value < last_reading_value) throw;

        power_debit += add_debit;
        power_credit += add_credit;
        last_reading_value = value;
        last_reading_time = time;
    }
}

contract Termination {
	address public owner;
	//Termination[] public peers;
    address[] public peers;
    mapping(address=>uint) public nodes;
	mapping(address=>uint) public meterings;
	event TestTermination(address _sender,address _target);

	function Termination() {
		owner=msg.sender;
	}

	function addPeer(address _peer) {
		if(msg.sender!=owner) throw;
		peers.push(_peer);
	}

	function removePeer(address _peer) {
		if(msg.sender!=owner) throw;
		for(uint i = 0 ; i < peers.length ; i++) {
			if(peers[i]==_peer) {
				delete peers[i];
			}
		}
	}

/*
	function addMetering(address a) {
		if(msg.sender!=owner) throw;
		meterings[a]=1;
	}

	function removeMetering(address a) {
		if(msg.sender!=owner) throw;
		meterings[a]=2;
	}

	function addNode(Node _node) {
		if(msg.sender!=owner) throw;
		if(meterings[_node.metering()]!=1) throw;
		_node.transferTermination(this);
		nodes[_node]=1;
	}

	function removeNode(Node _node) {
		if(msg.sender!=owner) throw;
		nodes[_node]=2;
	}

	function test(Node d) returns(bool) {
		return test(d,this);
	}

	function test(Node _delivery,Termination callstack) returns (bool) {
		TestTermination(msg.sender,_delivery);
		if(nodes[_delivery]==1) return true;

		for(uint i=0;i<peers.length;i++) {
				if(peers[i].test(_delivery,this)) return true;
		}
		return false;
	}
*/

	function() {
		if(msg.value>0) {
			owner.send(msg.value);
		}
	}
}

contract Metering {
    address public owner;

    function Metering() {
        owner=msg.sender;
    }
}

contract Node {
    address public manager;
    Metering public metering;

    function Node(Metering _metering) {
        manager=msg.sender;
        metering=_metering;
    }
}
