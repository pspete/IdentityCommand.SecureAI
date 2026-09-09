---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Remove-SAIMcpServer

## SYNOPSIS
Deletes a registered MCP server

## SYNTAX

```
Remove-SAIMcpServer -mcpServerId <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes a registered MCP server.

**The target must be disabled first** - deleting an `ENABLED` target is refused. Where the target was
registered with an Idira-held OAuth app, the stored credentials are purged before the registration is
removed. A predefined catalog template is unaffected; only the tenant's registration goes.

Requires the `admin` role on the tenant.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Remove-SAIMcpServer -mcpServerId 60395ad9-99ea-4a72-b3fe-ca67448a8f6f
```

Deletes the specified registration

### Example 2
```
Set-SAIMcpServerState -mcpServerId $mcpServerId -state DISABLED
Remove-SAIMcpServer -mcpServerId $mcpServerId
```

Disables a registration, then deletes it

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
