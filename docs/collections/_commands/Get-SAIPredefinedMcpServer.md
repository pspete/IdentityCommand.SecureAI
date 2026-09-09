---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Get-SAIPredefinedMcpServer

## SYNOPSIS
Gets the predefined MCP server templates

## SYNTAX

### All (Default)
```
Get-SAIPredefinedMcpServer [<CommonParameters>]
```

### byId
```
Get-SAIPredefinedMcpServer -templateId <String> [<CommonParameters>]
```

## DESCRIPTION
Gets the predefined MCP server templates available to the tenant - the catalog `New-SAIMcpServer`
registers from with `-predefinedTargetId`. Fetching one by identifier additionally returns the tools
the template exposes.

Each template's `oauthApplicationRegistration` says how its OAuth client is provisioned - `dynamic`
means supply `-registrationEndpoint` when registering, `manual` means supply `-clientId`.

**Two tenants on the same release can see different catalogs**: each template version declares a
rollout gate, and versions gated off for the tenant are omitted.

Note the template shape is flatter than a registration's: `authMethod` is a plain string rather than an
object, and the version field is `version` rather than `predefinedTargetVersion`.

Requires the `admin` or `builder` role on the tenant.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Get-SAIPredefinedMcpServer
```

Gets the template catalog

### Example 2
```
Get-SAIPredefinedMcpServer -templateId 3f1b7c2e-9a8d-4e4b-b7a2-1c5d6e7f8a90
```

Gets one template, including the tools it exposes

### Example 3
```
Get-SAIPredefinedMcpServer | Where-Object oauthApplicationRegistration -eq dynamic | Select-Object name, id
```

Lists the templates whose OAuth client can be registered dynamically

## PARAMETERS

### -templateId
The identifier of the predefined template.

```yaml
Type: String
Parameter Sets: byId
Aliases: id, predefinedTargetId

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```


### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
