/*1. Napisati upit koji æe prikazati naziv zaposlenog, naziv odjela i naziv posla za sve
zaposlene koji rade u istom odjelu kao i Susan, iskljuèujuæi Susan.*/
SELECT e.first_name || ' ' || e.last_name naziv, d.department_name "naziv odjela", j.job_title "naziv posla"
FROM employees e, departments d, jobs j
WHERE e.department_id=d.department_id AND e.job_id =j.job_id
      AND e.department_id = (SELECT department_id
                         FROM employees
                         WHERE first_name = 'Donald')
      AND e.first_name != 'Donald';

/*2. Napisati upit koji æe prikazati šifru, ime, prezime, platu za sve zaposlene koji
zaraðuju platu veæu od prosjeène plate svih zaposlenih iz odjela 30 i 90. */
SELECT employee_id sifra, first_name ime, last_name prezime, salary plata
FROM employees
WHERE salary> (SELECT Avg(salary)
              FROM employees
              WHERE department_id IN (30,90));


/*3. Napisati upit koji æe prikazati sve podatke o zaposlenim za sve zaposlene koji rade u
istom odjelu kao i neki od zaposlenih koji u imenu, na bilo kom mjestu, sadrže slovo «C». */
SELECT *
FROM employees
WHERE department_id = ANY (SELECT department_id
                         FROM employees
                         WHERE upper(first_name) LIKE '%C%');

/*4. Napisati upit koji æe prikazati šifru i naziv zaposlenog, kao i naziv posla za sve
zaposlene koji rade u odjelu koji je locairan u Torontu.*/
SELECT e.employee_id, e.first_name || ' ' || e.last_name naziv, j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
      AND e.department_id = (SELECT d.department_id
                           FROM departments d, locations l
                           WHERE d.location_id = l.location_id
                                 AND l.city = 'Toronto');

/*5. Napisati upit koji æe prikazati sve podatke o zaposlenim koji izvještavaju King-a.*/
SELECT *
FROM employees
WHERE manager_id = (SELECT employee_id
                    FROM employees
                    WHERE first_name || ' ' || last_name = 'Steven King');

/*6. Modificirati upit pod rednim brojem 3 tako da prikazuje samo one zaposlene koji
dobivaju platu veæu od prosjeène plate svih zaposlenih iz dotiènog odjela u kojem
dati zaposlenik radi. */
SELECT *
FROM employees e
WHERE e.department_id = ANY (SELECT department_id
                         FROM employees
                         WHERE first_name LIKE '%C%')
      AND e.salary> (SELECT Avg(salary)
                   FROM employees e
                   WHERE department_id=e.department_id);

/*7. Napisati upit koji æe prikazati naziv zaposlenog, naziv odjela i platu za sve one
zaposlene koji pripadaju istom odjelu i zaraðuju istu platu kao i neki od zaposlenih
koji dobiva dodatak na platu, iskljuèujuæi one zaposlene koji dobivaju dodatak na platu. */
SELECT e.first_name || ' ' || e.last_name naziv, d.department_name odjel, e.salary
FROM employees e, departments d
WHERE e.department_id = d.department_id
      AND (e.department_id, e.salary) IN (SELECT department_id, salary
                                          FROM employees
                                          WHERE commission_pct IS NOT NULL)
      AND e.commission_pct IS NOT NULL;

/*8. Napisati upit koji æe prikazati naziv zaposlenog, naziv odjela, platu i grad za svakog
zaposlenog koji ima istu platu i dodatak na platu kao i neki od zaposlenih koji rade
u Rimu. */
SELECT e.first_name || ' ' || e.last_name naziv, d.department_name odjel, e.salary plata, l.city grad
FROM employees e, departments d, locations l
WHERE e.department_id=d.department_id AND d.location_id=l.location_id
      AND (e.salary, Nvl(e.commission_pct,0)) IN (SELECT e1.salary, Nvl(e1.commission_pct,0)
                                                 FROM employees e1, departments d1, locations l1
                                                 WHERE e1.department_id=d1.department_id AND d1.location_id=l1.location_id
                                                 AND Upper(l1.city) LIKE 'ROME');

/*9. Napisati upit koji æe prikazati naziv zaposlenog, datum zaposlenja i platu za sve
zaposlene koji imaju istu platu i dodatak na platu kao i Scott. */
SELECT first_name || ' ' || last_name naziv, hire_date, salary
FROM employees
WHERE salary = (SELECT salary
               FROM employees
               WHERE first_name LIKE 'Donald')
               AND Nvl(commission_pct,0)=(SELECT Nvl(commission_pct,0)
               FROM employees
               WHERE first_name LIKE 'Donald');

/*10. Napisati upit koji æe prikazati samo one zaposlene koji zaraðuju platu veæu od plate
svih iz odjala za prodaju. Rezultat sortirati po plati od najveæe do najmanje.*/
SELECT *
FROM employees
WHERE salary> ALL (SELECT salary
                   FROM employees
                   WHERE department_id = (SELECT department_id
                                          FROM departments
                                          WHERE department_name LIKE 'Sales'));

/*11. Napisati upit koji æe prikazati naziv zaposlenog, naziv odjela, naziv posla i grad za
sve zaposlene koji primaju platu veæu od prosjeæne plate svojih svih šefova koji
imaju dodatak na platu i rade u istom odjelu kao i dotièni zaposlenik.*/
SELECT e.first_name || ' ' || e.last_name naziv, d.department_name naziv, j.job_title, l.city
FROM employees e, departments d, jobs j, locations l
WHERE e.department_id=d.department_id AND d.location_id=l.location_id AND e.job_id=j.job_id
      AND e.salary> (SELECT Avg(e1.salary)
                     FROM employees e1
                     WHERE e1.employee_id IN (SELECT manager_id FROM employees)
                           AND e.manager_id = e1.employee_id AND e1.commission_pct IS NOT NULL
                           AND e1.department_id = e.department_id);

/*12. Napisati upit koji æe prikazati šifru i naziv zaposlenog, šifru i naziv odjela, platu,
prosjeènu, minimalnu i maksimalnu platu odjela u kojem zaposlenik radi, kao i
minimalnu, maksimalnu i prosjeènu platu na nivou firme za sve zaposlene koji
imaju platu veæu od minimalne prosjeène plate svih šefova u odjelu u kojim dati zaposlenik radi. */
SELECT e.employee_id, e.first_name || ' ' || e.last_name naziv, d.department_id, d.department_name, e.salary,
       p.prosjecna, p.minimalna, p.maksimalna, f.najmanja, f.najveca, f.prosjecna
FROM employees e, departments d, (SELECT round(Avg(salary)) prosjecna, Min(salary) minimalna, Max(salary) maksimalna, department_id odjel
                                  FROM employees
                                  GROUP BY department_id) p, (SELECT Min(salary) najmanja, Max(salary) najveca, Round(Avg(salary)) prosjecna
                                                                      FROM employees) f
WHERE e.salary > (SELECT Avg(e1.salary)
                  FROM employees e1
                  WHERE e1.employee_id IN (SELECT manager_id
                                           FROM employees)
                        AND e1.department_id=e.department_id);


