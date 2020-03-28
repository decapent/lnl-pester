<#
    Demo Part 1
    PowerShell Tips n tricks (20 mins)
        •	Naming Convention – Verb-Noun Syntax
        •	Comment Based Help – Pourquoi, pour qui ?
        •	CmdletBinding – Qu’est-ce que ça change ?
        •	Validations des intrants
            o	Parameter Attributes
            o	Validate Set
            o	Validate Script
#>

Get-Verb | Select-Object Verb, Group, Description

<#
    Demo Part 2
    Introduction aux tests unitaires avec Pester (30 mins)
        •	Anatomie d’une suite de test Pester
            o	Describe, Context, It  
            o	Setup and Teardown hooks
            o	TestDrive    
        •	Assertions
        •	Metriques
        •	AzureDevOps Pipeline
#>

<#
    Sanity check INSTALL TOOLING FOR GATHERING METRICS
#>
Install-Module -Name Pester -Scope CurrentUser -Force -AllowClobber
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -AllowClobber

<#
    Metric #1. BROKEN TESTS
#>
Invoke-Pester ".\Tests\demo.tests.ps1" `
    -OutputFormat NUnitXml `
    -OutputFile ".\Tests\logs\Test-Pester.XML"

<#
    Metric #2. CODE COVERAGE
#>
Invoke-Pester ".\Tests\demo.tests.ps1" `
    -OutputFormat NUnitXml `
    -OutputFile ".\Tests\logs\Test-Pester.XML" `
    -CodeCoverage @('.\Sources\demo.ps1') `
    -CodeCoverageOutputFile ".\Tests\logs\Coverage-Pester.xml"

<#
    Metric #3. CODE ANALYSIS
#>
Invoke-ScriptAnalyzer '.\Sources\'
Invoke-ScriptAnalyzer '.\Sources\' -ExcludeRule "PSAvoidTrailingWhitespace"
Get-ScriptAnalyzerRule 
