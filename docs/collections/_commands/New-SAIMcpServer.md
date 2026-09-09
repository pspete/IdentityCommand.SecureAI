---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIMcpServer

## SYNOPSIS
Registers an MCP server

## SYNTAX

### Custom (Default)
```
New-SAIMcpServer -name <String> -description <String> -category <String> -upstreamUrl <String>
 [-authMethodType <String>] [-authorizationServer <String>] [-JWKS <String>] [-clientId <String>]
 [-clientSecret <SecureString>] [-registrationEndpoint <String>] [-owners <PSObject[]>]
 [-tags <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Predefined
```
New-SAIMcpServer -predefinedTargetId <String> [-templateDescription <String>]
 [-authMethodType <String>] [-authorizationServer <String>] [-JWKS <String>] [-clientId <String>]
 [-clientSecret <SecureString>] [-registrationEndpoint <String>] [-owners <PSObject[]>]
 [-tags <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Registers an MCP server target, either **custom** (you supply the upstream URL and category) or
**predefined** (registered from a catalog template listed by `Get-SAIPredefinedMcpServer`).

For a predefined registration the name, category and upstream always come from the template and
cannot be overridden; the description falls back to the template's when omitted, and your tags are
merged over the template's.

**OAuth 2.1 connection modes.** Three mutually exclusive shapes:

| Mode | What to supply |
| ---- | -------------- |
| Passthrough | none of `-clientId`, `-clientSecret`, `-registrationEndpoint`. Agents use their own tokens |
| Manual | `-clientId`, optionally `-clientSecret`. Idira holds the OAuth app |
| Dynamic client registration | `-registrationEndpoint` only. Idira registers the client on first authorization |

`-clientSecret` cannot be supplied without `-clientId`, and `-registrationEndpoint` cannot be combined
with either - this command rejects both combinations before sending the request.

`-clientSecret` is a `SecureString`, and the request body is sent as UTF8 bytes so the plaintext is not
exposed to PowerShell logging. The service never returns it.

Registrations created by a tenant administrator start `ENABLED`; those created by anyone else start
`DISABLED` and need `Set-SAIMcpServerState`.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
New-SAIMcpServer -name 'My Custom GitHub MCP Server' -description 'Custom GitHub MCP server' `
    -category DEVELOPER_TOOLS_AND_SOURCE_CONTROL -upstreamUrl 'https://github-mcp.company.com/api' `
    -authMethodType 'OAUTH2.1'
```

Registers a custom server, letting the service discover the authorization server

### Example 2
```
New-SAIMcpServer -name 'My Custom Slack MCP Server' -description 'Custom Slack MCP server' `
    -category COMMUNICATION_AND_TEAM_CHAT -upstreamUrl 'https://slack-mcp.company.com/api' `
    -authMethodType 'OAUTH2.1' -authorizationServer 'https://auth.company.com' `
    -clientId 'my-client-id' -clientSecret (Read-Host -AsSecureString)
```

Registers a custom server with an Idira-held OAuth app

### Example 3
```
New-SAIMcpServer -name 'Public MCP Server' -description 'No auth required' `
    -category WEB_AND_BROWSER_AUTOMATION -upstreamUrl 'https://public-api.example.com/mcp' -authMethodType NONE
```

Registers a custom server which needs no authentication

### Example 4
```
New-SAIMcpServer -predefinedTargetId 3f4e5d6c-7b8a-4c9d-a1e2-f3b4c5d6e7f8 `
    -authMethodType 'OAUTH2.1' -registrationEndpoint 'https://github-mcp.company.com/register'
```

Registers a catalog template whose OAuth client is created dynamically

### Example 5
```
Get-SAIPredefinedMcpServer | Where-Object name -eq 'Notion MCP' | ForEach-Object {
    New-SAIMcpServer -predefinedTargetId $_.id -tags @{ environment = 'production' }
}
```

Finds a template in the catalog and registers it

## PARAMETERS

### -name
A unique name for the custom server. Must start with a letter or digit and must not end with a space.

```yaml
Type: String
Parameter Sets: Custom
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
A description of the custom server.

```yaml
Type: String
Parameter Sets: Custom
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -category
The functional category of the custom server.

```yaml
Type: String
Parameter Sets: Custom
Aliases: 
Accepted values: COMMUNICATION_AND_TEAM_CHAT, EMAIL_AND_SCHEDULING, KNOWLEDGE_BASES_AND_DOCS, FILE_STORAGE_AND_CONTENT_REPOS, DEVELOPER_TOOLS_AND_SOURCE_CONTROL, DATABASES_AND_DATA_STORES, OBSERVABILITY_MONITORING_AND_TELEMETRY, ITSM_AND_INCIDENT_RESPONSE, WEB_AND_BROWSER_AUTOMATION, CLOUD_AND_INFRASTRUCTURE_OPERATIONS

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -upstreamUrl
The URL of the remote MCP server. Must not point at the AI Gateway itself.

```yaml
Type: String
Parameter Sets: Custom
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -predefinedTargetId
The identifier of the catalog template to register, from `Get-SAIPredefinedMcpServer`.

```yaml
Type: String
Parameter Sets: Predefined
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -templateDescription
A description override for a predefined registration. The template's description is used when omitted.

```yaml
Type: String
Parameter Sets: Predefined
Aliases: predefinedDescription

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -authMethodType
The authentication method. Omit to let the service probe the upstream and infer it.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: OAUTH2.1, NONE

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -authorizationServer
An authorization server selector, validated against those the upstream publishes. The upstream default is used when omitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -JWKS
The JWKS endpoint. Inherited from the upstream or template when omitted.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -clientId
The OAuth client id of an app registered with the MCP server, for the manual connection mode.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -clientSecret
The OAuth client secret matching `-clientId`. Never returned by the service.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -registrationEndpoint
The RFC 7591 dynamic client registration endpoint. Cannot be combined with `-clientId` or `-clientSecret`.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -owners
The users or roles responsible for the target, from `New-SAIOwnerDefinition`.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tags
Up to ten key-value pairs categorising the target.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```


### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
