# 1. Relax execution policy for the rest of the sandbox session
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

$progressPreference = 'silentlyContinue'

# 2. Install WinGet Client Module
Write-Host "Installing WinGet PowerShell module..."
Install-PackageProvider -Name NuGet -Force | Out-Null
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers | Out-Null

# 3. Bootstrap WinGet
Write-Host "Using Repair-WinGetPackageManager to bootstrap WinGet..."
Repair-WinGetPackageManager -AllUsers

# 4. Fix PATH for the current session
$wingetDir = Join-Path $env:LocalAppData "Microsoft\WindowsApps"
if ($env:PATH -notlike "*$wingetDir*") {
    $env:PATH = "$env:PATH;$wingetDir"
}

# 5. Verify
Write-Host "Verifying installation..."
winget --version
Write-Host "Done. Execution policy is now 'Bypass' and WinGet is in your PATH."
