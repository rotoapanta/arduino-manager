![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-orange.svg)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?logo=ubuntu)
![Shell](https://img.shields.io/badge/script-bash-121011?logo=gnu-bash)
![Arduino](https://img.shields.io/badge/Arduino_IDE-AppImage-00979D?logo=arduino)
![Status](https://img.shields.io/badge/status-stable-brightgreen)
![Issues](https://img.shields.io/github/issues/rotoapanta/arduino-manager)
![Last Commit](https://img.shields.io/github/last-commit/rotoapanta/arduino-manager)
![Repo Size](https://img.shields.io/github/repo-size/rotoapanta/arduino-manager)

---

<p align="right"><strong>[EN]</strong> | <a href="README.es.md">[ES]</a></p>

# <p align="center">Arduino IDE Manager (Linux)</p>

## Description

**Arduino IDE Manager** is a Bash-based tool that allows you to install, manage, update, and uninstall **Arduino IDE AppImage** on Linux systems, integrating it as a native desktop application.

The script automates the entire process: downloading or copying the AppImage, creating launchers, integrating it into the application menu, extracting the icon automatically, and enabling execution from the terminal — all without requiring root privileges.

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
  * Application icon (extracted from the AppImage)
* `--no-sandbox` wrapper for compatibility
* Logging system
* AppImage update mechanism
* Clean uninstall
* User-space installation (`~/.local`)
* Compatible with:
  * Ubuntu 22.04
  * Ubuntu 24.04
  * Other AppImage-compatible Linux distributions

---

## Installation Structure

Arduino IDE is installed in:

```
~/.local/opt/arduino/ArduinoIDE.AppImage
```

The script also creates:

```
~/.local/bin/arduino
~/.local/share/applications/arduino-ide.desktop
~/.local/share/icons/hicolor/256x256/apps/arduino-ide.png
```

Log file:

```bash
~/.local/state/arduino-manager/arduino-manager.log
```

---

## Requirements

* Linux (Ubuntu recommended)
* Bash
* `wget` or `curl`
* `find`, `chmod`, `mktemp`, `cp`, `rm`
* `libfuse2` or system equivalent (required to run AppImages)

---

## Installation

```bash
git clone https://github.com/rotoapanta/arduino-manager.git
cd arduino-manager
chmod +x arduino-manager.sh
./arduino-manager.sh
```

---

## Usage

### Interactive Mode

Running the script without arguments launches the interactive menu:

```
------------------------------------------------------------
Arduino IDE AppImage Installer
------------------------------------------------------------
1) Install from local AppImage
2) Install by downloading from URL
3) Uninstall
4) Exit
------------------------------------------------------------
```

### Non-Interactive Mode (CLI)

Install from a local file:

```bash
./arduino-manager.sh --install --from-file ~/Downloads/arduino-ide_2.3.8_Linux_64bit.AppImage
```

Install from URL:

```bash
./arduino-manager.sh --install --from-url "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"
```

Update:

```bash
./arduino-manager.sh --update --from-file ~/Downloads/arduino-ide_newer.AppImage
```

Uninstall:

```bash
./arduino-manager.sh --remove
```

Help:

```bash
./arduino-manager.sh --help
```

Version:

```bash
./arduino-manager.sh --version
```

---

## Run Arduino IDE

From terminal:

```bash
arduino
```

Or open it from your system applications menu.

> **Note:** If the `arduino` command is not found, make sure `~/.local/bin` is in your `PATH`. Add the following to your `~/.bashrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

---

## Uninstall

```bash
./arduino-manager.sh --remove
```

This removes the AppImage, the CLI wrapper, the .desktop entry, and the icon.

---

## Update Arduino IDE

```bash
./arduino-manager.sh --update --from-file new-version.AppImage
```

Or from URL:

```bash
./arduino-manager.sh --update --from-url "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"
```

---

## Why AppImage instead of APT?

| Method   | Version       | Recommended |
| -------- | ------------- | ----------- |
| APT      | Old / limited | ❌           |
| PPA      | Variable      | ⚠️          |
| AppImage | Latest        | ✅           |

---

## Project Structure

```
arduino-manager/
├── arduino-manager.sh
├── README.md
├── README.es.md
├── LICENSE
├── CHANGELOG.md
├── CONTRIBUTING.md
└── .github/
```

---

## Contributing

Contributions are welcome!

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a Pull Request

See `CONTRIBUTING.md` for more details.

---

## License

This project is licensed under the MIT License.

---

## Author

**Roberto Toapanta**  
Electrical Engineer  
Embedded Systems | IoT | Energy

---

## Roadmap

* [ ] Auto-detect AppImages in Downloads folder
* [ ] Version selector from GitHub Releases
* [ ] Auto-update feature
* [x] Logging system
* [x] Non-interactive mode
* [x] Icon extraction from AppImage

---

## Support

If you find this project useful, consider giving it a star ⭐
