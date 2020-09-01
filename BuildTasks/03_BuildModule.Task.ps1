task BuildModule {
    Write-Verbose "[BUILDMODULE][START]"
    Write-Verbose "[BUILD] Creating output path for $($env:BHProjectName)"
    New-Item -Path $script:OutputModulePath -ItemType Directory -Force | Out-Null

    Write-Verbose "[BUILD] Loading all sources files"

    $MainPSM1Contents = @()
    $MainPSM1Contents += $script:PublicEnums
    $MainPSM1Contents += $script:PublicClasses
    $MainPSM1Contents += $script:PrivateFunctions
    $MainPSM1Contents += $script:PublicFunctions

    Write-Verbose "[BUILDMODULE] building main psm1"
    $Date = Get-Date
    "#Generated at $($Date) by $($script:Author)" | Out-File -FilePath $Script:ModuleBuildPsm1 -Encoding utf8 -Append
    Foreach ($file in $MainPSM1Contents)
    {
        Get-Content $File.FullName | Out-File -FilePath $Script:ModuleBuildPsm1 -Encoding utf8 -Append
    }

    if (Test-Path -Path "$CodeSourcePath\Ressources")
    {
        Write-Output "[BUILDMODULE] Add ressources to Module "
        $RessourcesList = Get-ChildItem -Path $CodeSourcePath\Ressources

        foreach ($ressources in $RessourcesList)
        {
            $RessourcesPath = $CodeSourcePath + "\Ressources\" + $ressources.Name
            $DestinationPath = $script:OutputModulePath + "\Ressources\" + $ressources.Name
            Copy-Item -Path $RessourcesPath -Destination $DestinationPath -Force -Recurse -Confirm:$false
        }
        Write-Output "[BUILDMODULE] All ressources add to Module "
    }



    Write-Verbose "[BUILDMODULE][END]"
}
