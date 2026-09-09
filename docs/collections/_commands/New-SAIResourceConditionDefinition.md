---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIResourceConditionDefinition

## SYNOPSIS
Defines the resource grant of a policy

## SYNTAX

### MatchId (Default)
```
New-SAIResourceConditionDefinition -matchId <String> [-ConditionDefinition <PSObject[]>]
 [<CommonParameters>]
```

### MatchTag
```
New-SAIResourceConditionDefinition -matchTag <String> [-ConditionDefinition <PSObject[]>]
 [<CommonParameters>]
```

### InId
```
New-SAIResourceConditionDefinition -id <String[]> [-ConditionDefinition <PSObject[]>]
 [<CommonParameters>]
```

### InTag
```
New-SAIResourceConditionDefinition -tag <String[]> [-ConditionDefinition <PSObject[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Defines a match group for a policy's `-resources` grant - the MCP server tools the policy permits.

Resource identifiers take the form `mcp:<server>:<tool>`. Use `-matchId` or `-matchTag` for a glob
match, and `-id` or `-tag` for an exact list.

Groups are combined with **or** by the service, so pass a previous definition to
`-ConditionDefinition` to widen the grant.

## EXAMPLES

### Example 1
```
New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
```

Matches every tool on the reporting server

### Example 2
```
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:analytics:*' -ConditionDefinition $Resources
```

Matches the tools of two servers

### Example 3
```
New-SAIResourceConditionDefinition -id 'mcp:reporting:run-report', 'mcp:reporting:list-reports'
```

Matches two named tools exactly

### Example 4
```
New-SAIResourceConditionDefinition -matchTag 'production*'
```

Matches resources whose tag begins with production

## PARAMETERS

### -matchId
A glob matched against the resource identifier, for example `mcp:reporting:*`.

```yaml
Type: String
Parameter Sets: MatchId
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -matchTag
A glob matched against the resource tag.

```yaml
Type: String
Parameter Sets: MatchTag
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -id
The resource identifiers to match exactly.

```yaml
Type: String[]
Parameter Sets: InId
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -tag
The resource tags to match exactly.

```yaml
Type: String[]
Parameter Sets: InTag
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
