# OmarchyDotFiles

My collection of dotfiles for my personal Linux setup. This is where I manage all my configurations for the tools I use.

## ✨ What's included

* **Modular:** Easy to adapt—feel free to customize it to your needs.
* **Fancy Look:** Cool color palettes and fonts for a pleasant aesthetic.

## 🖥️ Screenshots

My current Hyprland setup:

![Dark Theme](./themes/nge_blue/preview.png)


## 🛠️ Scripts

This section contains various helper scripts for managing the configuration.

### `alacrittyToGhostty.sh`
This utility automates the migration of configuration settings (primarily **color schemes** and **fonts**) from the Alacritty terminal emulator's format to the format required by Ghostty.

### `install.sh`
This is the main setup script for the system. It handles the creation of necessary directories and establishes **symbolic links (`ln -s`)** between the configuration files in this repository and their final, required locations (e.g., in `~/.config/`).

### `GetDotfiles.sh`
This script handles the **initial retrieval and/or synchronization** of the repository, ensuring the latest configuration files are cloned or pulled and available locally before the installation process begins.

## 📝 My To-Dos

Here are a few items I want to tackle next:

- [ ] **Directory Check:** Before executing `ln -s` (symlink creation), I need to ensure that the target directory actually exists.
- [ ] **Optimize Symlink Creation:** Write a small script that automatically and reliably creates all necessary symlinks (`ln -s`), instead of setting them manually one by one.
- [ ] **Adjust Ghostty Config:** Set up and customize the configuration file for my new terminal emulator **Ghostty** (the conversion script is the first step!).
