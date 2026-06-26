```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║                           🚀 SCOOP SETUP 🚀                                ║
║                   Modern Windows Package Manager GUI                        ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?style=flat-square&logo=powershell)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-10%2B-0078D4?style=flat-square&logo=windows)](https://www.microsoft.com/windows/)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-blue?style=flat-square)](https://github.com/nihitdev/tools-setup/releases/tag/v1.0.0)

> This isn't another PowerShell script. It's a **modern GUI package manager for Windows**.

Automate your entire Windows developer environment setup in **5 minutes** instead of **45 minutes**. Search, select, install—all through an intuitive dark-themed graphical interface.

---

## 🎬 Watch It In Action

> **30-second demo** showing the complete workflow:

![Demo GIF](assets/demo.gif)

*Install Scoop → Select VS Code → Select Git → Click Install → Done*

> 💡 **GIF Specs:** 900×500 @ 10 FPS, <5MB | [Add your recording](assets/demo.gif)

---

## 💡 Why Scoop Setup?

Installing a fresh Windows development environment traditionally takes **hours**—manually installing Git, VS Code, Rust, Python, Docker, and dozens of other tools.

Scoop Setup **automates everything** through a modern graphical interface. No command-line knowledge needed. No remembering Scoop syntax. Just search, click checkboxes, and install.

### Perfect For:
- 🆕 New developer machines
- 💾 Fresh Windows installs
- 🖥️ VM provisioning
- 🧪 Lab & test environments
- 👨‍🎓 Students
- 👨‍💻 Developers switching machines

---

## ⚡ The Time Difference

| Task | Without Scoop Setup | With Scoop Setup |
|------|:---:|:---:|
| Install Git | 5 min | |
| Install VS Code | 8 min | |
| Install Helix | 4 min | |
| Install Rust | 6 min | |
| Install Python | 4 min | |
| Install Node.js | 4 min | |
| **Total** | **45 minutes ⏱️** | **5 minutes ⚡** |

---

## 📸 See It In Action

### Home Screen
![Home](assets/screenshot-home.png)
*Clean dark GUI with search and category filtering*

### Search & Select
![Search](assets/screenshot-search.png)
*Real-time package search and multi-select checkboxes*

### Installation
![Installing](assets/screenshot-installing.png)
*Live progress bar with colored installation logs*

### Complete
![Complete](assets/screenshot-complete.png)
*Success summary with export option*

---

## 🏗️ Architecture

Simple, elegant, and transparent:

```
                    ┌─────────────────────────┐
                    │  PowerShell GUI (Forms) │
                    └────────────┬────────────┘
                                 │
                  ┌──────────────┴──────────────┐
                  │                             │
         ┌────────▼────────┐         ┌─────────▼────────┐
         │ Detect Scoop    │         │ User selects     │
         │ Installation    │         │ packages via GUI │
         └────────┬────────┘         └─────────┬────────┘
                  │                            │
                  └──────────────┬─────────────┘
                                 │
                     ┌───────────▼───────────┐
                     │ Resolve dependencies  │
                     │ Manage buckets        │
                     └───────────┬───────────┘
                                 │
                     ┌───────────▼───────────┐
                     │ Install packages      │
                     │ Log output            │
                     └───────────┬───────────┘
                                 │
                     ┌───────────▼───────────┐
                     │ Installation complete │
                     └───────────────────────┘
```

---

## ✨ What Makes This Different

This isn't just automation—it's a **complete reimagining** of the Windows package installation experience.

### Key Features

- **🎨 Modern Dark GUI** — Professional dark theme, smooth interactions, Windows Forms
- **🚀 Zero Command-Line Knowledge** — Click and install. That's it.
- **📦 70+ Curated Packages** — Pre-selected, quality development tools
- **🔍 Smart Search** — Find any package in milliseconds
- **🪣 Smart Bucket Management** — Required buckets added automatically; duplicates skipped
- **✅ Smart Detection** — Already-installed apps highlighted (no re-installing)
- **📝 Live Colored Logs** — Real-time output with persistent logs in `%TEMP%`
- **💾 Export/Import** — Save your selection as JSON for other machines
- **🦀 Rust Support** — Rust stable installed correctly via rustup
- **⚡ One-Click Folder Access** — Open your Scoop directory directly from the GUI

---

## 📊 By The Numbers

```
✔ 70+ packages              ✔ Windows 10+
✔ 4 official Scoop buckets  ✔ Windows 11
✔ Rust toolchain            ✔ Docker & containers
✔ Python/Node.js            ✔ Nerd Fonts
✔ Java/JDK                  ✔ 50+ CLI tools
✔ Editors (VS Code, Helix)
```

---

## 🚀 Installation

### Option 1: Git Clone (Recommended)

```bash
git clone https://github.com/nihitdev/tools-setup.git
cd tools-setup
powershell -ExecutionPolicy Bypass -File .\scoop-setup.ps1
```

### Option 2: Download Release

1. Download [scoop-setup.ps1](https://github.com/nihitdev/tools-setup/releases/download/v1.0.0/scoop-setup.ps1)
2. Open **PowerShell as Administrator**
3. Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\scoop-setup.ps1
```

