-- Paweł Ciupka 234048
-- Maciej Majchrowski 234
--
--
--------------------

-- sprawdzenie ilości posiadanego danego typu jedzenia w bazie
create or replace function quantityOfSelectedFoodType(food_name IN varchar)
RETURN number IS
    food_type_count number;
BEGIN
select SUM(package.package_size * product.weight) into food_type_count 
    from package
    INNER JOIN  product
    ON package.product_id = product.product_id
    WHERE product.food_type = food_name

return food_type_count;
END;
/
-- wywołanie funkcji quantityOfSelectedFoodType
declare
    c varchar(20);
    food_type product.food_type%TYPE := 'napoj';
begin 
    c := quantityOfSelectedFoodType(food_type);
    dbms_output.put_line('W magazynie produktow typu: ' || food_type || ' jest: ' || c || ' kilogramow');
end;
/

-- dodawanie do pólek rzeczy według nazy produktu, nie ID
create or replace procedure add_Package_Of_Product
(
    nazwa_produktu IN product.name%type,
    nazwa_opakowania IN package.name%type,
    liczba_szt IN package.package_size%type,
    data_waznosci IN package.expiration_date%type
)
is
liczba_wystapien_nazwy number;
id_produktu number := 0;
brak_produktu EXCEPTION;
begin
    select product.product_id into id_produktu 
    from product
    where product.name = nazwa_produktu;
liczba_wystapien_nazwy := sql%rowcount;
if(id_produktu = 0) then 
    raise brak_produktu;
end if;
INSERT INTO package(name, product_id, expiration_date, placement_id, package_size) 
VALUES (
    nazwa_opakowania,
    id_produktu,
    TO_DATE(data_waznosci, 'yyyy/mm/dd'),
    1,
    liczba_szt
);
dbms_output.put_line('dodano nowe opakownie do bazy');
exception
    when brak_produktu then
        dbms_output.put_line('nie znaleziono produktu o nazwie: ' || nazwa_produktu);
end add_Package_Of_Product; 


-- wyswietlenie w scipt outpu
set serveroutput on;
begin
    add_Package_Of_Product(nazwa_produktu=>'Ser gouda 1kg', nazwa_opakowania=>'trojpak plastikowy', liczba_szt=>3, data_waznosci=>'2020/04/15');
end;

-- wyciąganie jednej rzeczy z konkretnego opakowania o nazwie

create or replace procedure take_one_item
(
    nazwa_opakowania in package.name%type,
    info_w in transaction.info%type
)
is
id_package package.package_id%type := 0;
brak_opakowania EXCEPTION;
begin
    select package.package_id into id_package
    from package
    where package.name = nazwa_opakowania
    fetch next 1 rows only;

if(id_package = 0)then
    raise brak_opakowania;
end if;
update package
    set package_size=package_size - 1
    where package.package_id=id_package;
dbms_output.put_line('Wyjeto jeden produkt z opakowania: ' || nazwa_opakowania);
INSERT INTO transaction(info, time_stamp, package_id) VALUES 
(
    info_w,
    TO_DATE(CURRENT_DATE, 'yyyy/mm/dd'),
    id_package
);
exception 
    when brak_opakowania then
        dbms_output.put_line('nie znaleziono opakowania o nazwie: ' || nazwa_opakowania);
end take_one_item;

-- wyswietlenie w scipt outpu
set serveroutput on;
begin
    take_one_item(nazwa_opakowania=>'Dwupak plastikowy', info_w=>'pora na kanapki');
end;

-- wyciąganie konkretnej liczby rzeczy z opakowania o nazwie i sprawdzenie ilosci

create or replace procedure take_x_packages
(
    nazwa_opakowania in package.name%type,
    liczba_wyciaganych in package.package_size%type,
    info_w in transaction.info%type
)
is
id_package package.package_id%type := 0;
brak_odpowiedniej_liczby EXCEPTION;
begin
    select package.package_id into id_package
    from package
    where package.name = nazwa_opakowania and package.package_size >= liczba_wyciaganych
    fetch next 1 rows only;

if(id_package = 0)then
    raise brak_odpowiedniej_liczby;
end if;
update package
    set package_size=(package_size-liczba_wyciaganych)
    where package.package_id=id_package;
dbms_output.put_line('Wyjeto ' || liczba_wyciaganych || ' opakowania: ' || nazwa_opakowania);
INSERT INTO transaction(info, time_stamp, package_id, number_of_taken_items) VALUES 
(
    info_w,
    TO_DATE(CURRENT_DATE, 'yyyy/mm/dd'),
    id_package,
    liczba_wyciaganych
);
exception 
    when brak_odpowiedniej_liczby then
        dbms_output.put_line('nie znaleziono opakowania o nazwie/nie ma tyle w magazynie: ' || nazwa_opakowania);
end take_x_packages;

-- wyswietlenie w scipt outpu
set serveroutput on;
begin
    take_x_packages(nazwa_opakowania=>'Zgrzewka - 12 szt',liczba_wyciaganych=>4,info_w=>'pora na picie');
end;

-- agregowanie rzeczy o tej samej dacie ważności i produkcie

-- szukaj rzecz na polkach o krótszym terminie przydatności

-- jak dodajesz na polke coś, sprawdź czy nie będzie za ciężko

-- produkt może mieć food_type tylko z określonego zakresu. 