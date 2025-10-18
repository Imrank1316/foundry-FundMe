
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 ;
import {Test, console} from "lib/forge-std/src/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
 
contract FundMeTest is Test {
FundMe fundme ;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();

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
        fundme.fund{value: 10e18}();
    }
}
