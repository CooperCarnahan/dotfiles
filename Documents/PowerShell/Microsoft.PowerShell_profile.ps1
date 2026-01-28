# mise activation
(&mise activate pwsh) | Out-String | Invoke-Expression

# starship initialization
Invoke-Expression (&starship init powershell)

# zoxide initialization
Invoke-Expression (& { (zoxide init powershell | Out-String) })
