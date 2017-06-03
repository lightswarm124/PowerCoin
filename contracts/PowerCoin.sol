pragma solidity ^0.4.8;


contract PowerCoin {

    address public owner;

    uint256 public last_reading_value;
	uint256 public last_reading_time;

    uint256 public power_debit;
	uint256 public power_credit;

}
