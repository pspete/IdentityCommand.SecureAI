---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Remove-SAIAgent

## SYNOPSIS
Deletes an AI agent

## SYNTAX

```
Remove-SAIAgent -agentId <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Permanently and irreversibly deletes an AI agent and its metadata.

**The agent must be suspended first.** An agent can only be deleted while its state is `SUSPENDED` or
`PENDING_CONFIGURATION`; deleting an `ACTIVE` agent is refused.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Remove-SAIAgent -agentId a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12
```

Deletes the specified agent

### Example 2
```
Set-SAIAgentState -agentId $agentId -state SUSPENDED
Remove-SAIAgent -agentId $agentId
```

Suspends an active agent, then deletes it

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
