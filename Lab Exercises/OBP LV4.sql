/*1. Napisati upit koji æe prikazati trenutni datum i korisnika logiranog na bazu
podataka. Labele za kolone su date i user respektivno. */
SELECT sysDATE, USER
FROM dual;

/*2. Napisati upit koji æe prikazati šifru, ime, prezime, platu i platu uveæanu za 25% kao
cijeli broj. Labela za novu platu je «plata uveæana za 25%». */
SELECT employee_id, first_name, last_name, salary,
         trunc(salary+salary*0.25) AS "Plata uvecana za 25%"
FROM employees;

/*3. Modificirati upit 2 tako da se doda nova kolona koja æe iz nove plata izdvojiti
posljednje 2 cifre plate i prikazati kao novu kolonu koja æe se zvati «ostatak plate». */
SELECT employee_id, first_name, last_name, salary,
         trunc(salary+salary*0.25) AS "Plata uvecana za 25%",
         Mod(Round(salary+salary*0.25),100) AS "posljednje dvije cifre uvecane"
FROM employees;

/*4. Napisati upit koji æe prikazati naziv zaposlenog, datum zaposlenja i datum prvog
ponedjeljka nakon 6 mjeseci rada zaposlenog. Datume predstaviti u formatu naziv
dana – naziv mjeseca, godina*/
SELECT first_name, To_Char(hire_date,'dd.mm.yyyy'),
       To_Char((Next_Day(Add_Months(hire_date,6), 'Friday')), 'dd.mm.yyyy')
FROM employees;

/*5. Za sve zaposlene iz tabele zaposlenih prikazati naziv zaposlenog, naziv odjela i
kontinent, kao i broj mjeseci zaposlenja zaposlenika. Broj mjeseci zaokružiti na
cjelobrojnu vrijednost.*/
SELECT e.first_name||' '||e.last_name AS "Naziv zaposlenog", d.department_name, r.region_name,
       abs(trunc(Months_Between(e.hire_date,SYSDATE))) AS "Mjeseci rada"
FROM employees e, departments d, locations l, countries c, regions r
WHERE e.department_id=d.department_id AND d.location_id=l.location_id AND l.country_id=c.country_id AND r.region_id=c.region_id;

/*6. Napisati upit koji æe prikazati za sve zaposlene iz odjela 10, 30 i 50 sljedeæe:
«naziv zaposlenog» prima platu «iznos plate» mjeseèno ali on bi želio platu «plata
uveæana za procenat dodataka na platu i pomnožena sa 4,5 puta». Labela za kolonu
je «plata o kojoj možeš samo sanjati». */
SELECT first_name||' prima platu '||salary||' mjesecno ali on bi zelio platu '||
       (salary+Nvl(salary*commission_pct,0))*4.5 AS "Plata iz snova"
FROM employees e, departments d
WHERE d.department_id=e.department_id AND e.department_id IN(10,30,50);

/*7. Napisati upit koji æe vratiti jednu kolonu "Ime + Plata" od naziva zaposlenog i
njegove plate za sve zaposlene. Formatirati "Ime + plata" tako da je vraæena
kolona dužine 50 karaktera i s lijeve strane nadopunjena s «$» karakterom.*/
SELECT LPad((first_name||' + '||salary),50,'$') AS "Ime+plata"
FROM employees;

/*8. Napisati upit koji æe prikazati naziv zaposlenog i dužinu naziva zaposlenog za sve
zaposlene èija imena poèinju sa slovima A, J, M i S. Naziv zaposlenog treba
prikazati tako da je prvi karakter naziva predstavljen malim slovom, a ostali
karakteri velikom slovima.*/
SELECT lower(SubStr(first_name,1,1)) || Upper(SubStr(first_name,2)),first_name, Length(first_name||' '||last_name) AS "Duzina punog imena"
FROM employees
WHERE (first_name LIKE 'A%' OR first_name LIKE 'J%' OR first_name LIKE 'M%' OR first_name LIKE 'S%');

/*9. Napisati upit koji æe prikazati naziv, datum zaposlenja i dan u sedmici kada je
zaposleni poèeo da radi. Rezultati sortirati po danima u sedmici poèevši od
ponedjeljka. */
SELECT first_name || ' ' || last_name, hire_date, To_Char(hire_date, 'DAY')
FROM employees
ORDER BY (hire_date - next_day(hire_date, 'MONDAY'));

/*10. Napisati upit koji æe prikazati naziv zaposlenog, grad u kojem zaposlenik radi, kao i
iznos dodatka na platu. Za one zaposlene koji ne dobivaju dodatak na platu ispisati
«zaposlenik ne prima dodatak na platu». */
SELECT e.first_name||' '||e.last_name AS naziv, l.city, Decode(e.commission_pct, NULL, 'Zaposlenik ne prima dodatak', e.salary+(e.salary*e.commission_pct))
FROM employees e, departments d, locations l
WHERE e.department_id=d.department_id AND d.location_id=l.location_id;

/*11. Napisati upit koji æe prikazati naziv zaposlenog, platu i indikator plate izražene za
znakom «*». Svaka zvjezdica oznaèava jednu hiljadu od plate. Na primjer ako
uposleni prima 2600 KM platu, tada treba za indikator plate ispisati ***, a ako
prima 2400 onda **. */
SELECT first_name||' '||last_name AS naziv, salary, LPad(' ',Trunc(salary/1000)+1,'*')
FROM employees;

/*12. Napisati upit koji æe prikazati sve zaposlene s stepenom posla. Stepen posla
potrebnoa je uraditi prema sljedeæoj specifikaciji:
Posao         Stepen
President     A
Manager       B
Analyst       C
Sales manager D
Programmer    E
Ostali        X */
SELECT e.first_name AS ime, j.job_title AS posao,
        CASE
          WHEN j.job_title LIKE 'President' THEN 'A'
          WHEN j.job_title LIKE 'Manager' THEN 'B'
          WHEN j.job_title LIKE 'Analyst' THEN 'C'
          WHEN j.job_title LIKE 'Sales Manager' THEN 'D'
          WHEN j.job_title LIKE 'Programmer' THEN 'E'
          ELSE 'X'
        END AS stepen
FROM employees e, jobs j
WHERE e.job_id=j.job_id;
