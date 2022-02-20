-- создайте пользователя test-admin-user
CREATE USER "test-admin-user";

-- БД test_db
CREATE DATABASE test_db;
\c test_db;

-- в test_db создайте таблицу orders
CREATE TABLE IF NOT EXISTS Orders (
    order_id SERIAL NOT NULL,
    name varchar(256) NOT NULL,
    price INT,
    PRIMARY KEY (order_id)
);

-- и clients
CREATE TABLE IF NOT EXISTS Clients (
    client_id SERIAL NOT NULL,
    last_name varchar(256) NOT NULL,
    country_name varchar(256) NOT NULL,
    order_id INT,
    PRIMARY KEY (client_id),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA "public" TO "test-admin-user";

-- создайте пользователя test-simple-user
CREATE USER "test-simple-user";

-- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA "public" TO "test-simple-user";
