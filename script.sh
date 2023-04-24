#!/bin/bash

# качаем dump.csv
wget https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv

# преобразуем dump.csv в норм вид для иморта в бд
sudo python3 encoding.py

# запуск pg в docker 
sudo docker-compose --project-name="test-pg" up -d

# ждем пока прогрузит контейнер
sleep 15

# копируем dump_output.csv в докер
sudo cp dump_output.csv ./docker-volume/pgdata

# заходим в psql
echo "toortoor" | psql -h 127.0.0.1 -U admini -d test-db

# создаем таблицу dump
psql -h 127.0.0.1 -U admini -d test-db -c "CREATE TABLE dump (ip text, domain text, url text, organization text, number text, date date);"

# загружаем данные из датасета
psql -h 127.0.0.1 -U admini -d test-db -c "COPY dump FROM '/var/lib/postgresql/data/pgdata/dump_output.csv' WITH (FORMAT CSV, NULL '', DELIMITER ';', HEADER TRUE);"

# выходим из psql
echo "\q" | psql -h 127.0.0.1 -U admini -d test-db

# запускаем скрипт для работы с бд и проверки функционала
python3 pgscript.py

# создаем дамп резервной копии в файл backup_docker.dump
pg_dump -U admini -h 127.0.0.1 test-db > backup_docker.dump
