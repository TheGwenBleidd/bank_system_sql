---Создается БД
CREATE DATABASE productsdb;

USE project;

---Таблица Страны
CREATE TABLE Countries(
	ID INT,
    CountryCode VARCHAR(30),
    CountryName VARCHAR(400)
);

---Таблица Города
CREATE TABLE Cities(
	ID INT,
    CityCode VARCHAR(30),
    CityName VARCHAR(400)
);

---Клиенты банка
CREATE TABLE BankClients(
	ID INT,
    FullName VARCHAR(400),
    CountryId INT,
    CityId INT,
    Address VARCHAR(400),
    UniqueIdentityNumber VARCHAR(12),
    Birthday DATE
);

---Создается первичные ключи
ALTER TABLE countries
ADD primary key (ID);

ALTER TABLE cities
ADD primary key (ID);

ALTER TABLE bankclients
ADD primary key (ID);

---Создается внешние ключи
ALTER TABLE bankclients
ADD foreign key(CountryId) references countries(ID);

alter table bankclients
add foreign key(CityId) references cities(ID);

---Столбец изменяется на уникальный
alter table bankclients
ADD unique(UniqueIdentityNumber);

---Записи в БД
INSERT into countries values (1, '1', 'United Kingdom');
INSERT into countries values (2, '2', 'USA');
INSERT into countries values (3, '3', 'Russia');
INSERT into countries values (4, '4', 'Kazakhstan');
INSERT into countries values (5, '5', 'China');
INSERT into countries values (6, '6', 'Uzbekistan');
INSERT into countries values (7, '7', 'Turkey');
INSERT into countries values (8, '8', 'Switzerland');
INSERT into countries values (9, '9', 'Germany');
INSERT into countries values (10, '10', 'Poland');

INSERT into cities values (1, '1', 'London');
INSERT into cities values (2, '2', 'Washington');
INSERT into cities values (3, '3', 'Moscow');
INSERT into cities values (4, '4', 'Almaty');
INSERT into cities values (5, '5', 'Beijing');
INSERT into cities values (6, '6', 'Tashkent');
INSERT into cities values (7, '7', 'Istambul');
INSERT into cities values (8, '8', 'Bern');
INSERT into cities values (9, '9', 'Berlin');
INSERT into cities values (10, '10', 'Warsaw');

insert into bankclients values(2, 'John Smith', '2', '2', 'street 32, house 21', '123456789101', '1990/04/03');
insert into bankclients values(3, 'Andrey Ivanov', '3', '3', 'street 12, house 43', '123456789123', '1995/03/03');
insert into bankclients values(4, 'Abraham Wilson', '2', '2', 'street 1, house 21', '453456789101', '1980/04/06');
insert into bankclients values(5, 'Konstantin Petrov', '3', '3', 'street 5', '125435678101', '2000/04/03');
insert into bankclients values(6, 'Baglan Bostanov', '4', '4', 'street 90, house 3', '321456789101', '1993/01/01');
insert into bankclients values(7, 'Asylbek Abdualiev', '4', '4', 'street 2, house 2', '123786789101', '1999/04/03');
insert into bankclients values(8, 'Maria Mironova', '3', '3', 'street 21, house 21', '523456789101', '1997/02/03');
insert into bankclients values(9, 'Michael Fischer', '9', '9', 'street 1, house 48', '101456789101', '2000/04/03');
insert into bankclients values(10, 'Bahrom Ustamberdiev', '6', '6', 'street 32, house 21', '12345678999', '1990/04/03');

---Изменяется имя столбца в таблице
UPDATE countries SET countries.CountryName = 'Kazakhstan Republic' WHERE countries.CountryName = 'Kazakhstan'

---Удаляется строка
DELETE FROM bankclients
WHERE bankclients.ID = 10;

---Сортировка клиентов по странам 
SELECT bankclients.FullName, countries.CountryName, cities.CityName, bankclients.Address, bankclients.UniqueIdentityNumber, bankclients.Birthday 
FROM countries 
inner join bankclients 
ON bankclients.CountryId = countries.ID
inner join cities
on bankclients.CityId = cities.ID;

