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

Describe 'Set-SAIMcpServer' {

    BeforeEach {

        Mock -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -MockWith {
            [pscustomobject]@{ id = 'mcp-1'; name = 'SomeServer'; state = 'ENABLED'; source = [pscustomobject]@{ type = 'CUSTOM' } }
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

        $Script:response = Set-SAIMcpServer -mcpServerId 'mcp-1' -description 'SomeDescription'
    }

    Context 'Request' {

        It 'sends request' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -Times 1 -Exactly -Scope It
        }

        It 'sends request to expected endpoint' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/mcp-servers/mcp-1'
            } -Times 1 -Exactly -Scope It
        }

        It 'uses expected method' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Method -eq 'PUT'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.targets.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends only the supplied fields' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Names = ($Body | ConvertFrom-Json).PSObject.Properties.Name
                ($Names -contains 'description') -and ($Names -notcontains 'mcpServerId') -and ($Names -notcontains 'category')
            } -Times 1 -Exactly -Scope It
        }

        It 'accepts the server id from the pipeline by property name' {
            [pscustomobject]@{ mcpServerId = 'mcp-9' } | Set-SAIMcpServer -description 'd'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -eq 'https://somedomain.aigw.cyberark.cloud/api/targets/mcp-servers/mcp-9'
            } -Times 1 -Exactly -Scope It
        }

        It 'does not send a request when WhatIf is specified' {
            $null = Set-SAIMcpServer -mcpServerId 'mcp-8' -description 'NotUpdated' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $URI -match 'mcp-8'
            } -Times 0 -Exactly -Scope It
        }
    }

}
