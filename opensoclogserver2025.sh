#!/bin/bash
# Autor: p0pc0rninj4 y la IA
# OpenSOC Log Server v2025 - versión ligera con Grafana/Loki/Promtail

set -euo pipefail
LOG_FILE="/var/log/opensoc_logserver_install.log"
exec > >(tee -i "$LOG_FILE") 2>&1

clear
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

echo "Bienvenido a OpenSOC Log Server v2025 - Ligero"

# Actualizar sistema
echo "Actualizando sistema..."
sudo apt-get update -y && sudo apt-get dist-upgrade -y

# Instalar herramientas básicas
echo "Instalando herramientas básicas..."
sudo apt-get install -y curl htop net-tools jq tmux python3 python3-pip wget gnupg2 software-properties-common

# Instalar rsyslog como servidor de logs
echo "Instalando y configurando Rsyslog como servidor..."
sudo apt-get install -y rsyslog
sudo systemctl enable rsyslog
sudo systemctl start rsyslog

# Crear directorio centralizado para logs y corregir permisos
sudo mkdir -p /var/log/opensoc
if getent group syslog >/dev/null; then
    sudo chown root:syslog /var/log/opensoc
else
    sudo chown root:root /var/log/opensoc
fi
sudo chmod 750 /var/log/opensoc

# Configuración Rsyslog para recibir logs remotos
sudo tee /etc/rsyslog.d/50-opensoc.conf > /dev/null <<EOL
module(load="imudp")
input(type="imudp" port="514")
module(load="imtcp")
input(type="imtcp" port="514")
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
*.* /var/log/opensoc/opensoc.log
EOL
sudo systemctl restart rsyslog

# Instalar Grafana
echo "Instalando Grafana..."
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
sudo apt-get update -y
sudo apt-get install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Instalar Loki
echo "Instalando Loki..."
wget https://github.com/grafana/loki/releases/download/v2.9.1/loki-linux-amd64.zip
unzip loki-linux-amd64.zip
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo chmod +x /usr/local/bin/loki
sudo mkdir -p /etc/loki
sudo tee /etc/loki/loki-config.yaml > /dev/null <<EOL
auth_enabled: false
server:
  http_listen_port: 3100
ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
  chunk_idle_period: 5m
  chunk_block_size: 262144
  chunk_retention_period: 1h
schema_config:
  configs:
    - from: 2020-10-15
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h
storage_config:
  boltdb_shipper:
    active_index_directory: /var/loki/index
    cache_location: /var/loki/cache
    shared_store: filesystem
  filesystem:
    directory: /var/loki/chunks
limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
EOL
sudo mkdir -p /var/loki/index /var/loki/cache /var/loki/chunks
sudo chown -R $(whoami):$(whoami) /var/loki
sudo tee /etc/systemd/system/loki.service > /dev/null <<EOL
[Unit]
Description=Loki Log Aggregator
After=network.target

[Service]
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/loki-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki

# Instalar Promtail
echo "Instalando Promtail..."
wget https://github.com/grafana/loki/releases/download/v2.9.1/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo chmod +x /usr/local/bin/promtail
sudo tee /etc/promtail/promtail-config.yaml > /dev/null <<EOL
server:
  http_listen_port: 9080
positions:
  filename: /tmp/positions.yaml
clients:
  - url: http://localhost:3100/loki/api/v1/push
scrape_configs:
  - job_name: opensoc_logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: opensoc
          __path__: /var/log/opensoc/*.log
EOL
sudo tee /etc/systemd/system/promtail.service > /dev/null <<EOL
[Unit]
Description=Promtail Log Agent
After=network.target

[Service]
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail/promtail-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOL
sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail

# Menú web en Flask para control de servicios
sudo pip3 install flask
tee ~/opensoc_logserver_web.py > /dev/null <<'EOF'
from flask import Flask, render_template_string, send_file
import subprocess, os
app = Flask(__name__)

TEMPLATE = '''
<!doctype html>
<title>OpenSOC Log Server</title>
<h1>OpenSOC Log Server v2025 - Ligero</h1>
<ul>
  <li><a href="/start_services">Iniciar servicios</a></li>
  <li><a href="/stop_services">Detener servicios</a></li>
  <li><a href="/view_logs">Descargar logs</a></li>
</ul>
'''
@app.route('/')
def index():
    return render_template_string(TEMPLATE)

@app.route('/start_services')
def start_services():
    subprocess.run(['sudo','systemctl','start','rsyslog','loki','promtail','grafana-server'])
    return "Servicios iniciados. <a href='/'>Volver</a>"

@app.route('/stop_services')
def stop_services():
    subprocess.run(['sudo','systemctl','stop','rsyslog','loki','promtail','grafana-server'])
    return "Servicios detenidos. <a href='/'>Volver</a>"

@app.route('/view_logs')
def view_logs():
    path = '/var/log/opensoc/opensoc.log'
    if os.path.exists(path):
        return send_file(path, as_attachment=True)
    return "No hay logs aún. <a href='/'>Volver</a>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=1337)
EOF

echo "Instalación completada! Inicia el menú web con: python3 ~/opensoc_logserver_web.py"
echo "Abre http://<IP_DEL_SERVIDOR>:1337 para controlar el Log Server y Grafana en http://<IP_DEL_SERVIDOR>:3000"
