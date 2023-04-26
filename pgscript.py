import psycopg2
import sys

# Установление соединения с базой данных
try:
    conn = psycopg2.connect(
        host="localhost", # заменить на адрес сервера
        port="5432",
        database="testdb",
        user="admini",
        password="toortoor"
    )
    print("Соединение с базой данных установлено успешно!")
except psycopg2.Error as e:
    print(f"Ошибка подключения к базе данных: {e}")
    sys.exit(1)

# функция для получения значений из стандартного ввода
def get_input():
    option_1 = input("---------------------\n Привет, выбирай, ввести свое sql выражение или выбрать столбец, чтобы получить информацию по нему\n где 1 - свой sql запрос, 2 - выбор столбца: ")
    if option_1 == "1":
        sql = input("Введите sql выражение: ")
        return sql
    elif option_1 == "2":
        column_num = input("---------------------\n Выберите номер столбца цифрой от 1 до 6 \n где нумерация 1 - ip, 2 - domain, 3 - url, 4 - organization, 5 - number, 6 - date:")
        option_2 = input("Выберите действие (1 - вывод статистики по выбранному столбцу, 2 - поиск по введенному значению в данном столбце):")
        if option_2 == "1":
            column_name = ["ip", "domain", "url", "organization", "number", "date"][int(column_num)-1]
            sql = f"SELECT {column_name}, COUNT(*) FROM dump GROUP BY {column_name}"
            return sql
        elif option_2 == "2":
            search_value = input("Введите значение для поиска: ")
            column_name = ["ip", "domain", "url", "organization", "number", "date"][int(column_num)-1]
            sql = f"SELECT * FROM dump WHERE {column_name} = '{search_value}'"
            return sql
    else:
        return None
    
while True:
    sql = get_input()
    if sql is None:
        break
    cursor = conn.cursor()
    cursor.execute(sql)
    rows = cursor.fetchall()
    for row in rows:
        print(row)
    cursor.close()


# закрытие соединения с бд
conn.close()
print("Соединение с базой данных закрыто")
