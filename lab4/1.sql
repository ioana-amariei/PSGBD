/* 
  1. O procedura (privata) ce returneaza varsta unui student 
  (in ani, luni si zile - vezi tema nr.1) a acelui student;
*/
CREATE OR REPLACE PROCEDURE varsta_student (p_data_nastere IN studenti.data_nastere%type, p_numar_ani OUT integer, p_numar_luni OUT integer, p_numar_zile OUT integer) AS
        v_data_intermediara varchar2(30);
    BEGIN
        p_numar_ani := floor(months_between(sysdate, p_data_nastere) /12); 
        v_data_intermediara := add_months(p_data_nastere, p_numar_ani*12);
        p_numar_luni := trunc(months_between(sysdate, v_data_intermediara));
        v_data_intermediara := add_months(p_data_nastere, p_numar_luni);
        p_numar_zile := trunc(sysdate - to_date(v_data_intermediara));
    END varsta_student;
