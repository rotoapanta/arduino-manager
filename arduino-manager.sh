#!/usr/bin/env bash
#
# ==============================================================================
#  Arduino IDE Manager
# ==============================================================================

set -euo pipefail

SCRIPT_NAME="arduino-manager"
SCRIPT_VERSION="1.2.0"

APP_NAME="Arduino IDE"
INSTALL_DIR="${HOME}/.local/opt/arduino"
BIN_DIR="${HOME}/.local/bin"
APP_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons/hicolor/256x256/apps"
LOG_DIR="${HOME}/.local/state/arduino-manager"
LOG_FILE="${LOG_DIR}/arduino-manager.log"

APPIMAGE_PATH="${INSTALL_DIR}/ArduinoIDE.AppImage"
WRAPPER_PATH="${BIN_DIR}/arduino"
DESKTOP_PATH="${APP_DIR}/arduino-ide.desktop"
ICON_PATH="${ICON_DIR}/arduino-ide.png"

DEFAULT_LOCAL_APPIMAGE="${HOME}/Descargas/arduino-ide_2.3.8_Linux_64bit.AppImage"
DEFAULT_URL="https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.8_Linux_64bit.AppImage"

print_line() {
    echo "------------------------------------------------------------"
}

create_log_dir() {
    mkdir -p "${LOG_DIR}"
}

log_info() {
    create_log_dir
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $*" | tee -a "${LOG_FILE}"
}

log_error() {
    create_log_dir
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $*" | tee -a "${LOG_FILE}" >&2
}

show_help() {
    cat <<EOF
Uso:
  ./${SCRIPT_NAME}.sh [opciones]

Opciones:
  --install               Instala Arduino IDE
  --remove                Desinstala Arduino IDE
  --update                Actualiza Arduino IDE
  --from-file RUTA        Usa un AppImage local
  --from-url URL          Descarga el AppImage desde una URL
  --help                  Muestra esta ayuda
  --version               Muestra la versión del script
EOF
}

check_dependencies() {
    local missing=()

    command -v chmod >/dev/null 2>&1 || missing+=("chmod")
    command -v cp >/dev/null 2>&1 || missing+=("cp")
    command -v mkdir >/dev/null 2>&1 || missing+=("mkdir")
    command -v find >/dev/null 2>&1 || missing+=("find")
    command -v mktemp >/dev/null 2>&1 || missing+=("mktemp")
    command -v rm >/dev/null 2>&1 || missing+=("rm")
    command -v cat >/dev/null 2>&1 || missing+=("cat")
    command -v tee >/dev/null 2>&1 || missing+=("tee")
    command -v date >/dev/null 2>&1 || missing+=("date")
    command -v head >/dev/null 2>&1 || missing+=("head")

    if ! command -v wget >/dev/null 2>&1 && ! command -v curl >/dev/null 2>&1; then
        missing+=("wget o curl")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "Faltan dependencias: ${missing[*]}"
        echo "Instálalas y vuelve a ejecutar el script."
        exit 1
    fi

    log_info "Dependencias verificadas correctamente."
}

create_dirs() {
    mkdir -p "${INSTALL_DIR}" "${BIN_DIR}" "${APP_DIR}" "${ICON_DIR}"
    log_info "Directorios de instalación verificados."
}

download_appimage() {
    local url="$1"

    if [[ -z "${url}" ]]; then
        log_error "La URL no puede estar vacía."
        echo "La URL no puede estar vacía."
        exit 1
    fi

    log_info "Descargando AppImage desde URL: ${url}"
    echo "Descargando AppImage..."

    if command -v wget >/dev/null 2>&1; then
        wget -O "${APPIMAGE_PATH}" "${url}"
    else
        curl -L "${url}" -o "${APPIMAGE_PATH}"
    fi

    chmod +x "${APPIMAGE_PATH}"
    log_info "AppImage descargado correctamente en ${APPIMAGE_PATH}"
}

copy_local_appimage() {
    local source_appimage="$1"

    if [[ ! -f "${source_appimage}" ]]; then
        log_error "No se encontró el archivo local: ${source_appimage}"
        echo "No se encontró el archivo:"
        echo "  ${source_appimage}"
        exit 1
    fi

    echo "Copiando AppImage local..."
    cp "${source_appimage}" "${APPIMAGE_PATH}"
    chmod +x "${APPIMAGE_PATH}"
    log_info "AppImage local copiado desde ${source_appimage}"
}

