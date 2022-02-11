Write-Host @"
________ ___.          .__    .___.__                _______________________________                            
\_____  \\_ |__   _____|__| __| _/|__|____    ____   \_   ___ \__    ___/\_   _____/                            
 /   |   \| __ \ /  ___/  |/ __ | |  \__  \  /    \  /    \  \/ |    |    |    __)                              
/    |    \ \_\ \\___ \|  / /_/ | |  |/ __ \|   |  \ \     \____|    |    |     \                               
\_______  /___  /____  >__\____ | |__(____  /___|  /  \______  /|____|    \___  /                               
        \/    \/     \/        \/         \/     \/          \/               \/                                
___________                   .__          __           .___                 __         .__  .__                
\__    ___/___   _____ ______ |  | _____ _/  |_  ____   |   | ____   _______/  |______  |  | |  |   ___________ 
  |    |_/ __ \ /     \\____ \|  | \__  \\   __\/ __ \  |   |/    \ /  ___/\   __\__  \ |  | |  | _/ __ \_  __ \
  |    |\  ___/|  Y Y  \  |_> >  |__/ __ \|  | \  ___/  |   |   |  \\___ \  |  |  / __ \|  |_|  |_\  ___/|  | \/
  |____| \___  >__|_|  /   __/|____(____  /__|  \___  > |___|___|  /____  > |__| (____  /____/____/\___  >__|   
             \/      \/|__|             \/          \/           \/     \/            \/               \/                                                          
"@

# $ErrorActionPreference = "silentlycontinue"

Write-Host "Enter Obsidian vault root directory:"
$root = Read-Host "INSTALL DIR"

Write-Host "`n"
Write-Host "[*] Installing to path: $root" -ForegroundColor Green

$path_var = "obsidian_path = `"*"

foreach ($line in Get-Content .\ctf_add_machine.ps1)
{
    if ($line -match $path_var)
    {
       (Get-Content .\ctf_add_machine.ps1) -replace [Regex]::Escape("$line"), "`$obsidian_path = `"$root`"" | Set-Content .\ctf_add_machine.ps1
    }
}

Write-Host "[*] Creating directory C:\Tools" -ForegroundColor Green

New-Item -Path "c:\" -Name "Tools" -ItemType "directory"

Write-Host "[*] Copying files" -ForegroundColor Green

Copy-Item .\ctf_add_machine.ps1 C:\Tools\

Write-Host "[*] Creating ctf.bat executable file" -ForegroundColor Green

Set-Content C:\Tools\ctf.bat "powershell.exe -ep bypass C:\Tools\ctf_add_machine.ps1 %1 %2 %3"

Write-Host "[*] Adding C:\Tools to Path" -ForegroundColor Green

$env_path = [Environment]::GetEnvironmentVariable("Path", "user")
$new_env_path = $env_path + ";C:\Tools"
[Environment]::SetEnvironmentVariable("Path", $new_env_path, "user")


Write-Host "[+] Installation complete. Enjoy :)" -ForegroundColor Green
Write-Host "`n"

Write-Host "Usage: ctf <arguments>"

Write-Host @"
________               .__              
\_____  \  __ _________|__|__ __  ______
 /  / \  \|  |  \_  __ \  |  |  \/  ___/
/   \_/.  \  |  /|  | \/  |  |  /\___ \ 
\_____\ \_/____/ |__|  |__|____//____  >
       \__>                          \/ 
"@

Read-Host "Press any key to exit..."