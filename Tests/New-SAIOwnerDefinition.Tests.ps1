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

Describe 'New-SAIOwnerDefinition' {

    Context 'Definition' {

        It 'defines a user owner' {
            $Owner = New-SAIOwnerDefinition -id 'u1' -name 'user@example' -type USER -sourceDirectoryName 'Some Directory' -sourceDirectoryId 'd1'
            $Owner.id | Should -Be 'u1'
            $Owner.type | Should -Be 'USER'
        }

        It 'applies the expected custom type' {
            (New-SAIOwnerDefinition -id 'r1' -name 'Platform Admins' -type ROLE).PSObject.TypeNames |
                Should -Contain 'IdCmd.SecureAI.Definition.Owner'
        }

        It 'allows a role without a source directory' {
            { New-SAIOwnerDefinition -id 'r1' -name 'Platform Admins' -type ROLE } | Should -Not -Throw
        }

        It 'requires a source directory for a user' {
            { New-SAIOwnerDefinition -id 'u1' -name 'n' -type USER } | Should -Throw '*sourceDirectoryName and sourceDirectoryId are required*'
        }

        It 'adds an owner to an existing definition' {
            $Owners = New-SAIOwnerDefinition -id 'r1' -name 'n1' -type ROLE
            $Owners = New-SAIOwnerDefinition -id 'r2' -name 'n2' -type ROLE -OwnerDefinition $Owners
            ($Owners | Measure-Object).Count | Should -Be 2
        }

    }

}
