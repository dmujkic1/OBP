 ALTER SESSION SET CURRENT_SCHEMA = erd;

/*1. Ispisati nazive bez ponavljanja svih pravnih lica za koje postoji fizièko lice na istoj lokaciji.*/
--1. Rezultat: 207
SELECT Sum(Length(ResNaziv)*3) FROM
(SELECT DISTINCT p.pravno_lice_id id, p.naziv ResNaziv
FROM fizicko_lice f, lokacija l, pravno_lice p
WHERE f.lokacija_id=l.lokacija_id AND p.lokacija_id=l.lokacija_id
      AND p.lokacija_id IN (SELECT lokacija_id
                             FROM fizicko_lice
                             WHERE lokacija_id IS NOT NULL));

/*2. Ispisati bez ponavljanja datum potpisivanja ugovora (u formatu dd.MM.yyyy) i naziv
pravnog lica za sve ugovore kod kojih je datum potpisivanja poslije prvog datuma
kupoprodaje faktura koje sadrže proizvod kod kojeg broj mjeseci garancije nije null.*/
--2. Rezultat: 402
SELECT Sum(Length(ResNaziv)*3 + Length("Datum Potpisivanja")*3) FROM
(SELECT DISTINCT To_Char(u.datum_potpisivanja, 'dd.MM.yyyy') "Datum Potpisivanja", p.naziv resnaziv
FROM ugovor_za_pravno_lice u, pravno_lice p
WHERE u.pravno_lice_id=p.pravno_lice_id
      AND u.datum_potpisivanja > (SELECT Min(datum_kupoprodaje)
                                  FROM faktura f, proizvod pr, narudzba_proizvoda n
                                  WHERE n.proizvod_id=pr.proizvod_id AND n.faktura_id=f.faktura_id
                                        AND pr.broj_mjeseci_garancije IS NOT NULL));

/*3. Ispisati nazive proizvoda èija je kategorija jednaka bar jednoj kategoriji proizvoda èija je
ukupna kolièina jednaka maksimalnoj od ukupnih kolièina svakog proizvoda posebno.*/
--3. Rezultat: 51
SELECT Sum(Length(naziv)*3) FROM
(SELECT naziv
FROM proizvod
WHERE kategorija_id = ANY (SELECT DISTINCT kat.kategorija_id
                           FROM kolicina kol, proizvod p, narudzba_proizvoda n, kategorija kat
                           WHERE kol.proizvod_id=p.proizvod_id AND n.proizvod_id=p.proizvod_id AND p.kategorija_id=kat.kategorija_id
                                 AND kol.kolicina_proizvoda=(SELECT Max(k.kolicina_proizvoda)
                                                             FROM kolicina k
                                                             WHERE k.proizvod_id IS NOT NULL )));

/*4. Ispisati nazive proizvoda i nazive proizvoðaèa za sve proizvode za èijeg proizvoðaèa
postoji proizvod èija je cijena proizvoda veæa od prosjeka cijena svih proizvoda.*/
--4. Rezultat: 504
SELECT Sum(Length("Proizvod")*3 + Length("Proizvodjac")*3) FROM
(SELECT p.naziv "Proizvod", pn.naziv "Proizvodjac"
FROM proizvod p, proizvodjac pr, pravno_lice pn
WHERE p.proizvodjac_id=pr.proizvodjac_id AND pr.proizvodjac_id=pn.pravno_lice_id
      AND pr.proizvodjac_id IN (SELECT proizvodjac_id
                                FROM proizvod
                                WHERE cijena > (SELECT Avg(cijena)
                                                FROM proizvod)));

/*5. Ispisati ime i prezime kupaca koji su istovremeno uposlenici i sumu potrošenog iznosa na
fakture koje su platili za svakog od njih (grupisani po imenu PA prezimenu) èija je suma
iznosa veæa od prosjeka (zaokruženog na dvije decimale) suma iznosa faktura fizièkih lica
(grupisanih po imenu PA prezimenu).*/
--5. Rezultat: 6897
SELECT Sum(Length("Ime i prezime")*3 + "iznos"*3) FROM
(SELECT fi.ime||' '||fi.prezime "Ime i prezime", SUM(f.iznos) AS "iznos"
FROM kupac k, uposlenik u, faktura f, fizicko_lice fi
WHERE k.kupac_id = fi.fizicko_lice_id
      AND u.uposlenik_id = fi.fizicko_lice_id
      AND f.kupac_id = k.kupac_id
GROUP BY fi.ime, fi.prezime
HAVING SUM(f.iznos) > (SELECT ROUND(AVG(SUM(f1.iznos)), 2)
                       FROM faktura f1
                       JOIN fizicko_lice f2 ON f1.kupac_id = f2.fizicko_lice_id
                       GROUP BY f2.ime, f2.prezime));

