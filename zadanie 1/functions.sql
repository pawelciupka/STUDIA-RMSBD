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

set serveroutput on;
begin
    add_Package_Of_Product(nazwa_produktu=>'Ser gouda 1kg', nazwa_opakowania=>'trojpak plastikowy', liczba_szt=>3, data_waznosci=>'2020/04/15');
end;

-- wyciąganie rzeczy z konkretnej ilości, nie pojedynczo

-- agregowanie rzeczy o tej samej dacie ważności i produkcie

-- szukaj rzecz na polkach o krótszym terminie przydatności

-- jak dodajesz na polke coś, sprawdź czy nie będzie za ciężko

-- produkt może mieć food_type tylko z określonego zakresu. 