# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIAgentState {
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
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ACTIVE', 'SUSPENDED')]
        [String]$state
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/agents/$agentId/state"

        $body = [ordered]@{ state = $state } | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($agentId, "Set AI Agent State: $state")) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Agents)

        }

    }#process

    end { }#end

}
