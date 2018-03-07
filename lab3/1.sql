set serveroutput on;
DROP TABLE tabel;
CREATE TABLE tabel(A integer, B integer);
DECLARE
   v_constanta constant integer := 5;
   v_contor1 integer;
   v_valoare_curenta v_contor1%type;
   v_cat v_contor1%type;
   v_rest v_contor1%type;
   v_suma_cifre v_contor1%type;
   v_index v_contor1%type;
   v_is_prime boolean;
BEGIN
    for v_contor1 in 1..10000 loop
        v_valoare_curenta := v_contor1;
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
                    if (mod(v_contor1, 2) = 0) 
                      then 
                      -- nr este par -> nu este prim
                        INSERT INTO tabel values (v_contor1, 0);
                        DBMS_OUTPUT.PUT_LINE(v_contor1||'   '|| 0);
                      else 
                        v_index := 3;
						v_is_prime := true;
                        while (((v_index * v_index) <= v_contor1) and v_is_prime) loop
                          if (mod(v_contor1, v_index) = 0) 
                            then INSERT INTO tabel values (v_contor1, 0);
                                  DBMS_OUTPUT.PUT_LINE(v_contor1||'   '|| 0);
								  v_is_prime := false;
                          end if;
                          v_index := v_index + 2;
                        end loop;
						if (v_is_prime)
							then
								INSERT INTO tabel values (v_contor1, 1); 
								DBMS_OUTPUT.PUT_LINE(v_contor1||'   '|| 1);
						end if;
                    end if; 
              end if;
            -- valori <= 9 
            else 
              if(mod(v_contor1, 9) = v_constanta)
                then
                  if ((v_contor1 = 2) or (v_contor1 = 3) or (v_contor1 = 5) or (v_contor1 = 7))
                      then INSERT INTO tabel values (v_contor1, 1); DBMS_OUTPUT.PUT_LINE(v_contor1||'   '|| 1);
                      else INSERT INTO tabel values (v_contor1, 0); DBMS_OUTPUT.PUT_LINE(v_contor1||'   '|| 0);
                  end if;
              end if;
        end if;
    end loop; 
END;