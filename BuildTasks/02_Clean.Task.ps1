task Clean {
    Write-Verbose "[CLEAN][START]"
    Write-Verbose "[CLEAN] test if output build directory already exist..."
    if (Test-Path -Path $script:OutputPath)
    {
        Write-Verbose "[CLEAN] Pre-build module find => Suppress"
        Remove-Item -Path $script:OutputPath -force -recurse -confirm:$false
    }
    else
    {
        Write-Verbose "[CLEAN] Nothing to do..."
    }
    Write-Verbose "[CLEAN][END]"
}
