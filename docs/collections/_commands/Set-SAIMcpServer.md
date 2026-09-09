---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIMcpServer

## SYNOPSIS
Updates a registered MCP server

## SYNTAX

```
Set-SAIMcpServer -mcpServerId <String> [-description <String>] [-category <String>]
 [-owners <PSObject[]>] [-tags <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a registered MCP server. Omitted values are left unchanged, so supply only what is changing.

Only the description, category, owners and tags can be changed. The name, source, upstream and
authentication method are fixed after registration; attempting to change them is refused by the
service. The state is changed with `Set-SAIMcpServerState`.

Requires the `admin` role on the tenant.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIMcpServer -mcpServerId 60395ad9-99ea-4a72-b3fe-ca67448a8f6f -description 'Updated description'
```

Updates the description of a registration

### Example 2
```
Set-SAIMcpServer -mcpServerId $mcpServerId -tags @{ env = 'dev'; team = 'platform' }
```

Replaces the tags of a registration

## PARAMETERS

### -mcpServerId
The unique identifier of the registered MCP server.

```yaml
Type: String
Parameter Sets: (All)
Aliases: id

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
A new description for the registration.

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

### -category
A new functional category for the registration. Editable even for predefined registrations.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: COMMUNICATION_AND_TEAM_CHAT, EMAIL_AND_SCHEDULING, KNOWLEDGE_BASES_AND_DOCS, FILE_STORAGE_AND_CONTENT_REPOS, DEVELOPER_TOOLS_AND_SOURCE_CONTROL, DATABASES_AND_DATA_STORES, OBSERVABILITY_MONITORING_AND_TELEMETRY, ITSM_AND_INCIDENT_RESPONSE, WEB_AND_BROWSER_AUTOMATION, CLOUD_AND_INFRASTRUCTURE_OPERATIONS

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -owners
The users or roles responsible for the target, from `New-SAIOwnerDefinition`. Replaces the current owners.

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
Key-value pairs categorising the target. Replaces the current tags.

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
