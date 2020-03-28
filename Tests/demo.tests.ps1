Describe ": Given the Demo tools" {
    BeforeAll {
        # Positioning ourselves at the script level
        Push-Location $PSScriptRoot

        # Source demo tools function
        . $(Resolve-Path "..\Sources\demo.ps1")

        # Copying Test data to Test Drive        
        $testData = Resolve-Path ".\Test Data"
        Get-ChildItem $testData -Recurse | Copy-Item -Destination $TestDrive
        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }

    Context "-> When obtaining the deployment logs from the database" {
        BeforeAll {
            # Setting tests context
            $invalidPath = ".\wontresolve\kappa.json"
            $directoryPath = $TestDrive
            $validPath = ".\demo.json"
            
            $unresolvedIdentity = "ABCD"
            
            $invalidEnvironment = "BANANA"
            $validEnvironment = "QA"
        }

        It "Throws if the path to the logs is not a file (directory specified)" {
            { Get-DeploymentLog `
                -DeploymentLogPath $directoryPath `
                -Identity $unresolvedIdentity `
                -Environment $validEnvironment } | Should -Throw
        }

        It "Throws if the path to the logs is invalid (the path does not resolves to anything)" {
            { Get-DeploymentLog `
                -DeploymentLogPath $invalidPath `
                -Identity $unresolvedIdentity `
                -Environment $validEnvironment } | Should -Throw
        }

        It "Throws if the specified Environment is not part of the accepted set" {
            { Get-DeploymentLog `
                -DeploymentLogPath $directoryPath `
                -Identity $unresolvedIdentity `
                -Environment $invalidEnvironment } | Should -Throw
        }

        It "Fetches all the deployment logs if not filters are specified" {
            # Arrange

            # Act
            $logs = Get-DeploymentLog -DeploymentLogPath $validPath

            # Assert
            $logs | Should -Not -Be $null
            $logs.Count | Should -BeGreaterThan 0
        }

        It "Fetches no deployment log for an unresolved Identity" {
            # Arrange

            # Act
            $logs = Get-DeploymentLog -DeploymentLogPath $validPath -Identity $unresolvedIdentity

            # Assert
            $logs.Count | Should -Be 0
        }

        It "Fetches a specific deployment for a valid Identity specified from the pipeline" {
            # Arrange
            $validLog = Get-DeploymentLog -DeploymentLogPath $validPath | Select-Object -First 1

            # Act
            $logs = $validLog.Identity | Get-DeploymentLog -DeploymentLogPath $validPath

            # Assert
            $logs.Count | Should -Be 1
            $logs[0].Identity | Should -Be $validLog.Identity
        }

        It "Fetches a filtered subset of deployment for a valid Environment" {
            # Arrange
            $allLogs = Get-DeploymentLog -DeploymentLogPath $validPath

            # Act
            $filteredLogs = Get-DeploymentLog -DeploymentLogPath $validPath -Environment $validEnvironment

            # Assert
            $filteredLogs.Count | Should -BeGreaterThan 0
            $filteredLogs.Count | Should -BeLessOrEqual $allLogs.Count
        }
    }
}