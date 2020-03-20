-- Paweł Ciupka 234048
-- Maciej Majchrowski 234
--
--
--------------------
-- INSERT DATA TO PLACE TABLE
INSERT INTO
    place (info, street, city, postal_code)
VALUES
    (
        'Zamieszkiwane przez rodzinę Kowalskich',
        'Aleja Politechniki 9',
        'Lodz',
        '93-590'
    );

INSERT INTO
    place (info, street, city, postal_code)
VALUES
    (
        'Zamieszkiwane przez rodzinę Nowakow',
        'Mickiewicza 69',
        'Lodz',
        '93-583'
    );

INSERT INTO
    place (info, street, city, postal_code)
VALUES
    (
        'Zamieszkiwane przez rodzinę Piotrkowskich',
        'Warszawska 2',
        'Kalisz',
        '62-800'
    );

INSERT INTO
    place (info, street, city, postal_code)
VALUES
    (
        'Zamieszkiwane przez rodzinę Markowskich',
        'Krakowska 122',
        'Warszawa',
        '80-102'
    );

--------------------
-- INSERT DATA TO PLACEMENT TABLE
INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 1', 10, 1);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 2', 8, 1);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 3', 15, 1);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 1', 20, 2);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 2', 18, 2);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 1', 12, 3);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 2', 20, 3);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 1', 30, 4);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 2', 20, 4);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 3', 10, 4);

INSERT INTO
    placement (info, weight_limit, place_id)
VALUES
    ('Polka numer 4', 5, 4);

--------------------
-- INSERT DATA TO FOOD_TYPE TABLE
INSERT INTO
    food_type (name)
VALUES
    ('Mieso');

INSERT INTO
    food_type (name)
VALUES
    ('Nabial');

INSERT INTO
    food_type (name)
VALUES
    ('Napoj');

--------------------
-- INSERT DATA TO PRODUCT TABLE
INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Szynka drobiowa', 'Tarczynskie', 4, 1);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Szynka konserwowa', 'Sokolow', 3, 1);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Piers z kurczaka', 'Biedronka', 9, 1);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Ser Gouda', 'Biedronka', 2, 2);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Ser wedzony', 'Lidl', 3, 2);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Ser Gouda', 'Biedronka', 2, 2);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Ser w plastrach', 'Lindor', 7, 2);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Pepsi', 'ColaCompany', 10, 3);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Coca Cola', 'ColaCompany', 15, 3);

INSERT INTO
    product (name, producent, weight, food_type_id)
VALUES
    ('Fanta', 'ColaCompany', 5, 3);

--------------------
-- INSERT DATA TO PACKAGE TABLE
INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Torba - 10 szt',
        1,
        TO_DATE('2020/04/23', 'yyyy/mm/dd'),
        1
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        '2 szt',
        2,
        TO_DATE('2020/04/29', 'yyyy/mm/dd'),
        1
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        '4 szt',
        3,
        TO_DATE('2020/04/27', 'yyyy/mm/dd'),
        1
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Opakowanie - 2 szt',
        4,
        TO_DATE('2020/05/25', 'yyyy/mm/dd'),
        2
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Paczka - 3 szt',
        5,
        TO_DATE('2020/05/23', 'yyyy/mm/dd'),
        4
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        '1 szt',
        6,
        TO_DATE('2020/05/29', 'yyyy/mm/dd'),
        6
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Zgrzewka - 6 szt',
        7,
        TO_DATE('2021/08/21', 'yyyy/mm/dd'),
        8
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Dwupak - 2 szt',
        8,
        TO_DATE('2021/01/20', 'yyyy/mm/dd'),
        8
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        '1 szt',
        9,
        TO_DATE('2022/01/02', 'yyyy/mm/dd'),
        10
    );

--------------------
-- INSERT DATA TO TRANSACTION TABLE
INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 1',
        TO_DATE('2020/03/11', 'yyyy/mm/dd'),
        1
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 2',
        TO_DATE('2020/03/12', 'yyyy/mm/dd'),
        2
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 3',
        TO_DATE('2020/03/13', 'yyyy/mm/dd'),
        3
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 4',
        TO_DATE('2020/03/14', 'yyyy/mm/dd'),
        4
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 5',
        TO_DATE('2020/03/15', 'yyyy/mm/dd'),
        5
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 6',
        TO_DATE('2020/03/16', 'yyyy/mm/dd'),
        6
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 7',
        TO_DATE('2020/03/17', 'yyyy/mm/dd'),
        7
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 8',
        TO_DATE('2020/03/18', 'yyyy/mm/dd'),
        8
    );

INSERT INTO
    transaction (info, time_stamp, package_id)
VALUES
    (
        'Info 9',
        TO_DATE('2020/03/19', 'yyyy/mm/dd'),
        9
    );