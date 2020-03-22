-- dodanie okreslonej liczby opakowan
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
