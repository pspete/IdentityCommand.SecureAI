---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Set-SAIPolicyState

## SYNOPSIS
Enables or disables a Secure AI access policy

## SYNTAX

```
Set-SAIPolicyState -policyId <String> -state <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Enables or disables a Secure AI access policy.

**Disabling takes effect immediately**: requests which previously matched the policy are denied until
it is enabled again, because access is denied by default.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Set-SAIPolicyState -policyId 3f4e5d6c-7b8a-4c9d-a1e2-f3b4c5d6e7f8 -state DISABLED
```

Disables a policy

### Example 2
```
Get-SAIPolicy | Where-Object state -eq ENABLED | Set-SAIPolicyState -state DISABLED
```

Disables every enabled policy

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

### -state
Whether the policy is enforced.

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
