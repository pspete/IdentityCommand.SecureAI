#region Loader
<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

#endregion Loader

#Copy IdentityCommand's private helpers into this module: this module's functions call them, and
#the argument completer registrations below do so at import time.
#Each copy is created from the function definition, so it runs in this module's scope and uses this
#module's $ISPSSSession, whether IdentityCommand loaded from source or from its combined psm1.
#Resolve a single IdentityCommand module: with more than one version loaded, Get-Module returns
#an array.
$Module = Get-Module -Name IdentityCommand | Sort-Object Version -Descending | Select-Object -First 1

if ($null -eq $Module) {
    throw 'The IdentityCommand module is not loaded. Import IdentityCommand and try again.'
}

& $Module { Get-ChildItem -Path Function: } |

    Where-Object { $_.ModuleName -eq $Module.Name -and -not $Module.ExportedFunctions.ContainsKey($_.Name) } |

    ForEach-Object {

        . ([scriptblock]::Create("function $($_.Name) {$($_.Definition)}"))

    }

#region Registration

Register-ArgumentCompleter -ParameterName 'agentId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIAgent' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIAgent'
    'Remove-SAIAgent'
    'Set-SAIAgent'
    'Set-SAIAgentState'
)

Register-ArgumentCompleter -ParameterName 'mcpServerId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIMcpServer'
    'Remove-SAIMcpServer'
    'Set-SAIMcpServer'
    'Set-SAIMcpServerState'
)

#The predefined catalog is the source of the template id a registration is created from
Register-ArgumentCompleter -ParameterName 'predefinedTargetId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPredefinedMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName 'New-SAIMcpServer'

Register-ArgumentCompleter -ParameterName 'templateId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPredefinedMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName 'Get-SAIPredefinedMcpServer'

Register-ArgumentCompleter -ParameterName 'policyId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPolicy' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIPolicy'
    'Remove-SAIPolicy'
    'Set-SAIPolicy'
    'Set-SAIPolicyState'
)

#endregion Registration

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force