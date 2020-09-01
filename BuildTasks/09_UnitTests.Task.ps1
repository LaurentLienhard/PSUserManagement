task UnitTests {
    Write-Verbose "[UNITTESTS][START]"
    $params = @{
        Script       = $env:BHProjectPath + "\UnitTests"
        OutputFile   = $Script:ResultUnitTestFile
        OutputFormat = 'NUnitXml'
        PassThru     = $true
        Show         = 'Failed', 'Fails', 'Summary'
    }

    $results = Invoke-Pester @params
    if ($results.FailedCount -gt 0) {
        Write-Error -Message "Failed [$($results.FailedCount)] Pester tests."
    }
    Write-Verbose "[UNITTESTS][END]"
}
