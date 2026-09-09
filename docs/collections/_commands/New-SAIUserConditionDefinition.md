---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIUserConditionDefinition

## SYNOPSIS
Defines the user grant of a policy

## SYNTAX

### InId (Default)
```
New-SAIUserConditionDefinition -id <String[]> [-ConditionDefinition <PSObject[]>] [<CommonParameters>]
```

### InRole
```
New-SAIUserConditionDefinition -roleId <String[]> [-ConditionDefinition <PSObject[]>]
 [<CommonParameters>]
```

### Any
```
New-SAIUserConditionDefinition [-Any] [-ConditionDefinition <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Defines a match group for a policy's `-user` grant - the users an agent may act on behalf of. Match by
user identifier, by role identifier, or with a wildcard matching any user.

Only valid on an `ON_BEHALF_OF` policy; an `AUTONOMOUS` policy must have no user grant.

Groups are combined with **or** by the service, so pass a previous definition to
`-ConditionDefinition` to widen the grant.

## EXAMPLES

### Example 1
```
New-SAIUserConditionDefinition -roleId finance-analysts
```

Matches users holding a role

### Example 2
```
$Users = New-SAIUserConditionDefinition -roleId finance-analysts
$Users = New-SAIUserConditionDefinition -id $NamedUserId -ConditionDefinition $Users
```

Matches a role or a named user

### Example 3
```
New-SAIUserConditionDefinition -Any
```

Matches any user

## PARAMETERS

### -id
The user identifiers to match.

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

### -roleId
The role identifiers to match.

```yaml
Type: String[]
Parameter Sets: InRole
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Any
Match any user.

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
