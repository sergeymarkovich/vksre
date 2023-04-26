# Занятие 5 - Основы баз данных
## Что можно добавить:
1) Подключение через ssh тунель используя библиотеку **paramiko**
2) еще посмотреть https://pyneng.readthedocs.io/ru/latest/book/18_ssh_telnet/scrapli.html
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
- **script.sh** - bash скрипт, который выполняет все описанные в следующем пункте последовательности

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

### Перед тем как делать дамп, на сервере:
1) Заходим в psql `sudo -u postgres psql` или в root postgres `sudo su - postgres`  
2) Создаем пользователя admini `create user admini with password 'toortoor'`
3) Создаем database **testdb** `create database testdb;`
4) Выдаем привелегии пользователю **admini** на database `GRANT ALL PRIVILEGES ON DATABASE testdb TO admini;`
5) После чего тестим `psql -h 127.0.0.1 -U admini testdb`

### Чтобы скрипт ходил на сервер, нужно настроить postgres на принятие пакетов с 0.0.0.0
1) `sudo nano /etc/postgresql/12/main/postgresql.conf`
Отредактируйте этот файл, измените параметр listen_addresses на значение '*' изменив строку: 

- `listen_addresses = '*'          # what IP address(es) to listen on;`

2) в файл pg_hba.conf добавьте правило, которое разрешает удаленное подключение к базе данных `sudo nano /etc/postgresql/12/main/pg_hba.conf` 
 и добавляем строку
- `host    all             all             0.0.0.0/0               md5`

3) `sudo systemctl restart postgresql.service`