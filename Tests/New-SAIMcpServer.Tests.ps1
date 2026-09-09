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

Describe 'New-SAIMcpServer' {

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

        $Script:response = New-SAIMcpServer -name 'SomeServer' -description 'd' -category DEVELOPER_TOOLS_AND_SOURCE_CONTROL -upstreamUrl 'https://mcp.example.com/api'
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
                $Method -eq 'POST'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the beta Accept header for the resource' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Accept -eq 'application/x.targets.beta+json'
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a custom source and the upstream url' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Payload = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($Payload.source.type -eq 'CUSTOM') -and ($Payload.upstream.url -eq 'https://mcp.example.com/api')
            } -Times 1 -Exactly -Scope It
        }

        It 'sends the body as UTF8 bytes because it can carry a client secret' {
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Body -is [byte[]]
            } -Times 1 -Exactly -Scope It
        }

        It 'sends a predefined source when registering a template' {
            $null = New-SAIMcpServer -predefinedTargetId 'tpl-1'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Payload = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($Payload.source.type -eq 'PREDEFINED') -and ($Payload.source.predefinedTargetId -eq 'tpl-1')
            } -Times 1 -Exactly -Scope It
        }

        It 'nests the auth method fields' {
            $null = New-SAIMcpServer -name 'Other' -description 'd' -category DATABASES_AND_DATA_STORES -upstreamUrl 'https://u' `
                -authMethodType 'OAUTH2.1' -authorizationServer 'https://auth' -clientId 'cid'
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Payload = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                ($Payload.authMethod.type -eq 'OAUTH2.1') -and ($Payload.authMethod.clientId -eq 'cid')
            } -Times 1 -Exactly -Scope It
        }

        It 'decodes a supplied client secret into the body' {
            $null = New-SAIMcpServer -name 'Other' -description 'd' -category DATABASES_AND_DATA_STORES -upstreamUrl 'https://u' `
                -authMethodType 'OAUTH2.1' -clientId 'cid' -clientSecret (ConvertTo-SecureString 'sekrit' -AsPlainText -Force)
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).authMethod.clientSecret -eq 'sekrit'
            } -Times 1 -Exactly -Scope It
        }

        It 'throws when a client secret is supplied without a client id' {
            { New-SAIMcpServer -name 'x' -description 'd' -category DATABASES_AND_DATA_STORES -upstreamUrl 'https://u' `
                    -authMethodType 'OAUTH2.1' -clientSecret (ConvertTo-SecureString 's' -AsPlainText -Force) } |
                Should -Throw '*clientSecret cannot be provided without clientId*'
        }

        It 'throws when a registration endpoint is combined with a client id' {
            { New-SAIMcpServer -name 'x' -description 'd' -category DATABASES_AND_DATA_STORES -upstreamUrl 'https://u' `
                    -authMethodType 'OAUTH2.1' -clientId 'cid' -registrationEndpoint 'https://r' } |
                Should -Throw '*registrationEndpoint cannot be combined with clientId or clientSecret*'
        }

        It 'rejects an unsupported category' {
            { New-SAIMcpServer -name 'x' -description 'd' -category NOPE -upstreamUrl 'https://u' } | Should -Throw
        }

        It 'does not send a request when WhatIf is specified' {
            $null = New-SAIMcpServer -name 'NotCreated' -description 'd' -category DATABASES_AND_DATA_STORES -upstreamUrl 'https://u' -WhatIf
            Should -Invoke -CommandName Invoke-IDRestMethod -ModuleName $Script:SAIModuleName -ParameterFilter {
                $Body -and ([System.Text.Encoding]::UTF8.GetString($Body) -match 'NotCreated')
            } -Times 0 -Exactly -Scope It
        }
    }
    Context 'Response' {

        It 'provides output' {
            $Script:response | Should -Not -BeNullOrEmpty
        }

        It 'outputs the registered server' {
            $Script:response.id | Should -Be 'mcp-1'
        }
    }

}
