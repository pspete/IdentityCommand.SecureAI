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

Describe 'New-SAIAgentConditionDefinition' {

    Context 'Definition' {

        It 'defines an in condition on agent ids' {
            $Group = New-SAIAgentConditionDefinition -id 'a1', 'a2'
            $Group.conditions[0].op | Should -Be 'in'
            $Group.conditions[0].key | Should -Be 'id'
            $Group.conditions[0].value | Should -Be @('a1', 'a2')
        }

        It 'applies the expected custom type' {
            (New-SAIAgentConditionDefinition -id 'a1').PSObject.TypeNames |
                Should -Contain 'IdCmd.SecureAI.Definition.AgentCondition'
        }

        It 'defines an any condition with a null value' {
            $Group = New-SAIAgentConditionDefinition -Any
            $Group.conditions[0].op | Should -Be 'any'
            $Group.conditions[0].value | Should -BeNullOrEmpty
        }

        It 'holds exactly one condition per group' {
            (New-SAIAgentConditionDefinition -id 'a1', 'a2').conditions.Count | Should -Be 1
        }

        It 'adds a group to an existing definition' {
            $Groups = New-SAIAgentConditionDefinition -id 'a1'
            $Groups = New-SAIAgentConditionDefinition -id 'a2' -ConditionDefinition $Groups
            ($Groups | Measure-Object).Count | Should -Be 2
        }

        It 'does not accept an id alongside Any' {
            { New-SAIAgentConditionDefinition -id 'a1' -Any } | Should -Throw
        }

    }

}
