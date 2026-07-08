#!/bin/bash
# SPDX-License-Identifier: GPL-3.0-only
# Copyright (C) 2026 blinkEgor

# I don't know which package manager you use, so I need to define it
declare -A os_info
os_info[/etc/debian_version]=apt
os_info[/etc/fedora-release]=dnf
os_info[/etc/arch-release]=pacman

for f in ${!os_info[@]}
do
    if [[ -f $f ]]; then
        pkg_manager="${os_info[$f]}"
        break
    fi
done

if [[ -z "$pkg_manager" ]]; then
    supported=$(printf '%s, ' "${os_info[@]}" | sed 's/, $//')
    echo "Unable to determine package manager. Only supported: $supported."
    exit 1
fi

# For comfortable use and change in feature. Apps' names in itch package manager
declare -A cmake_pkg
cmake_pkg[apt]="cmake"
cmake_pkg[dnf]="cmake"
cmake_pkg[pacman]="cmake"

declare -A curl_pkg
curl_pkg[apt]="curl"
curl_pkg[dnf]="curl"
curl_pkg[pacman]="curl"

declare -A firefox_pkg
firefox_pkg[apt]="firefox"
firefox_pkg[dnf]="firefox"
firefox_pkg[pacman]="firefox"

declare -A flatpak_pkg
flatpak_pkg[apt]="flatpak"
flatpak_pkg[dnf]="flatpak"
flatpak_pkg[pacman]="flatpak"

declare -A gpp_pkg
gpp_pkg[apt]="g++"
gpp_pkg[dnf]="gcc-c++"
gpp_pkg[pacman]="gcc"

declare -A git_pkg
git_pkg[apt]="git"
git_pkg[dnf]="git"
git_pkg[pacman]="git"

declare -A mangohud_pkg
mangohud_pkg[apt]="mangohud"
mangohud_pkg[dnf]="mangohud"
mangohud_pkg[pacman]="mangohud"

declare -A neovim_pkg
neovim_pkg[apt]="neovim"
neovim_pkg[dnf]="neovim"
neovim_pkg[pacman]="neovim"

declare -A openjdk_21_jdk_pkg
openjdk_21_jdk_pkg[apt]="openjdk-21-jdk"
openjdk_21_jdk_pkg[dnf]="java-21-openjdk"
openjdk_21_jdk_pkg[pacman]="jdk-openjdk"

declare -A ripgrep_pkg
ripgrep_pkg[apt]="ripgrep"
ripgrep_pkg[dnf]="ripgrep"
ripgrep_pkg[pacman]="ripgrep"

declare -A steam_pkg
steam_pkg[apt]="steam-installer"
steam_pkg[dnf]="steam"
steam_pkg[pacman]="steam"

declare -A translate_shell_pkg
translate_shell_pkg[apt]="translate-shell"
translate_shell_pkg[dnf]="translate-shell"
translate_shell_pkg[pacman]="translate-shell"

declare -A tree_pkg
tree_pkg[apt]="tree"
tree_pkg[dnf]="tree"
tree_pkg[pacman]="tree"

declare -A virtualbox_pkg
virtualbox_pkg[apt]="virtualbox"
virtualbox_pkg[dnf]="VirtualBox"
virtualbox_pkg[pacman]="virtualbox"

declare -A w3m_pkg
w3m_pkg[apt]="w3m"
w3m_pkg[dnf]="w3m"
w3m_pkg[pacman]="w3m"

declare -A wget_pkg
wget_pkg[apt]="wget"
wget_pkg[dnf]="wget"
wget_pkg[pacman]="wget"

declare -A xdotool_pkg
xdotool_pkg[apt]="xdotool"
xdotool_pkg[dnf]="xdotool"
xdotool_pkg[pacman]="xdotool"

declare -A xinput_pkg
xinput_pkg[apt]="xinput"
xinput_pkg[dnf]="xinput"
xinput_pkg[pacman]="xorg-xinput"

declare -A zip_pkg
zip_pkg[apt]="zip"
zip_pkg[dnf]="zip"
zip_pkg[pacman]="zip"

declare -A tmux_pkg
tmux_pkg[apt]="tmux"
tmux_pkg[dnf]="tmux"
tmux_pkg[pacman]="tmux"

declare -A ffmpeg_pkg
ffmpeg_pkg[apt]="ffmpeg"
ffmpeg_pkg[dnf]="ffmpeg-free"
ffmpeg_pkg[pacman]="ffmpeg"

