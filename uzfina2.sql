-- BAZA HURTOWNIA
--9.
create table nabywcy(
kod number(4) primary key,
nazwa varchar2(15) not null,
nip varchar2(10),
adres varchar2(40) not null);
--inaczej
create table nabywcy(
kod number(4),
nazwa varchar2(15) not null,
nip varchar2(10),
adres varchar2(40) not null,
primary key(kod));

create table faktury(
nr_faktury number(4) primary key,
data_wystawienia date default sysdate,
wartosc number(10,2) not null,
platnosc varchar2(1) check (platnosc = 'p' or platnosc = 'g'),
dla_kogo number(4) not null references nabywcy);--przed references mozna constraint
--inaczej
create table faktury(
primary key(nr_faktury),
nr_faktury number(4) primary key,
data_wystawienia date default sysdate,
wartosc number(10,2) not null,
platnosc varchar2(1) check (platnosc = 'p' or platnosc = 'g'),
dla_kogo number(4) not null,
constraint fk_faktury_dla_kogo foreign key (dla_kogo) references nabywcy(kod));

create table towary (
id_towaru number(3) primary key,
nazwa varchar2(30) not null,
stan number(10,2) not null check(stan>=0));

create table towary_na_fakturze(
nr_faktury number(4) references faktury,
nr_towaru number(3) references towary,
ilosc number(10,2) not null check (ilosc>0),
primary key(nr_faktury,nr_towaru));
--10
insert into nabywcy values(1,'firma','574860091','Zielona 6'); 
insert into nabywcy values('2','firmax','574860092','Polna 3'); 
insert into nabywcy values('3','firmay','574860093','Ró¿ana 15'); 
insert into nabywcy values('4','firmaz','574860094','Kolorowa 26');
insert into nabywcy (kod,nip,adres) values (6,'00380','G³êboka 3');--nie wykona siê
insert into nabywcy (kod,nazwa,adres) values ('5','firmab','Zielona 7');
insert into nabywcy (kod,nazwa,nip,adres) values (6,'firmaa','00380','G³êboka 3');
--11
insert into towary values(1,'Sól',10);
insert into towary values(2,'Pieprz',5);
INSERT INTO towary VALUES (3,'M¹ka',15);
INSERT INTO towary VALUES (4,'Chleb',13);
INSERT INTO towary VALUES (5,'Jajka',21);
--12
alter table nabywcy add (
kraj varchar2(15));
--13
update nabywcy set kraj='Polska';
--14
ALTER TABLE nabywcy MODIFY kraj NOT NULL;
--15
UPDATE nabywcy SET kraj='Niemcy' WHERE kod=(SELECT MAX(kod) FROM nabywcy);
--16
INSERT INTO nabywcy VALUES (7,'firmak','Francja','Kolorowa 1');
INSERT INTO nabywcy VALUES ((SELECT MAX(kod) FROM nabywcy)+1,'firmak','2712325780','Kolorowa 1','Francja');
--17
UPDATE towary SET stan=stan+100 WHERE id_towaru IN(2,3,5);
--18
ALTER TABLE nabywcy MODIFY adres VARCHAR2(50);
ALTER TABLE nabywcy MODIFY adres VARCHAR2(5);
--SQL Error: ORA-01441: nie mo¿na zmniejszyæ d³ugoœci kolumny, poniewa¿ niektóre wartoœci s¹ zbyt du¿e
--19
DELETE FROM nabywcy WHERE kraj='Niemcy';
--20
CREATE VIEW nabywcy_z_polski AS
  SELECT *
  FROM nabywcy 
  WHERE kraj='Polska'
  WITH READ ONLY;
