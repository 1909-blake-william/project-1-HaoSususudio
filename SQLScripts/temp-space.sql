CREATE OR REPLACE PROCEDURE new_reimb_query
AS
BEGIN
  CREATE OR REPLACE VIEW reimb_query AS
  SELECT *
  FROM ers_reimbursement;
END;
/


CREATE OR REPLACE PROCEDURE get_all_reimbursements()
AS
BEGIN
  CREATE OR REPLACE VIEW reimb_query AS
  SELECT *
  FROM ers_reimbursement;
END;
/

 select field
  into variable
  FROM ers_reimbursement
 where condition


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


procedure proexempt (parID number)
is 
  vardescription tithedb.parcel.description%type;
  varland tithedb.landuse.landuse_id%type;
  varlanduse tithedb.landuse.landuse%type;
  varparcel tithedb.parcel.parcel_id%type;
begin  
  select parcel_id,
         description,
         landuse
  into   varparcel,
         vardescription,
         varlanduse
  from   door
  where  parcel_id = parID;

  -- ... more stuff
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL; -- Handle error here.
  WHEN TOO_MANY_ROWS THEN
    NULL; -- Handle error here (or use "AND ROWNUM = 1" in your query).
END proexempt;
/



DECLARE
  emp_num       NUMBER(6) := 120;
  bonus         NUMBER(6) := 50;
  emp_last_name VARCHAR2(25);
  PROCEDURE raise_salary (emp_id IN NUMBER, amount IN NUMBER, 
                          emp_name OUT VARCHAR2) IS
    BEGIN
      UPDATE employees SET salary =
        salary + amount WHERE employee_id = emp_id;
      SELECT last_name INTO emp_name
        FROM employees
       WHERE employee_id = emp_id;
  END raise_salary;
BEGIN
  raise_salary(emp_num, bonus, emp_last_name);
  DBMS_OUTPUT.PUT_LINE
    ('Salary was updated for: ' || emp_last_name);
END;
/