#
#   Created By PARSA AZIMA
#   
# This is script can cleanup your windows 

function Remove-Temp {
    Write-Host "[+] Cleaning User TEMP"
    
    $tempPaths = @(
        "$env:TEMP\*",
        "$env:TMP\*",
        "$env:WINDIR\Temp\*"
    )

    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            $sizeOfPath = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            if ($sizeOfPath -gt 0) {
                $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
                Write-Host "[*] Removing $path, Size : $sizeInMB MB"
            } else {
                Write-Host "[*] Removing $path, Size : 0 MB"
            }
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "[+] Removed : $path"
        }
    }
}

function Remove-PreFetch {
    Write-Host "[+] Cleaning Prefetch"
    $prefetchPath = "$env:WINDIR\Prefetch\*"
    if (Test-Path $prefetchPath) {
        $sizeOfPath = (Get-ChildItem -Path $prefetchPath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        if ($sizeOfPath -gt 0) {
            $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
            Write-Host "[*] Removing $prefetchPath, Size : $sizeInMB MB"
        } else {
            Write-Host "[*] Removing $prefetchPath, Size : 0 MB"
        }   
        Remove-Item $prefetchPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Removed : $prefetchPath"
    }
}

function Remove-DnsCache {
    Write-Host "[+] Cleaning DNS Cache"
    ipconfig /flushdns | Out-Null
    Write-Host "[+] Removed DNS Cache"
}

function Remove-RecycleBin {
    Write-Host "[+] Cleaning Recycle Bin"
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue
    Write-Host "[+] Removed Recycle Bin contents"
}

function Remove-OldLogs {
    Write-Host '[+] Cleaning Old Log Files'
    $logPaths = @(
        "$env:WINDIR\Logs",
        "$env:WINDIR\System32\LogFiles"
    )
    $daysOld = 30
    $totalSizeRemoved = 0
    
    foreach ($logPath in $logPaths) {
        if (Test-Path $logPath) {
            $oldFiles = Get-ChildItem -Path $logPath -Recurse -File -ErrorAction SilentlyContinue | 
                        Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$daysOld) }
            
            if ($oldFiles) {
                $sizeOfPath = ($oldFiles | Measure-Object -Property Length -Sum).Sum
                $totalSizeRemoved += $sizeOfPath
                $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
                Write-Host "[*] Removing old logs from $logPath, Size : $sizeInMB MB"
                
                $oldFiles | Remove-Item -Force -ErrorAction SilentlyContinue
            }
        }
    }
    
    if ($totalSizeRemoved -gt 0) {
        $totalSizeInMB = [math]::Round($totalSizeRemoved / 1MB, 2)
        Write-Host "[+] Removed log files older than $daysOld days (Total: $totalSizeInMB MB)"
    } else {
        Write-Host "[+] No old log files found older than $daysOld days"
    }
}

