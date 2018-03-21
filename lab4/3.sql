/*
3. O procedura care sa elimine un student din baza de date (se vor elimina si constrangerile).
*/

alter table titluri disable constraint id_student_titlu_fk;
alter table lista_studenti disable constraint id_titlu_pk;

CREATE OR REPLACE PROCEDURE delete_student(p_id_student integer) AS
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
END;
