# Scoop Setup - one-file Windows GUI installer
# Save as: scoop-setup.ps1
# Run: powershell -ExecutionPolicy Bypass -File .\scoop-setup.ps1
# This only manages Scoop buckets/apps. No debloat, registry, or service tweaks.

#requires -Version 5.1
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-IsAdmin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    $p = New-Object Security.Principal.WindowsPrincipal($id)
    $p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-PwshExe {
    $p = Get-Process -Id $PID -ErrorAction SilentlyContinue
    if ($p -and $p.Path) { return $p.Path }
    if ($PSVersionTable.PSEdition -eq "Core") { return (Join-Path $PSHOME "pwsh.exe") }
    return (Join-Path $PSHOME "powershell.exe")
}

function Restart-ElevatedSta {
    if ([string]::IsNullOrWhiteSpace($PSCommandPath)) {
        throw "Save this script to a .ps1 file first."
    }
    Start-Process -FilePath (Get-PwshExe) `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -STA -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}

if (-not (Test-IsAdmin) -or [Threading.Thread]::CurrentThread.ApartmentState -ne "STA") {
    Restart-ElevatedSta
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Each package has: package name | category | Scoop bucket | short description | selected by default
$script:Apps = @(
    [PSCustomObject]@{N="7zip";C="Core";B="main";D="Archive manager";Default=$true}
    [PSCustomObject]@{N="git";C="Core";B="main";D="Git version control";Default=$true}
    [PSCustomObject]@{N="curl";C="Core";B="main";D="HTTP client";Default=$true}
    [PSCustomObject]@{N="jq";C="Core";B="main";D="JSON processor";Default=$true}
    [PSCustomObject]@{N="yq";C="Core";B="main";D="YAML and TOML processor";Default=$true}
    [PSCustomObject]@{N="less";C="Core";B="main";D="Terminal pager";Default=$true}

    [PSCustomObject]@{N="bat";C="Shell";B="main";D="Better cat";Default=$true}
    [PSCustomObject]@{N="bottom";C="Shell";B="main";D="Terminal system monitor";Default=$true}
    [PSCustomObject]@{N="broot";C="Shell";B="main";D="Directory navigator";Default=$true}
    [PSCustomObject]@{N="dark";C="Shell";B="main";D="Disk usage analyzer";Default=$true}
    [PSCustomObject]@{N="doggo";C="Shell";B="main";D="DNS lookup tool";Default=$true}
    [PSCustomObject]@{N="dust";C="Shell";B="main";D="Better du";Default=$true}
    [PSCustomObject]@{N="eza";C="Shell";B="main";D="Better ls";Default=$true}
    [PSCustomObject]@{N="fastfetch";C="Shell";B="main";D="System info";Default=$true}
    [PSCustomObject]@{N="fd";C="Shell";B="main";D="Fast file finder";Default=$true}
    [PSCustomObject]@{N="fzf";C="Shell";B="main";D="Fuzzy finder";Default=$true}
    [PSCustomObject]@{N="glow";C="Shell";B="main";D="Markdown viewer";Default=$true}
    [PSCustomObject]@{N="jid";C="Shell";B="main";D="Interactive JSON viewer";Default=$true}
    [PSCustomObject]@{N="oh-my-posh";C="Shell";B="main";D="Prompt engine";Default=$true}
    [PSCustomObject]@{N="procs";C="Shell";B="main";D="Better ps";Default=$true}
    [PSCustomObject]@{N="psfzf";C="Shell";B="extras";D="fzf for PowerShell";Default=$true}
    [PSCustomObject]@{N="pipes-rs";C="Shell";B="extras";D="Terminal animation";Default=$true}
    [PSCustomObject]@{N="pwsh";C="Shell";B="main";D="PowerShell 7";Default=$true}
    [PSCustomObject]@{N="xh";C="Shell";B="main";D="Friendly HTTP client";Default=$true}
    [PSCustomObject]@{N="yazi";C="Shell";B="main";D="Terminal file manager";Default=$true}
    [PSCustomObject]@{N="zoxide";C="Shell";B="main";D="Smart cd";Default=$true}

    [PSCustomObject]@{N="helix";C="Editors";B="main";D="Terminal editor";Default=$true}
    [PSCustomObject]@{N="lazygit";C="Editors";B="extras";D="Git terminal UI";Default=$true}
    [PSCustomObject]@{N="notepadplusplus";C="Editors";B="extras";D="Notepad++";Default=$true}
    [PSCustomObject]@{N="vscode";C="Editors";B="extras";D="Visual Studio Code";Default=$true}

    [PSCustomObject]@{N="deno";C="Development";B="main";D="Deno runtime";Default=$true}
    [PSCustomObject]@{N="gh";C="Development";B="main";D="GitHub CLI";Default=$true}
    [PSCustomObject]@{N="go";C="Development";B="main";D="Go toolchain";Default=$true}
    [PSCustomObject]@{N="mingw-winlibs";C="Development";B="main";D="C/C++ toolchain";Default=$true}
    [PSCustomObject]@{N="nodejs-lts";C="Development";B="main";D="Node.js LTS";Default=$true}
    [PSCustomObject]@{N="nodejs";C="Development";B="main";D="Node.js latest";Default=$false}
    [PSCustomObject]@{N="python";C="Development";B="main";D="Python";Default=$true}
    [PSCustomObject]@{N="rustup";C="Development";B="main";D="Rust toolchain manager";Default=$true}
    [PSCustomObject]@{N="rust-stable";C="Development";B="internal";D="Rust stable through rustup";Default=$true}
    [PSCustomObject]@{N="temurin25-jdk";C="Development";B="java";D="Temurin JDK 25";Default=$true}
    [PSCustomObject]@{N="uv";C="Development";B="main";D="Fast Python package manager";Default=$true}

    [PSCustomObject]@{N="archwsl";C="Containers";B="extras";D="Arch Linux WSL";Default=$true}
    [PSCustomObject]@{N="docker";C="Containers";B="main";D="Docker CLI";Default=$true}
    [PSCustomObject]@{N="docker-compose";C="Containers";B="main";D="Docker Compose";Default=$true}
    [PSCustomObject]@{N="qemu";C="Containers";B="main";D="VM emulator";Default=$true}

    [PSCustomObject]@{N="CascadiaCode-NF";C="Fonts";B="nerd-fonts";D="Cascadia Nerd Font";Default=$true}
    [PSCustomObject]@{N="FiraCode-NF";C="Fonts";B="nerd-fonts";D="Fira Code Nerd Font";Default=$true}
    [PSCustomObject]@{N="Hack-NF";C="Fonts";B="nerd-fonts";D="Hack Nerd Font";Default=$true}
    [PSCustomObject]@{N="JetBrainsMono-NF";C="Fonts";B="nerd-fonts";D="JetBrains Mono Nerd Font";Default=$true}
    [PSCustomObject]@{N="Meslo-NF";C="Fonts";B="nerd-fonts";D="Meslo Nerd Font";Default=$true}

    [PSCustomObject]@{N="bitwarden";C="Desktop";B="extras";D="Password manager";Default=$true}
    [PSCustomObject]@{N="brave";C="Desktop";B="extras";D="Brave browser";Default=$true}
    [PSCustomObject]@{N="discord";C="Desktop";B="extras";D="Discord";Default=$true}
    [PSCustomObject]@{N="Flow-Launcher";C="Desktop";B="extras";D="App launcher";Default=$true}
    [PSCustomObject]@{N="imageglass";C="Desktop";B="extras";D="Image viewer";Default=$true}
    [PSCustomObject]@{N="onecommander";C="Desktop";B="extras";D="File manager";Default=$true}

    [PSCustomObject]@{N="ffmpeg";C="Media";B="main";D="Audio/video toolkit";Default=$true}
    [PSCustomObject]@{N="foobar2000";C="Media";B="extras";D="Audio player";Default=$true}
    [PSCustomObject]@{N="foobar2000-encoders";C="Media";B="extras";D="Extra encoders";Default=$true}
    [PSCustomObject]@{N="meshlab";C="Media";B="extras";D="3D mesh editor";Default=$true}
    [PSCustomObject]@{N="potplayer";C="Media";B="extras";D="Video player";Default=$true}
    [PSCustomObject]@{N="yt-dlp";C="Media";B="main";D="Media downloader";Default=$true}

    [PSCustomObject]@{N="gsudo";C="System";B="main";D="sudo for Windows";Default=$true}
    [PSCustomObject]@{N="vcredist2022";C="System";B="extras";D="Visual C++ runtime";Default=$true}
)

$script:Selected = @{}
$script:Installed = @{}
$script:Installing = $false
$script:Populating = $false
$script:LogFile = Join-Path $env:TEMP ("scoop-setup-" + (Get-Date -Format "yyyyMMdd-HHmmss") + ".log")

foreach ($app in $script:Apps) { $script:Selected[$app.N] = $app.Default }

function Get-ScoopRoot {
    if ($env:SCOOP -and (Test-Path $env:SCOOP)) {
        return $env:SCOOP
    }

    $cmd = Get-Command scoop -ErrorAction SilentlyContinue
    if ($cmd -and $cmd.Source) {
        $shimPath = $cmd.Source
        $root = Split-Path -Parent (Split-Path -Parent $shimPath)
        if (Test-Path $root) { return $root }
    }

    foreach ($root in @("D:\Scoop", "C:\Scoop", (Join-Path $env:USERPROFILE "scoop"))) {
        if (Test-Path $root) { return $root }
    }

    return $null
}

function Get-Scoop {
    $cmd = Get-Command scoop -ErrorAction SilentlyContinue
    if ($cmd) {
        if ($cmd.Source) { return $cmd.Source }
        return "scoop"
    }

    $root = Get-ScoopRoot
    if ($root) { return Join-Path $root "shims\scoop.ps1" }

    return $null
}

function Get-InstalledBuckets {
    $scoop = Get-Scoop
    if (-not $scoop) { return @() }

    try {
        $output = & $scoop bucket list 2>&1
    } catch {
        return @()
    }

    $buckets = @()
    foreach ($line in $output) {
        $text = ($line | Out-String).Trim()
        if ([string]::IsNullOrWhiteSpace($text)) { continue }
        if ($text -match '^(Buckets:|Name|---)') { continue }
        $buckets += $text
    }

    return $buckets
}

function Ui-Log {
    param(
        [string]$Text,
        [System.Drawing.Color]$Color = [System.Drawing.Color]::Gainsboro
    )

    $line = "[" + (Get-Date -Format "HH:mm:ss") + "] " + $Text
    $log.SelectionStart = $log.TextLength
    $log.SelectionLength = 0
    $log.SelectionColor = $Color
    $log.AppendText($line + "`r`n")
    $log.SelectionColor = $log.ForeColor
    $log.ScrollToCaret()

    try { Add-Content -Path $script:LogFile -Value $line -Encoding UTF8 } catch {}
}

function Ensure-Scoop {
    if (Get-Scoop) {
        Ui-Log "Using existing Scoop." ([System.Drawing.Color]::LightGreen)
        return
    }

    $drive = if (Test-Path "D:\") { "D:" } else { "C:" }
    $scoopDir = "$drive\Scoop"
    $globalDir = "$drive\Scoop\globalapps"
    $installer = Join-Path $env:TEMP "scoop-install.ps1"

    Ui-Log "Installing Scoop into $scoopDir ..." ([System.Drawing.Color]::Khaki)

    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri "https://get.scoop.sh" -OutFile $installer -UseBasicParsing
    & $installer -ScoopDir $scoopDir -ScoopGlobalDir $globalDir -RunAsAdmin

    if ($LASTEXITCODE -ne 0) { throw "Scoop installer failed: exit code $LASTEXITCODE" }

    $env:SCOOP = $scoopDir
    $env:SCOOP_GLOBAL = $globalDir
    $env:Path = (Join-Path $scoopDir "shims") + ";" + $env:Path
    [Environment]::SetEnvironmentVariable("SCOOP", $scoopDir, "User")
    [Environment]::SetEnvironmentVariable("SCOOP_GLOBAL", $globalDir, "User")

    Ui-Log "Scoop installed successfully." ([System.Drawing.Color]::LightGreen)
}

function Run-Scoop {
    param([string[]]$Args)

    $scoop = Get-Scoop
    if (-not $scoop) { throw "Scoop was not found." }

    $out = & $scoop @Args 2>&1
    foreach ($line in $out) {
        $text = ($line | Out-String).Trim()
        if ($text) { Ui-Log "  $text" ([System.Drawing.Color]::DarkGray) }
    }

    if ($LASTEXITCODE -ne 0) { throw "Scoop exit code: $LASTEXITCODE" }
}

function Refresh-Installed {
    $script:Installed = @{}
    $scoop = Get-Scoop

    if (-not $scoop) {
        $scoopStatus.Text = "Scoop: not installed yet"
        Refresh-List
        return
    }

    $scoopStatus.Text = "Scoop: detected"

    try {
        foreach ($line in (& $scoop list 2>&1)) {
            $text = ($line | Out-String).Trim()
            if ($text -match "^(?<name>[A-Za-z0-9._-]+)\s+") {
                $script:Installed[$Matches.name.ToLowerInvariant()] = $true
            }
        }
    } catch {}

    Refresh-List
}

function Get-FilteredApps {
    $category = $categoryBox.SelectedItem.ToString()
    $search = $searchBox.Text.Trim()

    @($script:Apps | Where-Object {
        (($category -eq "All") -or ($_.C -eq $category)) -and
        ([string]::IsNullOrWhiteSpace($search) -or
            $_.N.IndexOf($search, [StringComparison]::OrdinalIgnoreCase) -ge 0 -or
            $_.D.IndexOf($search, [StringComparison]::OrdinalIgnoreCase) -ge 0)
    } | Sort-Object C, N)
}

function Update-SelectedCount {
    $count = @($script:Apps | Where-Object { $script:Selected[$_.N] }).Count
    $selectedLabel.Text = "$count of $($script:Apps.Count) selected"
    $installButton.Enabled = (-not $script:Installing) -and $count -gt 0
}

function Refresh-List {
    if (-not $list) { return }

    $script:Populating = $true
    $list.BeginUpdate()
    $list.Items.Clear()

    foreach ($app in Get-FilteredApps) {
        $status = if ($app.B -eq "internal") {
            "Toolchain"
        } elseif ($script:Installed.ContainsKey($app.N.ToLowerInvariant())) {
            "Installed"
        } else {
            "Not installed"
        }

        $item = New-Object System.Windows.Forms.ListViewItem($app.N)
        [void]$item.SubItems.Add($app.C)
        [void]$item.SubItems.Add($app.B)
        [void]$item.SubItems.Add($status)
        [void]$item.SubItems.Add($app.D)
        $item.Checked = [bool]$script:Selected[$app.N]
        $item.Tag = $app

        if ($status -eq "Installed") {
            $item.ForeColor = [System.Drawing.Color]::FromArgb(130, 225, 160)
        }

        [void]$list.Items.Add($item)
    }

    $list.EndUpdate()
    $script:Populating = $false
    Update-SelectedCount
}

function Set-UiLocked {
    param([bool]$Locked)

    $script:Installing = $Locked
    $allButton.Enabled = -not $Locked
    $devButton.Enabled = -not $Locked
    $clearButton.Enabled = -not $Locked
    $refreshButton.Enabled = -not $Locked
    $openButton.Enabled = -not $Locked
    $categoryBox.Enabled = -not $Locked
    $searchBox.Enabled = -not $Locked
    $list.Enabled = -not $Locked
    Update-SelectedCount
}

function Set-Progress {
    param([int]$Current, [int]$Total, [string]$Text)

    $progress.Maximum = [Math]::Max($Total, 1)
    $progress.Value = [Math]::Min([Math]::Max($Current, 0), $progress.Maximum)
    $progressLabel.Text = $Text
    [System.Windows.Forms.Application]::DoEvents()
}

function Install-Selection {
    $chosen = @($script:Apps | Where-Object { $script:Selected[$_.N] })

    if ($chosen.N -contains "nodejs-lts" -and $chosen.N -contains "nodejs") {
        $answer = [System.Windows.Forms.MessageBox]::Show(
            "Both Node.js LTS and Node.js Latest are selected.`n`nYes = keep LTS`nNo = keep Latest`nCancel = stop",
            "Choose Node.js version",
            [System.Windows.Forms.MessageBoxButtons]::YesNoCancel,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($answer -eq [System.Windows.Forms.DialogResult]::Cancel) { return }
        if ($answer -eq [System.Windows.Forms.DialogResult]::Yes) { $script:Selected["nodejs"] = $false }
        else { $script:Selected["nodejs-lts"] = $false }

        $chosen = @($script:Apps | Where-Object { $script:Selected[$_.N] })
        Refresh-List
    }

    if ($chosen.N -contains "rust-stable" -and -not ($chosen.N -contains "rustup")) {
        $script:Selected["rustup"] = $true
        $chosen = @($script:Apps | Where-Object { $script:Selected[$_.N] })
        Refresh-List
    }

    $ok = [System.Windows.Forms.MessageBox]::Show(
        "Install $($chosen.Count) selected applications?`n`nRequired Scoop buckets will be added automatically.",
        "Start install",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    if ($ok -ne [System.Windows.Forms.DialogResult]::Yes) { return }

    Set-UiLocked $true

    try {
        Ensure-Scoop

        $installedBuckets = Get-InstalledBuckets
        $buckets = @($chosen | Where-Object { $_.B -notin @("main", "internal") } | Select-Object -ExpandProperty B -Unique)
        $missingBuckets = $buckets | Where-Object { $_ -notin $installedBuckets }
        $total = 1 + $missingBuckets.Count + $chosen.Count
        $step = 0

        foreach ($bucket in $missingBuckets) {
            $step++
            Set-Progress $step $total "Adding bucket: $bucket"
            try {
                Run-Scoop @("bucket", "add", $bucket)
                Ui-Log "Bucket ready: $bucket" ([System.Drawing.Color]::LightGreen)
            } catch {
                Ui-Log "Bucket warning: $bucket - $($_.Exception.Message)" ([System.Drawing.Color]::Orange)
            }
        }

        foreach ($bucket in ($buckets | Where-Object { $_ -in $installedBuckets })) {
            Ui-Log "Bucket already installed: $bucket" ([System.Drawing.Color]::DarkGray)
        }

        foreach ($app in $chosen) {
            $step++
            Set-Progress $step $total "Installing: $($app.N)"

            try {
                if ($app.N -eq "rust-stable") {
                    Ui-Log "Installing Rust stable via rustup..." ([System.Drawing.Color]::Khaki)
                    & rustup toolchain install stable 2>&1 | ForEach-Object { Ui-Log "  $_" ([System.Drawing.Color]::DarkGray) }
                    if ($LASTEXITCODE -ne 0) { throw "rustup toolchain install stable failed." }

                    & rustup default stable 2>&1 | ForEach-Object { Ui-Log "  $_" ([System.Drawing.Color]::DarkGray) }
                    if ($LASTEXITCODE -ne 0) { throw "rustup default stable failed." }
                } else {
                    Run-Scoop @("install", $app.N)
                    $script:Installed[$app.N.ToLowerInvariant()] = $true
                }

                Ui-Log "Done: $($app.N)" ([System.Drawing.Color]::LightGreen)
            } catch {
                Ui-Log "FAILED: $($app.N) - $($_.Exception.Message)" ([System.Drawing.Color]::Tomato)
            }
        }

        Set-Progress $total $total "Finished. Check the log."
        Refresh-Installed
        Ui-Log "Finished. Log file: $script:LogFile" ([System.Drawing.Color]::LightGreen)

        [System.Windows.Forms.MessageBox]::Show(
            "Install queue finished.`n`nCheck the live log for failures.`n`nLog file:`n$script:LogFile",
            "Installation complete",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null
    } catch {
        Ui-Log "FATAL: $($_.Exception.Message)" ([System.Drawing.Color]::Tomato)
        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            "Installation error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        ) | Out-Null
    } finally {
        Set-UiLocked $false
    }
}

