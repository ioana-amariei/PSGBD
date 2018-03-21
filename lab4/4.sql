/*
 4. O procedura care sa afiseze informatii despre un student: 
 numar matricol, foaia matricola, media, varsta (apel la procedura de la punctul 1), 
 al catelea este in grupa, care ii sunt prietenii.
*/

CREATE OR REPLACE PROCEDURE informatii_student(p_id_student IN integer) AS
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
END;