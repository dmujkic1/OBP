/*1. Napisati upit koji �e prikazati naziv zaposlenog i platu za sve zaposlene koji imaju platu ve�u od 2456.*/
SELECT first_name||' '||last_name "Ime i Prezime", salary "Plata"
FROM employees
WHERE salary>2456;

/*2. Napisti upit koji �e prikazati naziv zaposlenog i �ifru odjela za �ifru zaposlenog 102.*/
SELECT first_name||' '||last_name "Naziv Zaposlenog", department_id
FROM employees
WHERE employee_id=102;

/*3. Napisati upit koji �e prikazati sve zaposlene �ija plata nije u rangu od 1000 do 2345. */
SELECT first_name||' '||last_name "Ime i Prezime", salary "Plata"
FROM employees
WHERE salary NOT BETWEEN 1000 AND 2345;

/*4. Napisati upit koji �e prikazati naziv zaposlenog (predstavljeno kao jedna kolona)
�Zaposleni�, posao i datum zaposlenja za sve zaposlene koji su po�eli da rade u
periodu od 11.01.1996 do 22.02.1997.*/
SELECT first_name||' '||last_name "Zaposleni", job_id, department_id, hire_date
FROM employees
WHERE hire_date BETWEEN To_Date('11/1/1996','dd/mm/yyyy') AND To_Date('22/2/2005', 'dd/mm/yyyy');

/*5. Napisati upit koji �e prikazati naziv zaposlenog i �ifru odjela za sve zaposlene iz
odjela 10 i 30 sortirano po prezimenu zaposlenog. */
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN(10,30)
ORDER BY last_name;

/*6. Napisati upit koji �e prikazati platu, ime, prezime i dodatak na platu za sve
zaposlene koji imaju platu ve�u od 1500 i rade u odjelima 10 ili 30. Za labele kolona
uzeti respektovno: mjese�na plata, ime zaposlenog, prezime zaposlenog i dodatak na platu.  */
SELECT salary, first_name, last_name, commission_pct "Dodatak na platu"
FROM employees
WHERE salary>1500 AND department_id IN(10,30);

/*7. Napisati upit sve zaposlene koji su po�eli da rade prije 1996 godine.  */
SELECT first_name, hire_date
FROM employees
WHERE hire_date<To_Date('1.1.2002', 'dd.mm.yyyy');

/*8. Napisati upit koji �e prikazati naziv, platu i posao zaposlenog za sve zaposlene koji nemaju nadre�enog */
SELECT first_name, manager_id, salary, job_id
FROM employees
WHERE manager_id IS NULL;

/*9. Napisati upit koji �e prikazati naziv zaposlenog, platu i dodatak na platu za sve one
zaposlene koji su stekli dodatak na platu. Sortirati podatke u opadaju�em poretku po plati i dodatku na platu.  */
SELECT first_name, last_name, salary, commission_pct*salary
FROM employees
WHERE commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

/*10. Napisati upit koji �e prikazati naziv zaposlenog za sve one zaposlene koji imaju dva
slova �l� u nazivu (naziv se sastoji od imena i prezimena zaposlenog). */
SELECT first_name||' '||last_name "Naziv zaposlenog"
FROM employees
WHERE first_name||' '||last_name LIKE ('%l%l%') AND first_name||' '||last_name NOT LIKE ('%l%l%l%');

/*11. Napisati upit koji �e prikazati naziv, platu i dodatak na platu za sve zaposlene �iji je
iznos dodatka na platu ve�i od plate zaposlenog umanjene za 80%. */
SELECT first_name||' '||last_name "Naziv", salary, Nvl(commission_pct*salary,0)  "Dodatak"
FROM employees
WHERE  (Nvl(commission_pct*salary,0))>salary*0.2;

