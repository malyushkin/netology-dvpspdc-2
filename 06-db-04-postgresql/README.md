# Практическое задание по теме «PostgreSQL»

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

### Ход работы

Настроим [Docker манифест](docker/docker-compose.yaml) и запустим `docker-compose`:

```shell
docker-compose up -d --remove-orphans
docker-compose ps
       Name                      Command              State    Ports
----------------------------------------------------------------------
netology_postgresql   docker-entrypoint.sh postgres   Up      5432/tcp
```

Зайдём в `psql` созданного контейнера и введём команду `\?`:

```shell
docker exec -it netology_postgresql psql -U postgres

postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
  \g [(OPTIONS)] [FILE]  execute query (and send results to file or |pipe);
...
```

Список необходимых команд:

* `\l[+] [PATTERN]` — вывод списка БД;
* `\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}` — подключение к БД;
* `\d[S+]` — вывод списка таблиц;
* `\d[S+] NAME` — вывод описания содержимого таблиц;
* `\q` — выход из psql.

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

### Ход работы

Создадим базу данных `test_database` и проверим её наличие командой `\l`: 

```shell
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# \l
                                   List of databases
     Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
---------------+----------+----------+------------+------------+-----------------------
 postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
               |          |          |            |            | postgres=CTc/postgres
 test_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```

Для восстановления бэкапа выйдем из `psql`. На гостевой машине выполним команду: 

```shell
psql -U postgres test_database < home/romanm/test_dump.sql
```

Вернёмся в `psql` и проверим наличие таблицы:

```postgresql
postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# \dt public.
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)
```

Выполним `ANALYZE` таблицы `public.orders`: 

```postgresql
test_database=# ANALYZE public.orders;
ANALYZE
```

Проанализируем view `pg_stats`:

```postgresql
test_database=# select tablename, attname, avg_width from pg_stats where tablename = 'orders';
 tablename | attname | avg_width
-----------+---------+-----------
 orders    | id      |         4
 orders    | title   |        16
 orders    | price   |         4
(3 rows)
```

Наибольшее среднее значение размера элементов в байтах: 16 (атрибут `title`).

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

### Ход работы

Для разбиения на шарды создадим новые таблицы `orders_1` и `orders_2`. С помощью инструкции `INSERT` вставим записи в соответствующую таблицу:

```postgresql
-- orders_1: price>499
CREATE TABLE orders_1 (CHECK (price > 499)) INHERITS (orders);
INSERT INTO orders_1 SELECT * FROM orders where price > 499;

-- orders_2: price<=499
CREATE TABLE orders_2 (CHECK (price <= 499)) INHERITS (orders);
INSERT INTO orders_2 SELECT * FROM orders where price <= 499;
```

При начальном проектировании можно было исследовать подход [секционирования таблиц](https://postgrespro.ru/docs/postgresql/10/ddl-partitioning#DDL-PARTITIONING-DECLARATIVE-BEST-PRACTICES). 

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

### Ход работы

На гостевой машине выполним команду: 

```shell
pg_dump -U postgres test_database > home/romanm/test_dump_new.sql
```

Доработаем инструкцию `CREATE` и добавим ограничение `UNIQUE`:

```sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) UNIQUE,
    price integer DEFAULT 0
);
```
