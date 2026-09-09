# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIUserConditionDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function builds a definition object and does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Any', Justification = 'Used via $PSCmdlet.ParameterSetName')]
    [CmdletBinding(DefaultParameterSetName = 'InId')]
    [OutputType('IdCmd.SecureAI.Definition.UserCondition')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'InId'
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'InRole'
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$roleId,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'Any'
        )]
        [switch]$Any,

        [parameter(Mandatory = $false)]
        [psobject[]]$ConditionDefinition
    )

    begin { }#begin

    process {

        $Condition = switch ($PSCmdlet.ParameterSetName) {

            'Any' { [ordered]@{ op = 'any'; value = $null } }
            'InRole' { [ordered]@{ op = 'in'; key = 'roleId'; value = @($roleId) } }
            default { [ordered]@{ op = 'in'; key = 'id'; value = @($id) } }

        }

        $Group = [pscustomobject]@{ conditions = @([pscustomobject]$Condition) }

        $Output = @($ConditionDefinition) + @($Group) | Where-Object { $null -ne $_ }

        $Output | Add-CustomType -Type 'IdCmd.SecureAI.Definition.UserCondition'

    }#process

    end { }#end

}
