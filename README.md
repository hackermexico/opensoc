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


OPENSOCLOG SERVER para VPS 

OpenSOC Log Server es una versión ligera y modular de OpenSOC diseñada para VPS. Su función principal es centralizar y recibir logs de sistemas y servicios, almacenarlos y ofrecer visualización y control a través de un menú web interactivo.

Componentes principales

Rsyslog

Recibe logs locales y remotos vía UDP/TCP (puerto 514).

Centraliza todos los logs en /var/log/opensoc/opensoc.log.

Grafana

Dashboard web para visualización de logs y métricas.

Puerto web: 3000.

Loki

Motor de almacenamiento de logs optimizado para Grafana.

Ligero, sin la sobrecarga de ELK Stack.

Promtail

Agente que lee los archivos de logs y los envía a Loki.

Escucha en /var/log/opensoc/*.log.

Menú Web en Flask

Interfaz simple en http://<IP_DEL_SERVIDOR>:1337.

Funciones: iniciar/detener servicios y descargar logs.

Totalmente independiente de Grafana; solo controla servicios y facilita acceso a logs.
