ALTER SESSION SET CURRENT_SCHEMA = erd;

/*1. Za svaki kontinent prikazati njegove države i gradove i broj lokacija zabilježenih u svakom gradu.
Ako kontinent nema države ispisati ‘Nema države’ a ako nema grada ‘Nema grada’.
Kolone nazvati Država, Grad i Kontinent, BrojLokacija*/
--3159
/*SELECT Sum(Length(Drzava)*3+Length(Grad)*3+Length(Kontinent)*3)*MAX(BrojLokacija) FROM
(SELECT k.naziv AS Kontinent, NVL(d.naziv, 'Nema države') AS Drzava, NVL(g.naziv, 'Nema grada') AS Grad, Count(l.lokacija_id) AS BrojLokacija
FROM kontinent k
LEFT OUTER JOIN drzava d ON d.kontinent_id = k.kontinent_id
LEFT OUTER JOIN grad g ON g.drzava_id = d.drzava_id
LEFT OUTER JOIN lokacija l ON l.grad_id=g.grad_id
GROUP BY k.naziv, d.naziv, g.naziv);*/
--SELECT k.naziv AS "Kontinent", NVL(d.naziv, 'Nema države') AS "Država", NVL(g.naziv, 'Nema grada') AS "Grad", l.broj AS "BrojLokacija"
--FROM lokacija l, grad g, drzava d, kontinent k
--WHERE l.grad_id=g.grad_id AND g.drzava_id=d.drzava_id AND d.kontinent_id=k.kontinent_id;


/*2. Prikazati naziv za sva pravna lica koja nisu raskinula ugovor a godina potpisivanja ugovora je parna.
Kolonu nazvati Naziv.*/
--21
/*SELECT SUM(LENGTH(naziv)*3) FROM
(SELECT p.naziv AS Naziv
FROM pravno_lice p, ugovor_za_pravno_lice u
WHERE u.pravno_lice_id = p.pravno_lice_id AND
                  u.datum_raskidanja IS NULL AND Mod(To_Number(To_Char(u.datum_potpisivanja, 'yyyy')),2)=0):*/


/*3. Za svaku državu prikazati kolicinu svakog proizvoda koja se nalazi u skladištima te države ako je
kolicina proizvoda veca od 50 i naziv države ne sadrži duplo slovo ‘s’.
Kolone nazvati Drzava, Proizvod i Kolicina_proizvoda.*/
--480
/*SELECT SUM(Length(Drzava)*3 + Length(proizvod)*3 + kolicina_proizvoda*3) FROM
(SELECT d.naziv AS Drzava, k.kolicina_proizvoda AS Kolicina_proizvoda, p.naziv AS Proizvod
FROM kolicina k, proizvod p, drzava d, skladiste s, lokacija l, grad g
WHERE k.skladiste_id=s.skladiste_id AND k.proizvod_id=p.proizvod_id AND s.lokacija_id=l.lokacija_id AND l.grad_id=g.grad_id AND g.drzava_id=d.drzava_id
                                    AND k.kolicina_proizvoda>50 AND d.naziv NOT LIKE '%s%s%');*/



/*4. Prikazati naziv proizvoda i broj mjeseci garancije za sve proizvode na koje postoji popust
a broj mjeseci garancije im je djeljiv sa 3.
Potrebno je prikazati rezultate bez ponavljanja*/
--129
/*SELECT Sum(Length(naziv)*3) FROM
(SELECT DISTINCT p.naziv, p.broj_mjeseci_garancije
FROM proizvod p, narudzba_proizvoda n
WHERE n.proizvod_id=p.proizvod_id AND n.popust_id IS NOT NULL
                                  AND Mod(p.broj_mjeseci_garancije,3)=0);*/




/*5. Prikazati kompletno ime i prezime u jednoj koloni i naziv odjela uposlenika koji je ujedno i kupac
proizvoda a nije šef tog odjela. Kao vrijednost treæe kolone nadodati vaš broj indeksa u svakom
redu. Kolone nazvati “ime i prezime”, “Naziv odjela” i “Indeks”.*/
--573
/*SELECT Sum(Length("ime i prezime")*3+Length("Naziv odjela")*3)
FROM
(SELECT f.ime||' '||f.prezime AS "ime i prezime", o.naziv AS "Naziv odjela", 19413 AS "Indeks"
FROM uposlenik u, odjel o, fizicko_lice f, kupac k
WHERE u.uposlenik_id=f.fizicko_lice_id AND k.kupac_id=f.fizicko_lice_id AND u.odjel_id=o.odjel_id
                                       AND u.uposlenik_id!=o.sef_id); */

