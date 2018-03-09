set serveroutput on;
DROP TABLE tabel;
CREATE TABLE tabel(A integer, B integer);
DECLARE
   v_constanta constant integer := 7;
   v_contor tabel.A%type;
   v_valoare_curenta tabel.A%type;
   v_cat tabel.A%type;
   v_rest tabel.A%type;
   v_suma_cifre tabel.A%type;
   v_index tabel.A%type;
   v_is_prime boolean;
BEGIN
    for v_contor in 1..10000 loop
        v_valoare_curenta := v_contor;
        v_suma_cifre := 0;
        -- valori > 9
        if(v_valoare_curenta > 9) 
          then 
              -- calculez suma cifrelor
              while (v_valoare_curenta > 10) loop       
                 v_rest := mod(v_valoare_curenta, 10);
                 v_suma_cifre := v_suma_cifre + v_rest;
                 v_valoare_curenta := trunc(v_valoare_curenta / 10);
                 v_cat := v_valoare_curenta; 
              end loop;
              v_suma_cifre := v_suma_cifre + v_cat;
              
              -- daca valoarea sumei cifrelor modulo 9 este egala cu valoarea 
              -- unei constante declarate la inceputul scriptului atunci verific primalitatea
              if(mod(v_suma_cifre, 9) = v_constanta)
                then 
                    -- verific primalitatea
                    if (mod(v_contor, 2) = 0) 
                      then 
                      -- nr este par -> nu este prim
                        INSERT INTO tabel values (v_contor, 0);
                        DBMS_OUTPUT.PUT_LINE(v_contor||'   '|| 0);
                      else 
                        v_index := 3;
                        v_is_prime := true;
                        while (((v_index * v_index) <= v_contor) and v_is_prime) loop
                          if (mod(v_contor, v_index) = 0) 
                            then INSERT INTO tabel values (v_contor, 0);
                                  DBMS_OUTPUT.PUT_LINE(v_contor||'   '|| 0);
                                   v_is_prime := false;
                          end if;
                          v_index := v_index + 2;
                        end loop;
                        if (v_is_prime)
                          then
                            INSERT INTO tabel values (v_contor, 1); 
                            DBMS_OUTPUT.PUT_LINE(v_contor||'   '|| 1);
                        end if;
                    end if; 
              end if;
            -- valori <= 9 
            else 
              if(mod(v_contor, 9) = v_constanta)
                then
                  if ((v_contor = 2) or (v_contor = 3) or (v_contor = 5) or (v_contor = 7))
                      then INSERT INTO tabel values (v_contor, 1); DBMS_OUTPUT.PUT_LINE(v_contor||'   '|| 1);
                      else INSERT INTO tabel values (v_contor, 0); DBMS_OUTPUT.PUT_LINE(v_contor||'   '|| 0);
                  end if;
              end if;
        end if;
    end loop; 
END;