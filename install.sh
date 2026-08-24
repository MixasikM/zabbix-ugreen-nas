#!/bin/bash
# Zabbix Agent 2 for UGREEN NAS (UGOS Pro) Installer Script

set -e

# Default values
ZBX_SERVER=""
ZBX_SERVER_ACTIVE=""
ZBX_HOSTNAME="Ugreen-NAS"
IMAGE="ghcr.io/mixasikm/zabbix-ugreen-nas:latest"

# PSK Encryption variables
ZBX_PSK_ID=""
ZBX_PSK_KEY=""

# Parse command line flags
while [[ $# -gt 0 ]]; do
  case $1 in
    --server)
      ZBX_SERVER="$2"
      shift 2
      ;;
    --server-active)
      ZBX_SERVER_ACTIVE="$2"
      shift 2
      ;;
    --host)
      ZBX_HOSTNAME="$2"
      shift 2
      ;;
    --psk-id)
      ZBX_PSK_ID="$2"
      shift 2
      ;;
    --psk-key)
      ZBX_PSK_KEY="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

# Interactive prompt if ZBX_SERVER is missing
if [ -z "$ZBX_SERVER" ]; then
  echo "======================================================"
  echo "  UGREEN NAS (UGOS Pro) Zabbix Agent 2 Installer"
  echo "======================================================"
  read -p "Enter Zabbix Server / Proxy IP or FQDN: " ZBX_SERVER
fi

if [ -z "$ZBX_SERVER" ]; then
  echo "Error: Zabbix Server IP is required."
  exit 1
fi

if [ -z "$ZBX_SERVER_ACTIVE" ]; then
  ZBX_SERVER_ACTIVE="$ZBX_SERVER"
fi

echo "--> Pulling latest Zabbix Agent 2 image for UGREEN NAS..."
docker pull "$IMAGE"

echo "--> Stopping existing zabbix-agent2 container if present..."
docker stop zabbix-agent2 2>/dev/null || true
docker rm zabbix-agent2 2>/dev/null || true

ENV_FLAGS=(
  -e ZBX_SERVER_HOST="$ZBX_SERVER"
  -e ZBX_SERVER_ACTIVE_HOST="$ZBX_SERVER_ACTIVE"
  -e ZBX_HOSTNAME="$ZBX_HOSTNAME"
  -e ZBX_LISTENPORT=10055
  -e ZBX_TIMEOUT=20
)

# Add PSK encryption flags if provided
if [ -n "$ZBX_PSK_ID" ] && [ -n "$ZBX_PSK_KEY" ]; then
  ENV_FLAGS+=(
    -e ZBX_TLSCONNECT="psk"
    -e ZBX_TLSACCEPT="psk"
    -e ZBX_TLSPSKIDENTITY="$ZBX_PSK_ID"
    -e ZBX_TLSPSKVALUE="$ZBX_PSK_KEY"
  )
fi

echo "--> Launching Zabbix Agent 2 container..."
docker run -d \
  --name zabbix-agent2 \
  --restart always \
  --net host \
  --cap-add SYS_RAWIO \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /dev:/dev:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  "${ENV_FLAGS[@]}" \
  "$IMAGE"

echo "======================================================"
echo " SUCCESS! Zabbix Agent 2 is now running on UGREEN NAS!"
echo " Zabbix Server : $ZBX_SERVER"
echo " Active Server : $ZBX_SERVER_ACTIVE"
echo " Hostname      : $ZBX_HOSTNAME"
echo " Listen Port   : 10055"
if [ -n "$ZBX_PSK_ID" ]; then
  echo " PSK Identity  : $ZBX_PSK_ID"
fi
echo "======================================================"
