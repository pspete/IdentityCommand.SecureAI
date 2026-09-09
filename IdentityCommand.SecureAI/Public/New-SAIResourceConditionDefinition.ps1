# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIResourceConditionDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function builds a definition object and does not change state')]
    [CmdletBinding(DefaultParameterSetName = 'MatchId')]
    [OutputType('IdCmd.SecureAI.Definition.ResourceCondition')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'MatchId'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$matchId,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'MatchTag'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$matchTag,

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
            ParameterSetName = 'InTag'
        )]
        [ValidateNotNullOrEmpty()]
        [String[]]$tag,

        [parameter(Mandatory = $false)]
        [psobject[]]$ConditionDefinition
    )

    begin { }#begin

    process {

        $Condition = switch ($PSCmdlet.ParameterSetName) {

            'MatchTag' { [ordered]@{ op = 'match'; key = 'tag'; value = $matchTag } }
            'InId' { [ordered]@{ op = 'in'; key = 'id'; value = @($id) } }
            'InTag' { [ordered]@{ op = 'in'; key = 'tag'; value = @($tag) } }
            default { [ordered]@{ op = 'match'; key = 'id'; value = $matchId } }

        }

        $Group = [pscustomobject]@{ conditions = @([pscustomobject]$Condition) }

        $Output = @($ConditionDefinition) + @($Group) | Where-Object { $null -ne $_ }

        $Output | Add-CustomType -Type 'IdCmd.SecureAI.Definition.ResourceCondition'

    }#process

    end { }#end

}
