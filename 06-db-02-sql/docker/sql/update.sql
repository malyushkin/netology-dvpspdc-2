\c test_db;

UPDATE Clients
SET order_id = 3
WHERE client_id = 1;

UPDATE Clients
SET order_id = 4
WHERE client_id = 2;

UPDATE Clients
SET order_id = 5
WHERE client_id = 3;