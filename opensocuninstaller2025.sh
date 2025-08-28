#!/bin/bash
# Autor: p0pc0rninj4 y la IA
# OpenSOC Uninstaller v2025

set -euo pipefail
LOG_FILE="/var/log/opensoc_uninstall.log"
exec > >(tee -i "$LOG_FILE") 2>&1

ascii_art() {
cat << "EOF"
 $$$$$$\                                 $$$$$$\   $$$$$$\   $$$$$$\  
$$  __$$\                               $$  __$$\ $$  __$$\ $$  __$$\ 
$$ /  $$ | $$$$$$\   $$$$$$\  $$$$$$$\  $$ /  \__|$$ /  $$ |$$ /  \__|
$$ |  $$ |$$  __$$\ $$  __$$\ $$  __$$\ \$$$$$$\  $$ |  $$ |$$ |      
$$ |  $$ |$$ /  $$ |$$$$$$$$ |$$ |  $$ | \____$$\ $$ |  $$ |$$ |      
$$ |  $$ |$$ |  $$ |$$   ____|$$ |  $$ |$$\   $$ |$$ |  $$ |$$ |  $$\ 
 $$$$$$  |$$$$$$$  |\$$$$$$$\ $$ |  $$ |\$$$$$$  | $$$$$$  |\$$$$$$  |
 \______/ $$  ____/  \_______|\__|  \__| \______/  \______/  \______/ 
          $$ |                                                        
          $$ |   ____  _____ ____  _     _____ ____ 
              / ___\/  __//  __\/ \ |\/  __//  __\
              |    \|  \  |  \/|| | //|  \  |  \/|
              \___ ||  /_ |    /| \// |  /_ |    /
              \____/\____\\_/\_\\__/  \____\\_/\_\                                                                                            
EOF
}

uninstall_service() {
    local svc=$1
    if systemctl is-active --quiet "$svc" || systemctl is-enabled --quiet "$svc"; then
        echo "Deteniendo y deshabilitando $svc..."
        sudo systemctl stop "$svc" || true
        sudo systemctl disable "$svc" || true
        echo "$svc removido de systemd"
    else
        echo "$svc no está activo o habilitado"
    fi
}

remove_package() {
    local pkg=$1
    if dpkg -l | grep -qw "$pkg"; then
        echo "Desinstalando $pkg..."
        sudo apt-get remove --purge -y "$pkg"
    else
        echo "$pkg no está instalado"
    fi
}

clean_logs() {
    echo "Limpiando logs de OpenSOC..."
    sudo rm -f /var/log/opensoc_*.log || true
}

main_menu() {
    while true; do
        clear
        ascii_art
        echo "OpenSOC Uninstaller v2025"
        echo "1) Detener y quitar servicios principales"
        echo "2) Desinstalar paquetes instalados"
        echo "3) Limpiar logs"
        echo "0) Salir"
        read -rp "Selecciona una opción: " choice
        case $choice in
            1) 
                uninstall_service wazuh-agent
                uninstall_service elasticsearch
                uninstall_service logstash
                uninstall_service kibana
                uninstall_service suricata
                uninstall_service zeek
                uninstall_service datadog-agent
                ;; 
            2) 
                remove_package wazuh-agent
                remove_package elasticsearch
                remove_package logstash
                remove_package kibana
                remove_package suricata
                remove_package zeek
                remove_package datadog-agent
                remove_package git
                remove_package build-essential
                ;; 
            3) clean_logs ;; 
            0) echo "Saliendo..."; exit 0 ;; 
            *) echo "Opción inválida"; sleep 2 ;;
        esac
        echo "Presiona Enter para volver al menú..."
        read -r
    done
}

# Inicio
clear
ascii_art
main_menu
