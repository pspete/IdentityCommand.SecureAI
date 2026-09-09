# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIPolicy {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 256)]
        [String]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ON_BEHALF_OF', 'AUTONOMOUS')]
        [String]$accessType,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('ENABLED', 'DISABLED')]
        [String]$state,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$agent,

        [parameter(
            Mandatory = $true,
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

        $URI = "$($ISPSSSession.tenant_url)/api/policies"

        #A user grant is required for an on-behalf-of policy and rejected for an autonomous one
        if (($accessType -eq 'ON_BEHALF_OF') -and (-not $PSBoundParameters.ContainsKey('user'))) {
            throw 'A user grant is required when accessType is ON_BEHALF_OF'
        }

        if (($accessType -eq 'AUTONOMOUS') -and $PSBoundParameters.ContainsKey('user')) {
            throw 'A user grant cannot be supplied when accessType is AUTONOMOUS'
        }

        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json -Depth 10

        if ($PSCmdlet.ShouldProcess($name, 'Create Secure AI Access Policy')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Policies)

        }

    }#process

    end { }#end

}
