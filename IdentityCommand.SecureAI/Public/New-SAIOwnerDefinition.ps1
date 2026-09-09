# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIOwnerDefinition {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Function builds a definition object and does not change state')]
    [CmdletBinding()]
    [OutputType('IdCmd.SecureAI.Definition.Owner')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$id,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('USER', 'ROLE')]
        [String]$type,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$sourceDirectoryName,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$sourceDirectoryId,

        [parameter(Mandatory = $false)]
        [psobject[]]$OwnerDefinition
    )

    begin { }#begin

    process {

        if (($type -eq 'USER') -and (-not ($PSBoundParameters.ContainsKey('sourceDirectoryName') -and $PSBoundParameters.ContainsKey('sourceDirectoryId')))) {
            throw 'sourceDirectoryName and sourceDirectoryId are required for a USER owner'
        }

        $Owner = $PSBoundParameters | Get-Parameter -ParametersToRemove OwnerDefinition

        $Output = @($OwnerDefinition) + @([pscustomobject]$Owner) | Where-Object { $null -ne $_ }

        $Output | Add-CustomType -Type 'IdCmd.SecureAI.Definition.Owner'

    }#process

    end { }#end

}
