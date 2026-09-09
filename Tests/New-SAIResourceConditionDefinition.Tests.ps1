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

Describe 'New-SAIResourceConditionDefinition' {

    Context 'Definition' {

        It 'defines a glob match on the resource id' {
            $Group = New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
            $Group.conditions[0].op | Should -Be 'match'
            $Group.conditions[0].key | Should -Be 'id'
            $Group.conditions[0].value | Should -Be 'mcp:reporting:*'
        }

        It 'defines a glob match on the resource tag' {
            $Group = New-SAIResourceConditionDefinition -matchTag 'production*'
            $Group.conditions[0].op | Should -Be 'match'
            $Group.conditions[0].key | Should -Be 'tag'
        }

        It 'applies the expected custom type' {
            (New-SAIResourceConditionDefinition -matchId 'a').PSObject.TypeNames |
                Should -Contain 'IdCmd.SecureAI.Definition.ResourceCondition'
        }

        It 'defines an in condition on resource ids' {
            $Group = New-SAIResourceConditionDefinition -id 'mcp:a:b', 'mcp:a:c'
            $Group.conditions[0].op | Should -Be 'in'
            $Group.conditions[0].value.Count | Should -Be 2
        }

        It 'defines an in condition on resource tags' {
            (New-SAIResourceConditionDefinition -tag 'production').conditions[0].key | Should -Be 'tag'
        }

        It 'adds a group to an existing definition' {
            $Groups = New-SAIResourceConditionDefinition -matchId 'mcp:reporting:*'
            $Groups = New-SAIResourceConditionDefinition -matchId 'mcp:analytics:*' -ConditionDefinition $Groups
            ($Groups | Measure-Object).Count | Should -Be 2
        }

        It 'does not accept a match alongside an in condition' {
            { New-SAIResourceConditionDefinition -matchId 'a' -id 'b' } | Should -Throw
        }

    }

}
