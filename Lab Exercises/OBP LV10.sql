LV7
1.
DROP TABLE zaposleni;

CREATE TABLE zaposleni
AS
SELECT * FROM employees;

DELETE FROM zaposleni;

ALTER TABLE zaposleni
ADD (id NUMBER,
     CONSTRAINT zaposleni_id_pk PRIMARY KEY (id));

ALTER TABLE zaposleni
DROP COLUMN employee_id;

INSERT INTO zaposleni
(id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
(SELECT * FROM employees);

2.
DROP TABLE odjeli;

CREATE TABLE odjeli
AS
SELECT * FROM departments;

DELETE FROM odjeli;

ALTER TABLE odjeli
ADD (id NUMBER,
     datum DATE,
     CONSTRAINT odjeli_id_datum__pk PRIMARY KEY (id, datum));

ALTER TABLE odjeli
DROP COLUMN department_id;

INSERT INTO odjeli
(id, department_name, manager_id, location_id, datum)
SELECT d.department_id, d.department_name, d.manager_id, d.location_id, SYSDATE
FROM departments d;

3.
ALTER TABLE zaposleni
ADD (odjel NUMBER,
     datum_odjela DATE,
     CONSTRAINT zaposleni_odjel_fk FOREIGN KEY (odjel, datum_odjela)
     REFERENCES odjeli (id, datum));

UPDATE zaposleni z
SET (z.odjel, z.datum_odjela) = (SELECT o.id, o.datum
                                 FROM odjeli o
                                 WHERE o.id = z.department_id);

ALTER TABLE zaposleni
DROP COLUMN department_id;

4.
SELECT *
FROM user_constraints;

SELECT *
FROM all_constraints
WHERE owner = 'HR' OR owner = 'TEST';

5.
SELECT *
FROM all_constraints
WHERE owner = 'HR' AND table_name IN ('EMPLOYEES', 'DEPARTMENTS');

6.
ALTER TABLE zaposleni
ADD plata_dodatak NUMBER;

UPDATE zaposleni z
SET z.plata_dodatak = (SELECT Decode(r.region_name,
                                     'Americas', z2.salary * (1 + Nvl(z2.commission_pct, 0)),
                                     NULL)
                       FROM zaposleni z2, odjeli o, locations l, countries c, regions r
                       WHERE z2.id = z.id AND z2.odjel = o.id AND o.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id);

7.
ALTER TABLE zaposleni
ADD CONSTRAINT zaposleni_pd_check
CHECK (plata_dodatak BETWEEN 0 AND 40000);

8.
Create VIEW zap_pog
AS
    SELECT z.id, z.first_name || ' ' || z.last_name "naziv", o.department_name
    FROM zaposleni z, odjeli o
    WHERE z.odjel = o.id AND z.salary > (SELECT Avg(salary)
                                         FROM zaposleni z2
                                         WHERE z.odjel = z2.odjel);

9.
SELECT *
FROM zap_pog zp, zzaposleni z
WHERE zp.id = z.id;

10.
CREATE VIEW posao_pogled
AS
    SELECT j.job_title, d.department_name, Avg(e.salary) "avg", e.salary * Nvl(e.commission_pct, 0) "dodatak"
    FROM employees e, departments d, jobs j
    WHERE e.department_id = d.department_id AND e.job_id = j.job_id
          AND REGEXP_Like(d.department_name, '[abc]') AND REGEXP_Like(j.job_title, '[abc]')
    GROUP BY j.job_title, d.department_name, e.salary * Nvl(e.commission_pct, 0)
WITH READ ONLY;

11.
CREATE OR REPLACE VIEW posao_pogled
AS
    SELECT j.job_title, d.department_name, Avg(e.salary) "avg", e.salary * Nvl(e.commission_pct, 0) "dodatak", plate.avg
    FROM employees e, departments d, jobs j, (SELECT Avg(salary) avg, department_id
                                              FROM employees
                                              GROUP BY department_id) plate
    WHERE e.department_id = d.department_id AND e.job_id = j.job_id AND e.department_id = plate.department_id
          AND REGEXP_Like(d.department_name, '[abc]') AND REGEXP_Like(j.job_title, '[abc]')
    GROUP BY j.job_title, d.department_name, e.salary * Nvl(e.commission_pct, 0), plate.avg;

12.
CREATE OR REPLACE VIEW posao_pogled
AS
    SELECT j.job_title, d.department_name, Avg(e.salary) "avg", e.salary * Nvl(e.commission_pct, 0) "dodatak", plate.avg "prosjecna plata odjela"
    FROM employees e, departments d, jobs j, (SELECT Avg(salary) avg, department_id
                                              FROM employees
                                              GROUP BY department_id) plate
    WHERE e.department_id = d.department_id AND e.job_id = j.job_id AND e.department_id = plate.department_id
          AND REGEXP_Like(d.department_name, '[abc]') AND REGEXP_Like(j.job_title, '[abc]')
    GROUP BY j.job_title, d.department_name, e.salary * Nvl(e.commission_pct, 0), plate.avg;

13.
CREATE VIEW sefovi_pogled
AS
	SELECT m.first_name || ' ' || m.last_name, Count(e.employee_id), plate.maksimum, plate.minimum
	FROM employees e, employees m,
	(SELECT Max(e2.salary) AS maksimum, Min(e2.salary) AS minimum, department_id
	 FROM employees e2
	 GROUP BY department_id) plate
	WHERE e.manager_id = m.employee_id AND m.department_id = plate.department_id
	GROUP BY m.first_name || ' ' || m.last_name, plate.maksimum, plate.minimum;

14.
CREATE OR REPLACE VIEW sefovi_pogled
AS
	SELECT m.first_name || ' ' || m.last_name "ime", Count(e.employee_id) "suma", plate.maksimum, plate.minimum, sume.suma
	FROM employees e, employees m,
	(SELECT Max(e2.salary) AS maksimum, Min(e2.salary) AS minimum, department_id
	 FROM employees e2
	 GROUP BY department_id) plate,
    (SELECT Sum(e2.salary) AS suma, e2.manager_id
     FROM employees e2
     GROUP BY manager_id) sume
	WHERE e.manager_id = m.employee_id AND m.department_id = plate.department_id AND m.employee_id = sume.manager_id
	GROUP BY m.first_name || ' ' || m.last_name, plate.maksimum, plate.minimum, sume.suma
WITH READ ONLY;