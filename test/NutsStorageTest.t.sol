// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {NutsStorage} from "../src/NutsStorage.sol";

contract NutsStorageTest is Test {
    NutsStorage private storageContract;
    address private defaultAdmin = address(1);
    address private admin = address(2);
    address private user = address(3);
    address private unauthorised = address(4);

    function setUp() public {
        storageContract = new NutsStorage(defaultAdmin, admin);
    }

    function testRolesSetup() public view {
        assertTrue(storageContract.hasRole(storageContract.DEFAULT_ADMIN_ROLE(), defaultAdmin));
        assertTrue(storageContract.hasRole(storageContract.ADMIN_ROLE(), admin));
    }

    function testAuthoriseUser() public {
        vm.prank(admin);
        storageContract.authoriseUser(user);
        assertTrue(storageContract.hasRole(storageContract.USER_ROLE(), user));
    }

    function testRevertsAuthoriseUserAsUser() public {
        vm.prank(admin);
        storageContract.authoriseUser(user);
        vm.expectRevert();
        vm.prank(user);
        storageContract.authoriseUser(user);
    }

    function testRevertsAuthoriseUserAsUnauthorised() public {
        vm.expectRevert();
        vm.prank(unauthorised);
        storageContract.authoriseUser(user);
    }

    function testRevokeUser() public {
        vm.prank(admin);
        storageContract.authoriseUser(user);
        assertTrue(storageContract.hasRole(storageContract.USER_ROLE(), user));

        vm.prank(admin);
        storageContract.revokeUser(user);
        assertFalse(storageContract.hasRole(storageContract.USER_ROLE(), user));
    }

    function testRevertsRevokeUserAsUnauthorised() public {
        vm.prank(admin);
        storageContract.authoriseUser(user);

        vm.expectRevert();
        vm.prank(unauthorised);
        storageContract.revokeUser(user);
    }

    function testSetImportantAsAuthorisedUser(uint256 newValue) public {
        vm.prank(admin);
        storageContract.authoriseUser(user);
        vm.prank(user);
        storageContract.setImportant(newValue);
        assertEq(storageContract.getImportant(), newValue);
    }

    function testRevertsSetImportantAsUnauthorisedUser(uint256 newValue) public {
        vm.expectRevert();
        vm.prank(unauthorised);
        storageContract.setImportant(newValue);
    }

    /**
     * TODO: can't prank msg.sedner for grantRole => find alternative testing method
     * e.g. msg.sender is NutsStorageTest address, not the defaultAdmin address
     * This is a foundry limitation of setting msg.sender only "for the next call"
     */
    // function testGrantAndRevokeAdminRoleByDefaultAdmin() public {
    //     address newAdmin = address(5);
    //     vm.prank(defaultAdmin);
    //     storageContract.grantRole(storageContract.ADMIN_ROLE(), newAdmin);
    //     assertTrue(storageContract.hasRole(storageContract.ADMIN_ROLE(), newAdmin));
    //     vm.prank(defaultAdmin);
    //     storageContract.revokeRole(storageContract.ADMIN_ROLE(), newAdmin);
    //     assertFalse(storageContract.hasRole(storageContract.ADMIN_ROLE(), newAdmin));
    // }
    // function testGrantAndRevokeUserRoleByDefaultAdmin() public {
    //     vm.prank(defaultAdmin);
    //     storageContract.grantRole(storageContract.USER_ROLE(), user);
    //     assertTrue(storageContract.hasRole(storageContract.USER_ROLE(), user));
    //     vm.prank(defaultAdmin);
    //     storageContract.revokeRole(storageContract.USER_ROLE(), user);
    //     assertFalse(storageContract.hasRole(storageContract.USER_ROLE(), user));
    // }
}
