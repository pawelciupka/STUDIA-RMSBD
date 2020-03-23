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
id_produktu number := 0;
brak_produktu EXCEPTION;
begin
    select product.product_id into id_produktu 
    from product
    where product.name = nazwa_produktu;
    fetch next 1 rows only;
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
    when no_data_found then 
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
begin
    select package.package_id into id_package
    from package
    where package.name = nazwa_opakowania
    fetch next 1 rows only;

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
    when no_data_found then 
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
begin
    select package.package_id into id_package
    from package
    where package.name = nazwa_opakowania and package.package_size >= liczba_wyciaganych
    fetch next 1 rows only;

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
    when no_data_found then 
        dbms_output.put_line('nie znaleziono opakowania o nazwie/nie ma tyle w magazynie: ' || nazwa_opakowania);
end take_x_packages;

-- wyswietlenie w scipt outpu
set serveroutput on;
begin
    take_x_packages(nazwa_opakowania=>'Zgrzewka - 12 szt',liczba_wyciaganych=>4,info_w=>'pora na picie');
end;

-- agregowanie rzeczy o tej samej dacie ważności i produkcie

-- szukaj rzecz na polkach o krótszym terminie przydatności
create or replace function find_less_fresh_product
(
    product_name in product.name%type
)
return placement.info%type is
    nazwa_polki placement.info%type;
begin
  select placement.info into nazwa_polki from placement
    inner join package 
    on placement.placement_id = package.placement_id    
    inner join product
    on package.product_id = product.product_id
    where product.name = product_name
    ORDER BY package.expiration_date asc
    FETCH FIRST 1 ROWS ONLY;

exception
  when no_data_found then
    dbms_output.put_line('nie znaleziono produktu w magazynie: ' || product_name);

return nazwa_polki;
end;
/

-- wywołanie funkcji find_less_fresh_product
declare
    c placement.info%type;
    product_name product.name%type := 'Szynka drobiowa 100g';
begin 
    c := find_less_fresh_product(product_name);
    dbms_output.put_line('W magazynie: ' || product_name || ' jest na : ' || c);
end;
/

-- pobranie wagi paczki po podaniu id produktu a także wielkości tej paczki -> wykorzystane do triggera check_placement_capacity
create or replace function get_weight_of_package_with_product_id
(
    current_product_id in package.package_id%type,
    current_package_size in package.package_size%type
)
return placement.weight_limit%type is
    final_weight placement.weight_limit%type := 0;
begin
select (current_package_size*product.weight) into final_weight
      from package
      inner join product on package.product_id = product.product_id
      where product.product_id = current_product_id
      fetch next 1 rows only;

dbms_output.put_line('zwracana wartosc: '||final_weight);
return final_weight;
end;
/

declare
    package_current_weight placement.weight_limit%type;
    product_id_n product.product_id%type := 1;
begin 
    package_current_weight := get_weight_of_package_with_product_id(current_product_id=>1,current_package_size=>3
                                                                    );
end;
/

drop trigger check_placement_capacity;
-- trigger sprawdzajacy czy mozna 
create trigger check_placement_capacity
before Insert on package
REFERENCING NEW AS new OLD AS old
FOR EACH ROW
declare 
    placement_current_cargo placement.weight_limit%type;
    package_current_weight placement.weight_limit%type;
    placement_weight_limit placement.weight_limit%type;
    placement_overload EXCEPTION;
begin
-- podaj wage produktow jaka jest obecnie na polce do zmiennej
    select sum(package.package_size * product.weight) into placement_current_cargo
    from package
    inner join product
    on package.product_id = product.product_id
    where package.placement_id = :new.placement_id;
    
    select placement.weight_limit into placement_weight_limit
    from placement
    where placement.placement_id = :new.placement_id
    fetch next 1 rows only;
    
    package_current_weight := get_weight_of_package_with_product_id(current_product_id=>:new.product_id,
                                                                    current_package_size=>:new.package_size);
    if (package_current_weight + placement_current_cargo) > placement_weight_limit
        then
            raise placement_overload;
    end if;
    if (package_current_weight + placement_current_cargo) <= placement_weight_limit
        then
            dbms_output.put_line('dodano nowe opakowanie na polke: ' || :new.placement_id);
    end if;
    
    EXCEPTION
        when placement_overload then
            dbms_output.put_line('polka nie zmiesci kolejnego opakowania, #polki:' || :new.placement_id);
            rollback transaction
        when no_data_found then
            dbms_output.put_line('nie znaleziono odpowiedniech danych w bazie');
end check_placement_capacity;
/

-- dodanie 100 paka za cieżkiego na polke -- jeszcze nie usuwa za duzego rekordu
INSERT INTO
    package (name, product_id, expiration_date, placement_id, package_size)
VALUES
    (
        'Butelka 1l',
        8,
        TO_DATE('2021/01/20', 'yyyy/mm/dd'),
        8,
        100
    );


-- produkt może mieć food_type tylko z określonego zakresu. 