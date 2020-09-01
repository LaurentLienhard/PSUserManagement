task Analyze {
    Write-Verbose "[ANALYSE][START]"
    $params = @{
        IncludeDefaultRules = $true
        Path                = $Script:ModuleBuildPsm1
        Settings            = "$env:BHModulePath\.vscode\PSScriptAnalyzerSettings.psd1"
        Severity            = 'Warning'
    }

    Write-Verbose "[ANALYSE] Analyzing $($Script:ModuleBuildPsm1)..."
    $results = Invoke-ScriptAnalyzer @params
    if ($results) {
        'One or more PSScriptAnalyzer errors/warnings were found.'
        'Please investigate or add the required SuppressMessage attribute.'
        $results | Format-Table -AutoSize
    }

    Write-Verbose "[ANALYSE][END]"
}
