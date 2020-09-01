@{
    PSDependOptions  = @{
        Target     = 'CurrentUser'
        Parameters = @{
            Force = $True
        }
    }

    Pester           = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
    InvokeBuild      = 'latest'
    BuildHelpers     = 'latest'
    PlatyPS          = 'latest'
    PSDeploy         = 'latest'
    PSScriptAnalyzer = 'latest'
}
