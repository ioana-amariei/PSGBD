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
    
    DBMS_OUTPUT.PUT_LINE(' ');
    
--    insert_student(4);
--    delete_student(2);
--    informatii_student(2);
END;


/* verificare clasament si prieteni */
/*
select s2.an, s2.grupa, s2.nume, s2.prenume,avg(n2.valoare) as "Medie"
from studenti s1, studenti s2, note n1, note n2
where s1.id = 2
and s1.id = n1.id_student
and s2.id = n2.id_student
and s1.grupa = s2.grupa
and s1.an = s2.an
group by s2.an, s2.grupa, s2.nume, s2.prenume
order by "Medie" desc;


select s2.nume, s2.prenume
from prieteni, studenti s1, studenti s2
where s1.id = 2
and s1.id = id_student1
and s2.id = id_student2
and s2.id in (select s.id from studenti s, prieteni
                where s.id = id_student1
                and s1.id = id_student2
                and s.id <> s1.id);
                
*/

