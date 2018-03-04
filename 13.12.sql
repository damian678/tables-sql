--27
CREATE TABLE prac AS SELECT * FROM firma.pracownicy;
--28
ALTER TABLE prac ADD PRIMARY KEY (id_prac);
ALTER TABLE prac add CHECK (placa_podstawowa >0);
alter table prac modify data_zatrudnienia default sysdate;
--29
create table wydz as
select * from firma.wydzialy;
ALTER TABLE wydz ADD PRIMARY KEY (kod_wydzialu);
alter table wydz add unique (id_kierownika);
--30 
create table stan as
select * from firma.stanowiska;
alter table stan add primary key (kod_stanowiska); 
--drop table stan cascade constraints;
--31
alter table prac add constraint fk_prac_kod_wydzialu foreign key (kod_wydzialu) references
wydz(kod_wydzialu);
--alter table prac modify kod_wydzialu references wydz;
--alter table prac add foreign key (kod_wydzialu) references wydz;
alter table prac add foreign key (kod_stanowiska) references stan on delete set null;
alter table wydz add constraint fk_prac_id_kierownika foreign key (id_kierownika) references
prac(id_prac);
--alter table wydz add foreign key (id_kierownika) references prac;
--32
alter table prac drop column kod_wyksztalcenia;
select * from prac;
--33
alter table prac add (pesel varchar2(11),unique(pesel));
alter table prac modify pesel not null;
--select * from prac;
--34
alter table wydz modify nazwa varchar2(30);
--35
--a)
UPDATE prac SET placa_podstawowa=placa_podstawowa*1.1 WHERE kod_wydzialu='w1'; 
select * from wydz;--w1 kod wydzialu administracja
select * from prac;
--b)
UPDATE prac SET placa_dodatkowa=50 WHERE placa_podstawowa<=1500;
--c)
UPDATE prac SET kod_wydzialu='w2' WHERE data_urodzenia=
(SELECT MIN(data_urodzenia) FROM prac WHERE kod_wydzialu='w1') and kod_wydzialu='w1';
--d)
update wydz set id_kierownika=9 where nazwa='kadry';--naruszono wiezy unikatowe
select * from wydz;
--e)
INSERT INTO wydz (kod_wydzialu,nazwa,id_kierownika)
VALUES('w7','reklama',(SELECT id_prac FROM prac WHERE imie='Marek' AND nazwisko='Suszek'));
select * from prac where imie='Marek' and nazwisko='Suszek';
--f)
delete from wydz where nazwa='reklama';
--g)
select * from stan;
select * from 