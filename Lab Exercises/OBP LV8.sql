/*1. Kreirati tabelu zaposlenih u okviru šeme baze na koju ste trenutno logirani. Za
naziv tabele koriste slovo «z» i broj vašeg indeksa (na primjer z14004):
CREATE TABLE z14004 AS SELECT * from employees; */
CREATE TABLE z19413
AS SELECT * FROM employees;

/*2. Opišite strukturu vaše tabele i identifirajte nazive kolona. Da li postoje neka
ogranièenja vezana za pojedine kolone tabele? Ako postoje koja su, ako ne zašto ne
postoje? */
Pregled ogranièenja izvorne tabele EMPLOYEES koja je iskorištena za kreiranje nove tabele:

SELECT t.column_name "Ime kolone", t.data_type "Vrsta Podataka", u.constraint_name "Ime ogranicenja", u.constraint_type "Vrsta ogranicenja"
FROM all_tab_columns t, all_cons_columns c, all_constraints u
WHERE t.table_name = 'EMPLOYEES' AND c.table_name = 'EMPLOYEES' AND u.table_name = 'EMPLOYEES'
      AND c.column_name = t.column_name AND u.constraint_name = c.constraint_name;

Pregled ogranièenja nove tabele:

SELECT t.column_name "Ime kolone", t.data_type "Vrsta Podataka", u.constraint_name "Ime ogranicenja", u.constraint_type "Vrsta ogranicenja"
FROM user_tab_columns t, user_cons_columns c, user_constraints u
WHERE t.table_name = 'Z19413' AND c.table_name = 'Z19413' AND u.table_name = 'Z19413'
      AND c.column_name = t.column_name AND u.constraint_name = c.constraint_name;

Vidljivo je da su zadržana samo ogranièenja NOT NULL, sva ostala ogranièenja potrebno je manuelno dodati (kopiranjem tabele ne kopiraju se njeni PK, FK i sl.).

