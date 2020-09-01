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
            $objUser = New-Object System.Security.Principal.NTAccount($This.Domain, $This.SamAccountName)
            $This.UID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
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
        $array[-1] = $array[-1].ToUpper()
        $array += $numbers | Get-Random -Count $NumberOfNumbers
        $array += $specialCharacters.Split(',') | Get-Random -Count $NumberOfSpecialCharacters
        $This.Password = ($array | Get-Random -Count $array.Count) -join ""
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