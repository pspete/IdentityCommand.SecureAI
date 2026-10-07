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

The `Connect-SAITenant` command initialises the bearer token used for module operations against the Secure AI service.

If an Identity session already exists (established with the `IdentityCommand` module's `New-IDSession` or `New-IDPlatformToken`), it is used as-is:

```powershell
# Resolve the Secure AI url automatically from the shared services subdomain
Connect-SAITenant -tenant_subdomain sometenant

# Or provide the Secure AI tenant url directly
Connect-SAITenant -tenant_url https://sometenant.aigw.cyberark.cloud
```

Otherwise, provide a credential and `Connect-SAITenant` authenticates to Idira Identity for you - the Identity tenant url is discovered from the same subdomain / url:

```powershell
# Interactive user authentication (any MFA challenges are handled by IdentityCommand)
Connect-SAITenant -tenant_subdomain sometenant -Credential $Credential

# Non-interactive service user authentication via an OAuth platform token
Connect-SAITenant -tenant_subdomain sometenant -Credential $ServiceUserCredential -PlatformToken
```
