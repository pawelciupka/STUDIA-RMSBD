-- Paweł Ciupka 234048
-- Maciej Majchrowski 234
--
-- PLACE TABLE
CREATE TABLE place (
  place_id number NOT NULL,
  info varchar2(50) NOT NULL,
  street varchar2(50) NOT NULL,
  city varchar2(20) NOT NULL,
  postal_code varchar2(6) NOT NULL
);

ALTER TABLE
  place
ADD
  CONSTRAINT place_pk PRIMARY KEY (place_id);

--
-- PLACEMENT TABLE
CREATE TABLE placement (
  placement_id number NOT NULL,
  info varchar2(50) NOT NULL,
  weight_limit number NOT NULL,
  CONSTRAINT place_id FOREIGN KEY(place_id) REFERENCES place(place_id)
);

ALTER TABLE
  placement
ADD
  CONSTRAINT placement_pk PRIMARY KEY (placement_id);

--
-- PACKAGE TABLE
CREATE TABLE package (
  package_id number NOT NULL,
  name varchar2(50) NOT NULL,
  CONSTRAINT product_id FOREIGN KEY(product_id) REFERENCES product(product_id),
  expiration_date date NOT NULL,
  CONSTRAINT placement_id FOREIGN KEY(placement_id) REFERENCES placement(placement_id)
);

ALTER TABLE
  package
ADD
  CONSTRAINT package_pk PRIMARY KEY (package_id);

--
-- PRODUCT TABLE
CREATE TABLE product (
  product_id number NOT NULL,
  name varchar2(50) NOT NULL,
  producent varchar2(50) NOT NULL,
  weight number NOT NULL,
  CONSTRAINT foot_type_id FOREIGN KEY(foot_type_id) REFERENCES food_type(foot_type_id)
);

ALTER TABLE
  product
ADD
  CONSTRAINT product_pk PRIMARY KEY (product_id);

--
-- FOOD_TYPE TABLE
CREATE TABLE food_type (
  food_type_id number NOT NULL,
  name varchar2(50) NOT NULL
);

ALTER TABLE
  food_type
ADD
  CONSTRAINT food_type_pk PRIMARY KEY (food_type_id);

--
-- TRANSACTION TABLE
CREATE TABLE transaction (
  transaction_id number NOT NULL,
  time_stamp timestamp NOT NULL,
  CONSTRAINT package_id FOREIGN KEY(package_id) REFERENCES package(package_id),
  info varchar2(50) NOT NULL
);

ALTER TABLE
  transaction
ADD
  CONSTRAINT transaction_pk PRIMARY KEY (transaction_id);

