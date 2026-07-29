{{- /* All OpenSSH server logic, in one place. Included by run_windows-system.ps1 both
       into the (unelevated) orchestrator session and verbatim into the elevated helper
       it generates, so these functions are defined exactly once.

       Split by privilege on purpose: the Get-/Test- probes are safe unelevated and let
       the orchestrator decide whether a UAC prompt is warranted at all, while the
       Install-/Set- actions require admin. */ -}}
function Get-OpenSSHAuthorizedKeyPath {
    # Accounts in the Administrators group are read from HERE, not ~/.ssh/authorized_keys.
    # This path is also why the key cannot be a chezmoi-managed target: chezmoi's
    # destination is the home directory and cannot reach C:\ProgramData.
    Join-Path $env:ProgramData 'ssh\administrators_authorized_keys'
}

function Get-OpenSSHManagedKey {
    # Resolved from 1Password at `chezmoi init` (op://Personal/SSH Key - Inter-Computer),
    # never committed. `dig` so an un-migrated machine renders "" instead of erroring.
    {{ dig "sshAuthorizedKey" "" . | quote }}
}

function Test-OpenSSHAuthorizedKey {
    $file = Get-OpenSSHAuthorizedKeyPath
    $key = Get-OpenSSHManagedKey
    if (-not $key) { return $true }  # nothing to reconcile
    if (-not (Test-Path -LiteralPath $file)) { return $false }
    Select-String -LiteralPath $file -SimpleMatch $key -Quiet
}

function Get-OpenSSHPendingActions {
    # Returns the names of the elevated actions still outstanding. Empty means converged,
    # which is what keeps a settled machine from prompting for UAC on every apply.
    $pending = @()

    if ((Get-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0').State -ne 'Installed') {
        $pending += 'Install-OpenSSHServer'
    }

    $svc = Get-Service sshd -ErrorAction SilentlyContinue
    if (-not $svc -or $svc.StartType -ne 'Automatic' -or $svc.Status -ne 'Running') {
        $pending += 'Set-OpenSSHServiceState'
    }

    if (-not (Test-OpenSSHAuthorizedKey)) { $pending += 'Set-OpenSSHAuthorizedKey' }

    return $pending
}

function Install-OpenSSHServer {
    # The ~~~~0.0.1.0 suffix is the DISM capability identity (Name~Publisher~Arch~Lang~
    # Version), NOT an OpenSSH version -- Microsoft has never incremented it. The build
    # actually delivered is whatever ships with this Windows version, serviced by Windows
    # Update. Slow (contacts Windows Update); the caller backgrounds this accordingly.
    Add-WindowsCapability -Online -Name 'OpenSSH.Server~~~~0.0.1.0' | Out-Null
}

function Set-OpenSSHServiceState {
    Set-Service -Name sshd -StartupType Automatic
    Start-Service sshd
}

function Set-OpenSSHAuthorizedKey {
    $file = Get-OpenSSHAuthorizedKeyPath
    $key = Get-OpenSSHManagedKey
    if (-not $key) {
        throw "sshAuthorizedKey is empty. Re-run 'chezmoi init' with the 1Password CLI signed in."
    }

    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $file) | Out-Null

    # Append-and-dedupe, never overwrite: clobbering would drop keys added out of band.
    if (-not (Test-OpenSSHAuthorizedKey)) { Add-Content -LiteralPath $file -Value $key }

    # sshd SILENTLY ignores this file unless its ACL is restricted to SYSTEM +
    # Administrators. The failure mode is a quiet fallback to password auth, so verify
    # with `ssh localhost` and confirm no password prompt.
    icacls $file /inheritance:r /grant "SYSTEM:F" /grant "BUILTIN\Administrators:F" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "icacls failed on $file (exit $LASTEXITCODE)" }
}
