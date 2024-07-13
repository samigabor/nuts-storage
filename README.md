# Nuts Storage

The Nuts Storage contract is designed to manage state-changing operations securely using a role-based access control approach. It divides responsibilities among different roles to ensure secure and organized management of state changes.

## Roles and Responsibilities

1. **DEFAULT_ADMIN_ROLE**
   - Can grant and revoke any roles, including itself.
   - Has the highest level of control over the contract.
   - It is recommended to use a multi-signature wallet for this role to reduce the risk of a single point of failure.

2. **ADMIN_ROLE**
   - Can grant and revoke the USER_ROLE.
   - Responsible for managing user access.

3. **USER_ROLE**
   - Can perform state-changing operations.
   - Limited to specific state-modifying functions defined in the contract.

## Centralization Risk

The DEFAULT_ADMIN_ROLE has complete control over the contract. If the private key of the account holding this role is compromised, an attacker could potentially grant themselves any role or take over the contract.

### Mitigation

- Use a **multi-signature** wallet for the DEFAULT_ADMIN_ROLE to reduce the risk of a single point of failure.
- For transparency, document that the DEFAULT_ADMIN_ROLE can override ADMIN_ROLE decisions.

## Potential Improvements

1. **Upgradeable Contracts** in case of bugs or new features
2. **Pauser Role** to pause the contract in case of emergency.
3. **Timelock Mechanism** to provide a buffer period during which role changes are performed.
