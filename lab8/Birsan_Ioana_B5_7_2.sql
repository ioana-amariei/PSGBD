--Creati un trigger care sa scrie intr-o tabela de tip LOG cate note au fost modificate de o comanda de tip update. 
--Nu se va permite decat modificarea in plus a notelor. 
-- conn as sysdba: password: admin

DROP TABLE GRADES_UPDATE;
/
CREATE TABLE GRADES_UPDATE(how_many numeric);
/
CREATE OR REPLACE TRIGGER check_grades_update_trigger
  AFTER UPDATE ON NOTE
DECLARE
    cursor updates IS SELECT how_many FROM GRADES_UPDATE;
    v_how_many NUMERIC := 0;
BEGIN
  OPEN updates;
    LOOP 
      FETCH updates INTO v_how_many;
      EXIT WHEN updates%NOTFOUND;
      v_how_many := v_how_many + 1;
    END LOOP;
    
    DELETE FROM GRADES_UPDATE;
    INSERT INTO GRADES_UPDATE VALUES(v_how_many);
  CLOSE updates;
END;
/

set serveroutput on;
set pagesize 100;

DECLARE
  CURSOR grades IS SELECT valoare FROM NOTE;
  v_read_value NOTE.valoare%TYPE := &i_value;
  v_current_value NOTE.valoare%TYPE;
  v_new_value NOTE.valoare%TYPE;
  v_count NUMERIC := 0;
BEGIN
  OPEN grades;
  LOOP
    FETCH grades INTO v_current_value;
     EXIT WHEN grades%NOTFOUND;
     v_new_value := v_current_value + v_read_value;
     IF(v_new_value >= v_current_value AND v_new_value <= 10) THEN
      UPDATE NOTE SET valoare = v_new_value WHERE valoare < 10;
      v_count := v_count + 1;
     END IF;
  END LOOP;
  v_count := v_count - 1;
  DBMS_OUTPUT.PUT_LINE('Updates:' || v_count);
  CLOSE grades;
END;
/

-- see if there can be future rows for update
select * from note where valoare < 10;



