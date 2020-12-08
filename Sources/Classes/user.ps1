enum FormatType
{
    UPPERCASE
    LOWERCASE
    FIRSTUPPERCASE
}

class USER
{
    [System.String]$GivenName
    [System.String]$SurName
    [System.String]$SamAccountName
    [System.String]$DisplayName
    [System.String]$Domain
    [System.String]$Password
    [System.String]$UID
    [System.String]$UPN
    [System.String]$VHDXFullPath

    USER([System.String]$GivenName, [System.String]$SurName)
    {
        $This.GivenName = $this.FormatString($GivenName, "FIRSTUPPERCASE")
        $This.SurName = $this.FormatString($SurName, "UPPERCASE")
        $this.SamAccountName = $this.GivenName + "." + $this.SurName
        $This.DisplayName = $this.SurName + " " + $this.GivenName

        try
        {
            if ((Get-ADDomain).DNSRoot)
            {
                $This.Domain = (Get-ADDomain).DNSRoot
            }
        }
        catch
        {
            $This.Domain = "NoDomain.Found"
        }
    }

    [void] ConvertUser2UID ()
    {
        if ($This.Domain -eq "NoDomain.Found")
        {
            Write-Warning "You must be in an Active Directory domain to convert a user to UID"
        }
        else
        {
            if ($This.IsAdUserExist())
            {
                $objUser = New-Object System.Security.Principal.NTAccount($This.Domain, $This.SamAccountName)
                $This.UID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
            }
            else
            {
                Write-Warning "The user $($this.SamAccountName) does not exist in the Active Directory"
            }

        }

    }


    [void] GetUpn ()
    {
        if ($This.IsAdUserExist())
        {
            $This.UPN = (get-AdUser -Identity $This.SamAccountName -Properties UserPrincipalName | Select-Object -ExpandProperty UserPrincipalName).Split("@")[1]
        }
    }

    [Double] GetVHDXProfileSize ([System.String]$Path)
    {
        $This.SetVHDXFullPath($Path)
        return (Get-Item $This.VHDXFullPath).length / 1GB


    }

    [void] CleanVHDXProfile ([System.String]$Path)
    {
        $This.SetVHDXFullPath($Path)

        $DriveLetter = (Mount-VHD -Path $This.VHDXFullPath -PassThru | Get-Disk | Get-Partition | Get-Volume).DriveLetter
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\cache\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\cache\*.*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\cache2\entries\*.*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\thumbnails\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\cookies.sqlite") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\webappsstore.sqlite") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Mozilla\Firefox\Profiles\*.default*\chromeappsstore.sqlite") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Google\Chrome\User Data\Default\Cache\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Google\Chrome\User Data\Default\Cache2\entries\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Google\Chrome\User Data\Default\Cookies") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Google\Chrome\User Data\Default\Media Cache") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Google\Chrome\User Data\Default\Cookies-Journal") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Microsoft\Windows\Temporary Internet Files\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Microsoft\Windows\WER\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Temp\*") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

        Remove-Item -Path ($DriveLetter + ":\AppData\Local\GoToMeeting") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue


        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\blob_storage") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\databases") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\databases") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\cache") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\gpucache") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\application cache\cache") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\Indexeddb") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\Local Storage") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\teams\tmp") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Roaming\Microsoft\Teams\Service Worker\CacheStorage") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -Path ($DriveLetter + ":\AppData\Local\Microsoft\Teams\previous") -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

        Dismount-VHD -Path $this.VHDXFullPath
    }

    [void] SetVHDXFullPath ([System.String]$Path)
    {
        if (!(Test-Path -Path $Path))
        {
            Write-Warning "The path passed in parameter cannot be found"
            Break
        }

        if (!($This.UID))
        {
            $this.ConvertUser2UID()
        }

        $VHDXFileName = "UVHD-" + $this.UID + ".vhdx"
        if (Get-ChildItem -Path $Path -Include $VHDXFileName)
        {
            $this.VHDXFullPath = (Join-Path -Path $Path -ChildPath $VHDXFileName)
        }
        else
        {
            Write-Warning "The profile file is not in the directory"
        }
    }

    [Void] GeneratePassword ([Int]$NumberOfAlphabets, [Int]$NumberOfNumbers, [Int]$NumberOfSpecialCharacters)
    {
        if ($NumberOfAlphabets -eq 0)
        {
            Write-Warning "The password cannot contain 0 alphabetic characters. The value is changed to 8 by default"
            $NumberOfAlphabets = 8
        }

        if ($NumberOfNumbers -eq 0)
        {
            Write-Warning "The password cannot contain 0 numeric characters. The value is changed to 1 by default"
            $NumberOfNumbers = 1
        }

        if ($NumberOfSpecialCharacters -eq 0)
        {
            Write-Warning "The password cannot contain 0 special characters. The value is changed to 1 by default"
            $NumberOfSpecialCharacters = 1
        }

        $Alphabets = 'a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z'
        $numbers = 0..9
        $specialCharacters = '!,@,#,$,%,&,(,),>,<,?,\,/,_'
        $array = @()
        $array += $Alphabets.Split(',') | Get-Random -Count $NumberOfAlphabets
        $array[0] = $array[0].ToUpper()
        $array[ - 1] = $array[ - 1].ToUpper()
        $array += $numbers | Get-Random -Count $NumberOfNumbers
        $array += $specialCharacters.Split(',') | Get-Random -Count $NumberOfSpecialCharacters
        $This.Password = ($array | Get-Random -Count $array.Count) -join ""
    }

    [Boolean] IsAdUserExist ()
    {
        $GetParams = @{
            Identity = $This.SamAccountName
        }

        try
        {
            Get-ADUser @GetParams
            Write-verbose "[CLASS USER][ISADUSEREXIST] User $($this.SamAccountName) found in Active Directory "
            return $true
        }
        catch
        {
            Write-Warning "[CLASS USER][ISADUSEREXIST] User $($this.Samaccountname) not found in Active Directory "
            Return $false
        }
    }

    [System.String] FormatString ([System.String]$Value, [FormatType]$Format)
    {
        switch ($Format)
        {
            "UPPERCASE"
            {
                $Value = ($This.RemoveStringLatinCharacter($Value).ToUpper())
            }
            "LOWERCASE"
            {
                $Value = ($This.RemoveStringLatinCharacter($Value).ToLower())
            }
            "FIRSTUPPERCASE"
            {
                $value = (Get-Culture).TextInfo.ToTitleCase(($This.RemoveStringLatinCharacter($Value)))
            }
        }

        $Value = $Value -replace " ", "-"

        return $Value
    }

    [System.String] RemoveStringLatinCharacter ([string]$String)
    {
        return ([Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String)))
    }
}

class HMUSER : USER
{
    HMUSER ()
    {

    }

    HMUSER ([System.String]$GivenName, [System.String]$SurName) : base ($GivenName, $SurName)
    {
        $this.SamAccountName = $this.SurName + " " + $this.GivenName
    }
}
