# Ensure we can run scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Function to check if we're running as administrator
function Test-Administrator {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Function to run a command as administrator
function Invoke-AsAdmin {
    param(
        [string]$Command,
        [string]$Message
    )
    
    Write-Host "Requiring administrative privileges for: $Message" -ForegroundColor Yellow
    if (-not (Test-Administrator)) {
        $encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Command))
        $process = Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -EncodedCommand $encodedCommand" -Wait -PassThru
        if ($process.ExitCode -ne 0) {
            throw "Failed to execute admin command: $Message"
        }
    } else {
        Invoke-Expression $Command
    }
}

# Function to install WSL
function Install-WSL {
    Write-Step "Installing Windows Subsystem for Linux (WSL)"
    
    # Check if WSL is already installed
    $wslCheck = wsl --status 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "WSL is already installed." -ForegroundColor Yellow
        return
    }

    # Install WSL with admin privileges
    $wslCommand = @"
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --update
    wsl --set-default-version 2
"@

    Invoke-AsAdmin -Command $wslCommand -Message "Installing WSL"

    # Optionally install a default Linux distribution
    Write-Host "Installing Ubuntu as the default WSL distribution..." -ForegroundColor Green
    Invoke-AsAdmin -Command "wsl --install -d Ubuntu" -Message "Installing Ubuntu WSL"
}

# Error handling
$ErrorActionPreference = 'Stop'

function Write-Step {
    param([string]$Message)
    Write-Host "`n==> $Message" -ForegroundColor Cyan
}

# Create necessary directories (no admin required)
Write-Step "Creating configuration directories"
$Directories = @(
    "$env:USERPROFILE\.config\chezmoi"
)
foreach ($Dir in $Directories) {
    if (-not (Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

# Function to install Winget packages
function Install-WingetPackages {
    param(
        [string]$Category,
        [string[]]$Packages,
        [bool]$RequiresAdmin = $false
    )
    Write-Step "Installing $Category via Winget"
    foreach ($Package in $Packages) {
        Write-Host "Installing $Package..." -ForegroundColor Green
        $wingetCmd = "winget install --exact --silent $Package"
        
        if ($RequiresAdmin) {
            Invoke-AsAdmin -Command $wingetCmd -Message "Installing $Package with Winget"
        } else {
            Invoke-Expression $wingetCmd
        }
        
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install $Package"
        }
    }
}

# Define Winget package groups
$WingetPackageGroups = @{
    'Productivity and Development Tools' = @{
        Packages = @('1password-cli', 'AgileBits.1Password')
        RequiresAdmin = $false
    }
}

# Install Winget packages
foreach ($Group in $WingetPackageGroups.GetEnumerator()) {
    Install-WingetPackages -Category $Group.Key -Packages $Group.Value.Packages -RequiresAdmin $Group.Value.RequiresAdmin
}

# Install Scoop if not present (no admin required by design)
Write-Step "Checking Scoop installation"
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop..."
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
}

# Define Scoop buckets to add
$ScoopBuckets = @(
    'extras',
    'nerd-fonts'
)

# Add Scoop buckets
Write-Step "Adding Scoop buckets"
foreach ($Bucket in $ScoopBuckets) {
    Write-Host "Adding bucket: $Bucket" -ForegroundColor Green
    scoop bucket add $Bucket
}

# Function to install Scoop packages
function Install-ScoopPackages {
    param(
        [string]$Category,
        [string[]]$Packages,
        [bool]$RequiresAdmin = $false
    )
    Write-Step "Installing $Category"
    foreach ($Package in $Packages) {
        Write-Host "Installing $Package..." -ForegroundColor Green
        if ($RequiresAdmin) {
            $scoopCmd = "`$env:PATH = `'$env:PATH`'; scoop install $Package"
            Invoke-AsAdmin -Command $scoopCmd -Message "Installing $Package"
        } else {
            scoop install $Package
        }
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "Failed to install $Package"
        }
    }
}

# Define package groups with admin requirements
$PackageGroups = @{
    'Core Development Tools' = @{
        Packages = @('aria2', 'git', 'gzip', 'unzip')
        RequiresAdmin = $false
    }
    'Build Tools' = @{
        Packages = @('cmake', 'make', 'llvm', 'gcc')
        RequiresAdmin = $false
    }
    'Shell and Navigation Tools' = @{
        Packages = @('fzf', 'starship', 'zoxide', 'bat', 'ripgrep', 'fd', 'clipboard', 'delta')
        RequiresAdmin = $false
    }
    'Terminal Applications' = @{
        Packages = @('neovim', 'lazygit', 'yazi')
        RequiresAdmin = $false
    }
    'Programming Languages' = @{
        Packages = @('go', 'nvm', 'zig')
        RequiresAdmin = $false
    }
    'System Tools' = @{
        Packages = @('extras/powertoys', 'extras/carapace-bin')
        RequiresAdmin = $true
    }
    'Fonts' = @{
        Packages = @('nerd-fonts/CascadiaCode-NF')
        RequiresAdmin = $false
    }
}

# Install packages by group
foreach ($Group in $PackageGroups.GetEnumerator()) {
    Install-ScoopPackages -Category $Group.Key -Packages $Group.Value.Packages -RequiresAdmin $Group.Value.RequiresAdmin
}

# Install WSL
Install-WSL

# Clone Neovim configuration (no admin required)
Write-Step "Setting up Neovim configuration"
$NvimConfigPath = "$env:USERPROFILE\AppData\Local\nvim"
if (-not (Test-Path $NvimConfigPath)) {
    git clone https://github.com/CooperCarnahan/nvim.git $NvimConfigPath
} else {
    Write-Host "Neovim configuration already exists" -ForegroundColor Yellow
}

Write-Host "`nSetup completed successfully!" -ForegroundColor Green
