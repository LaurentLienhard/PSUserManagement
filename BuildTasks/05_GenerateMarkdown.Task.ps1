task GenerateMarkdown {
    Write-Verbose "[GENERATEMARKDOWN][START]"
    $module = Import-Module -FullyQualifiedName $Script:ModuleBuildManifest -Force -PassThru

    try {
        if ($module.ExportedFunctions.Count -eq 0) {
            Write-Verbose "[GENERATEMARKDOWN] No functions have been exported for this module. Skipping Markdown generation..."
            return
        }

        $params = @{
            AlphabeticParamsOrder = $true
            ErrorAction           = 'SilentlyContinue'
            Locale                = 'en-US'
            Module                = $env:BHProjectName
            OutputFolder          = "$Script:DocsPath\en-US"
            WithModulePage        = $true
        }

        # ErrorAction is set to SilentlyContinue so this
        # command will not overwrite an existing Markdown file.
        Write-Verbose "[GENERATEMARKDOWN] Creating new Markdown help for $($env:BHProjectName)..."
        $null = New-MarkdownHelp @params
    } finally {
        Remove-Module -Name $env:BHProjectName -Force
    }

    Write-Verbose "[GENERATEMARKDOWN][END]"
}
