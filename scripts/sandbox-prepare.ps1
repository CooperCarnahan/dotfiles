# 1. Relax execution policy for the rest of the sandbox session
Set-ExecutionPolicy Bypass -Scope CurrentUser -Force

$progressPreference = 'silentlyContinue'

# 2. Install WinGet Client Module and NuGet provider
Write-Host "Installing NuGet provider..."
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force | Out-Null

Write-Host "Installing WinGet PowerShell modules..."
Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope AllUsers | Out-Null
Install-Module -Name Microsoft.WinGet.DSC -Force -Repository PSGallery -Scope AllUsers | Out-Null

# 3. Bootstrap WinGet
Write-Host "Using Repair-WinGetPackageManager to bootstrap WinGet..."
Repair-WinGetPackageManager -AllUsers

# 4. Pre-install DSC Configuration Modules
Write-Host "Pre-installing DSC Configuration Modules..."
$modules = @(
    'Microsoft.Windows.Developer',
    'Microsoft.Windows.Settings',
    'Microsoft.Windows.Feature',
    'Microsoft.Windows.Registry',
    'Microsoft.Windows.Service'
)

foreach ($module in $modules) {
    Write-Host "Installing $module..."
    Install-Module -Name $module -Force -AllowClobber -Scope AllUsers | Out-Null
}

# 5. Fix PATH for the current session
$wingetDir = Join-Path $env:LocalAppData "Microsoft\WindowsApps"
if ($env:PATH -notlike "*$wingetDir*") {
    $env:PATH = "$env:PATH;$wingetDir"
}

# 6. Verify
Write-Host "Verifying installation..."
winget --version
Write-Host "Done. Execution policy is now 'Bypass' and WinGet is in your PATH with all DSC modules."
