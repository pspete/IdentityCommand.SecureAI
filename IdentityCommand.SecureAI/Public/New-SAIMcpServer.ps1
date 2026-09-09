# .ExternalHelp IdentityCommand.SecureAI-help.xml
function New-SAIMcpServer {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Custom')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Custom'
        )]
        [ValidateLength(1, 256)]
        [String]$name,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Custom'
        )]
        [ValidateLength(1, 500)]
        [String]$description,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Custom'
        )]
        [ValidateSet('COMMUNICATION_AND_TEAM_CHAT', 'EMAIL_AND_SCHEDULING', 'KNOWLEDGE_BASES_AND_DOCS',
            'FILE_STORAGE_AND_CONTENT_REPOS', 'DEVELOPER_TOOLS_AND_SOURCE_CONTROL', 'DATABASES_AND_DATA_STORES',
            'OBSERVABILITY_MONITORING_AND_TELEMETRY', 'ITSM_AND_INCIDENT_RESPONSE', 'WEB_AND_BROWSER_AUTOMATION',
            'CLOUD_AND_INFRASTRUCTURE_OPERATIONS')]
        [String]$category,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Custom'
        )]
        [ValidateLength(1, 2048)]
        [String]$upstreamUrl,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Predefined'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$predefinedTargetId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Predefined'
        )]
        [ValidateLength(1, 500)]
        [Alias('predefinedDescription')]
        [String]$templateDescription,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateSet('OAUTH2.1', 'NONE')]
        [String]$authMethodType,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$authorizationServer,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$JWKS,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateLength(1, 512)]
        [String]$clientId,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [securestring]$clientSecret,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$registrationEndpoint,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [psobject[]]$owners,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$tags
    )

    begin { }#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/api/targets/mcp-servers"

        if ($PSBoundParameters.ContainsKey('clientSecret') -and (-not $PSBoundParameters.ContainsKey('clientId'))) {
            throw 'clientSecret cannot be provided without clientId'
        }

        if ($PSBoundParameters.ContainsKey('registrationEndpoint') -and
            ($PSBoundParameters.ContainsKey('clientId') -or $PSBoundParameters.ContainsKey('clientSecret'))) {
            throw 'registrationEndpoint cannot be combined with clientId or clientSecret - supply manual credentials or a registration endpoint for dynamic client registration, not both'
        }

        $Target = [ordered]@{ }

        if ($PSCmdlet.ParameterSetName -eq 'Predefined') {

            $Target['source'] = [ordered]@{ type = 'PREDEFINED'; predefinedTargetId = $predefinedTargetId }

            if ($PSBoundParameters.ContainsKey('templateDescription')) {
                $Target['description'] = $templateDescription
            }

        } else {

            $Target['source'] = [ordered]@{ type = 'CUSTOM' }
            $Target['name'] = $name
            $Target['description'] = $description
            $Target['category'] = $category
            $Target['upstream'] = [ordered]@{ url = $upstreamUrl }

        }

        if ($PSBoundParameters.ContainsKey('authMethodType')) {

            $AuthMethod = [ordered]@{ type = $authMethodType }

            foreach ($Field in 'authorizationServer', 'JWKS', 'clientId', 'registrationEndpoint') {
                if ($PSBoundParameters.ContainsKey($Field)) {
                    $AuthMethod[$Field] = $PSBoundParameters[$Field]
                }
            }

            if ($PSBoundParameters.ContainsKey('clientSecret')) {
                $AuthMethod['clientSecret'] = $(ConvertTo-InsecureString -SecureString $clientSecret)
            }

            $Target['authMethod'] = $AuthMethod

        }

        foreach ($Field in 'owners', 'tags') {
            if ($PSBoundParameters.ContainsKey($Field)) {
                $Target[$Field] = $PSBoundParameters[$Field]
            }
        }

        #The body can carry an OAuth client secret, so it travels as UTF8 bytes
        $body = $Target | ConvertTo-SecretBody -Depth 8

        if ($PSCmdlet.ShouldProcess($(if ($PSCmdlet.ParameterSetName -eq 'Predefined') { $predefinedTargetId } else { $name }), 'Register MCP Server')) {

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST -Body $body -Accept $(Get-SAIApiHeader -Resource Targets)

        }

    }#process

    end { }#end

}
