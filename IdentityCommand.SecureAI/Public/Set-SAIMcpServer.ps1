# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIMcpServer {
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
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 500)]
        [String]$description,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('COMMUNICATION_AND_TEAM_CHAT', 'EMAIL_AND_SCHEDULING', 'KNOWLEDGE_BASES_AND_DOCS',
            'FILE_STORAGE_AND_CONTENT_REPOS', 'DEVELOPER_TOOLS_AND_SOURCE_CONTROL', 'DATABASES_AND_DATA_STORES',
            'OBSERVABILITY_MONITORING_AND_TELEMETRY', 'ITSM_AND_INCIDENT_RESPONSE', 'WEB_AND_BROWSER_AUTOMATION',
            'CLOUD_AND_INFRASTRUCTURE_OPERATIONS')]
        [String]$category,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$owners,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$tags
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers/$mcpServerId"

        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove mcpServerId | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($mcpServerId, 'Update MCP Server')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body -Accept $(Get-SAIApiHeader -Resource Targets)

        }

    }#process

    end { }#end

}
