---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIAgentConditionDefinition

## SYNOPSIS
Defines the agent grant of a policy

## SYNTAX

### In (Default)
```
New-SAIAgentConditionDefinition -id <String[]> [-ConditionDefinition <PSObject[]>] [<CommonParameters>]
```

### Any
```
New-SAIAgentConditionDefinition [-Any] [-ConditionDefinition <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Defines a match group for a policy's `-agent` grant - either a list of agent identifiers, or a
wildcard matching any agent.

Groups are combined with **or** by the service, so pass a previous definition to
`-ConditionDefinition` to widen the grant. Each group holds exactly one condition; the service does
not yet support combining conditions within a group with and.

## EXAMPLES

### Example 1
```
New-SAIAgentConditionDefinition -id a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12
```

Matches one agent

### Example 2
```
New-SAIAgentConditionDefinition -id $FirstAgent, $SecondAgent
```

Matches either of two agents in a single condition

### Example 3
```
New-SAIAgentConditionDefinition -Any
```

Matches any agent

## PARAMETERS

### -id
The agent identifiers to match.

```yaml
Type: String[]
Parameter Sets: In
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Any
Match any agent.

```yaml
Type: SwitchParameter
Parameter Sets: Any
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConditionDefinition
An existing condition definition to add this group to.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

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
