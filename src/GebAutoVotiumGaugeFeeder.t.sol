// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./GebAutoVotiumGaugeFeeder.sol";

contract GebAutoVotiumGaugeFeederTest is DSTest {
    GebAutoVotiumGaugeFeeder feeder;

    function setUp() public {
        feeder = new GebAutoVotiumGaugeFeeder();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