/ -- create table zabiegi (
-- id_zabiegu number not null,
-- nazwa varchar2(30) not null,
-- cena number not null,
-- czas_zabiegu number not null,
-- id_stanowiska number,
-- constraint id_stanowisko_FK FOREIGN KEY(id_stanowiska) references stanowisko(id_stanowiska)
-- );
-- ALTER TABLE zabiegi ADD (
--   CONSTRAINT zabiegi_PK PRIMARY KEY (id_zabiegu));
-- CREATE SEQUENCE zabiegi_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER zabiegi_trigger
-- BEFORE INSERT ON zabiegi 
-- FOR EACH ROW
-- BEGIN
--   SELECT zabiegi_seq.NEXTVAL
--   INTO   :new.id_zabiegu
--   FROM   dual;
-- END;
-- /
-- create table pracownik (
-- id_pracownika number not null, 
-- imie varchar2(30) not null,
-- nazwisko varchar2 (40) not null,
-- id_stanowiska number,
-- constraint id_stanowisko_FK2 FOREIGN KEY(id_stanowiska) references stanowisko(id_stanowiska)
-- );
-- ALTER TABLE pracownik ADD (
--   CONSTRAINT pracownick_PK PRIMARY KEY (id_pracownika));
-- CREATE SEQUENCE pracownik_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER pracownik_trigger
-- BEFORE INSERT ON pracownik 
-- FOR EACH ROW
-- BEGIN
--   SELECT pracownik_seq.NEXTVAL
--   INTO   :new.id_pracownika
--   FROM   dual;
-- END;
-- /
-- create table oddzial (
-- id_oddzialu number not null,
-- nazwa varchar2 (30) not null
-- );
-- ALTER TABLE oddzial ADD (
--   CONSTRAINT oddzial_PK PRIMARY KEY (id_oddzialu));
-- CREATE SEQUENCE oddzial_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER oddzial_trigger
-- BEFORE INSERT ON oddzial 
-- FOR EACH ROW
-- BEGIN
--   SELECT oddzial_seq.NEXTVAL
--   INTO   :new.id_oddzialu
--   FROM   dual;
-- END;
-- /
-- create table gabinet (
-- id_gabinetu number not null,
-- nazwa varchar2(30) not null,
-- id_oddzialu number,
-- constraint id_oddzialu_FK FOREIGN KEY(id_oddzialu) references oddzial(id_oddzialu)
-- );
-- ALTER TABLE gabinet ADD (
--   CONSTRAINT gabinet_PK PRIMARY KEY (id_gabinetu));
-- CREATE SEQUENCE gabinet_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER gabinet_trigger
-- BEFORE INSERT ON gabinet 
-- FOR EACH ROW
-- BEGIN
--   SELECT gabinet_seq.NEXTVAL
--   INTO   :new.id_gabinetu
--   FROM   dual;
-- END;
-- /
-- create table klienci (
-- id_klienta number not null,
-- imie varchar2 (20) not null,
-- nazwisko varchar2 (30) not null,
-- plec varchar2(1) not null constraint osoba_plec_CH CHECK (plec='K' OR plec='M')
-- );
-- ALTER TABLE klienci ADD (
--   CONSTRAINT klienci_PK PRIMARY KEY (id_klienta));
-- CREATE SEQUENCE klienci_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER klienci_trigger
-- BEFORE INSERT ON klienci 
-- FOR EACH ROW
-- BEGIN
--   SELECT klienci_seq.NEXTVAL
--   INTO   :new.id_klienta
--   FROM   dual;
-- END;
-- /
-- create table rezerwacja (
-- id_rezerwacji number not null,
-- data date not null,
-- id_klienta number ,
-- id_zabiegu number ,
-- id_gabinetu number,
-- id_pracownika number,
-- constraint rezerwacja_klient_FK Foreign KEY(id_klienta) references klienci(id_klienta),
-- constraint rezerwacja_zabiegi_FK Foreign Key(id_zabiegu) references zabiegi(id_zabiegu),
-- constraint id_gabinetu_FK Foreign Key(id_gabinetu) references gabinet(id_gabinetu),
-- constraint id_pracownika_FK Foreign Key(id_pracownika) references pracownik(id_pracownika)
-- );
-- ALTER TABLE rezerwacja ADD (
--   CONSTRAINT rezerwacja_PK PRIMARY KEY (id_rezerwacji));
-- CREATE SEQUENCE rezerwacja_seq START WITH 1;
-- CREATE OR REPLACE TRIGGER rezerwacja_trigger
-- BEFORE INSERT ON rezerwacja 
-- FOR EACH ROW
-- BEGIN
--   SELECT rezerwacja_seq.NEXTVAL
--   INTO   :new.id_rezerwacji
--   FROM   dual;
-- END;
-- /
-- insert into stanowisko (nazwa) values ('masazysta');
-- insert into stanowisko (nazwa) values ('fryzjer');
-- insert into stanowisko (nazwa) values ('kosmetyczka');
-- insert into stanowisko (nazwa) values ('wizazysta');
-- insert into stanowisko (nazwa) values ('rehabilitant');
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('masaz', 100, 60, 1);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('czesanie', 40, 30, 2);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('pedicure', 30, 30, 3);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('makijaz', 40, 30, 4);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('fizjoterapia', 80, 120, 5);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('masaz tajski', 120, 45, 1);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('strzyzenie', 60, 40, 2);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('manicure', 50, 40, 3);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('makijaz wieczorowy', 60, 90, 4);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('rehabilitacja nurologiczna', 150, 120, 5);
-- insert into zabiegi (nazwa, cena, czas_zabiegu, id_stanowiska) values ('rehabilitacja ortopedyczna', 120, 120, 1);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Anna', 'Grzelak', 1);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Janusz', 'Nowak', 2);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Agnieszka', 'Baros', 3);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Marcin', 'Sikorski', 4);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Joanna', 'Olbratowska', 5);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Adam', 'Strzelecki', 1);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Aneta', 'Mickiewicz', 2);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Romuald', 'Soszynski', 3);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Zuzanna', 'Mikolajczyk', 4);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Pawel', 'Piotrowski', 5);
-- insert into pracownik (imie, nazwisko, id_stanowiska) values ('Milena', 'Piotrowska', 1);
-- insert into oddzial (nazwa) values ('Bajeczna kraina');
-- insert into oddzial (nazwa) values ('Oaza spokoju');
-- insert into oddzial (nazwa) values ('Lazurowe wybrzeze');
-- insert into gabinet (nazwa, id_oddzialu) values ('Rozany', 1);
-- insert into gabinet (nazwa, id_oddzialu) values ('Sloneczny', 2);
-- insert into gabinet (nazwa, id_oddzialu) values ('Lustrzany', 1);
-- insert into gabinet (nazwa, id_oddzialu) values ('Romantyczny', 1);
-- insert into gabinet (nazwa, id_oddzialu) values ('Ogrodowy', 2);
-- insert into klienci (imie, nazwisko, plec) values ('Marcelina', 'Kotowicz', 'K');
-- insert into klienci (imie, nazwisko, plec) values ('Michal', 'Debczynski', 'M');
-- insert into klienci (imie, nazwisko, plec) values ('Lidia', 'Dedkowska', 'K');
-- insert into klienci (imie, nazwisko, plec) values ('Piotr', 'Andrzejewski', 'M');
-- insert into klienci (imie, nazwisko, plec) values ('Monika', 'Marciniak', 'K');
-- insert into klienci (imie, nazwisko, plec) values ('Marek', 'Markiewicz', 'M');
-- insert into klienci (imie, nazwisko, plec) values ('Klaudia', 'Malinowska', 'K');
-- insert into klienci (imie, nazwisko, plec) values ('Albert', 'Krupowczyk', 'M');
-- insert into klienci (imie, nazwisko, plec) values ('Patrycja', 'Wlodowska', 'K');
-- insert into klienci (imie, nazwisko, plec) values ('Damian', 'Hertel', 'M');
-- --
-- alter session set nls_date_format = 'dd/MON/yyyy hh24:mi:ss';
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016/02/23 14:25:00', 'yyyy/mm/dd hh24:mi:ss'), 1, 1, 1, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-15 15:00:00', 'yyyy/mm/dd hh24:mi:ss'), 2, 2, 2, 2);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-16 16:00:00', 'yyyy/mm/dd hh24:mi:ss'), 2, 1, 2, 2);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-02-01 11:15:00', 'yyyy/mm/dd hh24:mi:ss'), 2, 3, 1, 3);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-25 13:00:00', 'yyyy/mm/dd hh24:mi:ss'), 3, 4, 2, 4);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-08 19:00:00', 'yyyy/mm/dd hh24:mi:ss'), 4, 4, 2, 4);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-04 17:45:00', 'yyyy/mm/dd hh24:mi:ss'), 5, 5, 3, 5);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2015-12-28 18:00:00', 'yyyy/mm/dd hh24:mi:ss'), 5, 6, 3, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2015-12-09 10:30:00', 'yyyy/mm/dd hh24:mi:ss'), 6, 6, 4, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-25 09:00:00', 'yyyy/mm/dd hh24:mi:ss'), 7, 6, 5, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-28 12:30:00', 'yyyy/mm/dd hh24:mi:ss'), 8, 7, 5, 7);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-30 16:00:00', 'yyyy/mm/dd hh24:mi:ss'), 8, 8, 5, 8);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-01-09 17:00:00', 'yyyy/mm/dd hh24:mi:ss'), 9, 9, 4, 9);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-02-10 18:10:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 10, 5, 10);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2016-02-10 18:50:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 10);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2005-07-19 15:50:00', 'yyyy/mm/dd hh24:mi:ss'), 4, 4, 3, 7);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2012-03-17 12:50:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2017-06-17 14:00:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2000-06-17 10:00:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2002-06-17 19:00:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 1);
-- insert into rezerwacja (data, id_klienta, id_zabiegu, id_gabinetu, id_pracownika) values (TO_DATE('2000-06-17 09:00:00', 'yyyy/mm/dd hh24:mi:ss'), 10, 9, 5, 1);
-- ---------------------Procedury--------------------------------------------------------------------------------------------
-- --1 Usuwanie rezerwacji starszych niz podana liczba lat
-- select data from rezerwacja order by data asc;
-- CREATE OR REPLACE PROCEDURE procedura1(arg in number) is
-- begin
-- 	delete from rezerwacja
-- 	where (data - sysdate) > (arg*365);
-- end;
-- SET SERVEROUTPUT ON
-- BEGIN
-- procedura1(10);
-- END;
-- /
-- --2 Dodawanie nowego klienta
-- select * from klienci;
-- CREATE OR REPLACE PROCEDURE procedura2 (imie in varchar2, nazwisko in varchar2) is
-- begin
-- 	if imie is null or nazwisko is null 
--     then DBMS_OUTPUT.put_line ('Prosze wpisac imie i nazwisko');
-- 	else 
-- 		insert into klienci (imie, nazwisko, plec) values (imie, nazwisko, 'K');
-- 		DBMS_OUTPUT.put_line ('Wprowadzono nowego klienta do bazy: ' || imie || ' ' || nazwisko); 
-- 	end if;
-- end;
-- SET SERVEROUTPUT ON
-- BEGIN
-- procedura2('Kamila', 'Matusiak');
-- END;
-- SET SERVEROUTPUT ON
-- BEGIN
-- procedura2('Imie', '');
-- END;
-- /
-- --3 Zmiana stanowiska dla danego pracownika
-- select * from pracownik;
-- CREATE OR REPLACE PROCEDURE procedura3 (idPracownika in varchar2, idStanowiska in varchar2) is
-- begin
-- 	if idPracownika is null or idStanowiska is null 
--     then DBMS_OUTPUT.put_line ('Podaj ID Pracownika oraz ID Stanowiska');
-- 	else
-- 		update pracownik
-- 		set id_stanowiska=idStanowiska
-- 		where id_pracownika=idPracownika;
-- 		DBMS_OUTPUT.put_line ('Zmieniono stanowisko dla pracownika o ID '|| idPracownika || ' na stanowisko o ID ' || idStanowiska);
-- 	end if;
-- end;
-- SET SERVEROUTPUT ON
-- BEGIN
-- procedura3(1, 2);
-- END;
-- /
-- ---------------------Funkcje-------------------------------------------------------------------------------------------------------
-- --Wypisanie najwiekszej liczby zabiegów, wykonanej przez jednego pracownika
-- CREATE OR REPLACE FUNCTION funkcja1 return number is
-- zmienna number;
-- begin
-- 	select max(zabiegi.id_zabiegu) as zabiegi into zmienna
-- 					from zabiegi, rezerwacja, pracownik
-- 					where zabiegi.id_zabiegu=rezerwacja.id_zabiegu
-- 						and rezerwacja.id_pracownika=pracownik.id_pracownika
-- 					order by count(zabiegi.id_zabiegu) desc;
-- 	return zmienna;
-- end;
-- select funkcja1 from SYS.dual;
-- --Zwrocenie liczby wszystkich pracownikow
-- CREATE OR REPLACE FUNCTION funkcja2 return number is
-- liczba number;
-- begin
-- 	select count(pracownik.id_pracownika) as liczba_pracowników into liczba
-- 					from pracownik, stanowisko
--           where pracownik.id_stanowiska=stanowisko.id_stanowiska;
-- 	return zmienna;
-- end;
-- select funkcja2 from dual;
-- ---------------------Wyzwalacze------------------------------------------------------------------------------------------------------
-- drop trigger wyzwalacz;
-- drop trigger wyzwalacz1;
-- drop trigger wyzwalacz2;
-- drop trigger wyzwalacz3;
-- drop trigger wyzwalacz4;
-- drop trigger wyzwalacz5;
-- drop trigger wyzwalacz6;
-- --1 Informacja o liczbie klientow po ich dodaniu lub usunieciu.
-- CREATE OR REPLACE TRIGGER wyzwalacz
-- AFTER INSERT OR DELETE
-- ON klienci
-- declare zmienna number;
-- BEGIN
--   select count(id_klienta) into zmienna from klienci;
--   DBMS_OUTPUT.put_line ('Liczba klienkow: ' || zmienna);
-- END;
-- /
-- insert into klienci (imie, nazwisko, plec) values ('Anna', 'Grzelak', 'K');
-- --2 Zliczanie oddzialow
-- CREATE OR REPLACE TRIGGER wyzwalacz2
-- AFTER DELETE
-- ON oddzial
-- declare licznik number;
-- BEGIN
--   DECLARE CURSOR kursor_3 IS
--     SELECT nazwa FROM oddzial
--     FOR UPDATE OF oddzial.nazwa;
--   odd kursor_3%ROWTYPE;
--   BEGIN
--     OPEN kursor_3;
--       FETCH kursor_3 INTO odd;
--         select count(id_oddzialu) into licznik from oddzial;
--         DBMS_OUTPUT.put_line ('Pozostalo ' || licznik || ' oddzialow');
--     CLOSE kursor_3;
--   END;
-- END;
-- /
-- delete from oddzial where nazwa = 'Zaczarowany las';
-- --3 Usuniecie pracownika
-- CREATE OR REPLACE TRIGGER wyzwalacz4
-- BEFORE DELETE
-- ON pracownik
-- BEGIN
--   DECLARE cursor kursor IS
--   select imie, nazwisko from pracownik;
--   imie_k varchar2(20);
--   nazwisko_k varchar2(30);
--   begin
--     open kursor;
--     fetch kursor into imie_k, nazwisko_k;
--     close kursor;
--   DBMS_OUTPUT.put_line ('Uwaga! usunales pracownika ');
--   end;
-- END;
-- /
-- delete from pracownik where id_pracownika = 3;
-- --4 Wypisanie cen zabiegow przy zmianie tabeli zabiegi.
-- CREATE OR REPLACE TRIGGER wyzwalacz5
-- AFTER INSERT OR UPDATE OR DELETE
-- ON zabiegi
-- declare zmienna number;
-- BEGIN
--   DECLARE CURSOR kursor_4 IS
--     SELECT nazwa, cena FROM zabiegi
--     FOR UPDATE OF zabiegi.nazwa, zabiegi.cena;
--   zab kursor_4%ROWTYPE;
--   BEGIN
--     OPEN kursor_4;
--     LOOP
--       FETCH kursor_4 INTO zab;
--       EXIT WHEN kursor_4%NOTFOUND;
--       IF zab.cena > 100 THEN 
--         DBMS_OUTPUT.put_line ('Cena > 100 zl: ' || zab.nazwa || ' ' || zab.cena || ' zl');
--       ELSIF zab.cena < 100 THEN
--         DBMS_OUTPUT.put_line ('Cena < 100 zl: ' || zab.nazwa || ' ' || zab.cena || ' zl');
--       END IF;
--     END LOOP;
--     IF zab.cena > 100 THEN 
--       select count(zab.cena) into zmienna from zabiegi;
--       DBMS_OUTPUT.put_line ('Liczba zabiegow powyzej 100zl: ' || zmienna);
--     END IF;
--     CLOSE kursor_4;
--   END;
-- END;
-- /
-- update zabiegi
-- set cena = 110
-- where nazwa = 'masaz';