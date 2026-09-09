#The completer helper functions live in IdentityCommand's Private folder, which the psm1 loads
#into this module's scope.

#region Registration

Register-ArgumentCompleter -ParameterName 'agentId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIAgent' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIAgent'
    'Remove-SAIAgent'
    'Set-SAIAgent'
    'Set-SAIAgentState'
)

Register-ArgumentCompleter -ParameterName 'mcpServerId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIMcpServer'
    'Remove-SAIMcpServer'
    'Set-SAIMcpServer'
    'Set-SAIMcpServerState'
)

#The predefined catalog is the source of the template id a registration is created from
Register-ArgumentCompleter -ParameterName 'predefinedTargetId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPredefinedMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName 'New-SAIMcpServer'

Register-ArgumentCompleter -ParameterName 'templateId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPredefinedMcpServer' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName 'Get-SAIPredefinedMcpServer'

Register-ArgumentCompleter -ParameterName 'policyId' -ScriptBlock (
    Get-ArgumentCompleter -RetrievalCommand 'Get-SAIPolicy' -ValueProperty 'id' -LabelProperty 'name'
) -CommandName @(
    'Get-SAIPolicy'
    'Remove-SAIPolicy'
    'Set-SAIPolicy'
    'Set-SAIPolicyState'
)

#endregion Registration
