# IdentityCommand.SecureAI

**IdentityCommand.SecureAI** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **CyberArk Secure AI API** from within the PowerShell environment.

| Main Branch              | Latest Build             | CodeFactor                 | Coverage                     | PowerShell Gallery        | License                      |
| ------------------------ | ------------------------ | -------------------------- | ---------------------------- | ------------------------- | ---------------------------- |
| [![appveyor][]][av-site] | [![tests][]][tests-site] | [![codefactor][]][cf-site] | [![codecov][]][codecov-link] | [![psgallery][]][ps-site] | [![license][]][license-link] |

[appveyor]: https://ci.appveyor.com/api/projects/status/q2av77njofnsul92/branch/main?svg=true
[av-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SecureAI/branch/main
[psgallery]: https://img.shields.io/powershellgallery/v/IdentityCommand.SecureAI.svg
[ps-site]: https://www.powershellgallery.com/packages/IdentityCommand.SecureAI
[tests]: https://img.shields.io/appveyor/tests/pspete/IdentityCommand-SecureAI.svg
[tests-site]: https://ci.appveyor.com/project/pspete/IdentityCommand-SecureAI
[downloads]: https://img.shields.io/powershellgallery/dt/IdentityCommand.SecureAI.svg?color=blue
[cf-site]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SecureAI
[codefactor]: https://www.codefactor.io/repository/github/pspete/IdentityCommand.SecureAI/badge
[codecov]: https://codecov.io/gh/pspete/IdentityCommand.SecureAI/branch/main/graph/badge.svg
[codecov-link]: https://codecov.io/gh/pspete/IdentityCommand.SecureAI
[license]: https://img.shields.io/github/license/pspete/IdentityCommand.SecureAI.svg
[license-link]: https://github.com/pspete/IdentityCommand.SecureAI/blob/main/LICENSE

## Using the Module

The module requires authentication to the CyberArk Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SecureAI`.

### Secure AI Authentication

The `Connect-SAITenant` command initialises the bearer token used for module operations against the Secure AI service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the Secure AI url automatically from the shared services subdomain
Connect-SAITenant -tenant_subdomain sometenant

# Or provide the Secure AI tenant url directly
Connect-SAITenant -tenant_url https://sometenant.aigw.cyberark.cloud
```

Otherwise, provide a credential and `Connect-SAITenant` authenticates to CyberArk Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-SAITenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-SAITenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```

### AI Agents

`New-SAIAgent` registers an agent and returns one-time connection credentials - capture the client secret from the response, since the service never returns it again:

```powershell
$Agent = New-SAIAgent -name 'Finance Copilot' -type COPILOT -description 'AI agent for the finance team'
$Agent.credentials

Get-SAIAgent
Get-SAIAgent -agentId $agentId

Set-SAIAgentState -agentId $agentId -state SUSPENDED
Remove-SAIAgent -agentId $agentId
```

### MCP Servers

Register a custom server by URL, or a predefined one from the catalog:

```powershell
# Custom, letting the service infer the auth method from the upstream
New-SAIMcpServer -name 'My Custom GitHub MCP Server' -description 'Custom GitHub MCP server' `
    -category DEVELOPER_TOOLS_AND_SOURCE_CONTROL -upstreamUrl 'https://github-mcp.company.com/api' -authMethodType 'OAUTH2.1'

# Custom, with an Idira-held OAuth app
New-SAIMcpServer -name 'My Custom Slack MCP Server' -description 'Custom Slack MCP server' `
    -category COMMUNICATION_AND_TEAM_CHAT -upstreamUrl 'https://slack-mcp.company.com/api' `
    -authMethodType 'OAUTH2.1' -clientId 'my-client-id' -clientSecret (Read-Host -AsSecureString)

# From the catalog
Get-SAIPredefinedMcpServer | Where-Object name -eq 'Notion MCP'
New-SAIMcpServer -predefinedTargetId $templateId
```

Three OAuth 2.1 connection modes: passthrough (no credential parameters), manual (`-clientId`, optionally `-clientSecret`), or dynamic client registration (`-registrationEndpoint` only). The command rejects the two invalid combinations - a secret without a client id, or a registration endpoint alongside credentials - before sending anything.

```powershell
Set-SAIMcpServerState -mcpServerId $mcpServerId -state ENABLED
Remove-SAIMcpServer -mcpServerId $mcpServerId
```

### Access Policies

A policy controls which agents may run tools on which MCP servers, and for whom. Access is denied by default - a request is allowed only where a policy permits it:

```powershell
# On behalf of a user
New-SAIPolicy -name 'Finance agent on behalf of analysts' -accessType ON_BEHALF_OF -state ENABLED `
    -agent (New-SAIAgentConditionDefinition -id $agentId) `
    -user (New-SAIUserConditionDefinition -roleId finance-analysts) `
    -resources (New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*')

# Fully autonomous
New-SAIPolicy -name 'Nightly cleanup agent' -accessType AUTONOMOUS -state ENABLED `
    -agent (New-SAIAgentConditionDefinition -id $maintenanceAgentId) `
    -resources (New-SAIResourceConditionDefinition -matchId 'mcp:maintenance:*')
```

Each grant is built from match groups, combined with OR - chain a builder onto a previous definition to widen it:

```powershell
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:analytics:*' -ConditionDefinition $Resources
```

```powershell
Get-SAIPolicy
Set-SAIPolicyState -policyId $policyId -state DISABLED
Remove-SAIPolicy -policyId $policyId
```

## Module Commands

| Command                              | Description                                          |
| ------------------------------------- | ----------------------------------------------------- |
| `Connect-SAITenant`                   | Authenticate to the Secure AI service                 |
| `Get-SAIAgent`                        | Get AI agents                                         |
| `New-SAIAgent`                        | Register an AI agent                                  |
| `Set-SAIAgent`                        | Update the metadata of an AI agent                    |
| `Remove-SAIAgent`                     | Delete an AI agent                                    |
| `Set-SAIAgentState`                   | Activate or suspend an AI agent                       |
| `Get-SAIMcpServer`                    | Get registered MCP servers                            |
| `New-SAIMcpServer`                    | Register an MCP server                                |
| `Set-SAIMcpServer`                    | Update a registered MCP server                        |
| `Remove-SAIMcpServer`                 | Delete a registered MCP server                        |
| `Set-SAIMcpServerState`               | Enable or disable a registered MCP server              |
| `Get-SAIPredefinedMcpServer`          | Get the predefined MCP server templates               |
| `Get-SAIPolicy`                       | Get Secure AI access policies                         |
| `New-SAIPolicy`                       | Create a Secure AI access policy                      |
| `Set-SAIPolicy`                       | Update a Secure AI access policy                      |
| `Remove-SAIPolicy`                    | Delete a Secure AI access policy                      |
| `Set-SAIPolicyState`                  | Enable or disable a Secure AI access policy            |
| `New-SAIOwnerDefinition`              | Define an owner of an agent, MCP server or policy     |
| `New-SAIAgentConditionDefinition`     | Define the agent grant of a policy                    |
| `New-SAIUserConditionDefinition`      | Define the user grant of a policy                     |
| `New-SAIResourceConditionDefinition`  | Define the resource grant of a policy                 |
| `Get-SAIModuleData`                   | Get the module version & session configuration data   |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant with the Secure AI service enabled
- An Account to Access CyberArk Identity

### Install Options

Users can install IdentityCommand.SecureAI from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

#### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand.SecureAI -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand.SecureAI`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

##### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand.SecureAI/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand.SecureAI -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand.SecureAI` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SecureAI Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand.SecureAI/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand.SecureAI-v#.#.#` folder to `IdentityCommand.SecureAI`
  - Copy the `IdentityCommand.SecureAI` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand.SecureAI Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand.SecureAI/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand.SecureAI` (`\<Archive Root>\IdentityCommand.SecureAI-main\IdentityCommand.SecureAI`) folder to your "Powershell Modules" directory of choice.

#### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand.SecureAI

```

Import the module:

```powershell

Import-Module IdentityCommand.SecureAI

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand.SecureAI

```

Get detailed information on specific commands:

```powershell

Get-Help Connect-SAITenant -Full

```

## Sponsorship

Please support continued development; consider sponsoring <a href="https://github.com/sponsors/pspete"> @pspete on GitHub Sponsors</a>

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand.SecureAI_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand.SecureAI_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand.SecureAI/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.
