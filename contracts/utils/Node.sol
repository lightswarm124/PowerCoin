pragma solidity ^0.4.8;

contract Node {
	address public manager;
	Termination public termination;
	Metering public metering;
	PowerDelivery[] public deliveries;
	PowerDelivery[] public archived_deliveries;

	function Node(Metering _metering) {
		manager=msg.sender;
		metering=_metering;
	}

	function transferManager(address a) {
		if(msg.sender!=manager) throw;
		manager=a;
	}

	function transferMetering(Metering a) {
		if(msg.sender!=manager) throw;
		if(metering.meters(this).last_reading_value()==0) throw;
 		metering=a;
	}

	function transferTermination(Termination t) {
		if(metering.meters(this).termination()!=t) throw;
		termination=t;
	}


	function createOffer(bool _is_feedin,uint256 _time_start,uint256 _time_end,uint256 _total_power,uint256 _peak_load,uint256 _min_load,uint256 _bid) {
		if(msg.sender!=manager) throw;
		PowerDelivery pd = new PowerDelivery(_is_feedin, _time_start,_time_end, _total_power, _peak_load,_min_load,termination,_bid);
		deliveries.push(pd);
	}

	function balanceDeliveries() {
		for(var i=0;i<deliveries.length;i++) {
				if((deliveries[i].time_start()>=now)&&(deliveries[i].openedBalances()==false)) {
					deliveries[i].openSubBalance();
				}
				if((deliveries[i].time_end()<=now)&&(deliveries[i].closedBalances()==false)) {
					deliveries[i].closeSubBalance();
				}
				if((deliveries[i].feed_in()!=this)&&(deliveries[i].feed_out()!=this)) {
					delete deliveries[i];
				}
				if(deliveries[i].closedBalances()) {
					archived_deliveries.push(deliveries[i]);
					delete deliveries[i];
				}
		}
	}

	function signSellFeedIn(PowerDelivery pd,uint256 value) {
		if(msg.sender!=manager) throw;
		pd.sellFeedIn(value);
		deliveries.push(pd);
	}

	function signBuyFeedOut(PowerDelivery pd,uint256 value) {
		if(msg.sender!=manager) throw;
		pd.buyFeedOut(value);
		deliveries.push(pd);
	}

	function() {
		if(msg.value>0) {
			manager.send(msg.value);
		}
	}
}
