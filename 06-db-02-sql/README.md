# Практическое задание по теме «SQL»

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

Скачаем образ `postgres:12`:

```bash
╰─➤  docker pull postgres:12
╰─➤  docker images
REPOSITORY             TAG           IMAGE ID       CREATED        SIZE
postgres               12            185652ba8110   21 hours ago   371MB
...
```

Настроим [YAML-манифест](docker/docker-compose.yaml) и запустим `docker-compose`:

```bash
╰─➤  docker-compose up -d
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

Для создания таблиц, пользователей и присвоения прав воспользуемся [скриптом](docker/sql/init.sql). Перезапустим `docker-compose` и зайдём в `psql`:

```bash
╰─➤  docker exec -it netology_postgres /bin/bash -c "psql -U postgres"
```

1. Итоговый список БД:

```sql
test_db=# \d
          List of relations
 Schema |  Name   | Type  |  Owner
--------+---------+-------+----------
 public | clients | table | postgres
 public | orders  | table | postgres
(2 rows)
```

2. Описание таблиц (describe)

```sql
test_db=# \d clients
                                          Table "public.clients"
    Column    |          Type          | Collation | Nullable |                  Default
--------------+------------------------+-----------+----------+--------------------------------------------
 client_id    | integer                |           | not null | nextval('clients_client_id_seq'::regclass)
 last_name    | character varying(256) |           | not null |
 country_name | character varying(256) |           | not null |
 order_id     | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (client_id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)
                         
test_db=# \d orders
                                        Table "public.orders"
  Column  |          Type          | Collation | Nullable |                 Default
----------+------------------------+-----------+----------+------------------------------------------
 order_id | integer                |           | not null | nextval('orders_order_id_seq'::regclass)
 name     | character varying(256) |           | not null |
 price    | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)
```

3. SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT table_name, grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name IN ('clients', 'orders')
  AND grantee <> 'postgres';
```

4. Список пользователей с правами над таблицами test_db

```sql
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
(22 rows)
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

Добавим SQL-скрипт [insert.sql](docker/sql/init.sql), скопируем его в контейнер и запустим команду:

```bash
docker exec -it netology_postgres /bin/bash -c "psql -U postgres -d test_db -f 'insert.sql'"
```

Выполним запросы:

```sql
test_db=# SELECT count(*) FROM Orders;
 count
-------
     5
(1 row)

test_db=# SELECT count(*) FROM Clients;
 count
-------
     5
(1 row)
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказка - используйте директиву `UPDATE`.

Добавим SQL-скрипт [update.sql](docker/sql/update.sql), скопируем его в контейнер и запустим команду:

```bash
docker exec -it netology_postgres /bin/bash -c "psql -U postgres -d test_db -f 'update.sql'"
```

Запрос:

```sql
SELECT c.last_name, o.name
FROM Clients c
INNER JOIN Orders o
        ON o.order_id = c.order_id;
```

Результат:

```sql
      last_name       |  name
----------------------+---------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)
```


## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```sql
EXPLAIN 
SELECT c.last_name, o.name
FROM Clients c
INNER JOIN Orders o
        ON o.order_id = c.order_id;
```

Результат

```sql
                              QUERY PLAN
----------------------------------------------------------------------
 Hash Join  (cost=1.11..2.19 rows=5 width=1032)
   Hash Cond: (c.order_id = o.order_id)
   ->  Seq Scan on clients c  (cost=0.00..1.05 rows=5 width=520)
   ->  Hash  (cost=1.05..1.05 rows=5 width=520)
         ->  Seq Scan on orders o  (cost=0.00..1.05 rows=5 width=520)
(5 rows)
```

Видим план выполнения запроса. Ключевые операторы: 
- `Seq Scan` — последовательный перебор строк таблицы;
- `Hash Cond` — условие для соединения с помощью хеш-таблицы;
- `Hash Join` — соединение с помощью хеш-таблицы.

План запроса измеряется в так называемых (условных) единицах стоимости (`cost`). Чем выше значения стоимости, тем дольше будет выполняться запрос. Атрибут `rows` указывает на количество обрабатываемых строк. Запрос читается снизу вверх.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

Создадим dump БД `test_db` в контейнере `netology_postgres`: 

```bash
╰─➤  docker exec -it netology_postgres /bin/bash
pg_dump -U postgres -W test_db > /dump/test_db.sql
```

Затем зайдём в консоль контейнера `netology_postgres_copy` и восстановим БД в контейнере `netology_postgres_copy`:

```bash
╰─➤  docker exec -it netology_postgres_copy /bin/bash

psql -U postgres -c 'create database test_db;'
psql -U postgres test_db < /dump/test_db.sql
```

Проверим данные в `test_db.clients`:

```sql
psql -U postgres test_db -c "select * from clients;"
 client_id |      last_name       | country_name | order_id
-----------+----------------------+--------------+----------
         4 | Ронни Джеймс Дио     | Russia       |
         5 | Ritchie Blackmore    | Russia       |
         1 | Иванов Иван Иванович | USA          |        3
         2 | Петров Петр Петрович | Canada       |        4
         3 | Иоганн Себастьян Бах | Japan        |        5
```