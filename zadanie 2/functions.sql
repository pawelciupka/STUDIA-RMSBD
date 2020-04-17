--------------------
-- sprawdzenie ilości posiadanego danego typu jedzenia w bazie
--!! wykonanie każdego z poleceń osobno działa, z jakiegoś powodu gdy uruchomi się cały skrypt to sqlserver sie gubi
CREATE
OR REPLACE FUNCTION quantityOfSelectedFoodType(food_name IN varchar) RETURN number IS food_type_count number;

BEGIN
SELECT
    SUM(package.package_size * product.weight) INTO food_type_count
FROM
    package
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.food_type = food_name;

RETURN food_type_count;

END;

/ -- wywołanie funkcji quantityOfSelectedFoodType
declare c varchar(20);

food_type product.food_type % TYPE := 'napoj';

BEGIN c := quantityOfSelectedFoodType(food_type);

dbms_output.put_line(
    'W magazynie produktow typu: ' || food_type || ' jest: ' || c || ' kilogramow'
);

END;

/ -- dodawanie do pólek rzeczy według nazy produktu, nie ID
CREATE
OR REPLACE PROCEDURE add_Package_Of_Product (
    nazwa_produktu IN product.name % TYPE,
    nazwa_opakowania IN package.name % TYPE,
    liczba_szt IN package.package_size % TYPE,
    data_waznosci IN package.expiration_date % TYPE
) IS id_produktu product.product_id % TYPE := 0;

brak_produktu EXCEPTION;

BEGIN
SELECT
    product.product_id INTO id_produktu
FROM
    product
WHERE
    product.name = nazwa_produktu FETCH next 1 ROWS ONLY;

dbms_output.put_line('znaleziono ' || id_produktu);

INSERT INTO
    package(
        name,
        product_id,
        expiration_date,
        placement_id,
        package_size
    )
VALUES
    (
        nazwa_opakowania,
        id_produktu,
        data_waznosci,
        1,
        liczba_szt
    );

dbms_output.put_line('dodano nowe opakownie do bazy');

END add_Package_Of_Product;

/ declare productName product.name % TYPE := 'Ser gouda 1kg';

opakowanie package.name % TYPE := 'trojpak plastikowy';

BEGIN add_Package_Of_Product(
    productName,
    opakowanie,
    3,
    TO_DATE('2020/03/19', 'yyyy/mm/dd')
);

END;

-- wyciąganie jednej rzeczy z konkretnego opakowania o nazwie
CREATE
OR REPLACE PROCEDURE take_one_item (
    nazwa_opakowania IN package.name % TYPE,
    info_w IN transaction.info % TYPE
) IS id_package package.package_id % TYPE := 0;

BEGIN
SELECT
    package.package_id INTO id_package
FROM
    package
WHERE
    package.name = nazwa_opakowania FETCH next 1 ROWS ONLY;

UPDATE
    package
SET
    package_size = package_size - 1
WHERE
    package.package_id = id_package;

dbms_output.put_line(
    'Wyjeto jeden produkt z opakowania: ' || nazwa_opakowania
);

INSERT INTO
    transaction(info, time_stamp, package_id)
VALUES
    (
        info_w,
        CURRENT_DATE,
        id_package
    );

exception
WHEN no_data_found THEN dbms_output.put_line(
    'nie znaleziono opakowania o nazwie: ' || nazwa_opakowania
);

END take_one_item;

/ -- wyswietlenie w scipt outpu
BEGIN take_one_item(
    nazwa_opakowania = > 'Dwupak plastikowy',
    info_w = > 'pora na kanapki'
);

END;

/ -- wyciąganie konkretnej liczby rzeczy z opakowania o nazwie i sprawdzenie ilosci
CREATE
OR REPLACE PROCEDURE take_x_packages (
    nazwa_opakowania IN package.name % TYPE,
    liczba_wyciaganych IN package.package_size % TYPE,
    info_w IN transaction.info % TYPE
) IS id_package package.package_id % TYPE := 0;

BEGIN
SELECT
    package.package_id INTO id_package
FROM
    package
WHERE
    package.name = nazwa_opakowania
    AND package.package_size >= liczba_wyciaganych FETCH next 1 ROWS ONLY;

UPDATE
    package
SET
    package_size =(package_size - liczba_wyciaganych)
WHERE
    package.package_id = id_package;

dbms_output.put_line(
    'Wyjeto ' || liczba_wyciaganych || ' opakowania: ' || nazwa_opakowania
);

INSERT INTO
    transaction(
        info,
        time_stamp,
        package_id,
        number_of_taken_items
    )
VALUES
    (
        info_w,
        CURRENT_DATE,
        id_package,
        liczba_wyciaganych
    );

