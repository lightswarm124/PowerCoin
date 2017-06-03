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

    function setFeedIn (bool _is_feeding) {
        if (msg.sender != owner) throw;
        electricity_feed_in = _is_feeding;
    }

    function updateReading (uint256 _value, uint256 _time, uint256 _add_debit, uint256 _add_credit) {
        //if(Metering(msg.sender)!=metering) throw;
        if (msg.sender != owner) throw;
        if (_time < last_reading_time) throw;
        if (_value < last_reading_value) throw;

        power_debit += add_debit;
        power_credit += add_credit;
        last_reading_value = value;
        last_reading_time = time;
    }

    function addPowerDebit (uint256 add_debit) {
        if (Metering(msg.sender) != metering) throw;
        power_debit += add_debit;
    }
}

contract Termination {
	address public owner;
	//Termination[] public peers;
    address[] public peers;
    mapping (address => uint) public nodes;
	mapping (address => uint) public meterings;
	event TestTermination (address _sender,address _target);

	function Termination () {
		owner = msg.sender;
	}

	function addPeer (address _peer) {
		if (msg.sender != owner) throw;
		peers.push(_peer);
	}

	function removePeer (address _peer) {
		if (msg.sender!=owner) throw;
		for (uint i = 0 ; i < peers.length ; i++) {
			if (peers[i] == _peer) {
				delete peers[i];
			}
		}
	}

    // @Dev rename param
    function addMetering (address a) {
        if (msg.sender != owner) throw;
        meterings[a] = 1;
    }
/*

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

	function () {
		if (msg.value>0) {
			owner.send(msg.value);
		}
	}
}

contract Metering {
	address public owner;
	mapping (address => Meter) public meters;
	mapping (address => Node) public nodes;
//	SubBalance[] subbalances;


	function Metering () {
		owner = msg.sender;
	}
/*
	function addMeter(Meter meter,Node _node) {
		if(msg.sender!=owner) throw;
		meters[_node]=meter;
		nodes[meter]=_node;
	}

	function openSubBalance(Node n,PowerDelivery pd) returns (SubBalance) {
		if(n.metering()!=this) throw;
		// TODO Add Trigger Que for start/stop reading
		SubBalance sb = new SubBalance(n,pd);
		subbalances.push(sb);
		return sb;
	}

	function closeSubBalance(SubBalance sb) {
		if(sb.node().metering()!=this) throw;
		for(var i=0;i<subbalances.length;i++) {
			if(subbalances[i]==sb) {
				// if there is still something due we have to add it here
				uint256 add_debit = subbalances[i].closeBalance();
				Meter m = Meter(meters[sb.node()]);
				m.addPDclosingDebit(add_debit);
				delete subbalances[i];
			}
		}
	}

	function updateReading(Meter m,uint256 reading_time,uint256 reading_value) {
		if(msg.sender!=owner) throw;
		if(nodes[m].metering()!=this) throw;
		// do clearing
		Node n= nodes[m];
		uint256 add_credit=0;
		uint256 add_debit=0;
		uint256 last_value=m.last_reading_value();
		uint256 last_time=m.last_reading_time();
		if(reading_time==0)reading_time=now;
		uint256 balancable=reading_value-last_value;
		for(var i=0;((i<subbalances.length)&&(balancable>0));i++) {
				if(subbalances[i].node()==n) {
					if(m.feed_in()==subbalances[i].isFeedin()) {
						balancable-=subbalances[i].applyBalance(balancable);
					}
				}
		}
		add_credit=(reading_value-last_value)-balancable;
		add_debit=balancable;
		m.updateReading(reading_value,reading_time,add_debit,add_credit);
	}

	function() {
		if(msg.value>0) {
			owner.send(msg.value);
		}
	}
*/
}

contract Node {
    address public manager;
    Metering public metering;

    function Node (Metering _metering) {
        manager = msg.sender;
        metering = _metering;
    }

    function transferManager (address _manager) {
        if (msg.sender != manager) throw;
        manager = _manager;
    }

    function transferMetering (Metering _newMeter) {
        if (msg.sender != manager) throw;
        if (metering.meters(this).last_reading_value() == 0) throw;
        metering = _newMeter;
    }
}
