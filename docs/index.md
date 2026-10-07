---
title: IdentityCommand.SecureAI
subtitle: PowerShell for Idira Secure AI
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/SecureAI/media/images/IdentityCommand.SecureAI.png' | relative_url }}" alt="IdentityCommand.SecureAI" width="471">
</div>

**IdentityCommand.SecureAI** is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the **Idira Secure AI API** from within the PowerShell environment.

It builds on [IdentityCommand]({{ '/' | relative_url }}) for authentication - see [Getting Started]({{ '/SecureAI/getting-started/' | relative_url }}) to install and connect, and the [command reference]({{ '/SecureAI/commands/' | relative_url }}) for every command.

## AI Agents

`New-SAIAgent` registers an agent and returns one-time connection credentials - capture the client secret from the response, since the service never returns it again:

```powershell
$Agent = New-SAIAgent -name 'Finance Copilot' -type COPILOT -description 'AI agent for the finance team'
$Agent.credentials

Get-SAIAgent
Get-SAIAgent -agentId $agentId

Set-SAIAgentState -agentId $agentId -state SUSPENDED
Remove-SAIAgent -agentId $agentId
```

## MCP Servers

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

## Access Policies

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
