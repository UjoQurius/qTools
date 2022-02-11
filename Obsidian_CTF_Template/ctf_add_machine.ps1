# Obsidian CTF Template
# Created by Qurius

$obsidian_path = "asdf"
$CTF_dir = "CTF"
$ErrorActionPreference= "silentlycontinue"
$cmd_args = $args

function Show-Help
{
    Write-Host @"
Usage:
        OBS <platform> <difficulty> <machine name>
Flags:
    -h Print this help
    -l List platforms
"@
}

function List-Platforms
{
    return "htb", "pg", "pgp"
}

function Check-Params
{
    # Arguments handling #TODO

    if ($cmd_args.count -eq 0)
    {
        if ($cmd_args[0] -ne "-h" -or $cmd_args[0] -ne "-l")
        {
            Write-Host "Please provide arguments! For more info use -h"
            exit    
        }
    }

    if ($cmd_args[0] -eq "-h")
    {
        Show-Help
    }

    if ($cmd_args[0] -eq "-l")
    {
        List-Platforms
    }

    else 
    {
        $platform = cmd_args[0]
        $difficulty = cmd_args[1]
        $machine_name = cmd_args[2]
    }
}

function Check-Platform
{
    $platforms = List-Platforms

    if ($platform -in $platforms)
    {
        if ($platform -eq "htb")
        {
            $platform = "HackTheBox"
        }
        
        if ($platform -eq "pg")
        {
            $platform = "Proving Grounds"
        }

        if ($platform -eq "pgp")
        {
            $platform = "Proving Grounds Practice"
        }
    }
    else
    {
        Write-Host "Provided platform is not supported!"
    }

    return $platform
}

function Create-DirStruct
{
    $platform = Check-Platform

    # Create directory structure for the new machine
    New-Item -ItemType Directory "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\Assets" | Out-Null # Out-Null so it does not write output to stdout
}

function Create-STDFiles
{
    $platform = Check-Platform
    $files = "00 - Credentials", "02 - Nmap", "03 - Enumeration", "04 - Initial Foothold", "05 - Post-Exploitation Enumeration", "06 - Privilege Escalation"

    # Create support file for the Obsidian graph
    New-Item -ItemType File "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\$machine_name.md" | Out-Null

    foreach ($file in $files)
    {
        # Create files for notetaking
        New-Item -ItemType File "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\$file.md" | Out-Null # Out-Null so it does not write output to stdout

        Add-Content "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\$machine_name.md" "[[$platform/$difficulty/$machine_name/$file]]"
    }

    Add-Content "$obsidian_path\$CTF_dir\$platform\$difficulty\$difficulty.md" "`[[$machine_name]]"
}

function Prepare-Files
{
    $platform = Check-Platform

    # Credentials table
    $table = "|Account|Username|Email|Password|Hash|`n|---|---|---|---|---|`n||||||`n||||||`n||||||"
    $c = "``"

    # Nmap scans
    $structure = "# TCP`n### Full-port Discovery Scan`n$c$c$c`sql`n`n$c$c$c`n### Selected Ports Script Scan`n$c$c$c`sql`n`n$c$c$c`n# UDP`n$c$c$c`sql`n`n$c$c$c"

    Add-Content "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\00 - Credentials.md" $table
    Add-Content "$obsidian_path\$CTF_dir\$platform\$difficulty\$machine_name\02 - Nmap.md" $structure
}

Check-Params
Create-DirStruct
Create-STDFiles
Prepare-Files