--21
INSERT INTO nabywcy_z_polski VALUES ((SELECT MAX(kod) FROM nabywcy)+1,'firma22','445644646','Langiewicza 9','Polska');
--SQL Error: ORA-42399: nie mo¿na przeprowadziæ operacji DML na perspektywie tylko do odczytu
--22
CREATE SEQUENCE sekwencja
START WITH 10 --;na tym mo¿na zakoñczyæ
INCREMENT BY 1;
--23
INSERT INTO towary VALUES(sekwencja.nextval,'Chleb',30);
--24
DROP SEQUENCE sekwencja;
--25
DROP VIEW nabywcy_z_polski;
--26
DROP TABLE nabywcy CASCADE CONSTRAINTS;
DROP TABLE faktury CASCADE CONSTRAINTS;
DROP TABLE towary CASCADE CONSTRAINTS;
DROP TABLE towary_na_fakturze CASCADE CONSTRAINTS;
--BAZA FIRMA----------------------------------------------------------------------
--27
CREATE TABLE prac AS SELECT * FROM firma.pracownicy;
--28
ALTER TABLE prac ADD PRIMARY KEY (id_prac);
ALTER TABLE prac MODIFY placa_podstawowa CHECK (placa_podstawowa >0);
ALTER TABLE prac MODIFY placa_dodatkowa  CHECK (placa_dodatkowa >0);
alter table prac modify data_zatrudnienia date default sysdate;
--29
CREATE TABLE wydz AS SELECT * FROM firma.wydzialy;
ALTER TABLE wydz ADD PRIMARY KEY (kod_wydzialu);
alter table wydz add unique (id_kierownika);
--SELECT * FROM firma.wydzialy;
--30
CREATE TABLE stan AS SELECT * FROM firma.stanowiska;
ALTER TABLE stan ADD PRIMARY KEY (kod_stanowiska);
--31
ALTER TABLE prac ADD CONSTRAINT fk_prac_kod_wydzialu FOREIGN KEY (kod_wydzialu) REFERENCES wydz(kod_wydzialu); 
ALTER TABLE prac ADD CONSTRAINT fk_prac_kod_stanowiska FOREIGN KEY (kod_stanowiska) REFERENCES stan(kod_stanowiska);
ALTER TABLE wydz ADD CONSTRAINT fk_wydz_id_kierownika FOREIGN KEY (id_kierownika) REFERENCES prac(id_prac);
--32
ALTER TABLE prac DROP COLUMN kod_wyksztalcenia;
--33
ALTER TABLE prac ADD ((pesel VARCHAR2(11)),UNIQUE(pesel));
--34
ALTER TABLE wydz MODIFY nazwa VARCHAR2(30);
--35
--a)
UPDATE prac SET placa_podstawowa=placa_podstawowa*0.1 WHERE kod_wydzialu='w1'; 
--b)
UPDATE prac SET placa_dodatkowa=50 WHERE praca_podstawowa<=1500;
--c)
UPDATE prac SET kod_wydzialu='w2' WHERE data_urodzenia=(SELECT MIN(data_urodzenia) FROM prac WHERE kod_wydzialu='w1');
--d)
UPDATE wydz SET id_kierownika=9 WHERE kod_wydzialu='w3';
--e)
INSERT INTO wydz (kod_wydzialu,nazwa,id_kierownika)
VALUES('w7','reklama',(SELECT id_prac FROM prac WHERE imie='Marek' AND nazwisko='Suszek'));
--f)
DELETE FROM wydz WHERE nazwa='reklama';
--g)
UPDATE prac SET placa_podstawowa=placa_podstawowa-(SELECT placa_podstawowa- placa_max FROM stan JOIN prac USING (kod_stanowiska))
WHERE placa_podstawowa>(SELECT placa_podstawowa- placa_max FROM stan JOIN prac USING (kod_stanowiska));
SELECT * FROM wydz;
SELECT kod_stanowiska,id_prac,nazwisko,placa_podstawowa, placa_min,placa_max FROM prac JOIN stan USING (kod_stanowiska);
SELECT * FROM stan;
SELECT * FROM prac;
--36
CREATE VIEW kierownik AS
SELECT kod_wydzialu,nazwa,imie,nazwisko FROM wydz JOIN prac USING (kod_wydzialu);
--DROP view kierownik;
--37
create view prac_po2000 as 
select * from prac where to_char(data_zatrudnienia,'yyyy')>2000  ;
--38
create sequence seq_prac 
start with 1;
--39
select * from prac_po2000;
insert into prac_po2000 values(seq_prac.nextval,'Adam','Kowalski','m',to_date('1977/12/23'),
's','w4',to_date('1990/03/23'),2444,null,'pb');
insert into prac_po2000 values(seq_prac.nextval,'Karol','Wiœniewski','m',to_date('1977/12/23'),
's','w4',sysdate,2444,null,'pb')
--40
alter table prac add unique(nazwisko);
insert into prac values (seq_prac.nextval,'Adam','Kowalski','m',to_date('1977/12/23'),
's','w4',to_date('1990/03/23'),2444,null,'pb');
insert into prac values(seq_prac.nextval,'Karol','Ford','m',to_date('1974/11/23'),
's','w4',sysdate,2444,null,'pb');


Select id_kursu,id_pracownika from transport.pracownicy JOIN transport.kursy ON
transport.pracownicy.id_pracownika=transport.kursy.kto;

