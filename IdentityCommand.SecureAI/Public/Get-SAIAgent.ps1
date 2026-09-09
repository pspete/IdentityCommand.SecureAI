# .ExternalHelp IdentityCommand.SecureAI-help.xml
function Get-SAIAgent {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'byId'
        )]
        [ValidateLength(1, 128)]
        [Alias('id')]
        [String]$agentId
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/agents"

        if ($PSCmdlet.ParameterSetName -eq 'byId') {

            $URI = "$URI/$agentId"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Agents)

        } else {

            #Send Request
            $result = Invoke-IDRestMethod -Uri $URI -Method GET -Accept $(Get-SAIApiHeader -Resource Agents)

            if ($null -ne $result) {

                $result.agents

            }

        }

    }#process

    end { }#end

}
