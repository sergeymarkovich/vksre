# Занятие 5 - Основы баз данных
## Задание для практического занятия
1) Загрузить базу реестра https://github.com/zapret-info/z-i/blob/master/dump.csv разобраться в структуре
2) Установить на сервер postgres 
3) Запустить postgres в докере
4) Перенести информацию из дампа в базу в pg 
5) Сделать утилиту на python, которая выбирает из базы информацию по ip или домену
6) Сделать подсчет статистики по базе (количество решение/ip/доменов)
7) Сделать бэкап базы и перенести её из докера на сервер
8) Сделать копию скрипта, который ходит на сервер вместо докера

## Последовательность действий для решения задания

### необходимые зависимости:
`pip install psycopg2-binary`

`pip install pandas`

- для скачивания датасета вводим `wget https://raw.githubusercontent.com/zapret-info/z-i/master/dump.csv`
- преобразуем **dump.csv** в **dump_output.csv** для иморта в pg запуском питоновского скрипта, который использует библиотеку pandas `sudo python3 encoding.py`
- поднимаем docker-compose file `sudo docker-compose --project-name="test-pg" up -d`
- заходим в pg в докере `psql -h 127.0.0.1 -U admini -d test-db`
- добавляем туда таблицу **dump**
```
CREATE TABLE dump 
(                       
    ip text,
    domain text,
    url text,
    organization text,
    number text,
    date date
);
```
- добавляем данные из cvs файла
`COPY dump FROM '/var/lib/postgresql/data/pgdata/dump_output.csv' WITH(FORMAT CSV, NULL '', DELIMITER ';', HEADER TRUE);`

- запускаем скрипт для работы с бд и проверки функционала `python3 pgscript.py`

### DUMP
Дамп можно сделать командой `pg_dump -U admini -h 127.0.0.1 test-db > backup_docker.dump`

Импортировать дамп можно только в существующую дб командой `psql -U admini -h 127.0.0.1 test-db < backup_docker.dump`