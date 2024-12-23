1.
CREATE TABLE odjeli
(id VARCHAR2(25) NOT NULL,
 naziv VARCHAR2(10) NOT NULL,
 opis CHAR(15),
 datum DATE NOT NULL,
 korisnik VARCHAR2(30) NOT NULL,
 napomena VARCHAR2(10));

2.
INSERT INTO odjeli
(id, naziv, opis, datum, korisnik, napomena)
SELECT department_id, SubStr(department_name, 0, 10), NULL, SYSDATE, USER, NULL
FROM departments;

3.
ALTER TABLE odjeli
ADD lokacija NUMBER;

UPDATE odjeli o
SET o.lokacija = (SELECT d.location_id
                  FROM departments d
                  WHERE d.department_id = o.id);

4.
CREATE TABLE zaposleni
(id NUMBER(4) NOT NULL,
 sifra_zaposlenog VARCHAR2(5) NOT NULL,
 naziv_zaposlenog CHAR(50),
 godina_zaposlenja NUMBER(4) NOT NULL,
 mjesec_zaposlenja CHAR(2) NOT NULL,
 sifra_odjela VARCHAR2(5),
 naziv_odjela VARCHAR2(15) NOT NULL,
 grad CHAR(10) NOT NULL,
 sifra_posla VARCHAR2(25),
 naziv_posla CHAR(50) NOT NULL,
 iznos_dodatka_na_platu NUMBER(5),
 plata NUMBER(6) NOT NULL,
 kontinent VARCHAR2(20),
 datum_unosa DATE NOT NULL,
 korisnik_unio CHAR(20) NOT NULL);

5.
INSERT INTO zaposleni
SELECT ROWNUM, To_Char(e.employee_id), e.first_name || ' ' || e.last_name, To_Number(To_Char(e.hire_date, 'YYYY')), To_Char(e.hire_date, 'MM'),
       To_Char(d.department_id), SubStr(d.department_name, 0, 15), SubStr(l.city, 0, 10), To_Char(j.job_id), j.job_title, Nvl(e.commission_pct, 0) * e.salary, e.salary, r.region_name, SYSDATE, USER
       FROM employees e, departments d, locations l, countries c, regions r, jobs j
       WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id AND e.job_id = j.job_id;

6.
CREATE TABLE zaposleni2
AS
SELECT *
FROM zaposleni;

7.
ALTER TABLE zaposleni2
ADD (zaposleni VARCHAR2(56),
     odjel VARCHAR2(21),
     posao VARCHAR2(76));

UPDATE zaposleni2
SET zaposleni = sifra_zaposlenog || ' ' || naziv_zaposlenog,
    odjel = sifra_odjela || ' ' || naziv_odjela,
    posao = sifra_posla || ' ' || naziv_posla;

ALTER TABLE zaposleni2
DROP (sifra_zaposlenog, naziv_zaposlenog, sifra_odjela, naziv_odjela, sifra_posla, naziv_posla);

8.
RENAME zaposleni2
TO zap_backup;

9.
COMMENT ON TABLE zaposleni
IS 'Tabela svih zaposlenika. Sadrzi sve podatke o zaposlenicima, odjelima u kojima rade, poslovima koje obavljaju, te lokacijama na kojima rade.';

COMMENT ON TABLE odjeli
IS 'Tabela svih odjela. Sadzi identifikacijske brojeve, imena, opise odjela, te podatke o tome ko je unio redove u tabelu.';

10.
COMMENT ON COLUMN zaposleni.naziv_zaposlenog
IS 'Podaci o zaposleniku. String duzine 50 karaktera koji sadrzi podatke o imenu i prezimenu zaposlenika.';

...

COMMENT ON COLUMN odjeli.id
IS 'Identifikacijski broj odjela. String duzine 25 karaktera koji mora biti definisan pri unosenju novog sloga.';

11.
ALTER TABLE zap_backup SET UNUSED (datum_unosa, korisnik_unio);

12.
SELECT *
FROM user_tab_comments
WHERE comments IS NOT NULL;

SELECT *
FROM user_col_comments
WHERE comments IS NOT NULL;

13.
ALTER TABLE zaposleni
DROP UNUSED COLUMNS;