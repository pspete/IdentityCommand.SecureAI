---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIMcpServerState

## SYNOPSIS
Enables or disables a registered MCP server

## SYNTAX

```
Set-SAIMcpServerState -mcpServerId <String> -state <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Toggles a registered MCP server between `ENABLED` and `DISABLED`.

The response carries only the identifier and resulting state, not the full target - fetch it with
`Get-SAIMcpServer` if you need the rest. Setting a target to the state it already holds succeeds and
emits no audit event.

Requires the `admin` role on the tenant.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIMcpServerState -mcpServerId 60395ad9-99ea-4a72-b3fe-ca67448a8f6f -state ENABLED
```

Enables a registration

### Example 2
```
Get-SAIMcpServer | Where-Object state -eq ENABLED | Set-SAIMcpServerState -state DISABLED
```

Disables every enabled registration

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

### -state
The state to move the target to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ENABLED, DISABLED

Required: True
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
