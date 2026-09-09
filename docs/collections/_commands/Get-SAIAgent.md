---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Get-SAIAgent

## SYNOPSIS
Gets AI agents

## SYNTAX

### All (Default)
```
Get-SAIAgent [<CommonParameters>]
```

### byId
```
Get-SAIAgent -agentId <String> [<CommonParameters>]
```

## DESCRIPTION
Gets the AI agents registered on the tenant - all of them, or one by identifier.

Each agent carries its `clientId`, owners, tags, callback URLs and a nested `status` object holding
its lifecycle state. Where the state is an error state, that object also carries a message.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Get-SAIAgent
```

Gets all registered agents

### Example 2
```
Get-SAIAgent -agentId a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12
```

Gets the specified agent

### Example 3
```
Get-SAIAgent | Where-Object { $_.status.state -eq 'CONNECTION_ERROR' }
```

Reports the agents which failed to connect

## PARAMETERS

### -agentId
The unique identifier of the agent.

```yaml
Type: String
Parameter Sets: byId
Aliases: id

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