# GUI colors
$bg = [System.Drawing.Color]::FromArgb(19, 19, 23)
$panelColor = [System.Drawing.Color]::FromArgb(31, 31, 38)
$inputColor = [System.Drawing.Color]::FromArgb(45, 45, 54)
$red = [System.Drawing.Color]::FromArgb(196, 48, 55)
$redDark = [System.Drawing.Color]::FromArgb(121, 24, 31)
$textColor = [System.Drawing.Color]::FromArgb(235, 235, 240)
$muted = [System.Drawing.Color]::FromArgb(175, 175, 188)

function New-Button {
    param([string]$Text, [int]$X, [int]$Y, [int]$W, [int]$H, [System.Drawing.Color]$Color)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $Text
    $b.Location = New-Object System.Drawing.Point($X, $Y)
    $b.Size = New-Object System.Drawing.Size($W, $H)
    $b.FlatStyle = "Flat"
    $b.FlatAppearance.BorderSize = 0
    $b.BackColor = $Color
    $b.ForeColor = [System.Drawing.Color]::White
    $b.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    return $b
}

$form = New-Object System.Windows.Forms.Form
$form.Text = "Scoop Setup"
$form.Size = New-Object System.Drawing.Size(1210, 780)
$form.MinimumSize = New-Object System.Drawing.Size(1100, 700)
$form.StartPosition = "CenterScreen"
$form.BackColor = $bg
$form.ForeColor = $textColor
$form.Font = New-Object System.Drawing.Font("Segoe UI", 9)

