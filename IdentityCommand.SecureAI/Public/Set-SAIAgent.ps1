# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 128)]
        [Alias('id')]
        [String]$agentId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(2, 256)]
        [ValidatePattern('^[A-Za-z0-9 _-]+$')]
        [String]$name,

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

        $URI = "$($ISPSSSession.tenant_url)/api/agents/$agentId"

        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove agentId | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($agentId, 'Update AI Agent')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body -Accept $(Get-SAIApiHeader -Resource Agents)

        }

    }#process

    end { }#end

}
