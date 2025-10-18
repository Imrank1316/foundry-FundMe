
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 ;
import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test {
FundMe fundme ;
address USER = makeAddr("user");
uint256 constant SEND_VALUE = 0.1 ether ;
uint256 constant STARTING_BALANCE = 10 ether;


    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);

    }
    function testDemo() public {
        assertEq(fundme.myValue(), 5e18);

    }

    function testOwnerIsMessageSender() public {
        console.log(fundme._owner());
        assertEq(fundme._owner(), msg.sender);
    }

    function testPriceFeedConverionIsAccurate() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughtEth() public {
        vm.expectRevert();
        fundme.fund();
    } 

    function testFundUpdatedFundedDataStructure() public {
        vm.prank(USER);  // the next TX send by the User
        fundme.fund{value: SEND_VALUE}();
        // uint256 amountFunded = fundme.getAddressToAmountFunded(address(this));
         uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunder() public {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();

        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }



}