---Создается таблица операции по счетам
CREATE TABLE account_transactions
(
	ID INT primary key auto_increment,
    TransactionType VARCHAR(30),
    ClientSender INT,
    ClientSenderAcc INT,
    ClientReceiver INT,
    ClientReceiverAcc INT,
    Amount decimal (18,3)
)

---Создается таблица счета
Create table Accounts(
	ID INT primary key auto_increment,
    ClientId INT,
    AccountNumber VARCHAR(15),
    AccountBalance decimal(18,3)
);

---Внешние ключи для таблиц account_transactions и Accounts
ALTER TABLE account_transactions
ADD foreign key(ClientSender) references bankclients(ID);

ALTER TABLE account_transactions
ADD foreign key(ClientSender) references accounts(ID);

ALTER TABLE account_transactions
ADD foreign key(ClientReceiver) references bankclients(ID);

ALTER TABLE account_transactions
ADD foreign key(ClientReceiverAcc) references accounts(ID);

ALTER TABLE accounts
ADD foreign key(ClientId) references bankclients(ID);

---Создается записи для счетов
insert into accounts values (1, 1, 'VQ3PWZQWKQ1X4KA' , 50000);
insert into accounts values (2, 2, 'TAMGZGHLFTICSQS' , 100000);
insert into accounts values (3, 3, 'QWOYN1XIST72LGN' , 60000);
insert into accounts values (4, 4, 'O37N1PUQZ7YRP4A' , 70000);
insert into accounts values (6, 6, 'PDZF1M5HKICP3R9' , 80000);
insert into accounts values (7, 7, 'OBZUOHTN8M0RLYZ' , 120000);
insert into accounts values (8, 8, 'INQFHABWT57ITIN' , 150000);
insert into accounts values (9, 9, 'G2K59NHW3QQQH9X' , 200000);

---Не смог создать триггер
---DELIMITER //
-- CREATE TRIGGER money_transfer1 
-- AFTER INSERT ON account_transactions 
-- FOR EACH ROW
-- BEGIN
-- 	UPDATE accounts SET accounts.AccountBalance = accounts.AccountBalance - Amount WHERE accounts.ID = ClientSenderAcc;
-- 	UPDATE accounts SET accounts.AccountBalance = accounts.AccountBalance + Amount WHERE accounts.ID = ClientReceiverAcc;	
-- END//
-- DELIMITER ;

---Операции Перевод Пополнение и Снятие логи записывается в таблицу account_transactions
UPDATE accounts 
set accounts.AccountBalance = accounts.AccountBalance - 1000 
WHERE accounts.AccountNumber = 'VQ3PWZQWKQ1X4KA';

UPDATE accounts 
set accounts.AccountBalance = accounts.AccountBalance + 1000 
WHERE accounts.AccountNumber = 'TAMGZGHLFTICSQS';

INSERT INTO account_transactions VALUES (1, 'money transfer', 1, 1, 2, 2, 1000); 

UPDATE accounts 
set accounts.AccountBalance = accounts.AccountBalance + 100000 
WHERE accounts.AccountNumber = 'F60RUEEIC4ANS6X';

INSERT INTO account_transactions VALUES (2, 'refill', 5, 5, 5, 5, 100000);

UPDATE accounts 
set accounts.AccountBalance = accounts.AccountBalance - 50000 
WHERE accounts.AccountNumber = 'OBZUOHTN8M0RLYZ';

INSERT INTO account_transactions VALUES (3, 'withdraw', 7, 7, 7, 7, 50000);

--Сортировка по странам и по городам
SELECT account_transactions.TransactionType, account_transactions.Amount, bankclients.FullName, countries.CountryName, cities.CityName
FROM account_transactions
INNER JOIN bankclients
ON bankclients.ID = account_transactions.ClientSender
INNER JOIN countries
ON bankclients.ID = countries.ID
INNER JOIN cities
ON bankclients.ID = cities.ID;


---Группировка клиентов по городам
SELECT cities.CityName, COUNT(bankclients.FullName)
FROM cities
inner join bankclients
on bankclients.CityId = cities.ID
group by CityName;

---Группировка клиентов по странам
SELECT countries.CountryName, COUNT(bankclients.FullName)
FROM countries
inner join bankclients
on bankclients.CountryId = countries.ID
group by CountryName;
