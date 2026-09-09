# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIMcpServerState {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$mcpServerId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ENABLED', 'DISABLED')]
        [String]$state
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers/$mcpServerId/state"

        $body = [ordered]@{ state = $state } | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($mcpServerId, "Set MCP Server State: $state")) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Targets)

        }

    }#process

    end { }#end

}
