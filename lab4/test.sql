/* Test exercitiul 1 lab 4

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
END;
*/


/* Test exercitiul 2 lab 4 
set serveroutput on;
BEGIN
    insert_student(4);
END;

*/
