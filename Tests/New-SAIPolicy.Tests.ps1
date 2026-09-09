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

Describe 'New-SAIPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ id = 'pol-1'; name = 'SomePolicy'; accessType = 'ON_BEHALF_OF'; state = 'ENABLED' }
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

        $Script:response = New-SAIPolicy -name 'SomePolicy' -accessType ON_BEHALF_OF -state ENABLED -agent ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'id'; value = @('agent-1') }) }) -user ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'roleId'; value = @('analysts') }) }) -resources ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'match'; key = 'id'; value = 'mcp:reporting:*' }) })
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/policies'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.policies.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the access type and state' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Payload = $Body | ConvertFrom-Json
                ($Payload.accessType -eq 'ON_BEHALF_OF') -and ($Payload.state -eq 'ENABLED')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the agent, user and resource grants' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Payload = $Body | ConvertFrom-Json
                ($Payload.agent[0].conditions[0].value -contains 'agent-1') -and
                ($Payload.user[0].conditions[0].key -eq 'roleId') -and
                ($Payload.resources[0].conditions[0].op -eq 'match')
            } -Times 1 -Exactly -Scope It
        }

        It 'throws when an on behalf of policy has no user grant' {
            { New-SAIPolicy -name 'x' -accessType ON_BEHALF_OF -state ENABLED -agent ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'id'; value = @('agent-1') }) }) -resources ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'match'; key = 'id'; value = 'mcp:reporting:*' }) }) } |
                Should -Throw '*user grant is required when accessType is ON_BEHALF_OF*'
        }

        It 'throws when an autonomous policy is given a user grant' {
            { New-SAIPolicy -name 'x' -accessType AUTONOMOUS -state ENABLED -agent ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'id'; value = @('agent-1') }) }) -user ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'roleId'; value = @('analysts') }) }) -resources ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'match'; key = 'id'; value = 'mcp:reporting:*' }) }) } |
                Should -Throw '*user grant cannot be supplied when accessType is AUTONOMOUS*'
        }

        It 'accepts an autonomous policy without a user grant' {
            { New-SAIPolicy -name 'x' -accessType AUTONOMOUS -state ENABLED -agent ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'id'; value = @('agent-1') }) }) -resources ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'match'; key = 'id'; value = 'mcp:reporting:*' }) }) } | Should -Not -Throw
        }

        It 'does not send a request when WhatIf is specified' {
            $null = New-SAIPolicy -name 'NotCreated' -accessType AUTONOMOUS -state ENABLED -agent ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'in'; key = 'id'; value = @('agent-1') }) }) -resources ([pscustomobject]@{ conditions = @([pscustomobject]@{ op = 'match'; key = 'id'; value = 'mcp:reporting:*' }) }) -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Body -match 'NotCreated'
            } -Times 0 -Exactly -Scope It
        }
    }
    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the created policy' {
            $Script:response.id | Should -Be 'pol-1'
        }
    }

}
