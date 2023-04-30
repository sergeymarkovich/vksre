# Занятие 6 - Мониторинг сервиса
## Задание:
1) Установить Prometheus https://prometheus.io/download/

2) Установить и настроить node_exporter https://github.com/prometheus/node_exporter

3) Установить Grafana https://grafana.com/oss/grafana/

4) Добавить в Grafana Prometheus как источник данных

5) Настроить стандартный дашборд состояния системы https://grafana.com/grafana/dashboards/1860-node-exporter-full/

## Решение 
https://www.dmosk.ru/miniinstruktions.php?mini=prometheus-stack-docker

1) Создаем каталоги, где будем создавать наши файлы:
`mkdir -p /opt/prometheus_stack/{prometheus,grafana,alertmanager,blackbox}`
2) Создаем файл `touch /opt/prometheus_stack/docker-compose.yml`
3) И переходим в каталог `cd /opt/prometheus_stack`
4) Настраиваем Prometheus + Node Exporter
- `sudo nano docker-compose.yml`
```
version: '3.7'

services:

  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus:/etc/prometheus/
    container_name: prometheus
    hostname: prometheus
    command:
      - --config.file=/etc/prometheus/prometheus.yml
    ports:
      - 9090:9090
    restart: unless-stopped
    environment:
      TZ: "Europe/Moscow"
    networks:
      - default

  node-exporter:
    image: prom/node-exporter
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    container_name: exporter
    hostname: exporter
    command:
      - --path.procfs=/host/proc
      - --path.sysfs=/host/sys
      - --collector.filesystem.ignored-mount-points
      - ^/(sys|proc|dev|host|etc|rootfs/var/lib/docker/containers|rootfs/var/lib/docker/overlay2|rootfs/run/docker/netns|rootfs/var/lib/docker/aufs)($$|/)
    ports:
      - 9100:9100
    restart: unless-stopped
    environment:
      TZ: "Europe/Moscow"
    networks:
      - default

networks:
  default:
    ipam:
      driver: default
      config:
        - subnet: 172.28.0.0/16
```

В данном примере мы создаем 2 сервиса — prometheus и node-exporter. Также мы отдельно определили подсеть 172.28.0.0/16, в которой будут находиться наши контейнеры docker.

5) Создаем конфигурационный файл для prometheus:
`sudo nano nano prometheus/prometheus.yml`
```
scrape_configs:
  - job_name: node
    scrape_interval: 5s
    static_configs:
    - targets: ['node-exporter:9100']
```
В данном примере мы прописываем наш node-exporter в качестве таргета.

6) Запускаем контейнеры: `sudo docker-compose up -d`

7) Открываем браузер и переходим по адресу http://<IP-адрес сервера>:9090 — мы должны увидеть страницу Prometheus. Переходим по адресу http://<IP-адрес сервера>:9100 — мы должны увидеть страницу Node Exporter:

8) Добавим к нашему стеку графану.
`sudo nano docker-compose.yml`
```
version: '3.7'

services:
  ...
  grafana:
    image: grafana/grafana
    user: root
    depends_on:
      - prometheus
    ports:
      - 3000:3000
    volumes:
      - ./grafana:/var/lib/grafana
      - ./grafana/provisioning/:/etc/grafana/provisioning/
    container_name: grafana
    hostname: grafana
    restart: unless-stopped
    environment:
      TZ: "Europe/Moscow"
    networks:
      - default

...
```

9) Перезапустим контейнеры:
`sudo docker-compose up -d`

10) Открываем браузер и переходим по адресу http://<IP-адрес сервера>:3000 — мы должны увидеть стартовую страницу Grafana. Для авторизации вводим admin / admin. После система потребует ввести новый пароль.

11) Настроим связку с Prometheus. Кликаем по иконке Configuration - Data Sources. Переходим к добавлению источника, нажав по Add data source. Среди списка источников данных находим и выбираем Prometheus, кликнув по Select. Задаем параметры для подключения к Prometheus: `http://prometheus:9090`.
Сохраняем настройки, кликнув по Save & Test:


12) Добавим дашборд для мониторинга с node exporter. Для этого уже есть готовый вариант. Кликаем по изображению плюса и выбираем Import. Вводим идентификатор дашборда. Для Node Exporter это **1860**. Кликаем Load — Grafana подгрузит дашборд из своего репозитория — выбираем в разделе Prometheus наш источник данных и кликаем по Import