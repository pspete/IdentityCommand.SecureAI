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

Describe 'Get-SAIPolicy' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ policies = @([pscustomobject]@{ id = 'pol-1'; name = 'SomePolicy'; accessType = 'ON_BEHALF_OF'; state = 'ENABLED' }); nextCursor = $null }
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

        $Script:response = Get-SAIPolicy
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
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.policies.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'requests a single policy by id' {
            $null = Get-SAIPolicy -policyId 'pol-1'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/policies/pol-1'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the policies of the response' {
            $Script:response.id | Should -Be 'pol-1'
        }

        It 'resends the cursor under a different name than it is returned' {
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
                [pscustomobject]@{ policies = @([pscustomobject]@{ id = 'pol-2' }); nextCursor = $null }
            } -ParameterFilter { $URI -match 'cursor=' }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
                [pscustomobject]@{ policies = @([pscustomobject]@{ id = 'pol-1' }); nextCursor = 'abc123' }
            } -ParameterFilter { $URI -notmatch 'cursor=' }

            (Get-SAIPolicy | Measure-Object).Count | Should -Be 2

            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -match 'cursor=abc123'
            } -Times 1 -Exactly -Scope It
        }
    }

}
