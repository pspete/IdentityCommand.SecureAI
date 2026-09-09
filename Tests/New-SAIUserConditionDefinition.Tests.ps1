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

Describe 'New-SAIUserConditionDefinition' {

    Context 'Definition' {

        It 'defines an in condition on user ids' {
            $Group = New-SAIUserConditionDefinition -id 'u1'
            $Group.conditions[0].key | Should -Be 'id'
        }

        It 'defines an in condition on role ids' {
            $Group = New-SAIUserConditionDefinition -roleId 'finance-analysts'
            $Group.conditions[0].key | Should -Be 'roleId'
            $Group.conditions[0].value | Should -Be @('finance-analysts')
        }

        It 'applies the expected custom type' {
            (New-SAIUserConditionDefinition -id 'u1').PSObject.TypeNames |
                Should -Contain 'IdCmd.SecureAI.Definition.UserCondition'
        }

        It 'defines an any condition' {
            (New-SAIUserConditionDefinition -Any).conditions[0].op | Should -Be 'any'
        }

        It 'adds a group to an existing definition' {
            $Groups = New-SAIUserConditionDefinition -roleId 'r1'
            $Groups = New-SAIUserConditionDefinition -id 'u1' -ConditionDefinition $Groups
            ($Groups | Measure-Object).Count | Should -Be 2
        }

        It 'does not accept an id alongside a role id' {
            { New-SAIUserConditionDefinition -id 'u1' -roleId 'r1' } | Should -Throw
        }

    }

}
