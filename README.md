# Linux Setup Script

This is a Bash script that installs all my favorite programs on a new Linux computer.

It works with three package managers:
- `apt` (Debian, Ubuntu, Linux Mint)
- `dnf` (Fedora)
- `pacman` (Arch Linux)

The script checks what programs are already installed and installs only the missing ones.

---

## !!! Before you run

**Read the script first** – you must know what it does.

The script uses `sudo` to install packages. You need administrator rights.

---

## How to use

1. Download the script:

```bash
wget https://github.com/blinkEgor/linux_setup/releases/download/v1.0.1/setup_2026-07-01_v1.0.1.sh
```

2. Make it executable:

```bash
chmod +x setup_2026-07-01_v1.0.1.sh
```

3. Run it with `sudo`

```bash
sudo ./setup_2026-07-01_v1.0.1.sh
```

---

## What it installs

The script installs:

**System packages:** `cmake`, `curl`, `g++` / `gcc`, `git`, `neovim`, `ffmpeg`, `pandoc`, and many others.

**Flatpak apps:** `Discord`, `Telegram`, `Krita`, `Vinegar`, and more.

It also reminds you about programs you need to install manually (like `legacylauncher`, `hamachi`, `warpd`).

---

## How to customize for your own needs

You can use this script as a **template** for your own setup.

1. Open the script in a text editor.

2. Find the arrays with package names (`cmake_pkg`, `curl_pkg`, etc.).

3. Add or remove packages – just follow the same pattern.

For example, to add `htop`, add a new block:

```bash
declare -A htop_pkg
htop_pkg[apt]="htop"
htop_pkg[dnf]="htop"
htop_pkg[pacman]="htop"
```

Then add `htop_pkg` to the packages list.

For Flatpak apps, add the application ID to the `flatpak_apps` array.