/*6. Za sve narudžbe èiji je popust konvertovan u vrijednost cijene manji od 200 prikazati proizvod,
cijenu proizvoda i postotak popusta narudžbe kao cijeli broj (od 0 do 100) i kao realni broj (od 0
do 1). Narudžbe koje nemaju popust trebaju biti prikazane kao 0 posto popusta. Nazvati kolone
Narudzba_id, Cijena, Postotak i PostotakRealni.*/
--12054
/*SELECT Sum(NARUDZBA_ID*3+cijena*3+postotak*3) FROM
(SELECT n.narudzba_id AS Narudzba_id, p.cijena AS Cijena, Nvl(po.postotak,0) AS Postotak, Nvl(po.postotak,0)/100 AS PostotakRealni
FROM narudzba_proizvoda n
LEFT OUTER JOIN proizvod p ON n.proizvod_id=p.proizvod_id
LEFT OUTER JOIN popust po ON n.popust_id=po.popust_id
WHERE Nvl(po.postotak,0)/100*p.cijena<200);*/


/*7. Prikazati sve raspoložive kategorije proizvoda i njihove nadkategorije. Ako je id kategorije 1
umjesto naziva kategorije treba pisati ‘Komp Oprema’ a ako nema kategorije treba pisati ‘Nema
Kategorije’. Nazvati kolone “Kategorija” i “Nadkategorija”*/
--429
/*SELECT Sum(Length("Kategorija")*3+Length("Nadkategorija")*3) FROM
(SELECT DECODE(k.kategorija_id, 1, 'Komp Oprema', DECODE(k.kategorija_id, NULL, 'Nema Kategorije', k.naziv)) AS "Kategorija",
        DECODE(nk.kategorija_id, 1, 'Komp Oprema', DECODE(nk.kategorija_id, NULL, 'Nema Kategorije', nk.naziv)) AS "Nadkategorija"
FROM KATEGORIJA k
LEFT OUTER JOIN KATEGORIJA nk ON k.nadkategorija_id = nk.kategorija_id);*/



/*8. Za svaki ugovor èije èije prve dvije cifre èine broj koji nije veæi od 50 ispisati datum raskidanja
ugovora. Ako ne postoji datum raskidanja, potrebno je prikazati datum raskidanja kao datum
potpisivanja ugovora plus dvije godine. Kolonu za datum raskidanja nazvati Raskid.*/
--14094
/*SELECT Sum(To_Number(To_Char(RASKID,'YYYY'))) FROM
(SELECT Nvl(datum_raskidanja,Add_Months(datum_potpisivanja, 24)) AS Raskid
FROM ugovor_za_pravno_lice
WHERE To_Number(SubStr(ugovor_id,1,2))<=50);*/


/*9. Prikazati ime i prezime, naziv odjela i id odjela svih uposlenika pri èemu je naziv odjela sa
MANAGER ako je u pitanju managment, HUMAN ako su u pitanju ljudski resursi i OTHER za
sve ostalo, sortiranih prvo po imenu po rastuæem poretku zatim po prezimenu po opadajuæem
poretku. Kolone nazvati ime prezime, odjel i odjel_id.*/
--60
/*SELECT SUM(Length(ime)*3+Length(prezime)*3+Length(Odjel)*3) FROM
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



/*10. Prikazati svaku kategoriju proizvoda i za svaku kategoriju najskuplji i najjeftiniji proizvod te
kategorije i zbir njihovih cijena sortirane po zbiru cijena najjeftinijeg i najskupljeg proizvoda u
rastuæem poretku. Zbir cijena nazvati ZCijena a proizvode Najjeftiniji i Najskuplji.*/
--3126
/*SELECT SUM(Length(Najjeftiniji)*3+ZCijena*3) FROM
(SELECT DISTINCT k.naziv, (SELECT p1.naziv FROM proizvod p1 WHERE p1.kategorija_id=k.kategorija_id AND cijena=(SELECT MAX(cijena) FROM Proizvod p2 WHERE p2.kategorija_id=k.kategorija_id)) AS Najskuplji,
                         (SELECT p2.naziv FROM proizvod p2 WHERE p2.kategorija_id=k.kategorija_id AND cijena=(SELECT MIN(cijena) FROM Proizvod p3 WHERE p3.kategorija_id=k.kategorija_id)) AS Najjeftiniji,
                         (SELECT MAX(cijena) + MIN(cijena) FROM proizvod p4 WHERE p4.kategorija_id = k.kategorija_id) AS ZCijena
FROM proizvod p, kategorija k
WHERE p.kategorija_id=k.kategorija_id)
WHERE ROWNUM<4;*/







