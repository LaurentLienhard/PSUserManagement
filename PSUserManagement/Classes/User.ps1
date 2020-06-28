enum FormatType {
    UPPERCASE
    LOWERCASE
    FIRSTUPPERCASE
}

class USER {
    [System.String]$FirstName
    [System.String]$LastName
    [System.String]$DisplayName
    [System.String]$SamAccountName
    [System.String]$Password

    #region <Constructor>
    user () {
    }

    USER ([System.String]$FirstName, [System.String]$LastName) {
        $This.FirstName = $this.FormatString($FirstName, "FIRSTUPPERCASE")
        $This.LastName = $this.FormatString($LastName, "UPPERCASE")
        $This.DisplayName = $this.LastName + " " + $this.FirstName
        $This.SamAccountName = $this.FirstName + "." + $this.LastName
    }
    #endregion <Constructor>

    #region <Method>
    [Boolean] IsAdUserExist ([System.String]$SamAccountName, [pscredential]$Credential, [system.string]$Server) {
        $GetParams = @{
            Identity   = $SamAccountName
            Credential = $Credential
            Server     = $Server
        }

        try {
            Get-ADUser @GetParams
            return $true
        }
        catch {
            Return $false
        }
    }

    [void] GeneratePassword ([System.Int32]$Length, [System.Int32]$NbNonAlphaNumeric) {
        $this.Password = [System.Web.Security.Membership]::GeneratePassword($Length, $NbNonAlphaNumeric)
    }

    [System.String] FormatString ([System.String]$Value, [FormatType]$Format) {
        switch ($Format) {
            "UPPERCASE" {
                $Value = ($This.RemoveStringLatinCharacter($Value).ToUpper())
            }
            "LOWERCASE" {
                $Value = ($This.RemoveStringLatinCharacter($Value).ToLower())
            }
            "FIRSTUPPERCASE" {
                $value = (Get-Culture).TextInfo.ToTitleCase(($This.RemoveStringLatinCharacter($Value)))
            }
        }

        $Value = $Value -replace " ", "-"

        return $Value
    }

    [System.String] RemoveStringLatinCharacter ([string]$String) {
        return ([Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($String)))
    }

    #endregion <Method>
}

class USERHM : USER {
    #region <Constructor>
    USERHM () {
    }

    USERHM ([System.String]$FirstName, [System.String]$LastName) : base ($FirstName, $LastName) {

        $This.SamAccountName = $this.LastName + " " + $this.FirstName
    }
    #endregion <Constructor>
}