/*6. Ispisati naziv kurirske službe èija je suma kolièine jednog proizvoda u njenim narudžbama
gdje ima popusta jednaka maksimalnoj sumi kolièine jednog proizvoda u narudžbama svih
kurirskih službi (suma grupisano po id kurirske službe) gdje ima popusta.*/
--6. Rezultat: 18
SELECT Sum(Length("naziv")*3) FROM
(SELECT pl.naziv AS "naziv"
FROM kurirska_sluzba kur, pravno_lice pl, narudzba_proizvoda np, faktura f, isporuka i
WHERE kur.kurirska_sluzba_id = i.kurirska_sluzba_id
      AND i.isporuka_id = f.isporuka_id
      AND f.faktura_id = np.faktura_id
      AND kur.kurirska_sluzba_id = pl.pravno_lice_id
GROUP BY pl.naziv
HAVING SUM(np.kolicina_jednog_proizvoda) = (SELECT MAX(SUM(np1.kolicina_jednog_proizvoda))
                                            FROM narudzba_proizvoda np1, faktura f1, isporuka i1
                                            WHERE f1.isporuka_id = i1.isporuka_id AND np1.faktura_id = f1.faktura_id
                                            GROUP BY i1.kurirska_sluzba_id));

/*7. Ispisati ime i prezime svakog kupca (grupisano po imenu i prezimenu zajedno) i uštedu
ostvarenu na sve popuste u njegovim fakturama (izraèunatu preko kolièine jednog
proizvoda). Kao vrijednost treæe kolone prikazati vaš broj indeksa. Kolone nazvati
“Kupac”, “Usteda” i “Indeks”.*/
--7. Rezultat 17709
SELECT Sum(Length("Kupac")*3 + Round("Usteda")*3) FROM
(SELECT fi.ime||' '||fi.prezime AS "Kupac", sum(pr.cijena*np.kolicina_jednog_proizvoda*po.postotak/100) AS "Usteda", '19413' AS "Indeks"
FROM kupac ku, fizicko_lice fi, narudzba_proizvoda np, popust po, faktura fa, proizvod pr
WHERE ku.kupac_id=fi.fizicko_lice_id AND np.popust_id=po.popust_id AND fa.kupac_id=ku.kupac_id AND np.proizvod_id=pr.proizvod_id AND np.faktura_id=fa.faktura_id
GROUP BY fi.ime, fi.prezime);

/*8. Ispisati sve isporuke bez ponavljanja isporuke èije fakture imaju popust i broj mjeseci
garancije.*/
--8. Rezultat: 243
SELECT Sum(idisporuke*3 + idkurirske*3) FROM
(SELECT DISTINCT isp.isporuka_id idisporuke, kur.kurirska_sluzba_id idkurirske
FROM isporuka isp, faktura fa, kurirska_sluzba kur, narudzba_proizvoda np, proizvod pr
WHERE fa.isporuka_id=isp.isporuka_id AND np.faktura_id=fa.faktura_id AND np.proizvod_id=pr.proizvod_id AND isp.kurirska_sluzba_id=kur.kurirska_sluzba_id
      AND np.popust_id IS NOT NULL
      AND pr.broj_mjeseci_garancije IS NOT NULL);

/*9. Ispisati naziv i cijenu proizvoda èija je cijena veæa od prosjeka (zaokruženog na dvije
decimale) maksimalnih cijena proizvoda iz svake kategorije.*/
--9. Rezultat: 9210
SELECT Sum(Length(naziv)*3 + cijena*3) FROM
(SELECT pr.naziv naziv, pr.cijena cijena
FROM proizvod pr, kategorija kat
WHERE pr.kategorija_id=kat.kategorija_id
     AND pr.cijena > (SELECT Round(Avg(Max(cijena)), 2)
                      FROM proizvod
                      GROUP BY kategorija_id));

/*10. Ispisati naziv i cijenu svih proizvoda èija je cijena manja od svih prosjeènih cijena svake
kategorije koja nije podkategorija kategorije tog proizvoda.*/
--10. Rezultat: 2448
SELECT Sum(Length(naziv)*3 + Round(cijena)*3) FROM
(SELECT p.naziv naziv, p.cijena cijena
FROM proizvod p, kategorija kat
WHERE p.kategorija_id=kat.kategorija_id
      AND p.cijena < ALL (SELECT Avg(pr.cijena)
                          FROM proizvod pr, kategorija k
                          WHERE pr.kategorija_id=k.kategorija_id AND kat.kategorija_id != k.nadkategorija_id
                          GROUP BY k.kategorija_id));
