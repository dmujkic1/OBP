ALTER SESSION SET CURRENT_SCHEMA = erd;

--1. 7371
/*SELECT Sum(Length(Drzava)*7+Length(Grad)*7+Length(Kontinent)*7)*MAX(BrojLokacija) FROM
(SELECT k.naziv AS Kontinent, NVL(d.naziv, 'Nema države') AS Drzava, NVL(g.naziv, 'Nema grada') AS Grad, Count(l.lokacija_id) AS BrojLokacija
FROM kontinent k
LEFT OUTER JOIN drzava d ON d.kontinent_id = k.kontinent_id
LEFT OUTER JOIN grad g ON g.drzava_id = d.drzava_id
LEFT OUTER JOIN lokacija l ON l.grad_id=g.grad_id
GROUP BY k.naziv, d.naziv, g.naziv);*/

--2. 49
/*SELECT SUM(LENGTH(naziv)*7) FROM
(SELECT p.naziv AS Naziv
FROM pravno_lice p, ugovor_za_pravno_lice u
WHERE u.pravno_lice_id = p.pravno_lice_id AND
                  u.datum_raskidanja IS NULL AND Mod(To_Number(To_Char(u.datum_potpisivanja, 'yyyy')),2)=0);*/

--3. 1120
/*SELECT SUM(Length(Drzava)*7 + Length(proizvod)*7 + kolicina_proizvoda*7) FROM
(SELECT d.naziv AS Drzava, k.kolicina_proizvoda AS Kolicina_proizvoda, p.naziv AS Proizvod
FROM kolicina k, proizvod p, drzava d, skladiste s, lokacija l, grad g
WHERE k.skladiste_id=s.skladiste_id AND k.proizvod_id=p.proizvod_id AND s.lokacija_id=l.lokacija_id AND l.grad_id=g.grad_id AND g.drzava_id=d.drzava_id
                                    AND k.kolicina_proizvoda>50 AND d.naziv NOT LIKE '%s%s%');*/

--4. 301
/*SELECT Sum(Length(naziv)*7) FROM
(SELECT DISTINCT p.naziv, p.broj_mjeseci_garancije
FROM proizvod p, narudzba_proizvoda n
WHERE n.proizvod_id=p.proizvod_id AND n.popust_id IS NOT NULL
                                  AND Mod(p.broj_mjeseci_garancije,3)=0);*/

--5. 1337
/*SELECT Sum(Length("ime i prezime")*7+Length("Naziv odjela")*7)
FROM
(SELECT f.ime||' '||f.prezime AS "ime i prezime", o.naziv AS "Naziv odjela", 19413 AS "Indeks"
FROM uposlenik u, odjel o, fizicko_lice f, kupac k
WHERE u.uposlenik_id=f.fizicko_lice_id AND k.kupac_id=f.fizicko_lice_id AND u.odjel_id=o.odjel_id
                                       AND u.uposlenik_id!=o.sef_id);*/

--6. 28126
/*SELECT Sum(NARUDZBA_ID*7+cijena*7+postotak*7) FROM
(SELECT n.narudzba_id AS Narudzba_id, p.cijena AS Cijena, Nvl(po.postotak,0) AS Postotak, Nvl(po.postotak,0)/100 AS PostotakRealni
FROM narudzba_proizvoda n
LEFT OUTER JOIN proizvod p ON n.proizvod_id=p.proizvod_id
LEFT OUTER JOIN popust po ON n.popust_id=po.popust_id
WHERE Nvl(po.postotak,0)/100*p.cijena<200);*/

--7. 1001
/*SELECT Sum(Length("Kategorija")*7+Length("Nadkategorija")*7) FROM
(SELECT DECODE(k.kategorija_id, 1, 'Komp Oprema', DECODE(k.kategorija_id, NULL, 'Nema Kategorije', k.naziv)) AS "Kategorija",
        DECODE(nk.kategorija_id, 1, 'Komp Oprema', DECODE(nk.kategorija_id, NULL, 'Nema Kategorije', nk.naziv)) AS "Nadkategorija"
FROM KATEGORIJA k
LEFT OUTER JOIN KATEGORIJA nk ON k.nadkategorija_id = nk.kategorija_id);*/

--8. 28188
/*SELECT Sum(To_Number(To_Char(RASKID,'YYYY'))) * 2 FROM
(SELECT Nvl(datum_raskidanja,Add_Months(datum_potpisivanja, 24)) AS Raskid
FROM ugovor_za_pravno_lice
WHERE To_Number(SubStr(ugovor_id,1,2))<=50);*/

--9. 140
/*SELECT SUM(Length(ime)*7+Length(prezime)*7+Length(Odjel)*7) FROM
(SELECT f.ime AS ime, f.prezime AS prezime,
        CASE
        WHEN u.uposlenik_id = o.sef_id THEN 'MANAGER'
        WHEN u.uposlenik_id != o.sef_id THEN 'HUMAN'
        ELSE 'OTHER'
        END AS odjel,
     o.odjel_id AS odjel_id
FROM uposlenik u, odjel o, fizicko_lice f
WHERE u.uposlenik_id=f.fizicko_lice_id AND u.odjel_id=o.odjel_id
ORDER BY f.ime ASC, f.prezime DESC)
WHERE ROWNUM<2;*/

--10. 7294
/*SELECT SUM(Length(Najjeftiniji)*7+ZCijena*7) FROM
(SELECT DISTINCT k.naziv, (SELECT p1.naziv FROM proizvod p1 WHERE p1.kategorija_id=k.kategorija_id AND cijena=(SELECT MAX(cijena) FROM Proizvod p2 WHERE p2.kategorija_id=k.kategorija_id)) AS Najskuplji,
                         (SELECT p2.naziv FROM proizvod p2 WHERE p2.kategorija_id=k.kategorija_id AND cijena=(SELECT MIN(cijena) FROM Proizvod p3 WHERE p3.kategorija_id=k.kategorija_id)) AS Najjeftiniji,
                         (SELECT MAX(cijena) + MIN(cijena) FROM proizvod p4 WHERE p4.kategorija_id = k.kategorija_id) AS ZCijena
FROM proizvod p, kategorija k
WHERE p.kategorija_id=k.kategorija_id)
WHERE ROWNUM<4;*/

