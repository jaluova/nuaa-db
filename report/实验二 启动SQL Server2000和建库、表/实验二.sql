DROP DATABASE IF EXISTS Demo;
CREATE DATABASE Demo CHARACTER SET utf8mb4;
SHOW DATABASES;
USE Demo;

DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    customid VARCHAR(17) PRIMARY KEY,
    name     VARCHAR(10),
    sex      VARCHAR(2),
    age      INT,
    xfg      DECIMAL(10, 2),
    address  VARCHAR(50),
    Joindate DATE,
    memo     VARCHAR(100)
);

DESC customer;