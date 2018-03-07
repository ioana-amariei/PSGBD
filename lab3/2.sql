/*
Utilizand un cursor explicit deschis cu clauza FOR UPDATE, construiti un script care sa faca update campului B din tabelul de la punctul 1. 
In loc de prim acesta va indica daca numarul respectiv este sau nu o valoare din sirul lui Fibonacci. 
Scriptul va afisa numarul de valori updatate (adica ce s-a schimbat din 0 in 1 + ce s-a schimbat din 1 in 0). 
*/

declare
  cursor informatii is select * from tabel order by tabel.A;
   v_info_a tabel.A%type;
   v_info_b tabel.B%type;
begin
    open informatii;
    DBMS_OUTPUT.PUT_LINE('Informatii stocate in tabel');
    loop
        fetch informatii into v_info_a, v_info_b;
        exit when informatii%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_info_a||'   '|| v_info_b);
    end loop;
    close informatii; 
end;