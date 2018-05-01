--Creati un trigger prin intermediul caruia sa preveniti orice modificare destructiva asupra bazei de date:
--
--    Eliminarea unei coloane dintr-o tabela
--    Stergerea de date
--    Truncherea tabelului
--Se va scrie intr-o tabela aditionala timpul la care s-a incercat actiunea si numele utilizatorului 
--ce a incercat sa o faca (http://www.java2s.com/Code/Oracle/User-Previliege/Getcurrentusername.htm).
--PS. veti avea nevoie de doi utilizatori care sa aiba acces in aceeasi schema de baze de date 
--(check this: https://profs.info.uaic.ro/~bd/wiki/index.php/Doi_utilizatori_cu_aceeasi_schema).
--PS2. Daca doar unul din utilizatori declanseaza triggerul pe care l-ati facut, veti pierde doua puncte. 

CREATE TABLE CHANGE_DB_TABLE(name varchar2(30), change_time timestamp);

/

CREATE OR REPLACE TRIGGER destructive_action_trigger 
  BEFORE DROP ON STUDENT.SCHEMA
DECLARE
  v_name VARCHAR2(30);
BEGIN
  v_name := ora_login_user;
  INSERT INTO CHANGE_DB_TABLE VALUES(v_name, CURRENT_TIMESTAMP);
  RAISE_APPLICATION_ERROR (-20000, 'You do not have the right to alter tables.');
END;

/

DROP TABLE NOTE;


-- to see all users
-- select * from all_users; 

-- get current user name
--select user from dual;



