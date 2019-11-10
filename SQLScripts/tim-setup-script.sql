DROP USER project1 CASCADE;
​ CREATE USER project1 IDENTIFIED BY p4ssw0rd DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp QUOTA 10M ON users;
GRANT CONNECT TO project1;
GRANT RESOURCE TO project1;
GRANT CREATE SESSION TO project1;
GRANT CREATE TABLE TO project1;
GRANT CREATE VIEW TO project1;
conn project1 / p4ssw0rd;
​
/************************************
Tables and sequences
************************************/
CREATE SEQUENCE reimb_status_id_seq;
CREATE TABLE ers_reimbursement_status (
  reimb_status_id NUMBER PRIMARY KEY,
  reimb_status VARCHAR2(10) NOT NULL
);
​ CREATE SEQUENCE reimb_type_id_seq;
CREATE TABLE ers_reimbursement_type (
  reimb_type_id NUMBER PRIMARY KEY,
  reimb_type VARCHAR2(10) NOT NULL
);
​ CREATE SEQUENCE ers_user_role_id_seq;
CREATE TABLE ers_user_roles (
  ers_user_role_id NUMBER PRIMARY KEY,
  user_role VARCHAR2(10) NOT NULL
);
​ CREATE SEQUENCE ers_users_id_seq;
CREATE TABLE ers_users (
  ers_users_id NUMBER PRIMARY KEY,
  ers_username VARCHAR2(50) UNIQUE NOT NULL,
  ers_password VARCHAR2(50) NOT NULL,
  user_first_name VARCHAR2(100) NOT NULL,
  user_last_name VARCHAR2(100) NOT NULL,
  user_email VARCHAR2(150) UNIQUE NOT NULL,
  user_role_id NUMBER REFERENCES ers_user_roles(ers_user_role_id)
);
​ CREATE SEQUENCE reimb_id_seq;
CREATE TABLE ers_reimbursment (
  reimb_id NUMBER PRIMARY KEY,
  reimb_amount NUMBER NOT NULL,
  reimb_submitted TIMESTAMP NOT NULL,
  reimb_resolved TIMESTAMP,
  reimb_description VARCHAR2(250),
  reimb_author NUMBER NOT NULL REFERENCES ers_users(ers_users_id),
  reimb_resolver NUMBER REFERENCES ers_users(ers_users_id),
  reimb_status_id NUMBER NOT NULL REFERENCES ers_reimbursement_status(reimb_status_id),
  reimb_type_id NUMBER NOT NULL REFERENCES ers_reimbursement_type(reimb_type_id)
);
​
/**********************************
*       Insert Table Values       *
**********************************/
-- Insert type of reimbursement
INSERT INTO ers_reimbursement_type
VALUES(REIMB_TYPE_ID_SEQ.nextval, 'LODGING');
INSERT INTO ers_reimbursement_type
VALUES(REIMB_TYPE_ID_SEQ.nextval, 'TRAVEL');
INSERT INTO ers_reimbursement_type
VALUES(REIMB_TYPE_ID_SEQ.nextval, 'FOOD');
INSERT INTO ers_reimbursement_type
VALUES(REIMB_TYPE_ID_SEQ.nextval, 'OTHER');
-- Insert reimbursement status
INSERT INTO ers_reimbursement_status
VALUES(REIMB_STATUS_ID_SEQ.nextval, 'PENDING');
INSERT INTO ers_reimbursement_status
VALUES(REIMB_STATUS_ID_SEQ.nextval, 'APPROVED');
INSERT INTO ers_reimbursement_status
VALUES(REIMB_STATUS_ID_SEQ.nextval, 'DENIED');
-- Insert user roles
INSERT INTO ers_user_roles
VALUES
  (ERS_USER_ROLE_ID_SEQ.nextval, 'EMPLOYEE');
INSERT INTO ers_user_roles
VALUES
  (ERS_USER_ROLE_ID_SEQ.nextval, 'MANAGER');
-- Insert users
INSERT INTO ers_users(
    ERS_USERS_ID,
    ers_username,
    ers_password,
    user_first_name,
    user_last_name,
    user_email,
    user_role_id
  )
VALUES(ERS_USERS_ID_SEQ.nextval, '', '', '', '', '', 1);
INSERT INTO ers_users(
    ERS_USERS_ID,
    ers_username,
    ers_password,
    user_first_name,
    user_last_name,
    user_email,
    user_role_id
  )
VALUES(ERS_USERS_ID_SEQ.nextval, '', '', '', '', '', 2);
commit;