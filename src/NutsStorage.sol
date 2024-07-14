// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

/**
 * A contract with multiple roles (default admin, admin, user) to manage state changes securely.
 */
contract NutsStorage is AccessControl {
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant USER_ROLE = keccak256("USER_ROLE");

    uint256 private important;

    event UserAuthorised(address indexed user);
    event UserRevoked(address indexed user);
    event ImportantUpdated(uint256 newValue);

    /**
     * Clear roles distinction:
     * - DEFAULT_ADMIN_ROLE: can grant/revoke any roles, including itself
     * - ADMIN_ROLE: can grant/revoke user roles
     * - USER_ROLE: can call state-changing functions
     */
    constructor(address _defaultAdmin, address _admin) {
        _grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);
        _grantRole(ADMIN_ROLE, _admin);

        // Enable the admin role to grant/revoke user roles
        _setRoleAdmin(USER_ROLE, ADMIN_ROLE);
    }

    /**
     * Enable an account to perform state-changing functions.
     * @param _user The address for which the user role is granted.
     * @dev Can only be called by an account with the `ADMIN_ROLE`. Grants `USER_ROLE` to `_user`.
     */
    function authoriseUser(address _user) external onlyRole(ADMIN_ROLE) {
        grantRole(USER_ROLE, _user);
        emit UserAuthorised(_user);
    }

    /**
     * @notice Revoke an account's ability to perform state-changing functions.
     * @param _user The address for which the user role is revoked.
     * @dev Can only be called by an account with the `ADMIN_ROLE`.
     */
    function revokeUser(address _user) external onlyRole(ADMIN_ROLE) {
        revokeRole(USER_ROLE, _user);
        emit UserRevoked(_user);
    }

    /**
     * Updates the `important` state variable.
     * @param _important The new value to set for the `important` state variable.
     * @dev Can only be called by an account with the `USER_ROLE`.
     */
    function setImportant(uint256 _important) external onlyRole(USER_ROLE) {
        important = _important;
        emit ImportantUpdated(_important);
    }

    /**
     * Returns the current value of the `important` state variable.
     */
    function getImportant() external view returns (uint256) {
        return important;
    }
}
