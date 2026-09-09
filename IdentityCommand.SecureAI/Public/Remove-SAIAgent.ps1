# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Remove-SAIAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 128)]
        [Alias('id')]
        [String]$agentId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/agents/$agentId"

        if ($PSCmdlet.ShouldProcess($agentId, 'Delete AI Agent')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SAIApiHeader -Resource Agents)

        }

    }#process

    end { }#end

}
