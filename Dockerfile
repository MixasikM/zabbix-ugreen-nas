FROM zabbix/zabbix-agent2:alpine-7.0-latest

LABEL maintainer="Mixasik"
LABEL description="Zabbix Agent 2 pre-configured for UGREEN NAS (UGOS Pro) monitoring"

# Copy UGOS Pro custom parameters into Zabbix agent config directories
COPY zabbix_agent2.d/ugos.conf /etc/zabbix/zabbix_agent2.d/ugos.conf
COPY zabbix_agent2.d/ugos.conf /etc/zabbix/zabbix_agent2.d/plugins.d/ugos.conf
