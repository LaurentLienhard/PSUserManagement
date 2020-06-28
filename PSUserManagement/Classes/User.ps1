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

    #region <Constructor>
    user () {
    }

    USER ([System.String]$FirstName, [System.String]$LastName) {
        $This.FirstName = $this.FormatString($FirstName, "FIRSTUPPERCASE")
        $This.LastName = $this.FormatString($LastName, "UPPERCASE")
        $This.DisplayName = $This.LastName + " " + $This.FirstName
        $This.SamAccountName = $this.FirstName + "." + $this.LastName
    }
    #endregion <Constructor>

    #region <Method>
    [Boolean] IsAdUserExist ([pscredential]$Credential, [system.string]$Server) {
        $GetParams = @{
            Identity   = $This.SamAccountName
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