$header = New-Object System.Windows.Forms.Panel
$header.Dock = "Top"
$header.Height = 98
$header.BackColor = $redDark
$form.Controls.Add($header)

$title = New-Object System.Windows.Forms.Label
$title.Text = "SCOOP SETUP"
$title.AutoSize = $true
$title.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 22)
$title.ForeColor = [System.Drawing.Color]::White
$title.Location = New-Object System.Drawing.Point(25, 15)
$header.Controls.Add($title)

$sub = New-Object System.Windows.Forms.Label
$sub.Text = "Choose tools • Buckets are automatic • Existing apps are safe to reselect"
$sub.AutoSize = $true
$sub.ForeColor = [System.Drawing.Color]::FromArgb(255, 225, 225)
$sub.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$sub.Location = New-Object System.Drawing.Point(29, 60)
$header.Controls.Add($sub)

$target = if (Test-Path "D:\") { "D:\Scoop" } else { "C:\Scoop" }
$targetText = New-Object System.Windows.Forms.Label
$targetText.Text = "NEW SCOOP TARGET: $target"
$targetText.AutoSize = $true
$targetText.ForeColor = [System.Drawing.Color]::White
$targetText.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$targetText.Location = New-Object System.Drawing.Point(890, 28)
$header.Controls.Add($targetText)

$filterPanel = New-Object System.Windows.Forms.Panel
$filterPanel.Location = New-Object System.Drawing.Point(20, 115)
$filterPanel.Size = New-Object System.Drawing.Size(800, 58)
$filterPanel.BackColor = $panelColor
$form.Controls.Add($filterPanel)

$catLabel = New-Object System.Windows.Forms.Label
$catLabel.Text = "Category"
$catLabel.AutoSize = $true
$catLabel.ForeColor = $muted
$catLabel.Location = New-Object System.Drawing.Point(16, 20)
$filterPanel.Controls.Add($catLabel)

$categoryBox = New-Object System.Windows.Forms.ComboBox
$categoryBox.Location = New-Object System.Drawing.Point(78, 14)
$categoryBox.Size = New-Object System.Drawing.Size(150, 28)
$categoryBox.DropDownStyle = "DropDownList"
$categoryBox.BackColor = $inputColor
$categoryBox.ForeColor = $textColor
[void]$categoryBox.Items.Add("All")
foreach ($c in ($script:Apps.C | Sort-Object -Unique)) { [void]$categoryBox.Items.Add($c) }
$categoryBox.SelectedIndex = 0
$filterPanel.Controls.Add($categoryBox)

$searchLabel = New-Object System.Windows.Forms.Label
$searchLabel.Text = "Search"
$searchLabel.AutoSize = $true
$searchLabel.ForeColor = $muted
$searchLabel.Location = New-Object System.Drawing.Point(248, 20)
$filterPanel.Controls.Add($searchLabel)

$searchBox = New-Object System.Windows.Forms.TextBox
$searchBox.Location = New-Object System.Drawing.Point(301, 14)
$searchBox.Size = New-Object System.Drawing.Size(280, 28)
$searchBox.BackColor = $inputColor
$searchBox.ForeColor = $textColor
$searchBox.BorderStyle = "FixedSingle"
$filterPanel.Controls.Add($searchBox)

$selectedLabel = New-Object System.Windows.Forms.Label
$selectedLabel.AutoSize = $true
$selectedLabel.ForeColor = [System.Drawing.Color]::LightSkyBlue
$selectedLabel.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 9)
$selectedLabel.Location = New-Object System.Drawing.Point(605, 20)
$filterPanel.Controls.Add($selectedLabel)

