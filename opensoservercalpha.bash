#!/bin/bash
# Autor: p0pc0rninj4 y la IA


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

# Función para mostrar un arte ASCII
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

# Script principal
clear
ascii_art
echo "Bienvenido a OPENSOC"
echo "Ejecutando el script..."

# Instrucciones de instalación de Bash
echo "Realizando la instalación de Bash:"
echo "1. apt-get update"
sudo apt-get update -y
echo "2. apt-get dist-upgrade"
sudo apt-get dist-upgrade -y
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
sudo apt-get install nmap -y
echo "10. nmap localhost"
nmap localhost

# Simulando algún proceso
duracion_total=10
for ((i=0; i<$duracion_total; i++)); do
    progress_bar $duracion_total
done

# Instalación de git y build-essential
echo "Instalando git y build-essential..."
sudo apt-get install git build-essential -y

# Mensaje final
echo "¡100% éxito! ¡Gracias totales por usar OpenSOC!"
