# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Get-SAIPredefinedMcpServer {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byId'
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('id', 'predefinedTargetId')]
        [String]$templateId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targets/predefined/mcp-servers"

        if ($PSCmdlet.ParameterSetName -eq 'byId') {

            $URI = "$URI/$templateId"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Targets)

        } else {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Targets)

            if ($null -ne $result) {

                $result.targets

            }

        }

    }#process

    end { }#end

}
