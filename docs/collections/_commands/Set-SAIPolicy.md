---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIPolicy

## SYNOPSIS
Updates a Secure AI access policy

## SYNTAX

```
Set-SAIPolicy -policyId <String> [-name <String>] [-state <String>] [-agent <PSObject[]>]
 [-resources <PSObject[]>] [-description <String>] [-tags <Hashtable>] [-owners <PSObject[]>]
 [-user <PSObject[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a Secure AI access policy. Omitted values are left unchanged by the service, so supply only
what is changing.

`accessType` is fixed at creation and cannot be changed. Any `-user` grant supplied must stay
consistent with it: an `ON_BEHALF_OF` policy cannot have its user grant removed, and an `AUTONOMOUS`
policy must not be given one.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIPolicy -policyId 3f4e5d6c-7b8a-4c9d-a1e2-f3b4c5d6e7f8 -state DISABLED
```

Disables a policy

### Example 2
```
Set-SAIPolicy -policyId $policyId -resources (New-SAIResourceConditionDefinition -matchId 'mcp:reporting:read-*')
```

Narrows the resources a policy grants

### Example 3
```
Set-SAIPolicy -policyId $policyId -name 'Analyst tooling' -tags @{ environment = 'production' }
```

Renames a policy and replaces its tags

## PARAMETERS

### -policyId
The unique identifier of the access policy.

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
A new name for the policy.

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

### -state
Whether the policy is enforced.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ENABLED, DISABLED

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -agent
The agent match groups, from `New-SAIAgentConditionDefinition`. Replaces the current grant.

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

### -resources
The resource match groups, from `New-SAIResourceConditionDefinition`. Replaces the current grant.

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

### -description
A new description for the policy.

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

### -tags
Key-value tags for filtering and organisation. Replaces the current tags.

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

### -owners
The users or roles assigned as policy owners, from `New-SAIOwnerDefinition`.

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

### -user
The user match groups, from `New-SAIUserConditionDefinition`. Valid only for an `ON_BEHALF_OF` policy.

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
