# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Remove-SAIPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$policyId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/policies/$policyId"

        if ($PSCmdlet.ShouldProcess($policyId, 'Delete Secure AI Access Policy')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method DELETE -Accept $(Get-SAIApiHeader -Resource Policies)

        }

    }#process

    end { }#end

}
