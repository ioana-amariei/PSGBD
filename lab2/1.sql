set serveroutput on;
DECLARE
      v_input_nume studenti.nume%TYPE := &v_input_nume;
      v_nume_student studenti.nume%type;
      v_numar_studenti int := 0; 
      v_id studenti.id%type;
      v_prenume studenti.prenume%type;
      v_nota_max note.valoare%type;
      v_nota_min note.valoare%type;
BEGIN
      select count(*) into v_numar_studenti from studenti where nume = v_input_nume;
      --exista cel putin un student cu acel nume
      if(v_numar_studenti != 0)
        then 
          select nume into v_nume_student 
          from (select nume from studenti where nume = v_input_nume) 
          where rownum=1; 
          
          --numarul de studenti avand acel nume de familie
          select count(*) into v_numar_studenti 
          from studenti 
          where nume = v_input_nume;
          DBMS_OUTPUT.PUT_LINE('Numar studenti cu acelasi nume de familie: ' || v_numar_studenti);
          
          --ID-ul si prenumele studentului care ar fi primul in ordine lexicografica 
          --(avand acelasi nume, veti ordona dupa prenume)
          select id, prenume into v_id, v_prenume 
          from (select id, prenume from studenti where nume = v_input_nume order by prenume asc) 
          where rownum=1;
          DBMS_OUTPUT.PUT_LINE('Id: ' || v_id || ' --- ' || 'Prenume: ' || v_prenume);
          
          --nota cea mai mica si cea mai mare a studentului de la punctul precedent
          select min(valoare), max(valoare) into v_nota_min, v_nota_max from note where id_student = v_id;
          DBMS_OUTPUT.PUT_LINE('Nota cea mai mica: ' || v_nota_min || ' --- ' || 'Nota cea mai mare: ' || v_nota_max);
          
          --numarul A la puterea B unde A este nota cea mai mare si B este nota cea mai mica a studentului
          DBMS_OUTPUT.PUT_LINE('Exponentierea: ' || (v_nota_max ** v_nota_min));
        else 
          DBMS_OUTPUT.PUT_LINE('Nu exista numele in tabela studenti');   
      end if;
END;