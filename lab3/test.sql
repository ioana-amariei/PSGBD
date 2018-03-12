set pagewidth 1000;
select T1.id, T1.nume, T1.prenume, T1.an, c.titlu_curs, n.valoare, T1."avg" 
from ( select * from (select  s.id, s.nume, s.prenume, s.an, avg(n.valoare) as "avg" 
                      from studenti s join note n on n.id_student=s.id group by s.id, s.nume, s.prenume, s.an, s.nume, s.prenume
                      having count(n.valoare) >= 3 order by avg(n.valoare) desc, s.an desc, s.nume asc, s.prenume asc ) 
      where rownum = 1) T1 join note n on
n.id_student = T1.id join cursuri c on c.id = n.id_curs;


set pagewidth 1000;
select s1.id, s1.nume, s1.prenume, s1.an, trunc(avg(n1.valoare),3) as "MEDIE", count(valoare) as "NUMAR NOTE"
from studenti s1, note n1
where s1.id = n1.id_student
group by s1.id, s1.nume, s1.prenume, s1.an
having count(valoare) >= 3
order by 5 desc, 4 desc, 2 asc;

select id
from studenti
order by id asc;


describe note;
select id_student, avg(valoare)
from note
group by id_student;


select id_student, sum(valoare) as "Suma note", count(valoare) as "Numar note"
from note, studenti
where id_student = studenti.id
and id_student = 543
group by id_student;