$list = New-Object System.Windows.Forms.ListView
$list.Location = New-Object System.Drawing.Point(20, 185)
$list.Size = New-Object System.Drawing.Size(800, 390)
$list.View = "Details"
$list.CheckBoxes = $true
$list.FullRowSelect = $true
$list.HideSelection = $false
$list.MultiSelect = $false
$list.BackColor = $panelColor
$list.ForeColor = $textColor
$list.BorderStyle = "FixedSingle"
[void]$list.Columns.Add("Tool", 165)
[void]$list.Columns.Add("Category", 110)
[void]$list.Columns.Add("Bucket", 95)
[void]$list.Columns.Add("Status", 105)
[void]$list.Columns.Add("What it does", 305)
$form.Controls.Add($list)

$side = New-Object System.Windows.Forms.Panel
$side.Location = New-Object System.Drawing.Point(840, 115)
$side.Size = New-Object System.Drawing.Size(335, 460)
$side.BackColor = $panelColor
$form.Controls.Add($side)

$sideTitle = New-Object System.Windows.Forms.Label
$sideTitle.Text = "INSTALL PLAN"
$sideTitle.AutoSize = $true
$sideTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 14)
$sideTitle.ForeColor = [System.Drawing.Color]::White
$sideTitle.Location = New-Object System.Drawing.Point(18, 17)
$side.Controls.Add($sideTitle)

