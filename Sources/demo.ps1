<#
    .SYNOPSIS
    Get the deployment logs.

    .DESCRIPTION
    Get the deployment logs from the deployment database.
    Can be filtered either by id or by environment.

    .PARAMETER DeploymentLogPath
    The path to the Json file containing the deployment logs

    .PARAMETER Identity
    The deployment's specific Id.

    .PARAMETER Environment
    The targeted environment... Kappa
#>
function global:Get-DeploymentLog {
    [CmdletBinding()]
    Param (
        [ValidateScript({$_ | Test-Path -PathType Leaf})]
        [Parameter(Mandatory)]
        [string]$DeploymentLogPath,

        [Parameter(ValueFromPipeline)]
        [string]$Identity,

        [ValidateSet("DEV", "QA", "PROD")]
        [string]$Environment
    )

    Write-Verbose "[Get-DeploymentLog]Entering function scope"

    Write-Verbose "Obtaining all the deployments"
    $data = Get-Content $DeploymentLogPath | ConvertFrom-Json

    if(![string]::IsNullOrEmpty($Identity)) {
        Write-Verbose "Identity parameter is specified, returning a collection of one"
        return $data.Logs | Where-Object { $_.Identity -eq $Identity }
    }

    if(![string]::IsNullOrEmpty($Environment)) {
        Write-Verbose "Environment parameter is specified, returning a collection of many"
        return $data.Logs | Where-Object { $_.Environment -eq $Environment }
    }

    Write-Verbose "No filters detected! returning ALL THE THINGS!"
    return $data.Logs
}