CREATE OR REPLACE PACKAGE management_facultate IS
    PROCEDURE varsta_student (p_data_nastere IN studenti.data_nastere%type, p_numar_ani OUT integer, p_numar_luni OUT integer, p_numar_zile OUT integer);
    PROCEDURE insert_student(p_numar_studenti integer);
    PROCEDURE delete_student(p_id_student integer);
    PROCEDURE informatii_student(p_id_student IN integer);
END management_facultate;

DROP TABLE titluri;
DROP TABLE lista_studenti;
CREATE TABLE lista_studenti(id integer not null, nr_mat integer, nume VARCHAR2(5 BYTE), prenume VARCHAR2(10 BYTE), 
                            an NUMBER(1,0) not null, bursa NUMBER(6,2), data_nast DATE, 
                            nota integer, titlu_curs VARCHAR2(50 BYTE) not null, 
                            constraint id_titlu_pk primary key (id, titlu_curs));
CREATE TABLE titluri (id_student NUMBER(1,0) not null, titlu_curs VARCHAR2(50 BYTE) not null,
                      constraint id_student_titlu_fk foreign key (id_student, titlu_curs) references lista_studenti (id, titlu_curs)
                      on delete cascade);

CREATE OR REPLACE PACKAGE BODY management_facultate IS
    PROCEDURE varsta_student (p_data_nastere IN studenti.data_nastere%type, p_numar_ani OUT integer, p_numar_luni OUT integer, p_numar_zile OUT integer) AS
        v_data_intermediara varchar2(30);
    BEGIN
        p_numar_ani := floor(months_between(sysdate, p_data_nastere) /12); 
        p_numar_luni := trunc(months_between(sysdate, p_data_nastere));
        v_data_intermediara := add_months(p_data_nastere, p_numar_luni);
        p_numar_zile := trunc(sysdate - to_date(v_data_intermediara));
    END varsta_student;


    PROCEDURE insert_student(p_numar_studenti integer) AS
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
    END insert_student;
    
    PROCEDURE delete_student(p_id_student integer) AS
        cursor update_lista_studenti is select * from lista_studenti for update nowait;
        v_numar_studenti integer;
        v_max_id integer;
    BEGIN
        select count(*) into v_numar_studenti from lista_studenti;  
        select max(id) into v_max_id from lista_studenti;
        
        if(v_numar_studenti < 1) then
            DBMS_OUTPUT.PUT_LINE('Nu exista studenti in tabela lista_studenti');
        elsif (p_id_student > v_max_id) then
            DBMS_OUTPUT.PUT_LINE('Nu exista studentul cu id-ul: ' || p_id_student || ' in tabela lista_studenti.');
        else 
            delete from lista_studenti where p_id_student = id;
        end if;
    END delete_student;
    
    PROCEDURE informatii_student(p_id_student IN integer) AS
        cursor foaie_matricola is select valoare, titlu_curs 
                                  from note, cursuri
                                  where note.id_curs = cursuri.id
                                  and note.id_student = p_id_student;
                                  
        cursor prieteni is select s2.nume, s2.prenume
                            from prieteni, studenti s1, studenti s2
                            where s1.id = p_id_student
                            and s1.id = id_student1
                            and s2.id = id_student2;
                            
        cursor clasament is select avg(n2.valoare) as "Medie"
                              from studenti s1, studenti s2, note n1, note n2
                              where s1.id = p_id_student
                              and s1.id = n1.id_student
                              and s2.id = n2.id_student
                              and s1.grupa = s2.grupa
                              and s1.an = s2.an
                              group by s2.id
                              order by "Medie" desc;
        
        v_nr_matricol studenti.nr_matricol%type;
        v_medie float;
        v_nume studenti.nume%type;
        v_prenume studenti.prenume%type;
        v_data_nastere studenti.data_nastere%type;
        v_numar_zile int := 0;
        v_numar_luni int := 0;
        v_numar_ani int := 0;
        v_valoare note.valoare%type;
        v_titlu_curs cursuri.titlu_curs%type;
        v_nume_prieten studenti.nume%type;
        v_prenume_prieten studenti.prenume%type;
        v_clasament_grupa integer := 1;
        v_medie_coleg float;
    BEGIN
        select nr_matricol, nume, prenume into v_nr_matricol, v_nume, v_prenume 
        from studenti 
        where id = p_id_student;
        
        DBMS_OUTPUT.PUT_LINE('Numar matricol: ' || v_nr_matricol);
        DBMS_OUTPUT.PUT_LINE('Nume: ' || v_nume);
        DBMS_OUTPUT.PUT_LINE('Prenume: ' || v_prenume);
        DBMS_OUTPUT.PUT_LINE(' ');
        
        DBMS_OUTPUT.PUT_LINE('Foaie matricola: ');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        open foaie_matricola;
            loop
                fetch foaie_matricola into v_valoare, v_titlu_curs;
                exit when foaie_matricola%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(v_titlu_curs || '  ' || v_valoare);
            end loop;
        close foaie_matricola;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        
        DBMS_OUTPUT.PUT_LINE(' ');
        select data_nastere into v_data_nastere from studenti where id = p_id_student;
        varsta_student(v_data_nastere, v_numar_ani, v_numar_luni, v_numar_zile);
        DBMS_OUTPUT.PUT_LINE('Varsta: '  || v_numar_ani || ' ani, ' || v_numar_luni || ' luni, ' || v_numar_zile || ' zile.');
        
        select avg(valoare) into v_medie from note where p_id_student = note.id_student;
        DBMS_OUTPUT.PUT_LINE('Media: ' || v_medie);
        
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('Lista prieteni: ');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        open prieteni;
            loop
                fetch prieteni into v_nume_prieten, v_prenume_prieten;
                exit when prieteni%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(v_nume_prieten || '  ' || v_prenume_prieten);
            end loop;
        close prieteni;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(' ');
        
        DBMS_OUTPUT.PUT_LINE('Clasament: ');
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        open clasament;
            loop
                fetch clasament into v_medie_coleg;
                exit when clasament%NOTFOUND;
                if(v_medie_coleg = v_medie) then
                    DBMS_OUTPUT.PUT_LINE('Studentul se afla pe locul: ' || '  ' || v_clasament_grupa || ' in grupa.');
                else
                    v_clasament_grupa := v_clasament_grupa + 1;
                end if;
            end loop;
        close clasament;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(' ');
    END informatii_student;
    
END management_facultate; 

/* TESTARE */
/*
set serveroutput on;
DECLARE
      cursor varste_studenti is select nume, prenume, data_nastere from studenti order by nume asc, prenume asc;
      v_nume studenti.nume%type;
      v_prenume studenti.prenume%type;
      v_data_nastere studenti.data_nastere%type;
      v_numar_zile int := 0;
      v_numar_luni int := 0;
      v_numar_ani int := 0;
BEGIN
    open varste_studenti;
    loop
        fetch varste_studenti into v_nume, v_prenume, v_data_nastere;
        exit when varste_studenti%NOTFOUND;
        varsta_student(v_data_nastere, v_numar_ani, v_numar_luni, v_numar_zile);
        DBMS_OUTPUT.PUT_LINE(v_nume || ' ' || v_prenume || ' ' || v_data_nastere || ' => '  || v_numar_ani || ' ani, ' || v_numar_luni || ' luni, ' || v_numar_zile || ' zile.');
    end loop;
    close varste_studenti; 
    
    insert_student(4);
--    delete_student(2);
    informatii_student(2);
END;
*/