$info = New-Object System.Windows.Forms.Label
$info.Text = @"
• Existing Scoop is kept.
• New Scoop: D:\Scoop or C:\Scoop.
• Required buckets are added.
• Node LTS and Latest are exclusive.
• Rust stable uses rustup.
• Docker here means Docker CLI.
"@
$info.Location = New-Object System.Drawing.Point(18, 58)
$info.Size = New-Object System.Drawing.Size(298, 155)
$info.ForeColor = $muted
$side.Controls.Add($info)

# Tooltips
$tooltip = New-Object System.Windows.Forms.ToolTip
$tooltip.AutoPopDelay = 5000
$tooltip.InitialDelay = 300
$tooltip.ReshowDelay = 100
$tooltip.ShowAlways = $true

$allButton = New-Button "SELECT ALL" 18 230 142 36 $inputColor
$side.Controls.Add($allButton)
$tooltip.SetToolTip($allButton, "Select all listed tools")

$devButton = New-Button "DEV PROFILE" 175 230 142 36 $inputColor
$side.Controls.Add($devButton)
$tooltip.SetToolTip($devButton, "Select a common development toolset")

$clearButton = New-Button "CLEAR SELECTION" 18 276 299 36 $inputColor
$side.Controls.Add($clearButton)
$tooltip.SetToolTip($clearButton, "Clear all selections")

