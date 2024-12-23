/*1. Napisati upit koji æe prikazati sumu iznosa datataka na platu, broj zaposlenih koji
dobivaju dodatak na platu, kao i ukupan broj zaposlenih.*/
SELECT Sum(salary*Nvl(commission_pct,0)) AS "suma dodataka",
       Count(commission_pct) AS "Zaposleni sa dodatkom",
       Count(*) AS "Ukupno zaposlenih"
FROM employees;

/*2. Napisati upit koji æe prikazati broj zaposlenih po poslovima i organizacionim
jedinicama. Za labele uzeti naziv posla, naziv organizacione jedinice i broj uposlenih
respektivno.*/
SELECT j.job_title AS "naziv posla", d.department_name AS "naziv org. jedinice", Count(e.employee_id) "Broj zaposlenih"
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id AND e.job_id = j.job_id
GROUP BY j.job_title, d.department_name;

/*3. Napisati upit koji æe prikazati najveæu, najmanju, sumarnu i prosjeènu platu za sve
zaposlene. Vrijednosti zaokružiti na šest decimalnih mjesta. */
/*SELECT Round(Max(salary), 6), Round(Min(salary),6), Round(sum(salary),6), Round(avg(salary),6)
FROM employees;*/
SELECT To_Char(Min(salary), 'fm999999.000000'), To_Char(Max(salary), 'fm999999.000000'), To_Char(Sum(salary), 'fm999999.000000'), To_Char(Avg(salary), 'fm999999.000000')
FROM employees;

/*4. Modificirati prethodni upit tako da pokazuje maksimalnu, minimalnu i prosjeènu
platu po poslovima. */
SELECT j.job_id, Min(e.salary), Max(e.salary), Sum(e.salary), Avg(e.salary)
FROM employees e, jobs j
WHERE e.job_id=j.job_id
GROUP BY j.job_id;

/*5. Napisati upit koji æe prikazati broj zaposlenih po poslovima. */
SELECT job_id, Count(employee_id)
FROM employees
GROUP BY job_id;

/*6. Napisati upit koji æe prikazati broj menadžera, bez njihovog prikazivanja.*/
SELECT Count(DISTINCT manager_id)
FROM employees;

/*7. Napisati upit koji æe prikazati naziv menadžera i platu samo za one menadžere koji
u okviru date organizacione jedinice dobivaju minimalnu platu u odnosu na sve
ostale menadžere ostalih odjela. */
SELECT m.first_name || ' ' || m.last_name, m.salary
FROM employees e, employees m
WHERE e.manager_id = m.employee_id AND m.salary = (SELECT Min(m2.salary)
                                                   FROM employees e2, employees m2
                                                   WHERE e2.manager_id = m2.employee_id AND m2.department_id = m.department_id)
GROUP BY m.first_name || ' ' || m.last_name, m.salary;

/*8. Napisati upit koji æe prikazati naziv odjela, naziv grada, broj zaposlenih i prosjeènu
platu za sve zaposlene u dotiènom odjelu. */
SELECT d.department_name, l.city, Count(e.employee_id), Round(Avg(e.salary))
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id AND d.location_id = l.location_id
GROUP BY d.department_name, l.city;

/*9. Napisati upit koji æe prikazati broj zaposlnih koji su bili zaposleni u 1995, 1996,
1997 i 1998, kao i ukupan broj zaposlenih u ovim godinama. Za labele uzeti 1995g,
1996g, 1997g, 1998g i ukupan broj zaposlenih respektivno.*/
SELECT Count(Decode(To_Char(hire_date, 'YYYY'), 2002, 1, NULL)) "1995g",
       Count(Decode(To_Char(hire_date, 'YYYY'), 2003, 1, NULL)) "1996g",
       Count(Decode(To_Char(hire_date, 'YYYY'), 2004, 1, NULL)) "1997g",
       Count(Decode(To_Char(hire_date, 'YYYY'), 2005, 1, NULL)) "1998g",
       Count(Decode(To_Char(hire_date, 'YYYY'), 2002, 1, 2003, 1, 2004, 1, 2005, 1, NULL)) "Ukupan broj"
FROM employees;

/*10. Napisati matrièni izvještaj koli æe prikazati naziv posla i sumarnu platu po odjelima,
kao i ukupnu platu po datim poslovima i odjelima. Za labele uzeti kao što je
prikazano na tabeli:

Posao       Odjel 10       Odjel 30       Odjel 50       Odjel 90       Ukupno
Menadžer                                     60                           60
Programer      20                            55             10            85
…              …              …               …              …             … */
SELECT j.job_title "Posao",
      (SELECT Sum(salary) FROM employees WHERE department_id = 10 AND job_id = j.job_id) "Odjel 10",
      (SELECT Sum(salary) FROM employees WHERE department_id = 30 AND job_id = j.job_id) "Odjel 30",
      (SELECT Sum(salary) FROM employees WHERE department_id = 50 AND job_id = j.job_id) "Odjel 50",
      (SELECT Sum(salary) FROM employees WHERE department_id = 90 AND job_id = j.job_id) "Odjel 90",
FROM jobs j;

