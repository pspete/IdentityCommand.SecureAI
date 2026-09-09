---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIPolicy

## SYNOPSIS
Creates a Secure AI access policy

## SYNTAX

```
New-SAIPolicy -name <String> -accessType <String> -state <String> -agent <PSObject[]>
 -resources <PSObject[]> [-description <String>] [-tags <Hashtable>] [-owners <PSObject[]>]
 [-user <PSObject[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
A Secure AI access policy controls which users and AI agents may run tools on registered MCP servers.
**Access is denied by default** - a request is allowed only where a policy permits it.

The `agent`, `user` and `resources` grants are arrays of match groups, combined with **or**: the grant
matches where any group matches. Build them with `New-SAIAgentConditionDefinition`,
`New-SAIUserConditionDefinition` and `New-SAIResourceConditionDefinition`, each of which chains onto a
previous definition.

`-accessType` decides whether a user grant is required:

- `ON_BEHALF_OF` - the agent acts for a user, so `-user` is **required**
- `AUTONOMOUS` - the agent acts alone, so `-user` must **not** be given

This command enforces both rules before sending the request.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
New-SAIPolicy -name 'Finance agent on behalf of analysts' -accessType ON_BEHALF_OF -state ENABLED `
    -agent (New-SAIAgentConditionDefinition -id a8f9c2d1-3e4b-42fa-bb71-2a913d45ef12) `
    -user (New-SAIUserConditionDefinition -roleId finance-analysts) `
    -resources (New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*')
```

Lets a named agent call reporting tools for users in a role

### Example 2
```
New-SAIPolicy -name 'Nightly cleanup agent' -accessType AUTONOMOUS -state ENABLED `
    -agent (New-SAIAgentConditionDefinition -id b9e8d7c6-5f4a-43ba-9c8d-1e2f3a4b5c6d) `
    -resources (New-SAIResourceConditionDefinition -matchId 'mcp:maintenance:*')
```

Lets an agent run maintenance tools with no user in the loop

### Example 3
```
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
$Resources = New-SAIResourceConditionDefinition -matchId 'mcp:analytics:*' -ConditionDefinition $Resources

New-SAIPolicy -name 'Analyst tooling' -accessType ON_BEHALF_OF -state ENABLED `
    -agent (New-SAIAgentConditionDefinition -Any) `
    -user (New-SAIUserConditionDefinition -roleId analysts) -resources $Resources
```

Lets any agent reach two tool namespaces for users in a role

## PARAMETERS

### -name
A unique name for the policy.

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

### -accessType
Whether the agent acts for a user or alone. Fixed at creation.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: ON_BEHALF_OF, AUTONOMOUS

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

### -agent
The agent match groups, from `New-SAIAgentConditionDefinition`.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -resources
The resource match groups, from `New-SAIResourceConditionDefinition`.

```yaml
Type: PSObject[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
A description of the policy's purpose.

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
Key-value tags for filtering and organisation.

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
The user match groups, from `New-SAIUserConditionDefinition`. Required for `ON_BEHALF_OF`, rejected for `AUTONOMOUS`.

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
