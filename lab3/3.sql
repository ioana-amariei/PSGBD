/*
 Construiti un bloc anonim care sa afiseze notele celui mai bun student din facultate care are macar trei note si 
 materiile la care le-a luat. Daca sunt doi studenti care au aceeasi medie va fi afisat cel din an mai mare sau, 
 in cazul in care sunt in acelasi an, vor fi afisate notele primului in ordine alfabetica. 
 Nu aveti voie sa utilizati join sau produs cartezian in cadrul cursorului si 
 nici functii de agregare pentru a calcula media (faceti-o matematic). Se vor afisa si numele si media studentului. 
*/

set serveroutput on;
DROP TABLE info_studenti;
CREATE TABLE info_studenti(id_student integer, medie_student number);
DECLARE
  cursor lista_id_studenti is select id from studenti order by id asc;
  cursor lista_note_student (p_id_student studenti.id%type) is select n.valoare from note n where n.id_student = p_id_student;
  v_medie number;   
  v_id_student studenti.id%type;
  v_numar_note integer;
  v_nota_student v_numar_note%type;
  v_suma_note v_numar_note%type;
BEGIN
  open lista_id_studenti;
  loop
    v_suma_note := 0;
    v_numar_note := 0;
    -- pentru fiecare student
    fetch lista_id_studenti into v_id_student;
    -- calculez media notelor
    open lista_note_student(v_id_student);
    loop 
      fetch lista_note_student into v_nota_student;
      v_suma_note := v_suma_note + v_nota_student;
      v_numar_note := v_numar_note + 1;
      exit when lista_note_student%NOTFOUND;
    end loop;
    close lista_note_student;
    --v_medie := trunc((v_suma_note / v_numar_note), 3);
    v_medie := v_suma_note / v_numar_note;
    insert into info_studenti values (v_id_student, v_medie);
    exit when lista_id_studenti%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_id_student || ' ' || round(v_medie, 3));
  end loop;
  close lista_id_studenti;
END;

