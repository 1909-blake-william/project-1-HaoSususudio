---------Delete old stuff--------------------------
DROP SEQUENCE reimb_id_seq;
DROP SEQUENCE reimb_status_id_seq;
DROP SEQUENCE reimb_type_id_seq;
DROP SEQUENCE ers_users_id_seq;
DROP SEQUENCE ers_user_role_id_seq;
DROP TRIGGER reimb_id_trig;
DROP TRIGGER reimb_status_id_trig;
DROP TRIGGER reimb_type_id_trig;
DROP TRIGGER ers_users_id_trig;
DROP TRIGGER ers_user_role_id_trig;
DROP TABLE ers_reimbursement;
DROP TABLE ers_reimbursement_status;
DROP TABLE ers_reimbursement_type;
DROP TABLE ers_users;
DROP TABLE ers_user_roles;
----------------------TABLES---------------------------
CREATE TABLE ers_user_roles (
  ers_user_role_id number PRIMARY KEY,
  user_role varchar2(10) NOT NULL
);
CREATE TABLE ers_users (
  ers_users_id number PRIMARY KEY,
  ers_username varchar2(50) UNIQUE NOT NULL,
  ers_secure_key varchar2(50) NOT NULL,
  ers_salt varchar2(50) NOT NULL,
  user_first_name varchar2(100) NOT NULL,
  user_last_name varchar2(100) NOT NULL,
  user_email varchar2(150) UNIQUE NOT NULL,
  user_role_id number REFERENCES ers_user_roles(ers_user_role_id)
);
CREATE TABLE ers_reimbursement_status (
  reimb_status_id number PRIMARY KEY,
  reimb_status varchar2(10) NOT NULL
);
CREATE TABLE ers_reimbursement_type (
  reimb_type_id number PRIMARY KEY,
  reimb_type varchar2(10) NOT NULL
);
CREATE TABLE ers_reimbursement (
  reimb_id number PRIMARY KEY,
  reimb_amount number(19, 2) NOT NULL,
  reimb_submitted timestamp NOT NULL,
  reimb_resolved timestamp,
  reimb_description varchar2(250),
  reimb_author number NOT NULL REFERENCES ers_users(ers_users_id),
  reimb_resolver number REFERENCES ers_users(ers_users_id),
  reimb_status_id number NOT NULL REFERENCES ers_reimbursement_status(reimb_status_id),
  reimb_type_id number NOT NULL REFERENCES ers_reimbursement_type(reimb_type_id)
);
--------------------Sequences for ID assignment --------------------------
CREATE SEQUENCE reimb_id_seq;
CREATE SEQUENCE reimb_status_id_seq;
CREATE SEQUENCE reimb_type_id_seq;
CREATE SEQUENCE ers_users_id_seq;
CREATE SEQUENCE ers_user_role_id_seq;
---------------------TRIGGERS----------------------------------
CREATE OR REPLACE 
TRIGGER reimb_id_trig BEFORE
INSERT OR UPDATE ON ers_reimbursement
FOR EACH ROW 
BEGIN 
  IF INSERTING THEN
    SELECT reimb_id_seq.nextval INTO :new.reimb_id
    FROM dual;
  ELSIF UPDATING THEN
    SELECT :old.reimb_id INTO :new.reimb_id
    FROM dual;
  END IF;
END;
/
CREATE OR REPLACE 
TRIGGER reimb_status_id_trig BEFORE
INSERT OR UPDATE ON ers_reimbursement_status
FOR EACH ROW 
BEGIN 
  IF INSERTING THEN
    SELECT reimb_status_id_seq.nextval INTO :new.reimb_status_id
    FROM dual;
  ELSIF UPDATING THEN
    SELECT :old.reimb_status_id INTO :new.reimb_status_id
    FROM dual;
  END IF;
END;
/
CREATE OR REPLACE 
TRIGGER reimb_type_id_trig BEFORE
INSERT OR UPDATE ON ers_reimbursement_type
FOR EACH ROW 
BEGIN 
  IF INSERTING THEN
    SELECT reimb_type_id_seq.nextval INTO :new.reimb_type_id
    FROM dual;
  ELSIF UPDATING THEN
    SELECT :old.reimb_type_id INTO :new.reimb_type_id
    FROM dual;
  END IF;
