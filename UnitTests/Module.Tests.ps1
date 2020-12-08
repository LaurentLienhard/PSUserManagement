Describe 'Module' {
    Context 'Manifest' {
        $script:manifest = $null

        It 'has a valid manifest' {
            {
                $script:manifest = Test-ModuleManifest -Path  ($env:BHBuildOutput + "\" + $env:BHProjectName + "\" + $env:BHProjectName + ".psd1") -ErrorAction Stop -WarningAction SilentlyContinue
            } | Should Not throw
        }

        It 'has a valid name in the manifest' {
            $script:manifest.Name | Should Be $env:BHProjectName
        }

        It 'has a valid root module' {
            $RootModule = ".\" + $env:BHProjectName + ".psm1"
            $script:manifest.RootModule | Should Be ($RootModule)
        }

        It 'has a valid version in the manifest' {
            $script:manifest.Version -as [Version] | Should Not BeNullOrEmpty
        }

        It 'has a valid description' {
            $script:manifest.Description | Should Not BeNullOrEmpty
        }

        It 'has a valid author' {
            $script:manifest.Author | Should Not BeNullOrEmpty
        }

        It 'has a valid guid' {
            {
                [guid]::Parse($script:manifest.Guid)
            } | Should Not throw
        }

        It 'has a valid copyright' {
            $script:manifest.CopyRight | Should Not BeNullOrEmpty
        }
    }
}

