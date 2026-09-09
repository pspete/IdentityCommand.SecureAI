# Change Log

All notable changes to this project will be documented in this file.

## Unreleased

### Added

- Initial release of `IdentityCommand.SecureAI`, wrapping the CyberArk Secure AI API.
- `Connect-SAITenant`: authenticate to the Secure AI service, resolving the service url from a
  shared services subdomain via platform discovery, or from a url supplied directly.
- Agents: `Get-`, `New-`, `Set-`, `Remove-SAIAgent` and `Set-SAIAgentState`. `New-SAIAgent` returns
  the one-time connection credentials - client id, client secret and gateway url - the service
  never returns the secret again.
- MCP servers: `Get-`, `New-`, `Set-`, `Remove-SAIMcpServer`, `Set-SAIMcpServerState` and
  `Get-SAIPredefinedMcpServer` for the catalog `New-SAIMcpServer -predefinedTargetId` registers
  from. `New-SAIMcpServer` supports passthrough, manual and dynamic client registration OAuth 2.1
  connection modes, and rejects the invalid credential combinations before sending a request.
  Results from `Get-SAIMcpServer` are paginated automatically.
- Access policies: `Get-`, `New-`, `Set-`, `Remove-SAIPolicy` and `Set-SAIPolicyState`.
  `New-SAIPolicy` enforces the user grant rule tied to `-accessType` - required for `ON_BEHALF_OF`,
  rejected for `AUTONOMOUS`. Results from `Get-SAIPolicy` are paginated automatically.
- Definition builders: `New-SAIOwnerDefinition`, `New-SAIAgentConditionDefinition`,
  `New-SAIUserConditionDefinition` and `New-SAIResourceConditionDefinition`. Each chains onto a
  previous definition, since the service combines match groups with OR.
- `Get-SAIModuleData`: get the module version and session configuration data.
