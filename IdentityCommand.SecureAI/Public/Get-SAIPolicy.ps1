# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Get-SAIPolicy {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byId'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id')]
        [String]$policyId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'All'
        )]
        [ValidateRange(1, 2147483647)]
        [int]$pageSize
    )

    begin { }#begin

    process {

        if ($PSCmdlet.ParameterSetName -eq 'byId') {

            $URI = "$($ISPSSSession.tenant_url)/api/policies/$policyId"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Policies)

        } else {

            $URI = "$($ISPSSSession.tenant_url)/api/policies"
            $URI = Add-QueryString -URI $URI -Parameter ($PSBoundParameters | Get-Parameter)

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Policies)

            if ($null -ne $result) {

                #The continuation token is returned as nextCursor and resent as cursor
                Get-PagedResult -InitialResult $result -URI $URI -Style Cursor -ResultProperty 'policies' -CursorRequestKey 'cursor' -CursorResponseKey 'nextCursor'

            }

        }

    }#process

    end { }#end

}
