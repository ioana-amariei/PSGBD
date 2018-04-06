CREATE OR REPLACE FUNCTION nota_recenta_student(
    pi_matricol IN CHAR)
  RETURN VARCHAR2
AS
  nota_recenta INTEGER;
  mesaj        VARCHAR2(32767);
BEGIN
  SELECT valoare
  INTO nota_recenta
  FROM
    (SELECT valoare
    FROM note
    WHERE nr_matricol = pi_matricol
    ORDER BY data_notare DESC
    )
  WHERE rownum <= 1;
  mesaj        := 'Cea mai recenta nota a studentului cu matricolul ' || pi_matricol || ' este ' || nota_recenta || '.';
  RETURN mesaj;
END nota_recenta_student;