function Remove-BrowserCache {
    Write-Host "[+] Cleaning Browser Caches"
    
    # Chrome Cache
    $chromeCache = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"
    if (Test-Path $chromeCache) {
        $files = Get-ChildItem -Path $chromeCache -Recurse -File -ErrorAction SilentlyContinue
        $sizeOfPath = ($files | Measure-Object -Property Length -Sum).Sum
        $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
        Write-Host "[*] Removing Chrome Cache, Size : $sizeInMB MB"
        Remove-Item $chromeCache -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Removed Chrome Cache"
    }
    
    # Firefox Cache
    $firefoxProfiles = "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles"
    if (Test-Path $firefoxProfiles) {
        Get-ChildItem $firefoxProfiles -Directory | ForEach-Object {
            $cachePath = Join-Path $_.FullName "cache2"
            if (Test-Path $cachePath) {
                $files = Get-ChildItem $cachePath -Recurse -File -ErrorAction SilentlyContinue
                $sizeOfPath = ($files | Measure-Object -Property Length -Sum).Sum
                $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
                Write-Host "[*] Removing Firefox Cache ($($_.Name)), Size : $sizeInMB MB"
                Remove-Item "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
        Write-Host "[+] Removed Firefox Cache"
    }
    
    # Edge Cache
    $edgeCache = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*"
    if (Test-Path $edgeCache) {
        $files = Get-ChildItem -Path $edgeCache -Recurse -File -ErrorAction SilentlyContinue
        $sizeOfPath = ($files | Measure-Object -Property Length -Sum).Sum
        $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
        Write-Host "[*] Removing Edge Cache, Size : $sizeInMB MB"
        Remove-Item $edgeCache -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Removed Edge Cache"
    }
}

function Remove-DumpFiles {
    Write-Host "[+] Cleaning Dump Files"
    $dumpPaths = @(
        "$env:WINDIR\Minidump\*.dmp",
        "$env:WINDIR\LiveKernelReports\*.dmp",
        "$env:LOCALAPPDATA\CrashDumps\*.dmp"
    )

    foreach ($path in $dumpPaths) {
        $files = Get-ChildItem -Path $path -ErrorAction SilentlyContinue
        if ($files) {
            $sizeOfPath = ($files | Measure-Object -Property Length -Sum).Sum
            $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
            Write-Host "[*] Removing $path, Size : $sizeInMB MB"
            Remove-Item $path -Force -ErrorAction SilentlyContinue
            Write-Host "[+] Removed dump files from $path"
        }
    }
}

function Remove-DesktopThumbs {
    Write-Host "[+] Cleaning Desktop Thumbnail Cache"
    $thumbsPaths = @(
        "$env:USERPROFILE\Desktop\Thumbs.db",
        "$env:USERPROFILE\Pictures\Thumbs.db",
        "$env:USERPROFILE\Documents\Thumbs.db"
    )
    
    Get-ChildItem -Path $env:USERPROFILE -Recurse -Filter "Thumbs.db" -ErrorAction SilentlyContinue | 
    Remove-Item -Force -ErrorAction SilentlyContinue
    
    Write-Host "[+] Thumbnail cache removed"
}

function Remove-OldRestorePoints {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "Admin rights required for restore points"
        return
    }
    vssadmin delete shadows /for=c: /oldest
}

function Remove-WindowsUpdateCache {
    Write-Host "[+] Cleaning Windows Update Cache"
    $windowsUpdatePath = "$env:WINDIR\SoftwareDistribution\Download\*"
    
    if (Test-Path $windowsUpdatePath) {
        # Stop Windows Update service temporarily
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        
        $sizeOfPath = (Get-ChildItem -Path $windowsUpdatePath -Recurse -File -ErrorAction SilentlyContinue | 
                       Measure-Object -Property Length -Sum).Sum
        $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
        
        Remove-Item $windowsUpdatePath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[*] Removed Windows Update Cache: $sizeInMB MB"
        
        # Restart Windows Update service
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
    }
}

function Remove-StoreCache {
    Write-Host "[+] Cleaning Windows Store Cache" -ForegroundColor Cyan
    $storePath = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache"
    if (Test-Path $storePath) {
        $sizeOfPath = (Get-ChildItem -Path $storePath -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
        $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
        Write-Host "[*] Removing Store Cache, Size: $sizeInMB MB"
        Remove-Item "$storePath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "[+] Windows Store Cache cleaned" -ForegroundColor Green
    } else {
        Write-Host "[-] Windows Store Cache not found" -ForegroundColor Yellow
    }
}

function Remove-OfficeCache {
    Write-Host "[+] Cleaning Office Cache" -ForegroundColor Cyan
    $officeVersions = @("16.0", "15.0", "14.0")
    foreach ($version in $officeVersions) {
        $officeCache = "$env:LOCALAPPDATA\Microsoft\Office\$version\OfficeFileCache\*"
        if (Test-Path $officeCache) {
            $sizeOfPath = (Get-ChildItem -Path $officeCache -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $sizeInMB = [math]::Round($sizeOfPath / 1MB, 2)
            Write-Host "[*] Removing Office $version Cache, Size: $sizeInMB MB"
            Remove-Item $officeCache -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "[+] Office Cache cleaned" -ForegroundColor Green
}

function Remove-NetworkCache {
    Write-Host "[+] Cleaning Network Cache" -ForegroundColor Cyan
    Write-Host "[*] Flushing DNS..."
    ipconfig /flushdns | Out-Null
    Write-Host "[*] Resetting Winsock..."
    netsh winsock reset | Out-Null
    Write-Host "[*] Resetting TCP/IP..."
    netsh int ip reset | Out-Null
    Write-Host "[*] Clearing ARP cache..."
    arp -d * | Out-Null
    Write-Host "[+] Network Cache cleaned" -ForegroundColor Green
}


function Remove-AdobeCache {
    Write-Host "[+] Cleaning Adobe Cache" -ForegroundColor Cyan
    $adobePaths = @(
        "$env:LOCALAPPDATA\Adobe\Common\Media Cache\*",
        "$env:LOCALAPPDATA\Adobe\Common\Media Cache Files\*",
        "$env:LOCALAPPDATA\Adobe\Common\PTX\*",
        "$env:APPDATA\Adobe\Common\Media Cache\*",
        "$env:TEMP\Adobe\*"
    )
    foreach ($path in $adobePaths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "[+] Adobe Cache cleaned" -ForegroundColor Green
}


function Remove-WindowsErrorReports {
    Write-Host "[+] Cleaning Windows Error Reports" -ForegroundColor Cyan
    $werPaths = @(
        "$env:LOCALAPPDATA\Microsoft\Windows\WER\ReportArchive\*",
        "$env:LOCALAPPDATA\Microsoft\Windows\WER\ReportQueue\*",
        "$env:APPDATA\Microsoft\Windows\WER\*",
        "$env:ProgramData\Microsoft\Windows\WER\*"
    )
    $totalSize = 0
    foreach ($path in $werPaths) {
        if (Test-Path $path) {
            $size = (Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            $totalSize += $size
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    if ($totalSize -gt 0) {
        Write-Host "[+] Removed $([math]::Round($totalSize/1MB, 2)) MB of error reports" -ForegroundColor Green
    } else {
        Write-Host "[+] No error reports found" -ForegroundColor Yellow
    }
}


function Remove-DotNetCache {
    Write-Host "[+] Cleaning .NET Cache" -ForegroundColor Cyan
    $dotnetPaths = @(
        "$env:WINDIR\Microsoft.NET\Framework\v*\Temporary ASP.NET Files\*",
        "$env:WINDIR\Microsoft.NET\Framework64\v*\Temporary ASP.NET Files\*",
        "$env:TEMP\Temporary ASP.NET Files\*"
    )
    foreach ($path in $dotnetPaths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "[+] .NET Cache cleaned" -ForegroundColor Green
}


function Optimize-Drives {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "Admin rights required for drive optimization!"
        return
    }
    Write-Host "[+] Optimizing Drives" -ForegroundColor Cyan
    Optimize-Volume -DriveLetter C -ReTrim -Verbose -ErrorAction SilentlyContinue
    Write-Host "[+] Drive optimization completed" -ForegroundColor Green
}


function Disable-Hibernation {
    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "Admin rights required to disable hibernation!"
        return
    }
    Write-Host "[+] Checking Hibernation status" -ForegroundColor Cyan
    $hiberStatus = powercfg /a | Select-String "Hibernation"
    powercfg -h off
    Write-Host "[+] Hibernation disabled - Saved $(Get-RamSize) GB of disk space" -ForegroundColor Green
}

function Remove-ShaderCache {
    Write-Host "[+] Cleaning Shader Cache" -ForegroundColor Cyan
    $shaderPaths = @(
        "$env:LOCALAPPDATA\D3DSCache\*",
        "$env:LOCALAPPDATA\AMD\DxCache\*",
        "$env:LOCALAPPDATA\NVIDIA\GLCache\*",
        "$env:LOCALAPPDATA\NVIDIA Corporation\NV_Cache\*"
    )
    foreach ($path in $shaderPaths) {
        if (Test-Path $path) {
            Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Write-Host "[+] Shader Cache cleaned" -ForegroundColor Green
}

function Show-CleanupReport {
    param($BeforeSize, $AfterSize)
    $saved = $BeforeSize - $AfterSize
    Write-Host "`n========== Cleanup Report ==========" -ForegroundColor Cyan
    Write-Host "Before: $([math]::Round($BeforeSize/1GB, 2)) GB"
    Write-Host "After:  $([math]::Round($AfterSize/1GB, 2)) GB"
    Write-Host "Saved:  $([math]::Round($saved/1GB, 2)) GB" -ForegroundColor Green
    Write-Host "=====================================" -ForegroundColor Cyan
}

function Get-DiskFreeSpace {
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'"
    return $disk.FreeSpace
}

function Full-Cleanup {
    Write-Host "[+] Starting System Cleanup..." -ForegroundColor Cyan
    Write-Host ""
    
    Remove-Temp
    Remove-PreFetch
    Remove-DnsCache
    Remove-RecycleBin
    Remove-OldLogs
    Remove-BrowserCache
    Remove-DumpFiles
    Remove-DesktopThumbs
    Remove-OldRestorePoints
    Remove-WindowsUpdateCache
    Remove-StoreCache
    Remove-OfficeCache
    Remove-NetworkCache

    Write-Host ""
    Write-Host "[+] System cleanup completed!" -ForegroundColor Green
}
function Print-UI {
    Clear-Host
    Write-Host "========== Windows Cleanup Script ==========" -ForegroundColor Cyan
    Write-Host "==========    Created By PARSA AZIMA    ==========" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "[1]  Remove Temp"
    Write-Host "[2]  Remove Prefetch"
    Write-Host "[3]  Remove DnsCache"
    Write-Host "[4]  Remove RecycleBin"
    Write-Host "[5]  Remove Old Logs"
    Write-Host "[6]  Remove BrowserCache"
    Write-Host "[7]  Remove Dump Files"
    Write-Host "[8]  Remove Desktop Thumbs"
    Write-Host "[9]  Remove Old Restore Points"
    Write-Host "[10] Remove Windows Update Cache"
    Write-Host "[11] Remove StoreCache"
    Write-Host "[12] Remove OfficeCache"
    Write-Host "[13] Remove NetworkCache"
    Write-Host "[14] Remove Adobe Cache"
    Write-Host "[15] Remove Windows Error Reports"
    Write-Host "[16] Remove .NET Cache"
    Write-Host "[17] Remove Shader Cache"
    Write-Host "[18] Remove PowerShell History"
    Write-Host "[19] Optimize Drives (Admin)"
    Write-Host "[20] Disable Hibernation (Admin)"
    Write-Host "[21] Full Clean Up"
    Write-Host "[0]  Exit"
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Gray
    Write-Host "Current free space: $([math]::Round((Get-DiskFreeSpace)/1GB, 2)) GB" -ForegroundColor Yellow
    
    $choice = Read-Host "`nSelect option"
    

    $beforeSpace = Get-DiskFreeSpace
    
    switch ($choice) {
        "1" { Clear-Host; Remove-Temp }
        "2" { Clear-Host; Remove-PreFetch }
        "3" { Clear-Host; Remove-DnsCache }
        "4" { Clear-Host; Remove-RecycleBin }
        "5" { Clear-Host; Remove-OldLogs }
        "6" { Clear-Host; Remove-BrowserCache }
        "7" { Clear-Host; Remove-DumpFiles }
        "8" { Clear-Host; Remove-DesktopThumbs }
        "9" { Clear-Host; Remove-OldRestorePoints }
        "10" { Clear-Host; Remove-WindowsUpdateCache }
        "11" { Clear-Host; Remove-StoreCache }
        "12" { Clear-Host; Remove-OfficeCache }
        "13" { Clear-Host; Remove-NetworkCache }
        "14" { Clear-Host; Remove-AdobeCache }
        "15" { Clear-Host; Remove-WindowsErrorReports }
        "16" { Clear-Host; Remove-DotNetCache }
        "17" { Clear-Host; Remove-ShaderCache }
        "18" { Clear-Host; Remove-PowerShellHistory }
        "19" { Clear-Host; Optimize-Drives }
        "20" { Clear-Host; Disable-Hibernation }
        "21" { Clear-Host; Full-Cleanup }
        "0" { 
            Clear-Host
            Write-Host "Exiting..." -ForegroundColor Green
            break
            exit
        }
        default {
            Clear-Host
            Write-Host "Option not defined!" -ForegroundColor Red
            Start-Sleep -Seconds 1.5
            Print-UI
            return
        }
    }
    
    
    $afterSpace = Get-DiskFreeSpace
    $savedSpace = ($afterSpace - $beforeSpace) / 1GB
    if ($savedSpace -gt 0) {
        Write-Host "`n[+] Space freed: $([math]::Round($savedSpace, 2)) GB" -ForegroundColor Green
    }
    
    Write-Host "`nPress any key to continue..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Print-UI
}

Print-UI
