function Get-SAIApiHeader {
    <#
    .SYNOPSIS
    Returns the Accept header value for a Secure AI resource.

    .DESCRIPTION
    Every Secure AI endpoint is a Beta API and requires an explicit Accept header naming the
    resource it belongs to; a request without it, or with the wrong one, is refused with 406 Not
    Acceptable. The three values are held here so the commands do not each carry a copy.

    Pass the returned value to Invoke-IDRestMethod's -Accept parameter.

    .PARAMETER Resource
    The resource the request addresses - agents, targets or policies.

    .EXAMPLE
    Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Agents)

    .OUTPUTS
    String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(
            Mandatory = $true,
            Position = 0
        )]
        [ValidateSet('Agents', 'Targets', 'Policies')]
        [string]$Resource
    )

    switch ($Resource) {

        'Agents' { 'application/x.agents.beta+json' }
        'Targets' { 'application/x.targets.beta+json' }
        'Policies' { 'application/x.policies.beta+json' }

    }

}