create_wrapper() {
    cat > "${WRAPPER_PATH}" <<EOF
#!/usr/bin/env bash
exec "${APPIMAGE_PATH}" --no-sandbox "\$@"
EOF

    chmod +x "${WRAPPER_PATH}"
    log_info "Wrapper creado en ${WRAPPER_PATH}"
}

extract_icon() {
    local tmp_dir
    local found_icon=""

    tmp_dir="$(mktemp -d)"

    (
        cd "${tmp_dir}"

        if "${APPIMAGE_PATH}" --appimage-extract >/dev/null 2>&1; then
            found_icon="$(find squashfs-root -type f \( \
                -iname "arduino-ide.png" -o \
                -iname "arduino.png" -o \
                -iname "*arduino*icon*.png" -o \
                -iname "*arduino*.png" \
            \) | head -n 1 || true)"

            if [[ -n "${found_icon}" ]]; then
                cp "${found_icon}" "${ICON_PATH}"
                echo "Ícono PNG extraído correctamente."
                log_info "Ícono PNG extraído a ${ICON_PATH} desde ${found_icon}"
            else
                echo "No se encontró un ícono PNG dentro del AppImage."
                log_info "No se encontró ícono PNG dentro del AppImage."
            fi
        else
            echo "No se pudo extraer el ícono del AppImage."
            log_info "No se pudo extraer el ícono del AppImage."
        fi
    )

    rm -rf "${tmp_dir}"
}

create_desktop_entry() {
    cat > "${DESKTOP_PATH}" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Arduino IDE
Comment=Open-source electronics prototyping platform
Exec=${WRAPPER_PATH} %F
Terminal=false
Categories=Development;Electronics;IDE;
StartupNotify=true
MimeType=text/x-arduino;
EOF

    if [[ -f "${ICON_PATH}" ]]; then
        cat >> "${DESKTOP_PATH}" <<EOF
Icon=${ICON_PATH}
EOF
    else
        cat >> "${DESKTOP_PATH}" <<EOF
Icon=arduino-ide
EOF
    fi

    chmod +x "${DESKTOP_PATH}"
    log_info "Acceso .desktop creado en ${DESKTOP_PATH}"
}

update_desktop_db() {
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "${APP_DIR}" >/dev/null 2>&1 || true
        log_info "Base de datos de aplicaciones actualizada."
    else
        log_info "update-desktop-database no está disponible. Se omite."
    fi
}

refresh_icon_cache() {
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        gtk-update-icon-cache "${HOME}/.local/share/icons/hicolor" >/dev/null 2>&1 || true
        log_info "Caché de iconos actualizada."
    else
        log_info "gtk-update-icon-cache no está disponible. Se omite."
    fi
}

ensure_local_bin_in_path() {
    if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
        log_info "~/.local/bin no está en PATH."
        echo
        echo "Aviso: ~/.local/bin no está actualmente en tu PATH."
        echo "Si el comando 'arduino' no funciona, añade esto a ~/.bashrc:"
        echo
        echo 'export PATH="$HOME/.local/bin:$PATH"'
        echo
    fi
}

clean_previous_icon_and_desktop() {
    rm -f "${ICON_PATH}" || true
    rm -f "${DESKTOP_PATH}" || true
    log_info "Archivos previos de icono y desktop limpiados."
}

show_summary() {
    print_line
    echo "Operación completada."
    echo
    echo "AppImage instalado en:"
    echo "  ${APPIMAGE_PATH}"
    echo
    echo "Comando disponible:"
    echo "  ${WRAPPER_PATH}"
    echo
    echo "Archivo .desktop:"
    echo "  ${DESKTOP_PATH}"
    echo
    echo "Ícono:"
    echo "  ${ICON_PATH}"
    echo
    echo "Archivo de log:"
    echo "  ${LOG_FILE}"
    echo
    echo "Si ~/.local/bin está en tu PATH, podrás abrirlo con:"
    echo "  arduino"
    echo
    echo "También debería aparecer en el menú de aplicaciones."
    print_line
}

install_common() {
    clean_previous_icon_and_desktop
    create_wrapper
    extract_icon
    create_desktop_entry
    update_desktop_db
    refresh_icon_cache
    ensure_local_bin_in_path
    log_info "Instalación finalizada correctamente."
    show_summary
}

