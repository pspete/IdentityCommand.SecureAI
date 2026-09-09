---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Get-SAIPolicy

## SYNOPSIS
Gets Secure AI access policies

## SYNTAX

### All (Default)
```
Get-SAIPolicy [-pageSize <Int32>] [<CommonParameters>]
```

### byId
```
Get-SAIPolicy -policyId <String> [<CommonParameters>]
```

## DESCRIPTION
Gets the Secure AI access policies on the tenant, or one by identifier.

An `ON_BEHALF_OF` policy carries a `user` grant; an `AUTONOMOUS` policy does not.

Results are paginated automatically; every page is retrieved and the policies of each are returned.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Get-SAIPolicy
```

Gets all access policies

### Example 2
```
Get-SAIPolicy -policyId 3f4e5d6c-7b8a-4c9d-a1e2-f3b4c5d6e7f8
```

Gets the specified policy

### Example 3
```
Get-SAIPolicy | Where-Object accessType -eq AUTONOMOUS
```

Gets the policies which let agents act with no user in the loop

## PARAMETERS

### -policyId
The unique identifier of the access policy.

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

### -pageSize
The maximum number of policies to return per request. The service returns 50 when not specified.

```yaml
Type: Int32
Parameter Sets: All
Aliases: 

Required: False
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
