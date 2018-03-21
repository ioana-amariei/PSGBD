/*
  2. O procedura care sa adauge un student in baza de date 
  (cu generare de ID, matricol si simulare de note la materiile din anii precedenti 
  - de exemplu daca este in anul 3 va avea note la materiile din anii 1 si 2).
*/

DROP TABLE titluri;
DROP TABLE lista_studenti;
CREATE TABLE lista_studenti(id integer not null, nr_mat integer, nume VARCHAR2(5 BYTE), prenume VARCHAR2(10 BYTE), 
                            an NUMBER(1,0) not null, bursa NUMBER(6,2), data_nast DATE, 
                            nota integer, titlu_curs VARCHAR2(50 BYTE) not null, 
                            constraint id_titlu_pk primary key (id, titlu_curs));
CREATE TABLE titluri (id_student NUMBER(1,0) not null, titlu_curs VARCHAR2(50 BYTE) not null,
                      constraint id_student_titlu_fk foreign key (id_student, titlu_curs) references lista_studenti (id, titlu_curs));

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
        v_nr_mat := DBMS_RANDOM.VALUE(1000, 3000);
        v_nume := DBMS_RANDOM.STRING('u', 5);
        v_prenume := DBMS_RANDOM.STRING('u',10);
        v_an := DBMS_RANDOM.VALUE(1,3);
        v_bursa := DBMS_RANDOM.VALUE(100,500);
        v_data_nast := TRUNC(SYSDATE + DBMS_RANDOM.value(0,366));
        
        for v_contor_an in 1..v_an loop
            open titlu_cursuri(v_contor_an);
                loop
                    fetch titlu_cursuri INTO v_titlu_curs;
                    exit when titlu_cursuri%NOTFOUND;
                    v_nota := DBMS_RANDOM.VALUE(4,10);
                    /* populeaza tabelul de studenti */
                    
                    insert into lista_studenti (id, nr_mat, nume, prenume, an, bursa, data_nast, nota, titlu_curs)
                    values (v_id, v_nr_mat, v_nume, v_prenume, v_an, v_bursa, v_data_nast, v_nota, v_titlu_curs);
                    insert into titluri  (id_student, titlu_curs) values(v_id, v_titlu_curs);
                    
                end loop;
            close titlu_cursuri;
        end loop;
     end loop;
  else DBMS_OUTPUT.PUT_LINE('Introduceti macar un student');
  end if;
END;