END;
/
CREATE OR REPLACE 
TRIGGER ers_users_id_trig BEFORE
INSERT OR UPDATE ON ers_users
FOR EACH ROW 
BEGIN 
  IF INSERTING THEN
    SELECT ers_users_id_seq.nextval INTO :new.ers_users_id
    FROM dual;
  ELSIF UPDATING THEN
    SELECT :old.ers_users_id INTO :new.ers_users_id
    FROM dual;
  END IF;
END;
/
CREATE OR REPLACE 
TRIGGER ers_user_role_id_trig BEFORE
INSERT OR UPDATE ON ers_user_roles
FOR EACH ROW 
BEGIN 
  IF INSERTING THEN
    SELECT ers_user_role_id_seq.nextval INTO :new.ers_user_role_id
    FROM dual;
  ELSIF UPDATING THEN
    SELECT :old.ers_user_role_id INTO :new.ers_user_role_id
    FROM dual;
  END IF;
END;
/
----------------------PROCEDURE FOR DATA MANUPULATION-------------
CREATE OR REPLACE PROCEDURE new_ers_user
(
  ers_username IN varchar2,
  ers_secure_key IN varchar2,
  ers_salt IN varchar2,
  user_first_name IN varchar2,
  user_last_name IN varchar2,
  user_email IN varchar2,
  user_role_id IN number,
  generated_id OUT number
)
AS
BEGIN
  INSERT INTO ers_users(ers_username, ers_secure_key, ers_salt
    , user_first_name,user_last_name, user_email, user_role_id)
  VALUES (ers_username, ers_secure_key, ers_salt
    , user_first_name,user_last_name, user_email, user_role_id)
  RETURNING ers_users_id INTO generated_id;
END;
/
CREATE OR REPLACE PROCEDURE request_new_reimbursement
(
  reimb_amount IN number,
  reimb_description IN varchar2,
  reimb_author IN number,
  reimb_type_id IN number,
  generated_id OUT number
)
AS
BEGIN
  INSERT INTO ers_reimbursement(reimb_amount, reimb_submitted, reimb_description, 
    reimb_author, reimb_status_id, reimb_type_id)
  VALUES (reimb_amount, CURRENT_TIMESTAMP, reimb_description,
    reimb_author, 1, reimb_type_id)
  RETURNING reimb_id INTO generated_id;
END;
/
CREATE OR REPLACE PROCEDURE update_reimb_status
(
  in_reimb_id IN ers_reimbursement.reimb_id%TYPE,
  in_reimb_status_id IN ers_reimbursement.reimb_id%TYPE,
  in_reimb_resolver IN ers_reimbursement.reimb_resolver%TYPE
)
AS
BEGIN
  UPDATE ers_reimbursement
  SET reimb_resolver = in_reimb_resolver, reimb_resolved = CURRENT_TIMESTAMP, reimb_status_id = in_reimb_status_id
  WHERE reimb_id = in_reimb_id;
