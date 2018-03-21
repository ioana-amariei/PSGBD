/* The syntax for the Oracle INSERT statement when inserting multiple records using a SELECT statement is:
          INSERT INTO table
          (column1, column2, ... column_n )
          SELECT expression1, expression2, ... expression_n
          FROM source_table
          [WHERE conditions];
Parameters or Arguments

table
    The table to insert the records into.
column1, column2, ... column_n
    The columns in the table to insert values.
expression1, expression2, ... expression_n
    The values to assign to the columns in the table. So column1 would be assigned the value of expression1, column2 would be assigned the value of expression2, and so on.
source_table
    The source table when inserting data from another table.
WHERE conditions
    Optional. The conditions that must be met for the records to be inserted. 
*/

/*
  2. O procedura care sa adauge un student in baza de date 
  (cu generare de ID, matricol si simulare de note la materiile din anii precedenti 
  - de exemplu daca este in anul 3 va avea note la materiile din anii 1 si 2).
*/



DROP TABLE lista_studenti;
CREATE TABLE lista_studenti(id integer not null, nr_mat integer, nume VARCHAR2(5 BYTE), prenume VARCHAR2(10 BYTE), an integer, bursa NUMBER(6,2), data_nast DATE, nota integer, titlu_curs VARCHAR2(50 BYTE));
CREATE OR REPLACE PROCEDURE insert_student(p_numar_studenti integer) AS
  v_id integer := 0;
  v_nr_mat integer;
  v_nume  varchar2(15 BYTE);
  v_prenume varchar2(30 BYTE);
  v_an integer;
  v_bursa integer;
  v_data_nast date;
  
  v_nota note.valoare%type;
  v_titlu cursuri.titlu_curs%type;
  
  v_contor_nr_studenti integer;
  v_contor_an integer;
  v_titlu_curs cursuri.titlu_curs%type;
  cursor titlu_cursuri (p_an integer)  is select titlu_curs from cursuri where p_an =cursuri.an;                 
BEGIN
  if (p_numar_studenti > 0) then
     for v_contor_nr_studenti in 1..p_numar_studenti loop
     /* genereaza valori random */
        v_id := v_id + 1;
        v_nr_mat := DBMS_RANDOM.VALUE(100000, 300000);
        v_nume := DBMS_RANDOM.STRING('u', 5);
        v_prenume := DBMS_RANDOM.STRING('u',10);
        v_an := DBMS_RANDOM.VALUE(1,3);
        v_bursa := DBMS_RANDOM.VALUE(100,500);
        v_data_nast := TRUNC(SYSDATE + DBMS_RANDOM.value(0,366));
        
        for v_contor_an in 1..v_an loop
            open titlu_cursuri(v_an);
                loop
                    fetch titlu_cursuri INTO v_titlu_curs;
                    exit when titlu_cursuri%NOTFOUND;
                    v_nota := DBMS_RANDOM.VALUE(4,10);
                    /* populeaza tabelul de studenti */
                    insert into lista_studenti (id, nr_mat, nume, prenume, an, bursa, data_nast, nota, titlu_curs)
                    values (v_id, v_nr_mat, v_nume, v_prenume, v_an, v_bursa, v_data_nast, v_nota, v_titlu_curs);
                end loop;
            close titlu_cursuri;
        end loop;
     end loop;
  else DBMS_OUTPUT.PUT_LINE('Introduceti macar un student');
  end if;
END;