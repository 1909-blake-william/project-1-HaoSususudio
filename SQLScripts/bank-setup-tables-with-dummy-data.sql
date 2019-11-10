ALTER SESSION SET TIME_ZONE='-5:00';
---------Delete old stuff--------------------------
DROP SEQUENCE account_id_seq;
DROP SEQUENCE user_id_seq;
DROP SEQUENCE transaction_id_seq;
DROP TRIGGER account_id_trig;
DROP TRIGGER user_id_trig;
DROP TRIGGER transaction_id_trig;
--DROP PROCEDURE update_account;
--DROP PROCEDURE new_user_login;
--DROP PROCEDURE new_user_info;
DROP TABLE transaction_log;
DROP TABLE account;
DROP TABLE user_info;
DROP TABLE user_login;
----------------------TABLES---------------------------
CREATE TABLE user_login
(
    username varchar2(20) PRIMARY KEY,
    secure_key varchar2(24) NOT NULL,
    salt_for_password varchar2(24) NOT NULL,
    role varchar2(10) DEFAULT 'customer' NOT NULL
);
  CREATE TABLE user_info
(
    user_id int PRIMARY KEY,
    username varchar2(20) REFERENCES user_login(username),
    first_name varchar2(20),
    last_name varchar2(20),
    phone_number varchar2(20),
    email varchar2(50) 
);
  CREATE TABLE account
(
    account_id int PRIMARY KEY,
    owner_username varchar2(20) REFERENCES user_login(username),
    account_type varchar2(15),
    designation varchar2(20),
    unit varchar2(15),
    balance number(12,2) DEFAULT 0,
    account_status varchar2(15) DEFAULT 'active' NOT NULL
);
CREATE TABLE transaction_log
(
    transaction_id int PRIMARY KEY,
    account_id int REFERENCES account(account_id),
    transaction_type varchar2(15),
    delta_balance number(12,2) DEFAULT 0,
    time_stamp TIMESTAMP-- WITH TIME ZONE
);
--------------------Sequences for ID assignment --------------------------
CREATE SEQUENCE user_id_seq; 
CREATE SEQUENCE account_id_seq; 
CREATE SEQUENCE transaction_id_seq;
---------------------TRIGGERS----------------------------------
CREATE OR REPLACE TRIGGER account_id_trig
BEFORE INSERT OR UPDATE ON account
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        SELECT account_id_seq.nextval INTO :new.account_id FROM dual;
    ELSIF UPDATING THEN
        SELECT :old.account_id INTO :new.account_id FROM dual;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER user_id_trig
BEFORE INSERT OR UPDATE ON user_info
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        SELECT user_id_seq.nextval INTO :new.user_id FROM dual;
    ELSIF UPDATING THEN
        SELECT :old.user_id INTO :new.user_id FROM dual;
    END IF;
END;
/
CREATE OR REPLACE TRIGGER transaction_id_trig
BEFORE INSERT OR UPDATE ON transaction_log
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        SELECT transaction_id_seq.nextval INTO :new.transaction_id FROM dual;
    ELSIF UPDATING THEN
        SELECT :old.transaction_id INTO :new.transaction_id FROM dual;
    END IF;
END;
/
---------------------PROCEDURES----------------------------------
CREATE OR REPLACE PROCEDURE new_user_login
(
    username IN varchar2,
    secure_key IN varchar2,
    salt IN varchar2
)
AS
BEGIN
    INSERT INTO user_login(username, secure_key, salt_for_password)
    VALUES (username, secure_key, salt);
END;
/
CREATE OR REPLACE PROCEDURE new_user_info
(
    username IN varchar2,
    first_name IN varchar2,
    last_name IN varchar2,
    phone_number IN varchar2,
    email IN varchar2,
    generated_id OUT int
)
AS
BEGIN
    INSERT INTO user_info(username, first_name, last_name, phone_number, email)
    VALUES (username, first_name, last_name, phone_number, email)
    RETURNING user_id INTO generated_id;
END;
/
CREATE OR REPLACE PROCEDURE create_new_account
(
    owner_username IN varchar2,
    account_type IN varchar2,
    designation IN varchar2,
    unit IN varchar2,
    balance IN number,
    generated_id OUT int
)
AS
BEGIN
    INSERT INTO account(owner_username, account_type, designation, unit, balance)
    VALUES (owner_username, account_type, designation, unit, balance)
    RETURNING account_id INTO generated_id;
END;
/
CREATE OR REPLACE PROCEDURE update_account
(
    account_id_in IN account.account_id%TYPE,
    balance_in IN account.balance%TYPE,
    account_status_in IN account.account_status%TYPE
)
AS
BEGIN
    UPDATE account
    SET balance = balance_in, account_status = account_status_in
    WHERE account_id = account_id_in;
END;
/
CREATE OR REPLACE PROCEDURE insert_transaction_log
(
    account_id IN int,
    transaction_type IN varchar2,
    delta_balance IN number,
    generated_id OUT int
)
AS
BEGIN
    INSERT INTO transaction_log(account_id, transaction_type, delta_balance, time_stamp)
    VALUES (account_id, transaction_type, delta_balance, SYSDATE)
    RETURNING transaction_id INTO generated_id;
