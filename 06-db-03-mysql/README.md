# Практическое задание по теме «MySQL»

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.

В следующих заданиях мы будем продолжать работу с данным контейнером.

### Ход работы

Настроим [Docker манифест](docker/docker-compose.yaml) и запустим `docker-compose`.

```shell
docker-compose build
```

Зайдём в созданный контейнер:

```shell
╰─➤ docker-compose up -d --remove-orphans
╰─➤ docker exec -it netology_mysql /bin/bash
```

Восстановим дамп `test_dump.sql` в БД `netology`:

```shell
root@68348c44b40f:/# mysql

mysql> create database netology;
Query OK, 1 row affected (0.01 sec)
mysql> exit;

root@68348c44b40f:/# mysql netology < /home/romanm/test_dump.sql
```

Зайдём в консоль `mysql` и выполним команды `help` (`\h`) и `status` (`\s`):

```mysql
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.
query_attributes Sets string parameters (name1 value1 name2 value2 ...) for the next query to pick up.

For server side help, type 'help contents'

mysql> \s
--------------
mysql  Ver 8.0.28 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		12
Current database:
Current user:		root@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			7 min 24 sec

Threads: 2  Questions: 82  Slow queries: 0  Opens: 195  Flush tables: 3  Open tables: 113  Queries per second avg: 0.184
```

Подключимся к БД `netology` и выведем список таблиц:

```mysql
mysql> USE netology;
mysql> SHOW tables;
+--------------------+
| Tables_in_netology |
+--------------------+
| orders             |
+--------------------+
1 row in set (0.01 sec)
```

Количество записей в таблице `orders` с `price` > 300:

```mysql
mysql> SELECT count(*) FROM orders WHERE price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

### Ход работы

Для создания пользователя воспользуемся инструкцией `CREATE USER` со следующими настройками:

```mysql
mysql> CREATE USER 'test'@'localhost'
  IDENTIFIED WITH mysql_native_password BY 'test-pass' -- плагин авторизации mysql_native_password
  WITH MAX_QUERIES_PER_HOUR 100 -- максимальное количество запросов в час - 100
  PASSWORD EXPIRE INTERVAL 180 DAY -- срок истечения пароля - 180 дней
  FAILED_LOGIN_ATTEMPTS 3 -- количество попыток авторизации - 3
  ATTRIBUTE '{"fname": "James", "lname": "Pretty"}' -- аттрибуты пользователя
;
```

Проверим атрибуты пользователя `test`:

```mysql
mysql> SELECT user
     , plugin
     , password_lifetime
     , max_questions
     , User_attributes
FROM mysql.user
WHERE user = 'test';
+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
| user | plugin                | password_lifetime | max_questions | User_attributes                                                                                                                     |
+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
| test | mysql_native_password |               180 |           100 | {"metadata": {"fname": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
+------+-----------------------+-------------------+---------------+-------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)
```

Для предоставления прав на чтение воспользуемся инструкцией `GRANT`:

```mysql
mysql> GRANT SELECT ON netology.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```

Даннеые `information_schema.user_attributes`:

```mysql
SELECT * 
FROM information_schema.user_attributes 
WHERE user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`

### Ход работы

Установка профилирования:

```mysql
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)
```

Зафиксируем время выполнения запроса `SELECT * FROM orders WHERE price > 100;`: 

```mysql
mysql> SELECT * FROM orders WHERE price > 100;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
4 rows in set (0.00 sec)

mysql> SHOW profiles;
+----------+------------+----------------------------------------+
| Query_ID | Duration   | Query                                  |
+----------+------------+----------------------------------------+
|        1 | 0.00174250 | SELECT * FROM orders WHERE price > 100 |
+----------+------------+----------------------------------------+
1 row in set, 1 warning (0.00 sec)
```

Проверим движок:

```mysql
mysql> SELECT table_schema, table_name, engine
    -> FROM information_schema.tables
    -> WHERE table_name = 'orders';
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| netology     | orders     | InnoDB |
+--------------+------------+--------+
1 row in set (0.01 sec)
```

Используется движок `InnoDB`. Сменим на `MyISAM` и так же зафиксируем время выполнения: 

```mysql
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.18 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SELECT * FROM orders WHERE price > 100;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
4 rows in set (0.00 sec)

mysql> SHOW profiles;
+----------+------------+----------------------------------------+
| Query_ID | Duration   | Query                                  |
+----------+------------+----------------------------------------+
|        4 | 0.00059400 | SELECT * FROM orders WHERE price > 100 |
+----------+------------+----------------------------------------+
```

* **InnoDB**: Время выполнения: 0.00174250. 
* **MyISAM**: Время выполнения: 0.00059400.

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.

### Ход работы

Сохраним копию файла `/etc/mysql/my.cnf`:

```shell
cp /etc/mysql/my.cnf /etc/mysql/my.cnf.bak
```

Дополним файл my.cnf следующими строками (в порядке предъявляемых требований):

```shell
innodb_flush_method=O_DSYNC
innodb_flush_log_at_trx_commit=2
innodb_file_per_table=ON
innodb_log_buffer_size=1M
innodb_buffer_pool_size=2G
innodb_log_file_size=100M
```
