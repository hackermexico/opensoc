# opensoc
Tools for make deployment of open source SOC - for monitoring and secure a lot of hosts - Windows and Linux agents event threat intel and response from IPS

OpenSOC es un framework modular para la instalación y gestión de herramientas de seguridad en sistemas Linux, especialmente orientado a VPS. Permite desplegar un entorno completo de Red Team / Blue Team / DFIR de forma rápida y segura, con soporte para limpieza total mediante un uninstaller dedicado.

Características principales

Instalador modular con menú interactivo.

Banner ASCII original conservado.

Instalación de herramientas y servicios esenciales:

Sistema y herramientas básicas: git, build-essential, curl, htop, net-tools, jq, tmux.

Blue Team: Wazuh Agent.

Detección de red: Suricata, Zeek.

SIEM/Logging: ELK Stack (ElasticSearch, Logstash, Kibana).

Respuesta a incidentes: TheHive + Cortex.

DFIR: Velociraptor.

Monitoring: Datadog Agent.

Escaneo rápido de puertos con Nmap.

Barra de progreso visual y logs en /var/log/opensoc_install.log.

Buenas prácticas: set -euo pipefail, validación de variables de entorno.

Menú para gestión avanzada y ejecución controlada.

Uninstaller

Script modular para desinstalar servicios y paquetes instalados por OpenSOC.

Limpieza de logs (/var/log/opensoc_*.log).

Detención y deshabilitación de servicios (systemctl stop/disable).

Desinstalación de paquetes (apt-get remove --purge).

Logs de desinstalación en /var/log/opensoc_uninstall.log.
