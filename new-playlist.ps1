<#
.SYNOPSIS
    This script tries to create a playlist (.lpl) file for your ROMs in a given path.

.DESCRIPTION
    Providing the RetroArch and ROM paths, this script will scan the ROM path and create a playlist file based on the files found during a recursive scan.
    If it detects a zip file, the script will try and enumerate the first file and append it to the ROM path in the playlist, as below.
    
    Each entry in the playlist file requires six lines:
      1) ROM path - ROM name inside zip needs to be specified and separated with #
      2) Display name
      3) Path to core [or DETECT]
      4) Name of core [or DETECT]
      5) CRC          [or DETECT]
      6) Name of playlist
    
    This script outputs the playlist encoding in ANSI.
    
    Example output-

    Nintendo - Super Nintendo Entertainment System.lpl
    D:\games\snes\[Japanese]\Final Fantasy 4.zip#Final Fantasy 4.smc
    Final Fantasy 4
    DETECT
    DETECT
    DETECT
    Nintendo - Super Nintendo Entertainment System.lpl

.PARAMETER RetroArchPath
    The path to the RetroArch directory.

    Required?                    true
    Position?                    0
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false

.PARAMETER ROMPath
    The path to the directory containing the ROM files you wish to scan.

    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false

.PARAMETER FileExtensions
    An array of file extensions you wish to include in the scan.
    If omitted, all files found are included in the scan.

    Required?                    false
    Position?                    2
    Default value                *
    Accept pipeline input?       false
    Accept wildcard characters?  true

.INPUTS
    None.
    
.OUTPUTS
    ANSI encoded file in $RetroArchPath\playlists.

.EXAMPLE
    .\new-playlist.ps1 -RetroArchPath C:\RetroArch -ROMPath C:\ROMS
    
    Scan C:\ROMS and create the playlist in C:\RetroArch\playlists.

.EXAMPLE
    .\new-playlist.ps1 -RetroArchPath C:\RetroArch -ROMPath C:\ROMS -FileExtensions *.zip,*.7z

    Scan C:\ROMS and create the playlist in C:\RetroArch\playlists, only including files with an extension of .zip or .7z

.EXAMPLE
    .\new-playlist.ps1 -RetroArchPath C:\RetroArch -ROMPath C:\ROMS -FileExtensions *.iso,*.cue

    Scan C:\ROMS and create the playlist in C:\RetroArch\playlists, only including files with an extension of .iso or .cue

.NOTES
    Created 30/01/2016
    Select-Text function created by Brent Challis and adapted - http://powershell.com/cs/media/p/10883.aspx
#>

Param(
    [Parameter(Mandatory=$True)]
	[String]$RetroArchPath=$(Read-Host "RetroArch path"),
    [Parameter(Mandatory=$True)]
	[String]$ROMPath=$(Read-Host "ROM path"),
    [Parameter(Mandatory=$False)]
	[String[]]$FileExtensions="*"
)

Function Select-TextItem{ 
    PARAM  
    ( 
        [Parameter(Mandatory=$true)] 
        $options
    ) 
     
        Write-Host "`nSystem Selection"

        [int]$optionPrefix = 1 
        
        # Create menu list
        foreach ($option in $options) 
        { 
            Write-Host ("{0,3}: {1}" -f $optionPrefix,$option) 
            
            $optionPrefix++ 
        } 
        
        Write-Host ("`n{0,3}: {1}" -f 0,"To cancel")
        
        [int]$response = Read-Host "`nEnter Selection" 
        
        $val = $null 
        
        if ($response -gt 0 -and $response -le $options.Count) 
        { 
            $val = $options[$response-1] 
        } else {
            break
        }

        return $val 
}

Function Get-ZipFile{
    Param(
        [Parameter(Mandatory=$true)]
        [string]$ROMFullFilePath
    )

    [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')|Out-Null
    $ROMZipFileEntry = ([IO.Compression.ZipFile]::OpenRead($ROMFullFilePath).Entries[0].FullName)

    Return $ROMZipFileEntry

}

$Systems = @(
"3DO",
"Atari - 2600",
"Atari - 7800",
"Atari - Jaguar",
"Atari - Lynx",
"Atari - ST",
"Bandai - WonderSwan Color",
"Bandai - WonderSwan",
"Commodore Amiga",
"DOOM",
"DOS",
"FB Alpha - Arcade Games",
"GCE - Vectrex",
"Magnavox - Odyssey2",
"MAME",
"Microsoft - MSX",
"Microsoft - MSX2",
"NEC - PC Engine - TurboGrafx 16",
"NEC - PC Engine CD - TurboGrafx-CD",
"NEC - PC Engine SuperGrafx",
"NEC - PC-FX",
"Neo Geo",
"Nintendo - Famicom Disk System",
"Nintendo - Game and Watch",
"Nintendo - Game Boy Advance",
"Nintendo - Game Boy Color",
"Nintendo - Game Boy",
"Nintendo - Nintendo 64",
"Nintendo - Nintendo DS Decrypted",
"Nintendo - Nintendo DS",
"Nintendo - Nintendo Entertainment System",
"Nintendo - Satellaview",
"Nintendo - Super Nintendo Entertainment System",
"Nintendo - Virtual Boy",
"Sega - 32X",
"Sega - Game Gear",
"Sega - Master System - Mark III",
"Sega - Mega Drive - Genesis",
"Sega - Mega-CD - Sega CD",
"Sega - Saturn",
"Sega - SG-1000",
"Sinclair - ZX Spectrum +3",
"SNK - Neo Geo Pocket Color",
"SNK - Neo Geo Pocket",
"Sony - PlayStation Portable",
"Sony - PlayStation"
)

$val = Select-TextItem $Systems

$LPLFileName = "$val.lpl"

$LPLFilePath = "$RetroArchPath\playlists"
$LPLPath = "$LPLFilePath\$LPLFileName"

Try {
    
    # Required because even if the path doesn't exist, GCI still seem's to exit with $true
    If(Test-Path $ROMPath){
        $ROMS = Get-ChildItem $ROMPath -Recurse -File -Include $FileExtensions
    } else {
        Write-Output "Error - Could not find ROM path $ROMPath"
        exit 1
    }

    ForEach($ROM in $ROMS){
        
        $ROMExtension = $ROM.Extension
        $ROMPath = $ROM.FullName
        $ROMName = ($ROM.BaseName).replace(".","")

        If($ROMExtension -eq ".zip"){
            
            $ROMZip = Get-ZipFile $ROMPath
            $ROMPath = "$ROMPath#$ROMZip"

        }

$LPLEntry = @"
$ROMPath
$ROMName
DETECT
DETECT
DETECT
$LPLFileName
"@

    $LPLEntry | Out-File -FilePath $LPLPath -Append -Encoding ascii

    }

    Write-Output "`nGenerated playlist file $LPLPath"

}

Catch {
    $_.exception
}