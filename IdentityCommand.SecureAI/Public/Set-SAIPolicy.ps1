# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Set-SAIPolicy {
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
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 256)]
        [String]$name,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ENABLED', 'DISABLED')]
        [String]$state,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$agent,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$resources,

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
        [hashtable]$tags,

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
        [psobject[]]$user
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/policies/$policyId"

        #The service leaves omitted fields unchanged, so only what was supplied is sent
        $body = $PSBoundParameters | Get-Parameter -ParametersToRemove policyId | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess($policyId, 'Update Secure AI Access Policy')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method PUT -Body $body -Accept $(Get-SAIApiHeader -Resource Policies)

        }

    }#process

    end { }#end

}
