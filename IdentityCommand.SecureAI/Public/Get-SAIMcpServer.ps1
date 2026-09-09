# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Get-SAIMcpServer {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byId'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$mcpServerId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'All'
        )]
        [ValidateRange(1, 2147483647)]
        [int]$pageSize
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'byId') {

            $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers/$mcpServerId"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Targets)

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers"
            $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Targets)

            if ($null -ne $result) {

                Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'mcpServers' -CursorRequestKey 'nextCursor' -CursorResponseKey 'nextCursor'

            }

        }

    }#process

    end { }#end

}
