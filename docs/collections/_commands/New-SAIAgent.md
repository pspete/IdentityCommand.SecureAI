---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# New-SAIAgent

## SYNOPSIS
Registers an AI agent

## SYNTAX

```
New-SAIAgent -name <String> -type <String> [-redirectCallbackUrls <String[]>] [-description <String>]
 [-owners <PSObject[]>] [-tags <Hashtable>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Registers a new AI agent. The agent is created in `PENDING_CONNECTION` state and the response carries
the connection details the agent needs: its `clientId`, `clientSecret` and the per-tenant gateway URL.

**The client secret is shown once and is not stored by the service** - capture it from the response.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
New-SAIAgent -name 'Finance Copilot' -type COPILOT -description 'AI agent for the finance team'
```

Registers a Copilot agent

### Example 2
```
$Agent = New-SAIAgent -name 'Sales Bot' -type CLAUDE -redirectCallbackUrls 'https://crm.company.com/oauth/callback' `
    -owners (New-SAIOwnerDefinition -id $UserId -name 'sales.lead@company.com' -type USER -sourceDirectoryName $Directory -sourceDirectoryId $DirectoryId) `
    -tags @{ environment = 'production'; department = 'sales' }

$Agent.credentials
```

Registers an agent with an owner and tags, then reads the one-time credentials

## PARAMETERS

### -name
A unique, human-readable name for the agent. Letters, digits, spaces, underscores and dashes only.

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
The type of agent, for example `COPILOT`, `CLAUDE` or `CUSTOM`.

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

### -redirectCallbackUrls
Up to ten approved HTTPS callback URLs. Auto-filled for predefined types; supply for `CUSTOM`.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -description
A description of the agent's purpose.

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
The users or roles responsible for the agent, from `New-SAIOwnerDefinition`.

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
Up to ten key-value pairs used to categorise the agent.

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
