CREATE OR REPLACE PROCEDURE get_all_reimbursements
(
  out_cursor_reimb OUT SYS_REFCURSOR
)
AS
BEGIN
  OPEN out_cursor_reimb FOR
  SELECT  reimb.reimb_id, reimb.reimb_amount, reimb.reimb_submitted, reimb.reimb_resolved, reimb.reimb_description,
    author.ers_users_id, author.user_first_name, author.user_last_name, author.user_email, a_role.user_role,
    resolver.ers_users_id, resolver.user_first_name, resolver.user_last_name, resolver.user_email, r_role.user_role,
    sta.reimb_status, rtype.reimb_type
  FROM ers_reimbursement reimb
  LEFT JOIN ers_users author ON (reimb.reimb_author = author.ers_users_id)
  LEFT JOIN ers_user_roles a_role ON (author.user_role_id = a_role.ers_user_role_id)
  LEFT JOIN ers_users resolver ON (reimb.reimb_resolver = resolver.ers_users_id)
  LEFT JOIN ers_user_roles r_role ON (resolver.user_role_id = r_role.ers_user_role_id)
  LEFT JOIN ers_reimbursement_status sta ON (reimb.reimb_status_id = sta.reimb_status_id)
  LEFT JOIN ers_reimbursement_type rtype ON (reimb.reimb_type_id = rtype.reimb_type_id)
  ORDER BY reimb.reimb_id;
END;
/
SET     SERVEROUTPUT ON
DECLARE c_out sys_refcursor;
  reimb_id number;
  reimb_amount number;
  reimb_submitted timestamp;
  reimb_resolved timestamp;
  reimb_description varchar2;
  author_id number;
  author_first_name varchar2;
  author_last_name varchar2;
  author_email varchar2; 
  a_role varchar2;
  resolver_id number;
  resolver_first_name varchar2;
  resolver_last_name varchar2;
  resolver_email varchar2;
  r_role varchar2;
  reimb_status varchar2;
  reimb_type varchar2;
BEGIN
    get_all_reimbursements(c_out);
    LOOP 
        FETCH c_out
        INTO  reimb_id, reimb_amount, reimb_submitted, reimb_resolved, reimb_description,
          author_id, author_first_name, author_last_name, author_email, a_role,
          resolver_id, resolver_first_name, resolver_last_name, resolver_email, r_role,
          reimb_status, reimb_type;
        EXIT WHEN c_out%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(reimb_id || ' ' || author_id || ' ' || resolver_id || ' ' || reimb_status);
    END LOOP;
  CLOSE c_out;
END;
/