CREATE TABLE ERASMUS(id NUMBER, registration_number VARCHAR2(6), surname VARCHAR2(15), first_name VARCHAR2(30), country_code VARCHAR2(2));
/
CREATE TABLE COUNTRY(name VARCHAR2(20), code VARCHAR2(2));
/
CREATE UNIQUE INDEX  registration_idx ON ERASMUS(registration_number);
/
INSERT INTO COUNTRY VALUES ('Spain', 'ES');
/
INSERT INTO COUNTRY VALUES ('France', 'FR');
/
INSERT INTO COUNTRY VALUES ('Italy', 'IT');
/
INSERT INTO COUNTRY VALUES ('Croatia', 'HR');
/
INSERT INTO COUNTRY VALUES ('Germany', 'DE');
/
INSERT INTO COUNTRY VALUES ('United Kingdom', 'GB');
/
INSERT INTO COUNTRY VALUES ('Norway', 'NO');
/
INSERT INTO COUNTRY VALUES ('Sweeden', 'SE');
/
INSERT INTO COUNTRY VALUES ('Switzerland', 'CH');
/

-- set serveroutput on;

DECLARE
  CURSOR random_students IS SELECT nr_matricol, nume, prenume FROM STUDENTI ORDER BY DBMS_RANDOM.VALUE;
  CURSOR random_code IS SELECT * FROM (SELECT code FROM COUNTRY
                                       ORDER BY DBMS_RANDOM.VALUE)
                        WHERE ROWNUM < 2;
  v_counter NUMBER := 0;
  v_registration_number VARCHAR2(6);
  v_first_name VARCHAR2(15);
  v_surname VARCHAR2(30);
  v_country_code VARCHAR2(2);
  v_id NUMBER := 1;
BEGIN
  DBMS_OUTPUT.enable();

  OPEN random_students;
  WHILE v_counter < 100 LOOP

        BEGIN
          FETCH random_students INTO v_registration_number, v_first_name, v_surname;
          OPEN random_code;
            FETCH random_code INTO v_country_code;
          CLOSE random_code;
          DBMS_OUTPUT.PUT_LINE('Copied student ' || v_registration_number || ' ' || v_first_name || ' ' || v_surname || ' ' || v_country_code);
          INSERT INTO ERASMUS VALUES (v_id, v_registration_number, v_first_name, v_surname, v_country_code);
          v_id := v_id + 1;
          v_counter := v_counter + 1;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN raise_application_error (-20001, 'No more students.');
          WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE ('Student ' || v_first_name || ' ' || v_surname || ' is already on the table.');
        END;

  END LOOP;
  CLOSE random_students;
END;
/
DROP TABLE COUNTRY;
/
DROP TABLE ERASMUS;
/