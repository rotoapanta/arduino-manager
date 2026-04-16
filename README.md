![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu)
![Shell](https://img.shields.io/badge/script-bash-121011?logo=gnu-bash)
![Arduino](https://img.shields.io/badge/Arduino-IDE%202.x-00979D?logo=arduino)
![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Issues](https://img.shields.io/github/issues/rotoapanta/arduino-manager)
![Last Commit](https://img.shields.io/github/last-commit/rotoapanta/arduino-manager)
![Repo Size](https://img.shields.io/github/repo-size/rotoapanta/arduino-manager)

---

<p align="right"><strong>[EN]</strong> | <a href="README.es.md">[ES]</a></p>

# <p align="center">Arduino IDE Manager (Linux)</p>

---

## Description

**Arduino IDE Manager** is a Bash-based tool that allows you to install, manage, update, and uninstall the **Arduino IDE AppImage** on Linux systems, integrating it as a native desktop application.

The script automates the entire process: downloading or copying the AppImage, creating launchers, integrating it into the application menu, extracting icons, and enabling execution from the terminal — all without requiring root privileges.

---

## Features

* Easy-to-use interactive menu
* Non-interactive CLI mode
* Installation from:
  * Local AppImage file
  * Remote URL
* Automatic creation of:
  * CLI command (`arduino`)
  * Desktop entry (.desktop)
  * Application icon
* Automatic icon extraction from AppImage
* Desktop database and icon cache refresh
* Logging system
* Update mechanism
* Clean uninstall
* User-space installation (`~/.local`)
* Compatible with:
  * Ubuntu 22.04
  * Ubuntu 24.04

---

## Installation Structure

Arduino IDE is installed in:

~/.local/opt/arduino/ArduinoIDE.AppImage


The script also creates:

~/.local/bin/arduino
~/.local/share/applications/arduino-ide.desktop
~/.local/share/icons/hicolor/256x256/apps/arduino-ide.png


Log file:

```bash
~/.local/state/arduino-manager/arduino-manager.log
```

Requirements
Linux (Ubuntu recommended)
Bash
wget or curl
find, chmod, mktemp
libfuse2 (required for AppImage)

Installation
git clone https://github.com/TU_USUARIO/arduino-manager.git
cd arduino-manager
chmod +x arduino-manager.sh
./arduino-manager.sh

Usage
Interactive Mode

The script provides a menu:
1) Install from local AppImage
2) Install from URL
3) Uninstall
4) Exit

Non-Interactive Mode (CLI)

Install from local file:

./arduino-manager.sh --install --from-file ~/Descargas/arduino-ide.AppImage
Install from URL:
./arduino-manager.sh --install --from-url "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"

Update:
./arduino-manager.sh --update --from-file ~/Descargas/arduino-ide_new.AppImage

Uninstall:
./arduino-manager.sh --remove

Help:
./arduino-manager.sh --help

Version:
./arduino-manager.sh --version

Run Arduino IDE

From terminal:

arduino

Or open it from your system applications menu.

Uninstall
./arduino-manager.sh --remove


