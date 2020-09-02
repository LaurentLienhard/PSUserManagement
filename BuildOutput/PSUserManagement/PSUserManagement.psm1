#Generated at 09/02/2020 10:42:49 by LIENHARD Laurent
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

    [Double] GetVHDXProfileSize ([System.String]$Path)
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
            $VHDXFullPath = (Join-Path -Path $Path -ChildPath $VHDXFileName)
            return (Get-Item $VHDXFullPath).length / 1GB
        }
        else
        {
            Write-Warning "The profile file is not in the directory"
            return 0
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
            return $true
        }
        catch
        {
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
