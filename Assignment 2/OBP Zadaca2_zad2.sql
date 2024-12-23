CREATE TABLE TabelaA (ID NUMBER PRIMARY KEY,
                      naziv VARCHAR(20),
                      datum DATE,
                      cijelibroj NUMBER,
                      realnibroj NUMBER,
                      CONSTRAINT rb CHECK (realnibroj>5),
                      CONSTRAINT cb CHECK (cijelibroj NOT BETWEEN 5 AND 15));

INSERT INTO TabelaA
VALUES (1,'tekst',NULL,NULL,6.2);

INSERT INTO TabelaA
VALUES (2,NULL,NULL,3,5.26);

INSERT INTO TabelaA
VALUES (3,'tekst',NULL,1,NULL);

INSERT INTO TabelaA
VALUES (4,NULL,NULL,NULL,NULL);

INSERT INTO TabelaA
VALUES (5,'tekst',NULL,16,6.78);

CREATE TABLE TabelaB (ID NUMBER PRIMARY KEY,
                      naziv VARCHAR(20),
                      datum DATE,
                      cijelibroj NUMBER UNIQUE,
                      realnibroj NUMBER,
                      FKTabelaA NUMBER REFERENCES TabelaA (ID) NOT NULL);

INSERT INTO TabelaB
VALUES (1,NULL,NULL,1,NULL,1);

INSERT INTO TabelaB
VALUES (2,NULL,NULL,3,NULL,1);

INSERT INTO TabelaB
VALUES (3,NULL,NULL,6,NULL,2);

INSERT INTO TabelaB
VALUES (4,NULL,NULL,11,NULL,2);

INSERT INTO TabelaB
VALUES (5,NULL,NULL,22,NULL,3);

CREATE TABLE TabelaC (ID NUMBER PRIMARY KEY,
                      naziv VARCHAR(20) NOT NULL,
                      datum DATE,
                      cijelibroj NUMBER NOT NULL,
                      realnibroj NUMBER,
                      FKTabelaB NUMBER,
                      CONSTRAINT FKCnst FOREIGN KEY (FKTabelaB) REFERENCES TabelaB (ID));

INSERT INTO TabelaC
VALUES (1,'YES',NULL,33,NULL,4);

INSERT INTO TabelaC
VALUES (2,'NO',NULL,33,NULL,2);

INSERT INTO TabelaC
VALUES (3,'NO',NULL,55,NULL,1);

--PROVJERA
INSERT INTO TabelaA (id, naziv, datum, cijeliBroj, realniBroj) VALUES (6, 'tekst', null, null,
6.20);

INSERT INTO TabelaB (id, naziv, datum, cijeliBroj, realniBroj, FkTabelaA) VALUES (6, null,
null, 1, null, 1);

INSERT INTO TabelaB (id, naziv, datum, cijeliBroj, realniBroj, FkTabelaA) VALUES (7, null,
null, 123, null, 6);

INSERT INTO TabelaC (id, naziv, datum, cijeliBroj, realniBroj, FkTabelaB) VALUES (4, 'NO',
null, 55, null, null);

UPDATE TabelaA SET naziv = 'tekst' WHERE naziv IS NULL AND cijeliBroj IS NOT NULL;

DROP TABLE TabelaB;

DELETE FROM TabelaA WHERE realniBroj IS NULL;

DELETE FROM TabelaA WHERE id = 5;

UPDATE TabelaB SET fktabelaA = 4 WHERE fktabelaA = 2;

ALTER TABLE TabelaA ADD CONSTRAINT cst CHECK (naziv LIKE 'tekst');

SELECT SUM(id) FROM TabelaA;
--Rezultat: 16
SELECT SUM(id) FROM TabelaB;
--Rezultat: 22
SELECT SUM(id) FROM TabelaC;
--Rezultat: 10


