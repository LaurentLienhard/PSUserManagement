---
external help file: PSUserManagement-help.xml
Module Name: PSUserManagement
online version:
schema: 2.0.0
---

# Get-VHDXProfileSize

## SYNOPSIS
retrieve profile size

## SYNTAX

```
Get-VHDXProfileSize [[-GivenName] <String>] [[-SurName] <String>] [[-Company] <String>]
 [[-ProfilePath] <String>]
```

## DESCRIPTION
This function is used to retrieve the size of a user's vhdx file.
This vhdx file is the person's RDS profile

## EXAMPLES

### EXAMPLE 1
```
Get-VHDXProfileSize -GivenName "laurent" -SurName "lienhard" -ProfilePath "\\srv-profils01\upd$"
```

## PARAMETERS

### -Company
{{ Fill Company Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GivenName
User first name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfilePath
Path in which profiles are stored

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: \\srv-profils01\upd$
Accept pipeline input: False
Accept wildcard characters: False
```

### -SurName
User last name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES
General notes

## RELATED LINKS
