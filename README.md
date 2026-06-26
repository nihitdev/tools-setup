# Scoop Setup

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=flat-square&logo=powershell)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%2B-0078D4?style=flat-square&logo=windows)](https://www.microsoft.com/windows/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://github.com/nihitdev/tools-setup/releases/tag/v1.0.0)

A polished Windows GUI for Scoop installs. Search, select, install.

---

## Demo

![Demo](assets/demo.gif)

> Replace `assets/demo.gif` with a 900×500, 10 FPS recording under 5MB.

---

## Install

```powershell
git clone https://github.com/nihitdev/tools-setup.git
cd tools-setup
powershell -ExecutionPolicy Bypass -File .\scoop-setup.ps1
```

Or download `scoop-setup.ps1`, open PowerShell as Administrator, and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scoop-setup.ps1
```

Requirements:
- Windows 10+ / 11
- PowerShell 5.1+
- Administrator access
- Internet connection

---

## Why Scoop Setup?

Fresh Windows developer setups are slow and repetitive.

Scoop Setup turns Scoop into a polished GUI installer, auto-manages buckets, detects installed apps, and saves selections for repeatable installs.

---

## Features

- Modern dark Windows Forms GUI
- Search and filter packages instantly
- Batch install multiple tools with one click
- Auto-add required buckets
- Detects already-installed apps
- Live progress and colorized logs
- Export/import package selections
- Reuse existing Scoop installs
- Rust support via rustup

---

## Screenshots

![Home](assets/screenshot-home.png)

![Search](assets/screenshot-search.png)

![Installing](assets/screenshot-installing.png)

![Complete](assets/screenshot-complete.png)

---

## Architecture

```mermaid
graph TD
  UI[PowerShell GUI] --> Detect[Scoop detection]
  Detect --> Buckets[Bucket management]
  Buckets --> Resolve[Package resolution]
  Resolve --> Install[Package installation]
  Install --> Log[Live logs & completion]
```

---

## Showcase

Ready for developers setting up:
- VS Code
- Helix
- Docker
- Rust
- Go
- Python
- Node.js
- Git workflows

---

## Included Software

Examples:
- Git, 7zip, curl, jq
- VS Code, Helix, Notepad++
- Python, Node.js, Go, Deno, Rust, JDK
- Docker, Docker Compose, ArchWSL
- Nerd fonts, Brave, Discord, Bitwarden

---

## Roadmap

- [x] Modern GUI
- [x] Search and filter
- [x] Multi-select install
- [x] Live logs
- [x] Scoop detection
- [ ] Package profiles
- [ ] Winget backend
- [ ] Chocolatey backend
- [ ] Theme settings

---

## FAQ

Is it safe?  
Yes. It only installs Scoop packages and manages Scoop buckets.

Already have Scoop?  
Yes. Existing Scoop installs are detected and reused.

Where are logs?  
Saved to `%TEMP%` with a timestamp.

Can I use it offline?  
No. Internet is required.

---

Built for developers who reinstall Windows too often.

---

## License

MIT License.
