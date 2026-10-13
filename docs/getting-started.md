---
title: Getting Started
subtitle: Install IdentityCommand.SecureAI and connect to Secure AI
---

## Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- An Idira Identity tenant with the Secure AI service enabled
- An Account to Access Idira Identity
- The `IdentityCommand` module.

## Install Options

Install from the PowerShell Gallery:

```powershell
Install-Module -Name IdentityCommand.SecureAI -Scope CurrentUser
```

Or download the [latest release](https://github.com/pspete/IdentityCommand.SecureAI/releases), unblock and extract the archive, and copy the `IdentityCommand.SecureAI` folder into a path listed in `$env:PSModulePath`.

## Authentication

The module requires authentication to the Idira Identity platform using the `IdentityCommand` module.

The `IdentityCommand` module must be installed and available in order to use `IdentityCommand.SecureAI`.

Authenticate with the `IdentityCommand` module, using `New-IDSession` (interactive user, including any MFA challenges) or `New-IDPlatformToken` (non-interactive service user). Commands find the Secure AI service url from the Identity session on first use - no separate connection step is needed:

```powershell
# Interactive user authentication
New-IDSession -tenant_url https://abc1234.id.cyberark.cloud -Credential $Credential

# Or non-interactive service user authentication via an OAuth platform token
New-IDPlatformToken -tenant_url https://abc1234.id.cyberark.cloud -Credential $ServiceUserCredential

Get-SAIAgent
```

Commands follow the current Identity session: a later `New-IDSession` or `New-IDPlatformToken` is used by the next command, and after `Close-IDSession` commands fail until you authenticate again.