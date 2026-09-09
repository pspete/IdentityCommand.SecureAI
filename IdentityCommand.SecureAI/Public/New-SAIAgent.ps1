# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIAgent {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(2, 256)]
        [ValidatePattern('^[A-Za-z0-9 _-]+$')]
        [String]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(2, 256)]
        [String]$type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateCount(0, 10)]
        [String[]]$redirectCallbackUrls,

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

        $URI = "$($ISPSSSession.tenant_url)/api/agents"

        $body = $PSBoundParameters | Get-Parameter | ConvertTo-Json -Depth 8

        if ($PSCmdlet.ShouldProcess($name, 'Register AI Agent')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Agents)

        }

    }#process

    end { }#end

}
