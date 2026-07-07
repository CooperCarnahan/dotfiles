# mise activation
(&mise activate pwsh) | Out-String | Invoke-Expression

# starship initialization
Invoke-Expression (&starship init powershell)

# zoxide initialization
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Deliberate refresh of winget-provisioned apps. `chezmoi apply` only ensures
# packages are present (--no-upgrade); this upgrades them on demand.
function Update-WingetApps {
    winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
}