/*3. U vašu tabelu zaposlenih dodajte 5 novih slogova za odjel marketinga i šefom sa
šifrom 100. */
INSERT INTO z19413
                  (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES
                  ((SELECT Max(employee_id) + 1
                   FROM employees),
                   'A', 'A', 'email1@etf.unsa.ba', '+387 33 000 000', To_Date('29.01.2024', 'DD.MM.YYYY'), (SELECT job_id
                                                                                                            FROM jobs
                                                                                                            WHERE job_title = 'Sales Manager'), 1500, NULL, 100, (SELECT department_id
                                                                                                                                                                  FROM departments
                                                                                                                                                                  WHERE department_name = 'Marketing'));

/*4. Promijenite dodatak na platu za sve one zaposlene koji imaju platu manju od 3000
KM. */
UPDATE z19413
SET commission_pct = NULL
WHERE salary < 3000;

/*5. Promijenite platu za sve one zapslene koji rade u New Yorku tako da im je plata
uveæana za dodatak na platu ako ga imaju, a ako ne onda smanjiti platu za 10% i
dodatak na platu uveæati za 15%. */
UPDATE z19413 z
SET salary = Decode(commission_pct,
                    NULL, salary * 0.9,
                    salary + salary * commission_pct),
   commission_pct = Decode(commission_pct,
                           NULL, commission_pct + 0.15,
                           commission_pct)
WHERE z.employee_id IN (SELECT e.employee_id
                        FROM z19413 e, departments d, locations l
                        WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.city = 'New York')

/*6. Modificirati šifru odjela za sve one zaposlene, u vašoj tabeli zaposlenih, koji rade u
Americi i imaju platu manju od prosjeène plate svih zaposlenih u dotiènom odjelu,
osim datog zaposlenog, tako da pripada odjelu Makretinga, i nemaju platu jednaku
minimalnoj i maksimalnoj plati na nivou svih organizacijskih jednica. */
UPDATE z19413
SET department_id = 1
WHERE employee_id IN (SELECT e.employee_id
                      FROM z19413 e, departments d, locations l, countries c, regions r
                      WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id
                            AND (r.region_name = 'Americas' AND e.salary < (SELECT Avg(e2.salary)
                                                                            FROM z19413 e2
                                                                            WHERE e2.department_id = e.department_id))
                            OR (d.department_name != 'Marketing' AND (e.salary, e.salary) NOT IN (SELECT Max(salary), Min(salary)
                                                                                      FROM employees)));

/*7. Modificirati šifru šefa, u vašoj tabeli zaposlenih, za sve one zaposlene koji su
nadreðeni onim šefovima koji posjeduju veæi broj zaposlenih od prosjeènog broja
zaposlenih kod svih preostalih šefova, onom šefu koji posjeduje minimalan broj
zaposlenih.*/
UPDATE z19413
SET manager_id = (SELECT e.employee_id
                  FROM employees e
                  WHERE (SELECT Count(*)
                           FROM employees e2
                           WHERE e2.manager_id = e.employee_id) = (SELECT Min(zaposlenici_po_sefovima.broj)
                                                                   FROM (SELECT Count(*) AS broj, manager_id
                                                                         FROM employees
                                                                         GROUP BY manager_id) zaposlenici_po_sefovima))

WHERE employee_id IN (SELECT DISTINCT e.manager_id
                     FROM employees e
                     WHERE e.employee_id IN (SELECT DISTINCT manager_id
                                             FROM employees)
                     AND (SELECT Count(*)
                           FROM employees e2
                           WHERE e2.manager_id = e.employee_id) >(SELECT Avg(zaposlenici_po_sefovima.broj)
                                                                   FROM (SELECT Count(*) AS broj, manager_id
                                                                         FROM employees
                                                                         GROUP BY manager_id) zaposlenici_po_sefovima)
                     AND e.manager_id IS NOT NULL);

/*8. Na osnovu prvog primjera kreirati file koji sadrži komande za kreiranje nove vaše
tabele odjela koja æe se zvati slièno kao tabela u prvom primjeru, samo što æe se
umjesto slova «z» sada koristiti slovo «o» i broj vašeg indeksa. */
CREATE TABLE o19413
AS SELECT * FROM departments;

/*9. Modificirati sve nazive odjela, u vašoj tabeli odjela, tako što æe te ispred imena
odjela staviti «US -», ako se odjel nalazi u Americi, u protivnom staviti «OS -» za
sve ostale odjele. */
UPDATE o19413 o
SET o.department_name = o.department_name || (SELECT Decode(r.region_name,
                                     'Americas', 'US -',
                                     'OS -')
                         FROM departments d, locations l, countries c, regions r
                         WHERE o.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id);

/*10. Iz vaše tabele zaposlenih izbrisati sve one zaposlene koji rade u onim odjelima koji
u imenu sadrže, na bilo kojoj poziciji, slovo 'a' ili 'A'.*/
DELETE FROM z19413 z
WHERE z.department_id IN (SELECT d.department_id
						              FROM departments d
						              WHERE o.department_id = d.department_id AND (d.department_name LIKE ('%A%') OR d.department_name LIKE ('%a%')));

/*11. Iz tabele odjela izbrisati sve odjele u kojim ne radi ni jedan zaposlenik.*/
DELETE FROM o19413 o
WHERE o.department_id NOT IN (SELECT d.department_id
						                  FROM employees e, departments d
						                  WHERE e.department_id = d.department_id);

/*12. Izbrisati sve one zaposlene, iz vaše tabele zaposlenih, koji ne rade u Aziji i imaju
šefa koji je nadreðen bar trojici zaposlenih, i gdje taj šef ima šefa koji prima platu
veæu od plate onog šefa koji u okviru firme ima minimalan broj zaposlenih kojim je
nadreðen.*/
DELETE FROM z19413 z
WHERE employee_id IN (SELECT e.employee_id
                      FROM employees e, departments d, locations l, countries c, regions r
                      WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id
                            AND r.region_name != 'Asia' AND e.manager_id IN (SELECT e2.employee_id
                                                                             FROM employees e2
                                                                             WHERE e2.employee_id IN (SELECT DISTINCT manager_id
                                                                                                      FROM employees)
                                                                                   AND (SELECT Count(*)
                                                                                        FROM employees e3
                                                                                        WHERE e3.manager_id = e2.employee_id) > 2
                                                                                   AND e2.manager_id IN (SELECT e4.employee_id
                                                                                                         FROM employees e4
                                                                                                         WHERE e4.salary > (SELECT Min(zaposlenici_po_sefovima.broj)
                                                                                                                            FROM (SELECT Count(*) AS broj, manager_id
                                                                                                                                  FROM employees
                                                                                                                                  GROUP BY manager_id) zaposlenici_po_sefovima))));