END;
/
---------------------DUMMY DATA INSERTION-----------------------------------------
SET SERVEROUTPUT ON
DECLARE gen_id int;
BEGIN
    new_user_login('mickey', 'RR1lFw6Ll8bbyBX/RfwQTQ==' ,'ChnFQQqYl8JUKBuRlNHF1A==');
    new_user_login('chip', 'YKdlCHGaXu4k18nU5evfBA==' ,'oAkxJeAq8NpTtZsvF+cNJg==');
    new_user_login('dale', '3XXMb2TNK8K5ssrmcPepBg==' ,'XiXA5pB+ftrTQqEhpDs/qQ==');
    new_user_login('pluto', '9GWplpIvllyQQAy4CiUgWg==', 'z8l6xGh2lRNF6+68jp5gzA==');
    new_user_login('donaldduck', 'uZH898cC8VYZVHeoCzX6LQ==','flo/5f/mwEKZQViCAhp7mQ==');
    new_user_login('whinniethepooh', 'gY5npUOBFZ3GnfS6VX7nIQ==','tyWhPi0AbTfNERQzKeRqcQ==');
    new_user_info('mickey', 'Mickey', 'von Sewer', '+1-000-265-9875', 'mickeymouse@disney.com', gen_id);
    new_user_info('chip', 'Chip', 'Bigtooth', '516.454.0981', 'info@chippendales.com', gen_id );
    new_user_info('dale', 'Dale', 'Rednose', '516.454.0981', 'daletherednosechipmunk@chippendales.com', gen_id);
    new_user_info('pluto', 'Pluto', 'Bonedigger', 'barkwoofbarkbark', 'pluto@disney.com', gen_id);
    new_user_info('donaldduck', 'Donald', 'Truck', '25687', 'potus@wh.gov', gen_id);
    new_user_info('whinniethepooh', 'Winnie', 'Xi', '8699504523', 'wxjp@163.com', gen_id);
    create_new_account('mickey', 'currency', 'USD', 'dollar', 2354645.24, gen_id);
    create_new_account('mickey', 'currency', 'RMB', 'yuan', 53365.50, gen_id);
    create_new_account('chip', 'commodity', 'acron', 'count', 652, gen_id);
    create_new_account('dale', 'commodity', 'acron', 'count', 0, gen_id);
    create_new_account('dale', 'currency', 'USD', 'dollar', -23.52, gen_id);
    create_new_account('mickey', 'commodity', 'acron', 'count', 54782, gen_id);
    create_new_account('mickey', 'commodity', 'bone', 'count', 3, gen_id);
    create_new_account('chip', 'currency', 'USD', 'dollar', 36500.00, gen_id);
    create_new_account('dale', 'currency', 'USD', 'dollar', 300.90, gen_id);
    create_new_account('dale', 'commodity', 'acron', 'count', 23, gen_id);
    create_new_account('pluto', 'commodity', 'bone', 'count', 1, gen_id);
    create_new_account('mickey', 'commodity', 'gold_nugget', 'ounce', 2335, gen_id);
    create_new_account('mickey', 'commodity', 'honey', 'kilogram', 453, gen_id);
    create_new_account('donaldduck', 'commodity', 'gold_nugget', 'ounce', 3556, gen_id);
    create_new_account('donaldduck', 'currency', 'USD', 'dollar', 684235.54, gen_id);
    create_new_account('donaldduck', 'currency', 'RMB', 'yuan', 584235.00, gen_id);
    create_new_account('whinniethepooh', 'commodity', 'honey', 'count', 2, gen_id);
    create_new_account('whinniethepooh', 'currency', 'USD', 'dollar', 25632145, gen_id);
    create_new_account('whinniethepooh', 'currency', 'RMB', 'yuan',8563668.00, gen_id);
    insert_transaction_log(  1 ,'deposit', 20, gen_id);
    insert_transaction_log(  1 ,'withdraw', 20, gen_id);
    insert_transaction_log(  1 ,'deposit', 30, gen_id);
    insert_transaction_log(  1 ,'deposit', 20, gen_id);
END;
/
UPDATE  user_login
SET     role = 'admin'
WHERE   username = 'mickey';
UPDATE  user_login
SET     role = 'manager'
WHERE   username = 'chip';
UPDATE  user_login
SET     role = 'manager'
WHERE   username = 'dale';
COMMIT;

-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES(  1 ,'deposit', 20, SYSDATE);
-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES( 1 ,'deposit', 20, SYSDATE);
-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES(  1 ,'deposit', 20, SYSDATE);
-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES( 1 ,'deposit', 20, SYSDATE);
-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES(  1 ,'deposit', 20, SYSDATE);
-- INSERT INTO transaction_log( account_id, transaction_type, delta_balance, time_stamp)
-- VALUES( 1 ,'deposit', 20, SYSDATE);


----------SHOW DUMMY DATA----------------------------
SELECT * FROM user_login;
SELECT * FROM user_info;
SELECT * FROM account;
SELECT * FROM transaction_log;