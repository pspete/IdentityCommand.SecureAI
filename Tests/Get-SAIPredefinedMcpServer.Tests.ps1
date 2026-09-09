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

Describe 'Get-SAIPredefinedMcpServer' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ targets = @([pscustomobject]@{ id = 'tpl-1'; name = 'Asana MCP Server'; authMethod = 'OAUTH2.1'; version = 1 }) }
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

        $Script:response = Get-SAIPredefinedMcpServer
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/predefined/mcp-servers'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Method -eq 'GET'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.targets.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'requests a single template by id' {
            $null = Get-SAIPredefinedMcpServer -templateId 'tpl-1'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/predefined/mcp-servers/tpl-1'
            } -Times 1 -Exactly -Scope It
        }
    }
    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the templates of the response' {
            $Script:response.id | Should -Be 'tpl-1'
        }
    }

}
