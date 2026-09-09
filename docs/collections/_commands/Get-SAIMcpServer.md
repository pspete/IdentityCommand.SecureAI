---
external help file: IdentityCommand.SecureAI-help.xml
Module Name: IdentityCommand.SecureAI
online version:
schema: 2.0.0
---

# Get-SAIMcpServer

## SYNOPSIS
Gets registered MCP servers

## SYNTAX

### All (Default)
```
Get-SAIMcpServer [-pageSize <Int32>] [<CommonParameters>]
```

### byId
```
Get-SAIMcpServer -mcpServerId <String> [<CommonParameters>]
```

## DESCRIPTION
Gets the MCP server targets registered on the tenant - both custom registrations and those created
from a predefined catalog template - or one by identifier.

Each registration carries the gateway URL agents reach it through, its upstream URL, its
authentication method, and its `ENABLED`/`DISABLED` state. A registration created from a template
carries the template id and the resolved template version under `source`.

Results are paginated automatically; every page is retrieved and the servers of each are returned.

This endpoint is a Beta API and requires a resource-specific Accept header, which the module sends for you.

## EXAMPLES

### Example 1
```
Get-SAIMcpServer
```

Gets all registered MCP servers

### Example 2
```
Get-SAIMcpServer -mcpServerId 60395ad9-99ea-4a72-b3fe-ca67448a8f6f
```

Gets the specified MCP server

### Example 3
```
Get-SAIMcpServer | Where-Object { $_.source.type -eq 'PREDEFINED' }
```

Gets the registrations created from a catalog template

## PARAMETERS

### -mcpServerId
The unique identifier of the registered MCP server.

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
The maximum number of servers to return per request. The service chooses a default when not specified.

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
