\c test_db;

INSERT INTO Orders (name, price)
VALUES ('Шоколад', 10),
       ('Принтер', 3000),
       ('Книга', 500),
       ('Монитор', 7000),
       ('Гитара', 4000);

INSERT INTO Clients (last_name, country_name)
VALUES ('Иванов Иван Иванович', 'USA'),
       ('Петров Петр Петрович', 'Canada'),
       ('Иоганн Себастьян Бах', 'Japan'),
       ('Ронни Джеймс Дио', 'Russia'),
       ('Ritchie Blackmore', 'Russia');