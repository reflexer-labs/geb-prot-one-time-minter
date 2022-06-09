// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.6.7;

import "ds-test/test.sol";
import "ds-token/token.sol";

import "./GebProtOneTimeMinter.sol";

contract GebProtOneTimeMinterTest is DSTest {
    DSToken prot;
    GebProtOneTimeMinter minter;
    address constant receiver = address(0xfab);
    uint256 constant mintAmount = 1000 ether;

    function setUp() public {
        prot = new DSToken("PROT", "PROT");
        minter = new GebProtOneTimeMinter(
            address(prot),
            receiver,
            mintAmount
        );

        prot.setOwner(address(minter));
    }

    function test_constructor() public {
        assertEq(address(minter.prot()), address(prot));
        assertEq(minter.mintReceiver(), receiver);
        assertEq(minter.mintAmount(), mintAmount);
        assertTrue(!minter.minted());
    }

    function testFail_constructor_null_prot() public {
        minter = new GebProtOneTimeMinter(
            address(0),
            receiver,
            mintAmount
        );
    }

    function testFail_constructor_null_receiver() public {
        minter = new GebProtOneTimeMinter(
            address(prot),
            address(0),
            mintAmount
        );
    }

    function testFail_constructor_null_amount() public {
        minter = new GebProtOneTimeMinter(
            address(prot),
            receiver,
            0
        );
    }

    function test_mint() public {
        assertEq(prot.balanceOf(receiver), 0);
        assertEq(prot.totalSupply(), 0);
        assertTrue(!minter.minted());
        minter.mint();
        assertEq(prot.balanceOf(receiver), mintAmount);
        assertEq(prot.totalSupply(), mintAmount);
        assertTrue(minter.minted());
    }

    function testFail_mint_twice() public {
        minter.mint();
        minter.mint();
    }

    function testFail_mint_unauthed() public {
        minter.removeAuthorization(address(this));
        minter.mint();
    }

    function test_transfer_ERC20() public {
        uint transferAmount = 25 ether;
        DSToken token = new DSToken("TKN", "TKN");
        token.mint(address(minter), transferAmount);
        minter.transferERC20(address(token), address(0x123), transferAmount);
        assertEq(token.balanceOf(address(minter)), 0);
        assertEq(token.balanceOf(address(0x123)), transferAmount);
    }

    function testFail_transfer_ERC20_unauthed() public {
        uint transferAmount = 25 ether;
        DSToken token = new DSToken("TKN", "TKN");
        token.mint(address(minter), transferAmount);
        minter.removeAuthorization(address(this));
        minter.transferERC20(address(token), address(0x123), transferAmount);
    }
}
