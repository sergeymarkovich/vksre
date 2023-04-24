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

## необходимые зависимости:
`pip install psycopg2-binary`

`pip install pandas`

## про файлы в репе
- **encoding.py** - приводит в датасет в кайф вид. на входе читается dump.csv. Pandas приводит его к норм виду. На выходе dump_output.csv
- **pgscript.py** - скрипт для подключения к pg. На выбор несколько опций. Первый выбор - свой sql запрос или работа с определенным столбцом. При выборе первого варианта вводится sql выражение. При выборе второго варианта выбирается номер столбца. Следующий выбор - получение статистики по столбцу или ввод своего значения для просмотра на наличие в данном столбце.
- **docker-compose.yml** - поднимает контейнер с указанными в нем параметрами 
- script.sh - bash скрипт, который выполняет все описанные в следующем пункте последовательности

## Последовательность действий для решения задания

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