$refreshButton = New-Button "REFRESH INSTALLED STATUS" 18 330 299 36 $inputColor
$side.Controls.Add($refreshButton)
$tooltip.SetToolTip($refreshButton, "Refresh detected installed apps and status")

$openButton = New-Button "OPEN SCOOP FOLDER" 18 385 142 36 $inputColor
$side.Controls.Add($openButton)
$tooltip.SetToolTip($openButton, "Open the Scoop installation folder in Explorer")

# Export / Import selection buttons
$exportButton = New-Button "EXPORT" 175 385 68 36 $inputColor
$side.Controls.Add($exportButton)
$tooltip.SetToolTip($exportButton, "Export current selection to Documents\\scoop-selection.json")

$importButton = New-Button "IMPORT" 249 385 68 36 $inputColor
$side.Controls.Add($importButton)
$tooltip.SetToolTip($importButton, "Import selection from Documents\\scoop-selection.json")

$logTitle = New-Object System.Windows.Forms.Label
$logTitle.Text = "LIVE INSTALL LOG"
$logTitle.AutoSize = $true
$logTitle.ForeColor = $muted
$logTitle.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 10)
$logTitle.Location = New-Object System.Drawing.Point(20, 592)
$form.Controls.Add($logTitle)

$log = New-Object System.Windows.Forms.RichTextBox
$log.Location = New-Object System.Drawing.Point(20, 616)
$log.Size = New-Object System.Drawing.Size(800, 110)
$log.ReadOnly = $true
$log.BackColor = [System.Drawing.Color]::FromArgb(12, 12, 15)
$log.ForeColor = [System.Drawing.Color]::Gainsboro
$log.BorderStyle = "FixedSingle"
$log.Font = New-Object System.Drawing.Font("Consolas", 8.5)
$form.Controls.Add($log)