install_from_local() {
    local source_path
    read -r -p "Ruta del AppImage local [${DEFAULT_LOCAL_APPIMAGE}]: " source_path
    source_path="${source_path:-$DEFAULT_LOCAL_APPIMAGE}"

    create_dirs
    copy_local_appimage "${source_path}"
    install_common
}

install_from_url() {
    local url
    read -r -p "URL directa del AppImage [${DEFAULT_URL}]: " url
    url="${url:-$DEFAULT_URL}"

    create_dirs
    download_appimage "${url}"
    install_common
}

install_non_interactive() {
    local source_type="$1"
    local source_value="$2"

    create_dirs

    case "${source_type}" in
        file)
            copy_local_appimage "${source_value}"
            ;;
        url)
            download_appimage "${source_value}"
            ;;
        *)
            log_error "Tipo de fuente no válido: ${source_type}"
            echo "Fuente no válida. Usa --from-file o --from-url."
            exit 1
            ;;
    esac

    install_common
}

update_arduino() {
    local source_type="$1"
    local source_value="$2"

    log_info "Iniciando actualización de Arduino IDE."
    install_non_interactive "${source_type}" "${source_value}"
    log_info "Actualización completada correctamente."
}

uninstall_arduino() {
    print_line
    echo "Desinstalando Arduino IDE instalado por este script..."
    rm -f "${WRAPPER_PATH}"
    rm -f "${DESKTOP_PATH}"
    rm -f "${ICON_PATH}"
    rm -rf "${INSTALL_DIR}"
    update_desktop_db
    refresh_icon_cache
    log_info "Arduino IDE eliminado del sistema del usuario."
    echo "Arduino IDE eliminado."
    print_line
}

main_menu() {
    clear || true
    print_line
    echo "Instalador de Arduino IDE AppImage"
    print_line
    echo "1) Instalar desde AppImage local"
    echo "2) Instalar descargando desde URL"
    echo "3) Desinstalar"
    echo "4) Salir"
    print_line

    local option
    read -r -p "Escoge una opción [1-4]: " option

    case "${option}" in
        1)
            install_from_local
            ;;
        2)
            install_from_url
            ;;
        3)
            uninstall_arduino
            ;;
        4)
            echo "Saliendo."
            exit 0
            ;;
        *)
            echo "Opción no válida."
            exit 1
            ;;
    esac
}

parse_args() {
    local action=""
    local source_type=""
    local source_value=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --install)
                action="install"
                shift
                ;;
            --remove)
                action="remove"
                shift
                ;;
            --update)
                action="update"
                shift
                ;;
            --from-file)
                if [[ $# -lt 2 ]]; then
                    log_error "Falta la ruta después de --from-file"
                    echo "Debes indicar una ruta después de --from-file"
                    exit 1
                fi
                source_type="file"
                source_value="$2"
                shift 2
                ;;
            --from-url)
                if [[ $# -lt 2 ]]; then
                    log_error "Falta la URL después de --from-url"
                    echo "Debes indicar una URL después de --from-url"
                    exit 1
                fi
                source_type="url"
                source_value="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            --version)
                echo "${SCRIPT_NAME} ${SCRIPT_VERSION}"
                exit 0
                ;;
            *)
                log_error "Opción no válida: $1"
                echo "Opción no válida: $1"
                echo "Usa --help para ver las opciones disponibles."
                exit 1
                ;;
        esac
    done

    if [[ -z "${action}" ]]; then
        return 1
    fi

    case "${action}" in
        install)
            if [[ -z "${source_type}" || -z "${source_value}" ]]; then
                log_error "Instalación no interactiva sin fuente definida."
                echo "Para instalar en modo no interactivo debes usar --from-file o --from-url."
                exit 1
            fi
            install_non_interactive "${source_type}" "${source_value}"
            ;;
        update)
            if [[ -z "${source_type}" || -z "${source_value}" ]]; then
                log_error "Actualización sin fuente definida."
                echo "Para actualizar debes usar --from-file o --from-url."
                exit 1
            fi
            update_arduino "${source_type}" "${source_value}"
            ;;
        remove)
            uninstall_arduino
            ;;
    esac

    return 0
}

check_dependencies

if ! parse_args "$@"; then
    main_menu
fi
