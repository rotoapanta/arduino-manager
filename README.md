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

<p align="right"><strong>[ES]</strong> | <strong>[EN]</strong></p>

# <p align="center">Arduino IDE Manager (Linux)</p>

---

# 🇪🇸 Español

## Descripción

**Arduino IDE Manager** es una herramienta en Bash que permite instalar, gestionar, actualizar y desinstalar **Arduino IDE AppImage** en sistemas Linux, integrándolo como una aplicación nativa del sistema.

El script automatiza completamente:

- Instalación del AppImage  
- Creación del comando CLI  
- Integración en el menú de aplicaciones  
- Configuración de ícono  
- Manejo de compatibilidad (sandbox Electron)  

Todo sin requerir privilegios de superusuario.

---

## Características

- Menú interactivo fácil de usar  
- Modo no interactivo mediante CLI  
- Instalación desde:
  - AppImage local  
  - URL remota  
- Creación automática de:
  - Comando CLI (`arduino`)  
  - Acceso en el menú (.desktop)  
  - Ícono de la aplicación  
- Corrección automática de sandbox (`--no-sandbox`)  
- Sistema de logs  
- Actualización del AppImage  
- Desinstalación limpia  
- Instalación en espacio de usuario (`~/.local`)  
- Compatible con:
  - Ubuntu 22.04  
  - Ubuntu 24.04  

---

## Estructura de instalación

```bash
~/.local/opt/arduino/ArduinoIDE.AppImage
