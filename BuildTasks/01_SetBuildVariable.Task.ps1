task SetBuildVariable {
    Write-Verbose "[SETBUILDVARIABLE][START]"

    #USE IN 02_Clean
    $script:OutputPath = $Env:BHBuildOutput
    Write-Verbose "[SETBUILDVARIABLE] Output Build path $($script:OutputPath)"

    #USE IN 03_BuildModule
    $script:CodeSourcePath = Join-Path $env:BHProjectPath -ChildPath "Sources"
    Write-Verbose "[SETBUILDVARIABLE] Code source path $($script:CodeSourcePath)"

    #USE IN 03_BuildModule
    $script:OutputModulePath = Join-Path $script:OutputPath -ChildPath $env:BHProjectName
    Write-Verbose "[SETBUILDVARIABLE] Output Module Build path $($script:OutputModulePath)"

    #USE IN 03_BuildModule
    $script:Author = "LIENHARD Laurent"
    Write-Verbose "[SETBUILDVARIABLE] Author $($script:Author)"

    #USE IN 03_BuildModule
    $Script:ModuleBuildPsm1 = Join-Path -path $script:OutputModulePath -ChildPath ($env:BHProjectName + ".psm1")
    Write-Verbose "[SETBUILDVARIABLE] Output path for module psm1 $($Script:ModuleBuildPsm1)"

    #USE IN 03_BuildModule, 04_BuilManifest
    $script:PublicEnums = Get-ChildItem -Path "$script:CodeSourcePath\Enums\" -Filter *.ps1 | Sort-Object Name
    $script:PublicClasses = Get-ChildItem -Path "$script:CodeSourcePath\Classes\" -Filter *.ps1 | Sort-Object Name
    $script:PrivateFunctions = Get-ChildItem -Path "$script:CodeSourcePath\Functions\Private" -Filter *.ps1 | Sort-Object Name
    $script:PublicFunctions = Get-ChildItem -Path "$script:CodeSourcePath\Functions\Public" -Filter *.ps1 | Sort-Object Name

    #USE IN 04_BuildManifest
    $Script:ModuleBuildManifest = Join-Path -path $script:OutputModulePath -ChildPath ($env:BHProjectName + ".psd1")
    Write-Verbose "[SETBUILDVARIABLE] Output path for module manifest $($Script:ModuleBuildManifest)"

    #USE IN 05_GenerateMarkdown
    $Script:DocsPath = Join-Path -path $env:BHProjectPath -ChildPath "Docs"
    Write-Verbose "[SETBUILDVARIABLE] Output path for documentation $($Script:DocsPath)"

    #USE IN 08_UnitTests
    $Script:ResultUnitTestFile = $script:OutputPath + "\UnitTestsResult.xml"
    Write-Verbose "  TestFile $($Script:ResultUnitTestFile)" -Verbose

    Write-Verbose "[SETBUILDVARIABLE][END]"
}
