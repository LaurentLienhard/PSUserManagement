<#
.SYNOPSIS
retrieve profile size

.DESCRIPTION
This function is used to retrieve the size of a user's vhdx file.
This vhdx file is the person's RDS profile

.PARAMETER GivenName
User first name

.PARAMETER SurName
User last name

.PARAMETER ProfilePath
Path in which profiles are stored

.EXAMPLE
Get-VHDXProfileSize -GivenName "laurent" -SurName "lienhard" -ProfilePath "\\srv-profils01\upd$"

.NOTES
General notes
#>
function Get-VHDXProfileSize
{
    param (
        [System.String]$GivenName,
        [System.String]$SurName,
        [ValidateSet("Habitation Moderne", "Ophea", "GIP")]
        [System.String]$Company,
        [System.String]$ProfilePath = "\\srv-profils01\upd$"
    )

    if ($Company -eq "Habitation Moderne")
    {
        $User = [HMUSER]::new($GivenName, $SurName)
    }
    else
    {
        $User = [USER]::new($GivenName, $SurName)
    }

    $user.GetVHDXProfileSize($ProfilePath)
}