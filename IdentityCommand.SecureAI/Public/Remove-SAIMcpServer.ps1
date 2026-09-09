# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Remove-SAIMcpServer {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$mcpServerId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers/$mcpServerId"

        if ($PSCmdlet.ShouldProcess($mcpServerId, 'Delete MCP Server')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SAIApiHeader -Resource Targets)

        }

    }#process

    end { }#end

}
