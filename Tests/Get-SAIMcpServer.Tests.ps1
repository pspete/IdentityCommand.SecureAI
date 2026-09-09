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

Describe 'Get-SAIMcpServer' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ mcpServers = @([pscustomobject]@{ id = 'mcp-1'; name = 'SomeServer'; state = 'ENABLED'; source = [pscustomobject]@{ type = 'CUSTOM' } }); nextCursor = $null }
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

        $Script:response = Get-SAIMcpServer
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/mcp-servers'
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

        It 'requests a single server by id' {
            $null = Get-SAIMcpServer -mcpServerId 'mcp-1'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/mcp-servers/mcp-1'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the page size in the query string' {
            $null = Get-SAIMcpServer -pageSize 25
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -match 'pageSize=25'
            } -Times 1 -Exactly -Scope It
        }
    }

    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the servers of the response' {
            $Script:response.id | Should -Be 'mcp-1'
        }

        It 'follows the continuation cursor until it is empty' {
            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
                [pscustomobject]@{ mcpServers = @([pscustomobject]@{ id = 'mcp-2' }); nextCursor = $null }
            } -ParameterFilter { $URI -match 'nextCursor=' }

            Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
                [pscustomobject]@{ mcpServers = @([pscustomobject]@{ id = 'mcp-1' }); nextCursor = 'eyJpZCI6' }
            } -ParameterFilter { $URI -notmatch 'nextCursor=' }

            (Get-SAIMcpServer | Measure-Object).Count | Should -Be 2
        }
    }

}
