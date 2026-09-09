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

Describe 'Get-SAIApiHeader' {

    InModuleScope 'IdentityCommand.SecureAI' {

        Context 'Accept Header' {

            It 'returns the documented header for <Resource>' -ForEach @(
                @{ Resource = 'Agents'; Expected = 'application/x.agents.beta+json' }
                @{ Resource = 'Targets'; Expected = 'application/x.targets.beta+json' }
                @{ Resource = 'Policies'; Expected = 'application/x.policies.beta+json' }
            ) {
                Get-SAIApiHeader -Resource $Resource | Should -Be $Expected
            }

            It 'returns a string' {
                Get-SAIApiHeader -Resource Agents | Should -BeOfType [string]
            }

            It 'throws for a resource the service does not define' {
                { Get-SAIApiHeader -Resource Something } | Should -Throw
            }

        }

    }

}