exception
WHEN no_data_found THEN dbms_output.put_line(
    'nie znaleziono opakowania o nazwie/nie ma tyle w magazynie: ' || nazwa_opakowania
);

END take_x_packages;

/ -- wyswietlenie w scipt outpu
BEGIN take_x_packages(
    nazwa_opakowania = > 'Zgrzewka - 12 szt',
    liczba_wyciaganych = > 4,
    info_w = > 'pora na picie'
);

END;

-- szukaj rzecz na polkach o krótszym terminie przydatności
CREATE
OR REPLACE FUNCTION find_less_fresh_product (product_name IN product.name % TYPE) RETURN placement.info % TYPE IS nazwa_polki placement.info % TYPE;

BEGIN
SELECT
    placement.info INTO nazwa_polki
FROM
    placement
    INNER JOIN package ON placement.placement_id = package.placement_id
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.name = product_name
ORDER BY
    package.expiration_date ASC
FETCH FIRST
    1 ROWS ONLY;

dbms_output.put_line(
    'znaleziono produktu w magazynie: ' || nazwa_polki
);

RETURN nazwa_polki;

END;

/ -- wywołanie funkcji find_less_fresh_product
declare c placement.info % TYPE;

product_name product.name % TYPE := 'Szynka drobiowa 100g';

BEGIN c := find_less_fresh_product(product_name);

dbms_output.put_line(
    'W magazynie: ' || product_name || ' jest na : ' || c
);

END;

/ -- wywołanie funkcji find_less_fresh_product
declare c placement.info % TYPE;

product_name product.name % TYPE := 'Szynka drobiowa 100g';

BEGIN c := find_less_fresh_product(product_name);

dbms_output.put_line(
    'W magazynie: ' || product_name || ' jest na : ' || c
);

END;

/ -- pobranie wagi paczki po podaniu id produktu a także wielkości tej paczki -> wykorzystane do triggera check_placement_capacity
CREATE
OR REPLACE FUNCTION get_weight_of_package_with_product_id (
    current_product_id IN package.package_id % TYPE,
    current_package_size IN package.package_size % TYPE
) RETURN placement.weight_limit % TYPE IS final_weight placement.weight_limit % TYPE := 0;

BEGIN
SELECT
    (current_package_size * product.weight) INTO final_weight
FROM
    package
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.product_id = current_product_id FETCH next 1 ROWS ONLY;

dbms_output.put_line('zwracana wartosc: ' || final_weight);

RETURN final_weight;

END;

/ declare package_current_weight placement.weight_limit % TYPE;

product_id_n product.product_id % TYPE := 1;

BEGIN package_current_weight := get_weight_of_package_with_product_id(
    current_product_id = > 1,
    current_package_size = > 3
);

END;

/ DROP trigger check_placement_capacity;

-- trigger sprawdzajacy czy mozna 
CREATE trigger check_placement_capacity before
INSERT
    ON package REFERENCING NEW AS new OLD AS old FOR EACH ROW declare placement_current_cargo placement.weight_limit % TYPE;

package_current_weight placement.weight_limit % TYPE;

placement_weight_limit placement.weight_limit % TYPE;

placement_overload EXCEPTION;

BEGIN -- podaj wage produktow jaka jest obecnie na polce do zmiennej
SELECT
    sum(package.package_size * product.weight) INTO placement_current_cargo
FROM
    package
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    package.placement_id = :new.placement_id;

SELECT
    placement.weight_limit INTO placement_weight_limit
FROM
    placement
WHERE
    placement.placement_id = :new.placement_id FETCH next 1 ROWS ONLY;

package_current_weight := get_weight_of_package_with_product_id(
    current_product_id = > :new.product_id,
    current_package_size = > :new.package_size
);

IF (package_current_weight + placement_current_cargo) > placement_weight_limit THEN raise placement_overload;

END IF;

IF (package_current_weight + placement_current_cargo) <= placement_weight_limit THEN dbms_output.put_line(
    'dodano nowe opakowanie na polke: ' || :new.placement_id
);

END IF;

EXCEPTION
WHEN placement_overload THEN dbms_output.put_line(
    'polka nie zmiesci kolejnego opakowania, #polki:' || :new.placement_id
);

WHEN no_data_found THEN dbms_output.put_line('nie znaleziono odpowiedniech danych w bazie');

END check_placement_capacity;

/ -- dodanie 100 paka za cieżkiego na polke -- jeszcze nie usuwa za duzego rekordu
INSERT INTO
    package (
        name,
        product_id,
        expiration_date,
        placement_id,
        package_size
    )
VALUES
    (
        'Butelka 1l',
        8,
        TO_DATE('2021/01/20', 'yyyy/mm/dd'),
        8,
        100
    );

-- produkt może mieć food_type tylko z określonego zakresu.