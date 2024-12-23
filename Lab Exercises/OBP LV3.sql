/*1. Napisati upit koji æe prikazati naziv zaposlenog , šifru i naziv odjela za sve
zaposlene. */
SELECT e.first_name||' '||e.last_name "Naziv zaposlenika", e.department_id, d.department_name
FROM employees e, departments d
WHERE e.department_id=d.department_id;

/*2. Napisati jedinstvenu listu svih poslova iz odjela 30. */
SELECT DISTINCT j.job_title
FROM jobs j, employees e, departments d
WHERE j.job_id=e.job_id AND e.department_id=d.department_id AND d.department_id=30;

/*3. Napisati upit koji æe prikazati naziv zaposlenog, naziv odjela i lokaciju za sve
zaposlene koji ne primaju dodataka na platu. */
SELECT e.first_name||' '||e.last_name AS Naziv, d.department_name, l.city
FROM employees e, departments d, locations l
WHERE e.department_id=d.department_id AND d.location_id=l.location_id
                                      AND commission_pct IS NULL;

/*4. Napisati upit koji æe prikazati naziv zaposlenog i naziv odjela za sve zaposlene koji u
imenu sadrže slovo A na bilo kom mjestu.*/
SELECT e.first_name||' '||e.last_name AS "Naziv", d.department_name
FROM employees e, departments d
WHERE e.department_id=d.department_id AND e.first_name||' '||e.last_name LIKE '%A%';

/*5. Napisati upit koji æe prikazati naziv, posao, broj i naziv odjela za sve zaposlene koji
rade u DALLAS-u.*/
SELECT e.first_name||' '||e.last_name AS "Naziv", j.job_title, d.department_name
FROM employees e, departments d, locations l, jobs j
WHERE j.job_id=e.job_id AND e.department_id=d.department_id AND d.location_id=l.location_id
                        AND l.city LIKE 'Seattle';

/*6. Napisati upit koji æe prikazati naziv zaposlenog, naziv šefa i grad šefa u kojem radi.
Za labele kolona uzeti Naziv zaposlenog, Šifra zaposlenog, Naziv šefa, Šifra šefa,
Grad šefa, respektivno. */
SELECT z.first_name||' '||z.last_name AS "Naziv zaposlenog", m.first_name||' '||m.last_name AS "Naziv sefa",
       z.employee_id AS "Sifra zaposlenog", m.employee_id AS "Sifra sefa", l.city AS "Grad sefa"
FROM employees z, employees m, locations l, departments d
WHERE z.manager_id=m.employee_id AND m.department_id=d.department_id AND d.location_id=l.location_id;

/*7. Modificirati upit pod rednim brojem šest, da prikazuje i manager-a King-a koji nema
predpostavljenog.*/
SELECT z.first_name || ' ' || z.last_name AS "Naziv zaposlenog", m.first_name || ' ' || m.last_name AS "Naziv sefa",
       z.employee_id AS "Sifra zaposlenog", m.employee_id AS "Sifra sefa", l.city AS "Grad sefa"
FROM employees z
left JOIN employees m ON  z.manager_id=m.employee_id
left JOIN departments d ON  m.department_id=d.department_id
left JOIN locations l ON  d.location_id=l.location_id;

/*8. Napisati upit koji æe prikazati naziv zaposlenog, šifru odjela, i sve zaposlene koji
rade u istom odjelu kao i uzeti zaposlenik. Za kolone uzeti odgovarajuæe labele. */
SELECT e2.first_name || ' ' || e2.last_name "Zaposlenik", e.department_id "Odjel", e.first_name || ' ' || e.last_name "Drugi zaposlenik iz odjela"
FROM employees e, employees e2
WHERE e.department_id = e2.department_id AND e2.employee_id <> e.employee_id
ORDER BY e.department_id;


/*9. Napisati upit koji æe prikazati naziv, posao, naziv odjela, platu i stepene plate za sve
zaposlene kod kojih stepen plate nije u rasponu kada se na platu zaposlenog doda
dodatak na platu. */
SELECT e.first_name, j.job_title, d.department_name, e.salary, j.min_salary, j.max_salary
FROM employees e, jobs j, departments d
WHERE e.job_id=j.job_id AND e.department_id=d.department_id
                        AND (e.salary+(e.salary*Nvl(e.commission_pct, 0))) NOT BETWEEN j.min_salary AND j.max_salary;

/*10. Napisati upit koji æe prikazati naziv i datum zaposlenja za sve radnike koji su
zaposeleni poslije Blake-a. */
SELECT DISTINCT e.first_name || ' ' || e.last_name AS "Naziv zaposlenog", e.hire_date AS "Datum zaposlenja"
FROM employees e, employees e2
WHERE e.hire_date >= e2.hire_date AND e2.last_name = 'Tuvault' AND e.employee_id <> e2.employee_id;

/*11. Napisati upit koji æe prikazati naziv i datum zaposlenja zaposlenog, naziv i datum
zaposlenja šefa zaposlenog, za sve zaposlene koji su se zaposlili prije svog šefa.*/
SELECT DISTINCT e.first_name || ' ' || e.last_name AS "Naziv zaposlenog", e.hire_date AS "Datum zaposlenja zaposlenog",
m.first_name || ' ' || m.last_name AS "Naziv šefa", m.hire_date AS "Datum zaposlenja sefa"
FROM employees e
left JOIN employees m ON e.manager_id=m.employee_id
WHERE e.hire_date < m.hire_date;
