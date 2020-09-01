[CmdletBinding()]
param(
    [parameter(Position = 0)]
    $Task = 'Default',
    # Bootstrap dependencies
    [switch]$Bootstrap
)

Clear-Host
Write-Verbose "[BUILD][START]"

# Bootstrap dependencies
if ($Bootstrap.IsPresent)
{
    Write-Verbose "[BUILD] Installing module dependencies..."
    Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    if ((Test-Path -Path ./requirements.psd1))
    {
        if (-not (Get-Module -Name PSDepend -ListAvailable))
        {
            Install-Module -Name PSDepend -Repository PSGallery -Scope CurrentUser -Force
        }
        Import-Module -Name PSDepend -Verbose:$false
        Invoke-PSDepend -Path './requirements.psd1' -Install -Force -WarningAction SilentlyContinue
    }
    else
    {
        Write-Warning "No [requirements.psd1] found. Skipping build dependency installation."
    }
}

Write-Verbose "[BUILD] Build Environement variable..."
if (!(Get-ChildItem Env:BH*))
{
    Write-Verbose "[BUILD] Set Build Environement variable..."
    Set-BuildEnvironment
}
else
{
    Write-Verbose "[BUILD] Build Environement variable already set.."
}

$Script:ModuleBuildFilePath = $env:BHModulePath + "\" + $env:BHProjectName + ".Build.ps1"


Write-Verbose "[BUILD] Invoking build action [$($Task)]"
$Error.Clear()
Invoke-Build -Task $Task -File $Script:ModuleBuildFilePath -Result 'Result'
if ($Result.Error)
{
    $Error[-1].ScriptStackTrace | Out-String
    Write-Verbose "[BUILD][END] With Error"
    exit 1
}

Write-Verbose "[BUILD][END] with no error"
exit 0
