---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIOwnerDefinition

## SYNOPSIS
Defines an owner of an agent, MCP server or policy

## SYNTAX

```
New-SAIOwnerDefinition -id <String> -name <String> -type <String> [-sourceDirectoryName <String>]
 [-sourceDirectoryId <String>] [-OwnerDefinition <PSObject[]>] [<CommonParameters>]
```

## DESCRIPTION
Defines an owner - a user or a role - for the `-owners` of an agent, an MCP server registration or a
policy.

The directory fields are required for a `USER` owner and optional for a `ROLE`.

Pass a previous definition to `-OwnerDefinition` to add another owner to it.

## EXAMPLES

### Example 1
```
New-SAIOwnerDefinition -id 5d7b7ab4-4fa8-4d76-bac1-d0a0759c0d73 -name 'john.doe@company.com' -type USER `
    -sourceDirectoryName 'Idira Cloud Directory' -sourceDirectoryId '09B9A9B0-6CE8-465F-AB03-65766D33B05E'
```

Defines a single user owner

### Example 2
```
$Owners = New-SAIOwnerDefinition -id $UserId -name $UserName -type USER -sourceDirectoryName $Directory -sourceDirectoryId $DirectoryId
$Owners = New-SAIOwnerDefinition -id $RoleId -name 'Platform Admins' -type ROLE -OwnerDefinition $Owners
```

Adds a role owner to a user owner

## PARAMETERS

### -id
The identity identifier in the directory service.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -name
The display name of the identity.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -type
Whether the owner is a user or a role.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: USER, ROLE

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -sourceDirectoryName
The name of the directory service. Required for a `USER`.

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

### -sourceDirectoryId
The identifier of the directory service. Required for a `USER`.

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

### -OwnerDefinition
An existing owner definition to add this owner to.

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