$progress = New-Object System.Windows.Forms.ProgressBar
$progress.Location = New-Object System.Drawing.Point(840, 620)
$progress.Size = New-Object System.Drawing.Size(335, 21)
$form.Controls.Add($progress)

$progressLabel = New-Object System.Windows.Forms.Label
$progressLabel.Text = "Ready. Select tools, then click Install selected."
$progressLabel.Location = New-Object System.Drawing.Point(840, 650)
$progressLabel.Size = New-Object System.Drawing.Size(335, 42)
$progressLabel.ForeColor = $muted
$form.Controls.Add($progressLabel)

$scoopStatus = New-Object System.Windows.Forms.Label
$scoopStatus.Text = "Scoop: checking..."
$scoopStatus.Location = New-Object System.Drawing.Point(840, 697)
$scoopStatus.Size = New-Object System.Drawing.Size(335, 22)
$scoopStatus.ForeColor = [System.Drawing.Color]::LightSkyBlue
$form.Controls.Add($scoopStatus)

$installButton = New-Button "INSTALL SELECTED" 840 732 335 38 $red
$installButton.Font = New-Object System.Drawing.Font("Segoe UI Semibold", 11)
$form.Controls.Add($installButton)

$categoryBox.Add_SelectedIndexChanged({ if (-not $script:Installing) { Refresh-List } })
$searchBox.Add_TextChanged({ if (-not $script:Installing) { Refresh-List } })

