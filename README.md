<img width="1462" height="745" alt="Screenshot 2026-06-02 181641" src="https://github.com/user-attachments/assets/91ea949d-ca28-41f3-a01e-67a91066504d" />

# 🧹 PowerClean – Advanced Windows System Cleaner

**PowerClean** is a powerful, modular, and interactive PowerShell script designed to clean up temporary files, caches, logs, browser data, system dumps, and optimize Windows performance. Developed by **PARSA AZIMA**, this tool helps you recover disk space, improve system responsiveness, and remove digital footprints with ease.

---

## 📋 Table of Contents

- [Features](#-features)
- [Screenshots](#-screenshots)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Usage Guide](#-usage-guide)
- [Functions Overview](#-functions-overview)
- [Admin vs Non-Admin Modes](#-admin-vs-non-admin-modes)
- [Safety & Error Handling](#-safety--error-handling)
- [Full Cleanup](#-full-cleanup)
- [FAQ](#-faq)
- [License](#-license)
- [Contact](#-contact)

---

## ✨ Features

| Category | Description |
|----------|-------------|
| 🗑️ **Temp Files** | Removes user and system TEMP directories |
| ⚡ **Prefetch & Cache** | Cleans Prefetch, DNS cache, and Shader cache |
| 🌐 **Browser Caches** | Supports Chrome, Firefox, and Microsoft Edge |
| 📦 **Windows Update** | Cleans SoftwareDistribution cache |
| 🧾 **Logs & Reports** | Deletes old logs (>30 days) and Windows Error Reports |
| 🧹 **Recycle Bin** | Empties Recycle Bin programmatically |
| 🖼️ **Thumbnails** | Removes Thumbs.db files recursively |
| 🧠 **System Caches** | .NET Cache, Adobe Cache, Office Cache, Store Cache |
| 🔧 **Network Reset** | Flushes DNS, resets Winsock & TCP/IP, clears ARP |
| 🚀 **Optimization** | Drive optimization (Trim) and Hibernation disable |
| 📊 **Cleanup Report** | Shows space saved before and after operation |
| 🖥️ **Interactive Menu** | User-friendly numbered menu with real-time free space |

---

## 🖼️ Screenshot (Menu Preview)

========== Windows Cleanup Script ==========
========== Created By PARSA AZIMA ==========

[1] Remove Temp
[2] Remove Prefetch
[3] Remove DnsCache
[4] Remove RecycleBin
[5] Remove Old Logs
[6] Remove BrowserCache
[7] Remove Dump Files
[8] Remove Desktop Thumbs
[9] Remove Old Restore Points
[10] Remove Windows Update Cache
[11] Remove StoreCache
[12] Remove OfficeCache
[13] Remove NetworkCache
[14] Remove Adobe Cache
[15] Remove Windows Error Reports
[16] Remove .NET Cache
[17] Remove Shader Cache
[18] Remove PowerShell History
[19] Optimize Drives (Admin)
[20] Disable Hibernation (Admin)
[21] Full Clean Up
[0] Exit

============================================
Current free space: 42.15 GB
text


---

## 📦 Requirements

- **Operating System**: Windows 10 / 11 (64-bit recommended)
- **PowerShell**: Version 5.1 or higher
- **Execution Policy**: Bypass or RemoteSigned (see installation)
- **Administrator Rights**: Required for options 9, 19, 20 (script warns if missing)

---

## 📥 Installation

### Option 1: Clone with Git

```powershell
git clone https://github.com/ParsaAzima/PowerClean.git
cd PowerClean
```
Option 2: Download directly

Download PowerClean.ps1 from the repository.
Option 3: One-liner download (PowerShell)

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ParsaAzima/PowerClean/main/PowerClean.ps1" -OutFile "PowerClean.ps1"
```
Set Execution Policy (if needed)

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
🚀 Usage Guide
Run the script
```powershell
.\PowerClean.ps1
```
Navigate the menu

    Type the number of the function you want to execute.

    Press Enter to confirm.

    After each operation, the script shows how much space was freed.

    Press any key to return to the main menu.

    Type 0 to exit.

Example: Clean browser cache only

    Run .\PowerClean.ps1

    Type 6 and press Enter

    Script removes Chrome, Firefox, and Edge caches

    Displays freed space

    Press any key to continue

📂 Functions Overview
#	Function Name	Description	Admin Required
1	Remove-Temp	Deletes user TEMP, TMP, and Windows Temp	❌
2	Remove-PreFetch	Clears Windows Prefetch folder	❌
3	Remove-DnsCache	Flushes DNS resolver cache	❌
4	Remove-RecycleBin	Empties Recycle Bin	❌
5	Remove-OldLogs	Deletes logs older than 30 days	❌
6	Remove-BrowserCache	Clears Chrome, Firefox, Edge caches	❌
7	Remove-DumpFiles	Removes crash dump files (.dmp)	❌
8	Remove-DesktopThumbs	Deletes Thumbs.db files	❌
9	Remove-OldRestorePoints	Deletes oldest system restore point	✅
10	Remove-WindowsUpdateCache	Clears Windows Update download cache	❌
11	Remove-StoreCache	Cleans Microsoft Store cache	❌
12	Remove-OfficeCache	Removes Microsoft Office file cache	❌
13	Remove-NetworkCache	Flushes DNS, resets Winsock & TCP/IP, clears ARP	❌
14	Remove-AdobeCache	Cleans Adobe media and temporary caches	❌
15	Remove-WindowsErrorReports	Deletes WER reports (Archive, Queue, etc.)	❌
16	Remove-DotNetCache	Clears Temporary ASP.NET Files	❌
17	Remove-ShaderCache	Removes D3D, AMD, NVIDIA shader caches	❌
18	Remove-PowerShellHistory	Deletes PowerShell command history	❌
19	Optimize-Drives	Runs ReTrim optimization on C: drive	✅
20	Disable-Hibernation	Disables hibernation and deletes hiberfil.sys	✅
21	Full-Cleanup	Runs all non-admin functions sequentially	❌
🔐 Admin vs Non-Admin Modes

    Non-admin functions (most options) work without elevation.

    Admin functions (9, 19, 20) will show a warning and exit gracefully if not run as Administrator.

    The script does not auto-elevate itself for security reasons.

To run as Administrator manually:

    Right-click PowerShell → Run as Administrator

    Navigate to script folder

    Execute .\PowerClean.ps1

🛡️ Safety & Error Handling

    All Remove-Item commands use:

        -ErrorAction SilentlyContinue (no script interruption)

        -Force to override read-only attributes

    Functions check if a path exists before attempting cleanup

    Size calculation uses Measure-Object -Property Length -Sum to show MB/GB freed

    Windows Update service is stopped and restarted automatically during cache cleanup

    No registry changes or system file deletions

⚡ Full Cleanup

The Full Cleanup option (#21) runs the following functions in sequence:

    Remove-Temp

    Remove-PreFetch

    Remove-DnsCache

    Remove-RecycleBin

    Remove-OldLogs

    Remove-BrowserCache

    Remove-DumpFiles

    Remove-DesktopThumbs

    Remove-WindowsUpdateCache

    Remove-StoreCache

    Remove-OfficeCache

    Remove-NetworkCache

    Admin functions (restore points, drive optimization, hibernation) are NOT included in Full Cleanup by design.

❓ FAQ
Q: Will this delete my personal files?

A: No. PowerClean only targets temporary files, caches, logs, and system data. It does not touch Documents, Downloads, Desktop, or user data.
Q: Can I undo a cleanup?

A: No. Deleted files are permanently removed (except Recycle Bin which is emptied intentionally). Use with caution.
Q: Why do I see "Access Denied" for some files?

A: Some system files may be in use by running processes. The script skips them automatically with -ErrorAction SilentlyContinue.
Q: How much space can I expect to free?

A: Depends on usage. Typical results: 2–15 GB after first run, 1–3 GB for regular maintenance.
Q: Can I add my own custom paths?

A: Yes. Edit the script and add new paths to the relevant array ($tempPaths, $logPaths, etc.).
📄 License

This project is licensed under the MIT License – see the LICENSE file for details.

You are free to use, modify, and distribute this script with attribution.
👨‍💻 Contact

Author: PARSA AZIMA
GitHub: github.com/ParsaAzima
Project Link: github.com/ParsaAzima/PowerClean

For bugs, suggestions, or contributions, please open an issue on GitHub.
⭐ Support

If you find PowerClean useful, consider giving it a star on GitHub and sharing it with others!
