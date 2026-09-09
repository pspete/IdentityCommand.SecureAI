---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIAgent

## SYNOPSIS
Updates the metadata of an AI agent

## SYNTAX

```
Set-SAIAgent -agentId <String> [-name <String>] [-description <String>] [-owners <PSObject[]>]
 [-tags <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the metadata of an AI agent. Omitted values are left unchanged, so supply only what is
changing.

Only the name, description, owners and tags can be changed here. An agent's type and callback URLs are
fixed after registration, its tools and connectors are managed elsewhere, and its state is changed with
`Set-SAIAgentState`.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIAgent -agentId a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12 -description 'Updated purpose'
```

Updates the description of an agent

### Example 2
```
Set-SAIAgent -agentId $agentId -name 'Onboarding bot' -tags @{ environment = 'production'; team = 'people' }
```

Renames an agent and replaces its tags

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

### -name
A new name for the agent.

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

### -description
A new description for the agent.

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
The users or roles responsible for the agent, from `New-SAIOwnerDefinition`. Replaces the current owners.

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
Key-value pairs categorising the agent. Replaces the current tags.

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
