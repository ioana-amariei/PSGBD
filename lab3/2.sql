/*
Utilizand un cursor explicit deschis cu clauza FOR UPDATE, construiti un script care sa faca update campului B din 
tabelul de la punctul 1. 
In loc de prim acesta va indica daca numarul respectiv este sau nu o valoare din sirul lui Fibonacci. 
Scriptul va afisa numarul de valori updatate (adica ce s-a schimbat din 0 in 1 + ce s-a schimbat din 1 in 0). 
*/

set serveroutput on;
DECLARE
  cursor informatii is select * from tabel order by tabel.A;
  cursor update_informatii is select * from tabel for update of B nowait;
   v_info_a tabel.A%type;
   v_info_b tabel.B%type;
   v_numar_valori_update tabel.A%type := 0;
   v_fib_condition1 tabel.A%type;
   v_fib_condition2 tabel.A%type;
   v_radacina_patrata1 tabel.A%type;
   v_radacina_patrata2 tabel.A%type;
BEGIN
    -- afisare tabel initial
    open informatii;
    DBMS_OUTPUT.PUT_LINE('Informatiile stocate initial in tabel');
    
    loop
        fetch informatii into v_info_a, v_info_b;
        exit when informatii%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_info_a||'   '|| v_info_b);
    end loop;
    close informatii; 
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    
    -- prelucrare si update tabel
    open update_informatii;
    DBMS_OUTPUT.PUT_LINE('Informatiile din tabel dupa update');
    loop
        fetch update_informatii into v_info_a, v_info_b;
        exit when update_informatii%NOTFOUND;
        
        v_fib_condition1 := (5 * v_info_a * v_info_a) + 4;
        v_fib_condition2 := (5 * v_info_a * v_info_a) - 4;
        v_radacina_patrata1 := floor(sqrt(v_fib_condition1));
        v_radacina_patrata2 := floor(sqrt(v_fib_condition2));
        
        if(((v_radacina_patrata1 * v_radacina_patrata1) = v_fib_condition1) or ((v_radacina_patrata2 * v_radacina_patrata2) = v_fib_condition2)) then 
            if (v_info_b = 0) then
              v_info_b := 1;
              UPDATE tabel SET B = 1;
              v_numar_valori_update := v_numar_valori_update + 1;
            end if;
        elsif(v_info_b = 1) then 
          v_info_b := 0;
          UPDATE tabel SET B = 0;
          v_numar_valori_update := v_numar_valori_update + 1;
        end if;

      DBMS_OUTPUT.PUT_LINE(v_info_a||'   '|| v_info_b);
    end loop;
    close update_informatii;
         
    DBMS_OUTPUT.PUT_LINE('----------------------------------');
    
    DBMS_OUTPUT.PUT_LINE('Numar valori updatate: '|| v_numar_valori_update);
END;
