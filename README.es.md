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

<p align="right"><a href="README.md">[EN]</a> | <strong>[ES]</strong></p>

# <p align="center">Arduino IDE Manager (Linux)</p>

## Descripción

**Arduino IDE Manager** es una herramienta en Bash que permite instalar, gestionar, actualizar y desinstalar **Arduino IDE AppImage** en sistemas Linux, integrándolo como una aplicación nativa de escritorio.

El script automatiza todo el proceso: descarga o copia del AppImage, creación de lanzadores, integración en el menú de aplicaciones, extracción automática del ícono y habilitación de ejecución desde la terminal — todo sin requerir privilegios de superusuario.

---

## Características

* Menú interactivo fácil de usar
* Modo no interactivo por línea de comandos
* Instalación desde:
  * Archivo AppImage local
  * URL remota
* Creación automática de:
  * Comando CLI (`arduino`)
  * Entrada de escritorio (.desktop)
  * Ícono de la aplicación (extraído del propio AppImage)
* Wrapper con `--no-sandbox` para máxima compatibilidad
* Sistema de logs
* Mecanismo de actualización del AppImage
* Desinstalación limpia
* Instalación en espacio de usuario (`~/.local`)
* Compatible con:
  * Ubuntu 22.04
  * Ubuntu 24.04
  * Otras distribuciones Linux compatibles con AppImage

---

## Estructura de Instalación

Arduino IDE se instala en:

```bash
~/.local/opt/arduino/ArduinoIDE.AppImage
```

El script también crea:

```bash
~/.local/bin/arduino
~/.local/share/applications/arduino-ide.desktop
~/.local/share/icons/hicolor/256x256/apps/arduino-ide.png
```

Archivo de log:

```bash
~/.local/state/arduino-manager/arduino-manager.log
```

---

## Requisitos

* Linux (se recomienda Ubuntu)
* Bash
* `wget` o `curl`
* `find`, `chmod`, `mktemp`, `cp`, `rm`
* `libfuse2` o equivalente del sistema (necesario para ejecutar AppImages)

---

## Instalación

```bash
git clone https://github.com/rotoapanta/arduino-manager.git
cd arduino-manager
chmod +x arduino-manager.sh
./arduino-manager.sh
```

---

## Uso

### Modo Interactivo

Ejecutar el script sin argumentos lanza el menú interactivo:

```text
------------------------------------------------------------
Instalador de Arduino IDE AppImage
------------------------------------------------------------
1) Instalar desde AppImage local
2) Instalar descargando desde URL
3) Desinstalar
4) Salir
------------------------------------------------------------
```

### Modo No Interactivo (CLI)

Instalar desde archivo local:

```bash
./arduino-manager.sh --install --from-file ~/Descargas/arduino-ide_2.3.8_Linux_64bit.AppImage
```

Instalar desde URL:

```bash
./arduino-manager.sh --install --from-url "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"
```

Actualizar:

```bash
./arduino-manager.sh --update --from-file ~/Descargas/arduino-ide_nueva.AppImage
```

Desinstalar:

```bash
./arduino-manager.sh --remove
```

Ayuda:

```bash
./arduino-manager.sh --help
```

Versión:

```bash
./arduino-manager.sh --version
```

---

## Ejecutar Arduino IDE

Desde la terminal:

```bash
arduino
```

O ábrelo desde el menú de aplicaciones de tu sistema.

> **Nota:** Si el comando `arduino` no se encuentra, asegúrate de que `~/.local/bin` esté en tu `PATH`. Agrega lo siguiente a tu `~/.bashrc`:
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ```

---

## Desinstalar

```bash
./arduino-manager.sh --remove
```

Esto elimina el AppImage, el wrapper de CLI, la entrada .desktop y el ícono.

---

## Actualizar Arduino IDE

```bash
./arduino-manager.sh --update --from-file nueva-version.AppImage
```

O desde URL:

```bash
./arduino-manager.sh --update --from-url "https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"
```

---

## ¿Por qué AppImage en vez de APT?

| Método   | Versión          | Recomendado |
| -------- | ---------------- | ----------- |
| APT      | Antigua/limitada | ❌           |
| PPA      | Variable         | ⚠️          |
| AppImage | Última versión   | ✅           |

---

## Estructura del Proyecto

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

## Contribuciones

¡Las contribuciones son bienvenidas!

1. Haz un fork del repositorio
2. Crea una nueva rama
3. Realiza tus cambios
4. Envía un Pull Request

Consulta `CONTRIBUTING.md` para más detalles.

---

## Licencia

Este proyecto está licenciado bajo la Licencia MIT.

---

## Autor

**Roberto Toapanta**  
Ingeniero Eléctrico  
Sistemas Embebidos | IoT | Energía

---

## Roadmap

* [ ] Detección automática de AppImages en la carpeta de Descargas
* [ ] Selector de versión desde GitHub Releases
* [ ] Actualización automática
* [x] Sistema de logs
* [x] Modo no interactivo
* [x] Extracción de ícono desde el AppImage

---

## Soporte

Si este proyecto te resulta útil, considera darle una estrella ⭐
