#!/bin/bash
# Autor: p0pc0rninj4 y la IA
# OpenSOC v2025

set -euo pipefail
LOG_FILE="/var/log/opensoc_install.log"
exec > >(tee -i "$LOG_FILE") 2>&1

# Banner original
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

# Barra de progreso
progress_bar() {
    local duracion=${1}
    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duracion; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duracion)*100/100 )); }
    clean_line() { printf "\r"; }
    for (( elapsed=1; elapsed<=$duracion; elapsed++ )); do
        already_done; remaining; percentage
        sleep 1
        clean_line
    done
    already_done; remaining; percentage
    echo ""
}

# Funciones de instalación
install_system_update() {
    echo "Actualizando sistema..."
    sudo apt-get update -y && sudo apt-get dist-upgrade -y
}

install_basic_tools() {
    echo "Instalando herramientas básicas: git, build-essential, curl, htop, net-tools, jq, tmux..."
    sudo apt-get install -y git build-essential curl htop net-tools jq tmux
}

install_wazuh_agent() {
    echo "Instalando Wazuh Agent..."
    # ejemplo simplificado
    sudo apt-get install -y wazuh-agent || echo "Revisar repositorio Wazuh"
}

install_suricata_zeek() {
    echo "Instalando Suricata y Zeek..."
    sudo apt-get install -y suricata zeek || echo "Ver repos oficiales para últimas versiones"
}

install_elk_stack() {
    echo "Instalando ElasticSearch + Logstash + Kibana..."
    sudo apt-get install -y elasticsearch logstash kibana || echo "Ver instalación oficial ELK"
}

install_thehive_cortex() {
    echo "Instalando TheHive + Cortex..."
    # placeholder
    echo "TheHive y Cortex deben instalarse desde repositorio oficial"
}

install_velociraptor() {
    echo "Instalando Velociraptor (DFIR)..."
    sudo apt-get install -y velociraptor || echo "Ver documentación oficial Velociraptor"
}

install_datadog_agent() {
    echo "Instalando Datadog Agent..."
    if [[ -z "${DD_API_KEY:-}" ]]; then
        read -rp "Introduce tu DD_API_KEY: " DD_API_KEY
    fi
    DD_SITE=${DD_SITE:-"us3.datadoghq.com"}
    bash -c "\$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
}

scan_nmap() {
    echo "Ejecutando escaneo rápido con Nmap en localhost..."
    nmap localhost
}

# Menú interactivo
main_menu() {
    while true; do
        clear
        ascii_art
        echo "OpenSOC v2025"
        echo "1) Actualizar sistema"
        echo "2) Instalar herramientas básicas"
        echo "3) Instalar Wazuh Agent"
        echo "4) Instalar Suricata + Zeek"
        echo "5) Instalar ELK Stack"
        echo "6) Instalar TheHive + Cortex"
        echo "7) Instalar Velociraptor"
        echo "8) Instalar Datadog Agent"
        echo "9) Escaneo rápido Nmap"
        echo "0) Salir"
        read -rp "Selecciona una opción: " choice
        case $choice in
            1) install_system_update ;; 
            2) install_basic_tools ;; 
            3) install_wazuh_agent ;; 
            4) install_suricata_zeek ;; 
            5) install_elk_stack ;; 
            6) install_thehive_cortex ;; 
            7) install_velociraptor ;; 
            8) install_datadog_agent ;; 
            9) scan_nmap ;; 
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
echo "Bienvenido a OpenSOC v2025"
main_menu