$list.Add_ItemCheck({
    param($sender, $e)
    if ($script:Populating) { return }

    $app = $sender.Items[$e.Index].Tag
    if ($app) {
        $script:Selected[$app.N] = ($e.NewValue -eq [System.Windows.Forms.CheckState]::Checked)
        $form.BeginInvoke([System.Action]{ Update-SelectedCount }) | Out-Null
    }
})

$allButton.Add_Click({
    foreach ($app in $script:Apps) { $script:Selected[$app.N] = $true }
    $script:Selected["nodejs"] = $false
    Refresh-List
})

$devButton.Add_Click({
    foreach ($app in $script:Apps) {
        $script:Selected[$app.N] = ($app.C -in @("Core", "Shell", "Editors", "Development"))
    }
    $script:Selected["nodejs"] = $false
    Refresh-List
})

$clearButton.Add_Click({
    foreach ($app in $script:Apps) { $script:Selected[$app.N] = $false }
    Refresh-List
})

$refreshButton.Add_Click({ Refresh-Installed })

$openButton.Add_Click({
    $scoop = Get-Scoop
    if (-not $scoop) {
        [System.Windows.Forms.MessageBox]::Show("Scoop is not installed yet.") | Out-Null
        return
    }

    $root = Get-ScoopRoot
    if ($root) {
        Start-Process explorer.exe $root
        return
    }
})

# Export selection
$exportButton.Add_Click({
    $path = Join-Path (Join-Path $env:USERPROFILE "Documents") "scoop-selection.json"
    $sel = @{}
    foreach ($app in $script:Apps) { $sel[$app.N] = [bool]$script:Selected[$app.N] }
    try {
        ($sel | ConvertTo-Json -Depth 3) | Out-File -FilePath $path -Encoding UTF8
        [System.Windows.Forms.MessageBox]::Show("Selection exported to `n$path","Export complete",[System.Windows.Forms.MessageBoxButtons]::OK) | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Export failed: $($_.Exception.Message)","Export error",[System.Windows.Forms.MessageBoxButtons]::OK) | Out-Null
    }
})

# Import selection
$importButton.Add_Click({
    $path = Join-Path (Join-Path $env:USERPROFILE "Documents") "scoop-selection.json"
    if (-not (Test-Path $path)) { [System.Windows.Forms.MessageBox]::Show("No selection file found at `n$path") | Out-Null; return }
    try {
        $json = Get-Content $path -Raw | ConvertFrom-Json
        foreach ($app in $script:Apps) {
            if ($json.PSObject.Properties.Name -contains $app.N) {
                $script:Selected[$app.N] = [bool]$json.$($app.N)
            }
        }
        Refresh-List
        [System.Windows.Forms.MessageBox]::Show("Selection imported","Import complete",[System.Windows.Forms.MessageBoxButtons]::OK) | Out-Null
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Failed to import selection: $($_.Exception.Message)","Error",[System.Windows.Forms.MessageBoxButtons]::OK) | Out-Null
    }
})

$installButton.Add_Click({ Install-Selection })

$form.Add_Shown({
    Ui-Log "Scoop setup started." ([System.Drawing.Color]::LightSkyBlue)
    Ui-Log "Log: $script:LogFile" ([System.Drawing.Color]::DarkGray)
    Refresh-Installed
})

[void]$form.ShowDialog()