declare -A pandoc_pkg
pandoc_pkg[apt]="pandoc"
pandoc_pkg[dnf]="pandoc"
pandoc_pkg[pacman]="pandoc"

declare -A inotify_pkg
inotify_pkg[apt]="inotify-tools"
inotify_pkg[dnf]="inotify-tools"
inotify_pkg[pacman]="inotify-tools"

# For comfortable use in cycle. WARN: Don't forget to add new pkg name to this array too.
packages=(
    cmake_pkg curl_pkg firefox_pkg flatpak_pkg gpp_pkg git_pkg
    mangohud_pkg neovim_pkg openjdk_21_jdk_pkg ripgrep_pkg steam_pkg
    translate_shell_pkg tree_pkg virtualbox_pkg w3m_pkg wget_pkg
    xdotool_pkg xinput_pkg zip_pkg tmux_pkg ffmpeg_pkg pandoc_pkg
    inotify_pkg
)

# Wrap all check and install logic to two functions for fast use and quick change in one place
is_installed() {
    local pkg_name="$1"
    case "$pkg_manager" in
        apt)   dpkg -s "$pkg_name" &>/dev/null ;;
        dnf)   rpm -q "$pkg_name" &>/dev/null ;;
        pacman) pacman -Q "$pkg_name" &>/dev/null ;;
    esac
}

install_pkg() {
    local pkg_name="$1"
    case "$pkg_manager" in
        apt)   sudo apt install -y "$pkg_name" ;;
        dnf)   sudo dnf install -y "$pkg_name" ;;
        pacman) sudo pacman -S --noconfirm "$pkg_name" ;;
    esac
}

# Exceptions section
# apt feature for fresh packages.
if [[ "$pkg_manager" == "apt" ]]; then
    echo "Update list of packages..."
    sudo apt update
fi

# pacman don't include steam by default, so I need to add multilib to install steam from pacman
if [[ "$pkg_manager" == "pacman" ]]; then
    if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
        echo "Including multilib repo..."
        sudo sed -i '/^#\[multilib\]/,/^#Include/s/^#//' /etc/pacman.conf
        sudo pacman -Sy
    fi
fi

# Allow auto-check and auto-install all packages without changing it in the feature.
for pkg_array in "${packages[@]}"; do
    declare -n current_pkg="$pkg_array"
    pkg_name="${current_pkg[$pkg_manager]}"

    if [[ -z "$pkg_name" ]]; then
        echo "WARN: there's not name for package $pkg_array in $pkg_manager"
        continue
    fi

    if is_installed "$pkg_name"; then
        echo "$pkg_name is installed, nothing to do"
    else
        echo "Install $pkg_name ..."
        install_pkg "$pkg_name"
    fi
done

# Flatpak array for quick use and change.
# Note: this simpler because you don't need to define package manager, it's Flatpak ;)
flatpak_apps=(
    "com.discordapp.Discord"
    "com.jaquadro.NBTExplorer"
    "moe.launcher.the-honkers-railway-launcher"
    "org.kde.krita"
    "org.telegram.desktop"
    "org.vinegarhq.Vinegar"
)

is_flatpak_installed() {
    flatpak info "$1" &>/dev/null
}

install_flatpak() {
    flatpak install -y flathub "$1"
}

# Before some install you need to know is Flatpak is installed successful.
if ! command -v flatpak &>/dev/null; then
    echo "ERROR: flatpak isn't installed. Install flatpak manual and rerun the script"
    exit 1
fi

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

for app_id in "${flatpak_apps[@]}"; do
    if is_flatpak_installed "$app_id"; then
        echo "$app_id is installed, nothing to do"
    else
        echo "Install $app_id ..."
        install_flatpak "$app_id"
    fi
done

# Just check and remind for external programs. Manual installation. Use correct program name and original domain.
external_programs=(
    legacylauncher hamachi warpd
)

declare -A original_domain
original_domain[legacylauncher]="https://legacylauncher.ru/ru"
original_domain[hamachi]="https://www.vpn.net/"
original_domain[warpd]="https://github.com/rvaiya/warpd"

echo "Checking external programs that need to install manual..."

for prog in "${external_programs[@]}"; do
    if command -v "$prog" &>/dev/null; then
        echo "$prog is installed. Nothing to do"
    else
        echo "WARN: $prog not found. Install from original web-site: ${original_domain[$prog]}"
    fi
done
