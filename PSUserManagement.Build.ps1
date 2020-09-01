Write-Verbose "[INVOKEBUILMODULE][START]"
Write-Verbose "[INVOKEBUILMODULE] Import common tasks ..."
Get-ChildItem -Path $env:BHProjectPath\BuildTasks\*.Task.ps1 | ForEach-Object {
    Write-Verbose "[INVOKEBUILMODULE] Importing $($_.FullName)"
    . $_.FullName
}

task Default SetBuildVariable, Clean, BuildModule, BuildManifest, Analyze, UnitTests, GenerateMarkdown, GenerateHelp
task Build SetBuildVariable, Clean, BuildModule, BuildManifest
task PSAnalyse SetBuildVariable, Analyze
task Test SetBuildVariable, build, ImportModule, UnitTests
task Helpify SetBuildVariable, ImportModule, GenerateMarkdown, GenerateHelp

Write-Verbose "[INVOKEBUILMODULE][END]"
