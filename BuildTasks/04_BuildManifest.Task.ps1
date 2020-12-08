task BuildManifest {
    Write-Verbose "[BUILDMANIDEST][START]"

    Write-Verbose "[BUILDMANIFEST] Adding functions to export..."
    $FunctionsToExport = $Script:PublicFunctions.BaseName

    Copy-Item -Path (Get-PSModuleManifest) -Destination $Script:ModuleBuildManifest

    if ($FunctionsToExport -ne $null) {
        Update-ModuleManifest -Path $Script:ModuleBuildManifest -FunctionsToExport $FunctionsToExport
    }
    Write-Verbose "[BUILDMANIDEST][END]"
}
