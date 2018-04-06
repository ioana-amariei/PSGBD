  CREATE OR REPLACE FUNCTION nota_recenta_student(
    pi_matricol IN CHAR)
  RETURN VARCHAR2
AS
  nota_recenta INTEGER;
  mesaj        VARCHAR2(32767);
  counter      INTEGER;
BEGIN
  SELECT valoare
  INTO nota_recenta
  FROM
    (SELECT valoare
    FROM note, studenti
    WHERE nr_matricol = pi_matricol
    ORDER BY data_notare DESC
    )
  WHERE rownum <= 1;
  mesaj        := 'Cea mai recenta nota a studentului cu matricolul ' || pi_matricol || ' este ' || nota_recenta || '.';
  RETURN mesaj;
EXCEPTION
WHEN no_data_found THEN
  SELECT COUNT(*) INTO counter FROM studenti WHERE nr_matricol = pi_matricol;
  IF counter = 0 THEN
    mesaj   := 'Studentul cu matricolul ' || pi_matricol || ' nu exista in baza de date.';
  ELSE
    SELECT COUNT(*) INTO counter FROM note, studenti WHERE nr_matricol = pi_matricol;
    IF counter = 0 THEN
      mesaj   := 'Studentul cu matricolul ' || pi_matricol || ' nu are nici o nota.';
    END IF;
  END IF;
RETURN mesaj;
END nota_recenta_student;