set serveroutput on;
DECLARE
      v_data_nastere constant varchar2(30) := to_date('14-02-1989', 'DD-MM-YYYY');
      v_numar_zile int := 0;
      v_numar_luni v_numar_zile%type;
      v_data_intermediara varchar2(30);
      v_zi_saptamana varchar(10); 
BEGIN
      v_numar_luni := trunc(months_between(sysdate, v_data_nastere));
      v_data_intermediara := add_months(v_data_nastere, v_numar_luni);
      v_numar_zile := trunc(sysdate - to_date(v_data_intermediara));
      DBMS_OUTPUT.PUT_LINE('Numar zile: ' || v_numar_zile || ' --- ' || 
                           'Numar luni: ' || v_numar_luni); 
      v_zi_saptamana := to_char(to_date(v_data_nastere), 'day');
      DBMS_OUTPUT.PUT_LINE('Zi: ' || v_zi_saptamana);
END;
