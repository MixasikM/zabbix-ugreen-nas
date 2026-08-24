# 🚀 Zabbix 7.0 Agent 2 for UGREEN NAS (UGOS Pro)

[![Docker Multi-Arch](https://img.shields.io/badge/docker-amd64%20%7C%20arm64-blue)](https://github.com/MixasikM/zabbix-ugreen-nas/pkgs/container/zabbix-ugreen-nas)
[![Zabbix](https://img.shields.io/badge/zabbix-7.0%20LTS-orange)](https://www.zabbix.com)
[![UGOS Pro](https://img.shields.io/badge/UGOS%20Pro-Supported-green)](https://www.ugreen.com)

[**English**](#english) | [**Русский**](#русский)

---

<a name="english"></a>
## 🇬🇧 English

Pre-configured, zero-friction **Zabbix Agent 2** for **UGREEN NAS (UGOS Pro)**. No need to apply for developer certificates, use SSH, or share private device SN/MAC with vendor.

### ✨ Features
* 📦 **Pre-packaged UserParameters**: Built-in monitoring for UGOS Pro OS version, Fan Speeds, CPU/Board Temps, S.M.A.R.T., RAID/Btrfs health, and UPS status.
* 📋 **All-in-One Zabbix 7.0 Master Templates**:
  * 🌟 Passive Checks: [`templates/template_ugreen_nas.yaml`](templates/template_ugreen_nas.yaml)
  * ⚡ Active Checks: [`templates/template_ugreen_nas_active.yaml`](templates/template_ugreen_nas_active.yaml)
* 🐳 **Multi-Arch Docker**: Supports both **x86_64 / amd64** (Intel/AMD models) and **arm64** (ARM models).
* 🔒 **PSK Encryption Ready**: Pre-configured variables for PSK identity and 64-char hex key.
* ⚡ **1-Click Web GUI Deployment**: Deploy directly via UGOS Container Manager in your browser — zero SSH required!

---

### 🚀 Recommended GUI Method (UGOS Container Manager in Browser)

1. Open **Container Manager** in UGOS Pro Web UI -> **Project** -> **Create project**.
2. **Name**: Enter `zabbix-agent2`.
3. **Storage path**: Click 📁 icon and select a folder (e.g. `Shared folder/docker/zabbix-agent2`).
4. **Compose configuration**: Paste the YAML snippet below into the text editor (or click `Import` -> `Import from the local computer` to upload `docker-compose.yml`):

```yaml
services:
  zabbix-agent2:
    image: ghcr.io/mixasikm/zabbix-ugreen-nas:latest
    container_name: zabbix-agent2
    restart: always
    network_mode: host
    cap_add:
      - SYS_RAWIO
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /dev:/dev:ro
      - /etc/os-release:/host/etc/os-release:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    environment:
      ZBX_SERVER_HOST: "192.168.1.X"               # Passive checks: Allowed Zabbix Server / Proxy IPs
      ZBX_SERVER_ACTIVE_HOST: "192.168.1.X"        # Active checks: Target Zabbix Server / Proxy FQDN or IP
      ZBX_HOSTNAME: "Ugreen-NAS"                  # Hostname registered in Zabbix Frontend
      ZBX_LISTENPORT: 10055                       # Agent Listen Port
      ZBX_TIMEOUT: 20

      # Optional PSK Encryption (Uncomment if using PSK in Zabbix)
      # ZBX_TLSCONNECT: "psk"
      # ZBX_TLSACCEPT: "psk"
      # ZBX_TLSPSKIDENTITY: "PSK_Ugreen_NAS"
      # ZBX_TLSPSKVALUE: "4210555551184425b819e3a513d6c0f64210555551184425b819e3a513d6c0f6"
```

5. Replace `"192.168.1.X"` with your Zabbix Server / Proxy IP and click **Deploy**.
6. Import the template of your choice into Zabbix 7.0 (**Data collection** -> **Templates** -> **Import**):
   * 🌟 Passive Checks: [`templates/template_ugreen_nas.yaml`](templates/template_ugreen_nas.yaml)
   * ⚡ Active Checks: [`templates/template_ugreen_nas_active.yaml`](templates/template_ugreen_nas_active.yaml)
7. Assign **ONLY ONE** template to your UGREEN NAS host in Zabbix.

---

### ⚡ Alternative: SSH 1-Liner (For Power Users)

```bash
curl -fsSL https://raw.githubusercontent.com/MixasikM/zabbix-ugreen-nas/main/install.sh | bash -s -- --server 192.168.1.X --host Ugreen-NAS
```

---
---

<a name="русский"></a>
## 🇷🇺 Русский

Готовый **Zabbix Agent 2** для сетевых накопителей **UGREEN NAS (UGOS Pro)**. Не требует SSH, консолей, получения прав разработчика (`ugdev.sig`) или отправки серийных номеров в Ugreen.

---

### 🚀 Основной способ: Через веб-интерфейс NAS (Container Manager) — БЕЗ SSH!

1. Откройте **Container Manager** (Центр контейнеров) в веб-интерфейсе Ugreen NAS.
2. Перейдите в раздел **Project (Проекты)** -> нажмите **Create project (Создать проект)**.
3. Укажите поля по примеру:
   * **Name (Имя проекта):** `zabbix-agent2`
   * **Storage path (Путь хранения):** Нажмите 📁 `Select` и выберите папку (например, `Shared folder/docker/zabbix-agent2`).
   * **Compose configuration (Конфигурация):** Вставьте готовый текст `docker-compose.yml` (см. код выше).
4. В строках `ZBX_SERVER_HOST` и `ZBX_SERVER_ACTIVE_HOST` измените `"192.168.1.X"` на реальный IP/FQDN вашего Zabbix сервера или прокси.
5. *(Опционально)* Для шифрования PSK раскомментируйте строки `ZBX_TLSCONNECT`, `ZBX_TLSACCEPT`, `ZBX_TLSPSKIDENTITY` и `ZBX_TLSPSKVALUE` (вставьте 64-символьный hex-ключ).
6. Убедитесь, что стоит галочка `[x] Run immediately after creation` и нажмите синюю кнопку **Deploy**.
7. Импортируйте нужный шаблон в Zabbix 7.0 (**Сбор данных** -> **Шаблоны** -> **Импорт**):
   * 🌟 Пассивный режим: [`templates/template_ugreen_nas.yaml`](templates/template_ugreen_nas.yaml)
   * ⚡ Активный режим: [`templates/template_ugreen_nas_active.yaml`](templates/template_ugreen_nas_active.yaml)
8. Привяжите выбранный шаблон к вашему хосту Ugreen-NAS в Zabbix.
