#!/bin/bash
# Uninstaller de OpenSOC Log Server v2025
# Autor: p0pc0rninj4 + IA

set -euo pipefail

echo "[*] Deteniendo servicios..."
sudo systemctl stop promtail loki grafana-server rsyslog || true
sudo systemctl disable promtail loki grafana-server rsyslog || true

echo "[*] Eliminando archivos de configuración..."
sudo rm -rf /etc/loki /etc/promtail /etc/rsyslog.d/50-opensoc.conf
sudo rm -f /etc/systemd/system/loki.service /etc/systemd/system/promtail.service

echo "[*] Eliminando directorios de logs..."
sudo rm -rf /var/log/opensoc /var/loki

echo "[*] Eliminando binarios descargados..."
sudo rm -f /usr/local/bin/loki /usr/local/bin/promtail

echo "[*] Eliminando entorno virtual de Flask..."
rm -rf ~/opensoc_env
rm -f ~/opensoc_logserver_web.py

echo "[*] Recargando systemd para limpiar servicios..."
sudo systemctl daemon-reload

echo "[*] Desinstalando Grafana..."
sudo apt-get remove --purge -y grafana
sudo apt-get autoremove -y

echo "[*] Desinstalación completa. El sistema está limpio de OpenSOC Log Server v2025."
