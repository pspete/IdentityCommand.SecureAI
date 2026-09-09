---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIAgentState

## SYNOPSIS
Activates or suspends an AI agent

## SYNTAX

```
Set-SAIAgentState -agentId <String> -state <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Moves an AI agent between `ACTIVE` and `SUSPENDED`.

The remaining states - `PENDING_CONNECTION`, `PENDING_CONFIGURATION`, `ERROR` and `CONNECTION_ERROR` -
are assigned by the service and cannot be set here.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIAgentState -agentId a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12 -state SUSPENDED
```

Suspends an agent

### Example 2
```
Get-SAIAgent | Where-Object { $_.status.state -eq 'ACTIVE' } | Set-SAIAgentState -state SUSPENDED
```

Suspends every active agent

## PARAMETERS

### -agentId
The unique identifier of the agent.

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
The lifecycle state to move the agent to.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ACTIVE, SUSPENDED

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
