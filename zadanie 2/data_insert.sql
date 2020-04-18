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
-- INSERT DATA TO PRODUCT PHOTO TABLE
BEGIN
add_photo('szynkaD100g.jpg', 'Szynka drobiowa');
END;
/
BEGIN
add_photo('konserwowa.jpg', 'Szynka konserwowa');
END;
/
BEGIN
add_photo('filetKurczak500g.jpg', 'Filet z piersi kurczaka');
END;
/
BEGIN
add_photo('gouda1kg.jpg', 'Ser gouda');
END;
/
BEGIN
add_photo('serWedzony.jpg', 'Ser wedzony');
END;
/
BEGIN
add_photo('pepsi2l.jpg', 'Pepsi');
END;
/
BEGIN
add_photo('cola1l.jpg', 'Coca-Cola');
END;
/
BEGIN
add_photo('fanta05l.jpg', 'Fanta');
END;
/


--------------------
-- INSERT DATA TO PRODUCT TABLE
INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    (
        'Szynka drobiowa 100g',
        'Sokolow',
        0.1,
        'bialko',
        1
    );

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    (
        'Szynka konserwowa 200g',
        'Krakus',
        0.2,
        'bialko',
        2
    );

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    (
        'Filet z piersi kurczaka 500g',
        'Biedronka',
        0.5,
        'bialko',
        3
    );

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    ('Ser gouda 1kg', 'Mlekovita', 1, 'nabial', 4);

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    (
        'Ser wedzony w plastrach 200g',
        'Mlekovita',
        0.2,
        'nabial',
        5
    );

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    (
        'Ser Gouda w plastrach 150g',
        'Mlekpol',
        0.15,
        'nabial',
        4
    );

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    ('Pepsi 2l', 'PepsiCola', 2, 'napoj', 6);

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    ('Coca Cola 1l', 'ColaCompany', 1, 'napoj', 7);

INSERT INTO
    product (name, producent, weight, food_type, product_photo_id)
VALUES
    ('Fanta 500ml', 'ColaCompany', 0.5, 'napoj', 8);

--------------------
-- INSERT DATA TO PACKAGE TABLE
INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Paczka plastikowa',
        1,
        TO_DATE('2020/04/23', 'yyyy/mm/dd'),
        1
    );

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
        'Dwupak plastikowy',
        2,
        TO_DATE('2020/04/29', 'yyyy/mm/dd'),
        1,
        2
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Paczka plastikowa',
        3,
        TO_DATE('2020/04/27', 'yyyy/mm/dd'),
        1
    );

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
        'Opakowanie - 2 szt',
        4,
        TO_DATE('2020/05/25', 'yyyy/mm/dd'),
        2,
        2
    );

INSERT INTO
    package (name, product_id, expiration_date, placement_id)
VALUES
    (
        'Paczka plastikowa',
        1,
        TO_DATE('2020/05/23', 'yyyy/mm/dd'),
        4
    );

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
        'Dwupak plastikowy',
        6,
        TO_DATE('2020/05/29', 'yyyy/mm/dd'),
        6,
        2
    );

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
        'Zgrzewka - 6 szt',
        7,
        TO_DATE('2021/08/21', 'yyyy/mm/dd'),
        8,
        6
    );

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
        'Dwupak butelek',
        8,
        TO_DATE('2021/01/20', 'yyyy/mm/dd'),
        8,
        2
    );

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
        'Zgrzewka - 12 szt',
        9,
        TO_DATE('2022/01/02', 'yyyy/mm/dd'),
        10,
        12
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