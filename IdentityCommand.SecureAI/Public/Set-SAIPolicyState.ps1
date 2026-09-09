# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIPolicyState {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$policyId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ENABLED', 'DISABLED')]
        [String]$state
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/policies/$policyId/state"

        $body = [ordered]@{ state = $state } | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($policyId, "Set Secure AI Access Policy State: $state")) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Policies)

        }

    }#process

    end { }#end

}
