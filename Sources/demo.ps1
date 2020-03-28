<#
    .SYNOPSIS
    Get the deployment logs.

    .DESCRIPTION
    Get the deployment logs from the deployment database.
    Can be filtered either by id or by environment.

    .PARAMETER DeploymentPath
    The path to the Json file containing the deployment logs

    .PARAMETER Identity
    The deployment's specific Id. Stored as a GUID

    .PARAMETER Environment
    The targeted environment... Kappa
#>
function global:Get-DeploymentLog {
    [CmdletBinding()]
    Param (
        [ValidateScript({$_ | Test-Path -PathType Leaf})]
        [Parameter(Mandatory)]
        [string]$DeploymentLogsPath,

        [ValidateScript({
            try {
                [System.Guid]::Parse($_) | Out-Null
                $true
            } catch {
                $false
            }
        })]
        [Parameter(ValueFromPipeline)]
        [string]$Identity,

        [ValidateSet("DEV", "QA", "PROD")]
        [string]$Environment
    )

    Write-Verbose "[Get-DeploymentLog]Entering function scope"

    # Get un json avec le model
    $models = Get-Content $DeploymentLogsPath | ConvertFrom-Json

    if(![string]::IsNullOrEmpty($Identity)) {
        # return specific model
    }

    if(![string]::IsNullOrEmpty($Environment)) {
        # return filtered models
    }

    return $models
}