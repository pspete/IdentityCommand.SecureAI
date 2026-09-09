# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIAgentConditionDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function builds a definition object and does not change state')]
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Any', Justification = 'Used via $PSCmdlet.ParameterSetName')]
    [CmdletBinding(DefaultParameterSetName = 'In')]
    [OutputType('IdCmd.SecureAI.Definition.AgentCondition')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'In'
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$id,

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

        #Each group carries exactly one condition; groups are combined with or by the service
        $Condition = if ($PSCmdlet.ParameterSetName -eq 'Any') {
            [ordered]@{ op = 'any'; value = $null }
        } else {
            [ordered]@{ op = 'in'; key = 'id'; value = @($id) }
        }

        $Group = [pscustomobject]@{ conditions = @([pscustomobject]$Condition) }

        $Output = @($ConditionDefinition) + @($Group) | Where-Object { $null -ne $_ }

        $Output | Add-CustomType -Type 'IdCmd.SecureAI.Definition.AgentCondition'

    }#process

    end { }#end

}
