BeforeAll {
    $Script:SAIModuleName = 'IdentityCommand.SecureAI'

    #Get Current Directory
    $Here = Split-Path -Parent $PSCommandPath

    #Resolve Path to Module Directory
    $ModulePath = Resolve-Path "$Here\..\$Script:SAIModuleName"

    #Define Path to Module Manifest
    $ManifestPath = Join-Path "$ModulePath" "$Script:SAIModuleName.psd1"

    if ( -not (Get-Module -Name $Script:SAIModuleName -All)) {

        Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

    }
}

Describe 'Set-SAIAgent' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ id = 'agent-1'; name = 'SomeAgent'; status = [pscustomobject]@{ state = 'ACTIVE' } }
        }

        InModuleScope -ModuleName $Script:SAIModuleName {
            $ISPSSSession = [ordered]@{
                tenant_url = 'https://somedomain.aigw.cyberark.cloud'
                User       = $null
                TenantId   = 'SomeTenant'
                SessionId  = 'SomeSession'
                WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
        }

        $Script:response = Set-SAIAgent -agentId 'agent-1' -description 'SomeDescription'
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/agents/agent-1'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Method -eq 'PUT'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.agents.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends only the supplied metadata' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Names = ($Body | ConvertFrom-Json).PSObject.Properties.Name
                ($Names -contains 'description') -and ($Names -notcontains 'name') -and ($Names -notcontains 'agentId')
            } -Times 1 -Exactly -Scope It
        }

        It 'accepts the agent id from the pipeline by property name' {
            [pscustomobject]@{ agentId = 'agent-9' } | Set-SAIAgent -name 'Renamed'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/agents/agent-9'
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send a request when WhatIf is specified' {
            $null = Set-SAIAgent -agentId 'agent-8' -description 'NotUpdated' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -match 'agent-8'
            } -Times 0 -Exactly -Scope It
        }
    }

}
