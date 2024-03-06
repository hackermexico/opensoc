#!/bin/bash

# Ruta del archivo de configuración
ARCHIVO_CONFIG="instalador.conf"

# Función para leer un valor de configuración
leer_valor_config() {
  clave="$1"
  grep -q "^$clave=" "$ARCHIVO_CONFIG" && sed -n "s/^$clave=//p" "$ARCHIVO_CONFIG"
}

# Función para instalar un paquete
# - Admite el nombre del paquete y la URL del repositorio opcional como argumentos
instalar_paquete() {
  nombre_paquete="$1"
  url_repositorio="$2"
  exito=0

  # Verifica si el paquete ya está instalado
  if dpkg -l "$nombre_paquete" | grep -q instalado; then
    echo "$nombre_paquete: ya está instalado"
  else
    echo "Instalando $nombre_paquete..."
    if [ -z "$url_repositorio" ]; then
      sudo apt update &> /dev/null && sudo apt install -y "$nombre_paquete"
    else
      # Agrega el repositorio e instala si es necesario
      sudo apt-add-repository -y "$url_repositorio" && sudo apt update && sudo apt install -y "$nombre_paquete"
    fi
    if [ $exito -eq 1 ]; then
      echo "$nombre_paquete: instalado con éxito"
    else
      echo "Error al instalar $nombre_paquete"
    fi
  fi
}

# Función para instalar una herramienta específica
# - Toma el nombre de la herramienta y un puntero a la función como argumentos
instalar_herramienta() {
  nombre_herramienta="$1"
  funcion_instalacion="$2"

  # Verifica si la herramienta ya está definida en una función
  if type -t "$funcion_instalacion" &> /dev/null; then
    $funcion_instalacion
  else
    echo "Error: Función de instalación '$funcion_instalacion' no encontrada para $nombre_herramienta."
  fi
}

# ... (las funciones de instalación de herramientas existentes permanecen sin cambios o se actualizan)

# Función principal para instalar todas las herramientas
instalar_todo() {
  for herramienta in $(cat "$ARCHIVO_CONFIG" | grep -w "^herramienta=[^=]*=" | cut -d= -f2-); do
    nombre_herramienta=$(echo "$herramienta" | cut -d: -f1)
    funcion_instalacion=$(echo "$herramienta" | cut -d: -f2-)
    instalar_herramienta "$nombre_herramienta" "$funcion_instalacion"
  done
}

# Función para mostrar el menú de instalación
mostrar_menu() {
  # Arte ASCII de OpenSOC
  echo "                     _   _ _   _
                    | | | | | | |
                    | | | | | | |
                    | |_| |_| | |
                    |_   _____| |
                     | | |     | |
                     |_| |_____|_|

             Bienvenido a la instalación de OpenSOC

    1. Verificar requisitos previos
    2. Actualizar el sistema
    3. Instalar dependencias
    4. Clonar el repositorio OpenSOC
    5. Compilar e instalar OpenSOC
    6. Configurar OpenSOC
        6.1 Copiar archivo de configuración
        6.2 Editar archivo de configuración
    7. Iniciar OpenSOC
    8. Verificar estado del servicio
    9. Acceder a la interfaz web
   10. Salir

   Ingrese el número de la opción deseada: "
}

# Función para obtener la opción del usuario
obtener_opcion() {
  read -r opcion
  case $opcion in
    1) verificar_requisitos_previos ;;
    2) actualizar_sistema ;;
    3) instalar_dependencias ;;
    4) clonar_repositorio_opensoc ;;
    5) compilar_e_instalar_opensoc ;;
    6) configurar_opensoc ;;
    7) iniciar_opensoc ;;
    8) verificar_estado_del_servicio ;;
    9) acceder_a_la_interfaz_web ;;
    10) exit 0 ;;
    *) echo "Opción no válida. Elija una opción del 1 al 10." ;;
  esac
}

# Bucle principal del menú
while true; do
  mostrar_menu
  obtener_opcion
done