### Requirements

- **Windows 10+** or **Windows 11**
- **PowerShell 5.1+** (built-in)
- **Administrator access** (required)
- **~2 GB disk space** (for typical toolset)
- **Internet connection** (to download packages)

---

## 📖 Usage

1. **Launch** — Script opens the GUI automatically
2. **Browse** — View packages by category or use search
3. **Select** — Check boxes to choose what you want
4. **Presets** — Use **SELECT ALL** or **DEV PROFILE** for quick selections
5. **Review** — See selection count in the panel
6. **Install** — Click **INSTALL SELECTED** to begin
7. **Monitor** — Watch live progress and logs
8. **Save** — (Optional) Click **EXPORT** to save your selection for later

---

## 📦 What Gets Installed

### Core Utilities
7zip · Git · curl · jq · yq · less

### Terminal & Shell
bat · eza · fd · fzf · zoxide · fastfetch · bottom · oh-my-posh · pwsh 7

### Editors
VS Code · Helix · Notepad++ · LazyGit

### Development
Python · Node.js (LTS & Latest) · Go · Deno · Rust (rustup) · JDK 25 · MinGW

### Containers
Docker · Docker Compose · ArchWSL · QEMU

### Fonts
CascadiaCode · FiraCode · Hack · JetBrainsMono · Meslo (all Nerd Fonts)

### Desktop
Brave · Discord · Bitwarden · Flow Launcher · OneCommander · ImageGlass

### Media
FFmpeg · yt-dlp · PotPlayer · foobar2000 · MeshLab

### System
gsudo · Visual C++ Redistributable 2022

---

## 🪣 Supported Buckets

- **main** — Core packages (automatic)
- **extras** — Additional tools
- **nerd-fonts** — Font variants
- **java** — Java development kits

---

## 🤝 Contributing

Found a bug? Have a feature idea? Want to add a package?

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/my-feature`)
3. Make changes
4. Commit (`git commit -m "Add feature X"`)
5. Push (`git push origin feature/my-feature`)
6. Open a PR

### Contribution Ideas
- 🆕 New packages
- 🐛 Bug reports & fixes
- ✨ Feature requests
- 📖 Documentation
- 🌍 Translations

---

## ❓ FAQ

**Q: Is this safe?**  
A: Yes. Only Scoop and official buckets. Zero registry tweaks or system modifications.

**Q: I already have Scoop installed?**  
A: The script detects and reuses it safely. No conflicts.

**Q: Can I use this offline?**  
A: No. Internet required to download packages.

**Q: Where are logs stored?**  
A: `%TEMP%\scoop-setup-YYYYMMDD-HHMMSS.log`

**Q: Can I save and reuse my selection?**  
A: Yes. Click **EXPORT** to save to `Documents\scoop-selection.json`. Use **IMPORT** elsewhere.

**Q: Does this work on Windows 7 or 8?**  
A: No. Windows 10+ only.

**Q: How do I uninstall packages?**  
A: Use Scoop CLI:
```powershell
scoop uninstall <package-name>
```

**Q: What if installation fails?**  
A: Check the log in `%TEMP%`. Most failures are network-related.

---

## 📄 License

MIT License — see [LICENSE](LICENSE)

---

## 🙏 Acknowledgments

Built on [Scoop](https://scoop.sh/), the excellent Windows package manager.

---

**Made with ❤️ for Windows developers who reinstall way too often**

⭐ **If this saved you time, star the repo!**

