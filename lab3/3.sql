set serveroutput on;
DROP TABLE info_studenti;
DROP TABLE tabel_primul_student;

CREATE TABLE info_studenti(id_student integer, medie_student number);
CREATE TABLE tabel_primul_student(id_student integer, nume varchar2(15 byte), prenume varchar2(30 byte), medie_student number);

DECLARE

  cursor lista_id_studenti is select id from studenti order by id asc;
  cursor lista_note_student (p_id_student studenti.id%type) is select n.valoare from note n where n.id_student = p_id_student;
                            
  cursor selectie_cel_mai_bun_student is select * 
                                         from (select s1.id, s1.nume, s1.prenume, i1.medie_student as "MEDIE"
                                              from studenti s1, info_studenti i1
                                              where s1.id = i1.id_student
                                              order by "MEDIE" desc, s1.an desc, s1.nume asc)
                                         where rownum < 2;
                                 
  cursor rezultat_final is select t1.id_student, t1.nume, t1.prenume, c1.titlu_curs, n1.valoare, t1.medie_student
                           from  tabel_primul_student t1, cursuri c1, note n1
                           where t1.id_student = n1.id_student
                           and c1.id = n1.id_curs;
  
  v_medie number;   
  v_id_student studenti.id%type;
  v_nume studenti.nume%type;
  v_prenume studenti.prenume%type;
  v_titlu_curs cursuri.titlu_curs%type;
  v_valoare note.valoare%type;
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
    
    v_medie := v_suma_note / v_numar_note;
    -- adaug in tabel doar daca are cel putin 3 note
    if (v_numar_note >= 3)
      then insert into info_studenti values (v_id_student, v_medie);
    end if;
    exit when lista_id_studenti%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_id_student || ' ' || round(v_medie, 3));
  end loop;
  close lista_id_studenti;
  
  DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Studentul cu cea mai buna medie:');
  
  open selectie_cel_mai_bun_student;
  fetch selectie_cel_mai_bun_student into v_id_student, v_nume, v_prenume, v_medie;
  insert into tabel_primul_student values (v_id_student, v_nume, v_prenume, v_medie);
  DBMS_OUTPUT.PUT_LINE(v_id_student || ' ' || v_nume || ' ' || v_prenume || ' ' || round(v_medie, 3));
  close selectie_cel_mai_bun_student;
  
   DBMS_OUTPUT.PUT_LINE('-----------------------------------------------');
   DBMS_OUTPUT.PUT_LINE('Toate informatiile despre cel mai bun student:');
   open rezultat_final;
   loop
    fetch rezultat_final into v_id_student, v_nume, v_prenume, v_titlu_curs, v_valoare, v_medie;
    exit when rezultat_final%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_id_student || ' ' || v_nume || ' ' || v_prenume || ' ' || v_titlu_curs || ' -- ' || v_valoare || ' -- ' || round(v_medie, 3));
   end loop;
   close rezultat_final;
  
END;

