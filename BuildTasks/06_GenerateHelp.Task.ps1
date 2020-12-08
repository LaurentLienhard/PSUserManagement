task GenerateHelp {
    Write-Verbose "[GENERATEHELP][START]"
    if (-not(Get-ChildItem -Path $Script:DocsPath -Filter '*.md' -Recurse -ErrorAction 'Ignore')) {
        Write-Verbose "[GENERATEHELP] No Markdown help files to process. Skipping help file generation..."
        return
    }

    $params = @{
        Force      = $true
        OutputPath = "$script:OutputModulePath\en-US"
        Path       = "$Script:DocsPath\en-US"
    }

    # Generate the module's primary MAML help file.
    Write-Verbose "[GENERATEHELP] Creating new External help for $($env:BHProjectName)..."
    $null = New-ExternalHelp @params

    Write-Verbose "[GENERATEHELP][END]"
}
