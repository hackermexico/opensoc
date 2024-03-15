#!/bin/bash

# Función para mostrar una barra de progreso
# Adaptada de: https://unix.stackexchange.com/a/449510
progress_bar() {
    local duracion=${1}

    ya_hecho() { for ((hecho=0; hecho<$transcurrido; hecho++)); do printf "▇"; done }
    restante() { for ((resta=$transcurrido; resta<$duracion; resta++)); do printf " "; done }
    porcentaje() { printf "| %s%%" $(( (($transcurrido)*100)/($duracion)*100/100 )); }
    limpiar_linea() { printf "\r"; }

    for (( transcurrido=1; transcurrido<=$duracion; transcurrido++ )); do
        ya_hecho; restante; porcentaje
        sleep 1
        limpiar_linea
    done

    ya_hecho; restante; porcentaje
    echo ""
}

# Función para mostrar un arte ASCII relacionado a la seguridad
ascii_art() {
cat << "EOF"
    ____                  _      _____ _       
   / _ \__      ___ __ _| | __ |_   _| | __ _ 
  / /_\/\ \ /\ / / '__| | |/ /   | | | |/ _` |
 / /_\\\ \ V  V /| |  | |   <    | | | | (_| |
 \____/ \_/\_/ |_|  |_|_|\_\   |_| |_|\__,_|
                                            
EOF
}

# Script principal
clear
ascii_art
echo "Bienvenido a OPENsoc"
echo "Ejecutando el script..."

# Historial de instalación de Bash
echo "Realizando el historial de instalación de Bash:"
echo "1. apt-get update"
sudo apt-get update
echo "2. apt-get upgrade"
sudo apt-get upgrade
echo "3. wget -q -O - https://updates.atomicorp.com/installers/oum | bash"
wget -q -O - https://updates.atomicorp.com/installers/oum | bash
echo "4. oum update"
oum update
echo "5. oum configure"
oum configure
echo "6. oum update"
oum update
echo "7. DD_API_KEY=f890acfe0d569f30aaf961eead1bdfe9 DD_SITE=\"us3.datadoghq.com\" bash -c \"\$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)\""
DD_API_KEY=f890acfe0d569f30aaf961eead1bdfe9 DD_SITE="us3.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script_agent7.sh)"
echo "8. nmap localhost"
nmap localhost
echo "9. apt-get install nmap"
sudo apt-get install nmap
echo "10. nmap localhost"
nmap localhost

# Simulando algún proceso
duracion_total=10
for ((i=0; i<$duracion_total; i++)); do
    progress_bar $duracion_total
done

# Control de errores
echo "Revisando errores..."
if [ $? -eq 0 ]; then
    echo "¡No se encontraron errores!"
else
    echo "¡Error detectado!"
fi

echo "¡Script completado!"