END;
/
-------------------FUNCTIONS FOR DATA QUERRY-------------------------
CREATE OR REPLACE PROCEDURE get_all_reimbursements
(
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    reimb.reimb_author, reimb.reimb_resolver, sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  ORDER BY reimb.reimb_id;
END;
/
CREATE OR REPLACE PROCEDURE get_reimb_by_id
(
  in_reimb_id IN int,
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    reimb.reimb_author, reimb.reimb_resolver, sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  LEFT JOIN ers_users author ON (reimb.reimb_author = author.ers_users_id)
  WHERE reimb.reimb_id = in_reimb_id;
END;
/
CREATE OR REPLACE PROCEDURE get_reimb_by_author
(
  in_author_username IN varchar2,
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    reimb.reimb_author, reimb.reimb_resolver, sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  LEFT JOIN ers_users author ON (reimb.reimb_author = author.ers_users_id)
  WHERE author.ers_username = in_author_username
  ORDER BY reimb.reimb_id;
END;
/
CREATE OR REPLACE PROCEDURE get_reimb_by_status
(
  in_reimb_status IN varchar2,
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    reimb.reimb_author, reimb.reimb_resolver, sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  LEFT JOIN ers_users author ON (reimb.reimb_author = author.ers_users_id)
  WHERE sta.reimb_status = in_reimb_status
  ORDER BY reimb.reimb_id;
END;
/
CREATE OR REPLACE PROCEDURE get_reimb_by_author_and_status
(
  in_author_username IN varchar2,
  in_reimb_status IN varchar2,
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    reimb.reimb_author, reimb.reimb_resolver, sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  LEFT JOIN ers_users author ON (reimb.reimb_author = author.ers_users_id)
  WHERE author.ers_username = in_author_username AND sta.reimb_status = in_reimb_status
  ORDER BY reimb.reimb_id;
END;
/
CREATE OR REPLACE PROCEDURE get_all_user_info
(
  out_cursor_user_info OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_user_info FOR
  SELECT ers_users_id, ers_username, user_first_name, user_last_name, user_email, u_role.user_role
  FROM ers_users u
  LEFT JOIN ers_user_roles u_role ON (u.user_role_id = u_role.ers_user_role_id)
  ORDER BY u.ers_users_id;
END;
/
CREATE OR REPLACE PROCEDURE get_user_info_by_username
(
  in_username IN varchar2,
  out_cursor_user_info OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_user_info FOR
  SELECT ers_users_id, ers_username, user_first_name, user_last_name, user_email, u_role.user_role
  FROM ers_users u
  LEFT JOIN ers_user_roles u_role ON (u.user_role_id = u_role.ers_user_role_id)
  WHERE u.ers_username = in_username
  ORDER BY u.ers_users_id;
END;
/
CREATE OR REPLACE PROCEDURE get_user_info_by_userid
(
  in_userid IN number,
  out_cursor_user_info OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_user_info FOR
  SELECT ers_users_id, ers_username, user_first_name, user_last_name, user_email, u_role.user_role
  FROM ers_users u
  LEFT JOIN ers_user_roles u_role ON (u.user_role_id = u_role.ers_user_role_id)
  WHERE u.ers_users_id = in_userid
  ORDER BY u.ers_users_id;
END;
/
CREATE OR REPLACE PROCEDURE get_user_login_by_username
(
  in_username IN varchar2,
  out_cursor_user_info OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_user_info FOR
  SELECT u.ers_username, u.ers_secure_key, u.ers_salt, u_role.user_role
  FROM ers_users u
  LEFT JOIN ers_user_roles u_role ON (u.user_role_id = u_role.ers_user_role_id)
  WHERE u.ers_username = in_username;
END;
/
--------------------REFRENCE TABLES DATA INSERTION------------------
INSERT INTO ers_reimbursement_type(reimb_type)
VALUES('LODGING');
INSERT INTO ers_reimbursement_type(reimb_type)
VALUES('TRAVEL');
INSERT INTO ers_reimbursement_type(reimb_type)
VALUES('FOOD');
INSERT INTO ers_reimbursement_type(reimb_type)
VALUES('OTHER');
INSERT INTO ers_reimbursement_status(reimb_status)
VALUES('PENDING');
INSERT INTO ers_reimbursement_status(reimb_status)
VALUES('APPROVED');
INSERT INTO ers_reimbursement_status(reimb_status)
VALUES('DENIED');
INSERT INTO ers_user_roles(user_role)
VALUES ('MANAGER');
INSERT INTO ers_user_roles(user_role)
VALUES ('EMPLOYEE');
--------------INSERT DUMMY USERS AND REIMBURSEMENTS-----------------
SET SERVEROUTPUT ON
DECLARE gen_id number;
BEGIN
  new_ers_user('mickey', 'RR1lFw6Ll8bbyBX/RfwQTQ==' ,'ChnFQQqYl8JUKBuRlNHF1A==', 
    'Mickey', 'von Sewer', 'mickeymouse@disney.com', 1, gen_id);
  new_ers_user('chip', 'YKdlCHGaXu4k18nU5evfBA==' ,'oAkxJeAq8NpTtZsvF+cNJg==', 
    'Chip', 'Bigtooth', 'info@chippendales.com', 2, gen_id);
  new_ers_user('dale', '3XXMb2TNK8K5ssrmcPepBg==' ,'XiXA5pB+ftrTQqEhpDs/qQ==',
    'Dale', 'Rednose', 'daletherednosechipmunk@chippendales.com', 2, gen_id);
  new_ers_user('pluto', '9GWplpIvllyQQAy4CiUgWg==', 'z8l6xGh2lRNF6+68jp5gzA==',
    'Pluto', 'Bonedigger', 'pluto@disney.com', 2, gen_id);
  new_ers_user('winnie', 'gY5npUOBFZ3GnfS6VX7nIQ==','tyWhPi0AbTfNERQzKeRqcQ==',
    'Winnie', 'Xi', 'wxjp@163.com', 2, gen_id);
  request_new_reimbursement(102.53, 'Embassy Inn in Washington DC', 2, 1, gen_id);
  request_new_reimbursement(336.78, 'Plane Tickets to Charlotte, NC', 2, 2, gen_id);
  request_new_reimbursement(8.52, 'McDonalds', 2, 3, gen_id);
  request_new_reimbursement(18.71, 'Uber', 2, 2, gen_id);
  request_new_reimbursement(15.06, 'Dry Cleaning', 2, 4, gen_id);
  request_new_reimbursement(18.00, 'Chestnut Cake', 3, 3, gen_id);
  request_new_reimbursement(2720.58, 'Car Rental - Lambogini', 3, 2, gen_id);
  request_new_reimbursement(200000.00, '"Activity" Expense', 3, 4, gen_id);
  request_new_reimbursement(52600.00, 'A lot of honey', 5, 3, gen_id);
  request_new_reimbursement(2.10, 'bowbowbow', 4, 3, gen_id);
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('10-Oct-19 14:23:10.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 1;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('10-Oct-19 14:34:10.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 2;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('10-Oct-19 14:46:10.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 3;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('10-Oct-19 14:48:10.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 4;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('10-Oct-19 14:53:10.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 5;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('11-Oct-19 18:52:11.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 6;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('19-Oct-19 02:23:58.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 7;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('21-Oct-19 11:33:56.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 8;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('05-Nov-19 12:20:05.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 9;
  UPDATE ers_reimbursement SET reimb_submitted = TO_TIMESTAMP ('07-Nov-19 09:10:55.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 10;
  update_reimb_status(1, 2, 1);
  update_reimb_status(2, 2, 1);
  update_reimb_status(3, 3, 1);
  update_reimb_status(6, 2, 1);
  update_reimb_status(7, 3, 1);
  UPDATE ers_reimbursement SET reimb_resolved = TO_TIMESTAMP ('13-Oct-19 09:23:11.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 1;
  UPDATE ers_reimbursement SET reimb_resolved = TO_TIMESTAMP ('13-Oct-19 09:24:45.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 2;
  UPDATE ers_reimbursement SET reimb_resolved = TO_TIMESTAMP ('13-Oct-19 09:29:55.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 3;
  UPDATE ers_reimbursement SET reimb_resolved = TO_TIMESTAMP ('18-Oct-19 10:52:11.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 6;
  UPDATE ers_reimbursement SET reimb_resolved = TO_TIMESTAMP ('18-Oct-19 11:01:19.123000', 'DD-Mon-RR HH24:MI:SS.FF') WHERE reimb_id = 7;
END;
/
COMMIT;

--------------------TEST SELECT------------------
-- SELECT * FROM ers_reimbursement_type;
-- SELECT * FROM ers_reimbursement_status; 
-- SELECT * FROM ers_user_roles;
SELECT * FROM ers_users;
SELECT * FROM ers_reimbursement;