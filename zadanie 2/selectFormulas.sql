-- wyswietlanie wspolnej wagi dla wszystkich produktow danego typu w bazie
SELECT
    package.name,
    package.package_size,
    product.name,
    product.weight,
    product.producent,
    product.food_type,
    package.package_size * product.weight AS laczna_waga
FROM
    package
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.food_type = 'napoj';

SELECT
    SUM(package.package_size * product.weight) AS laczna_waga
FROM
    package
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.food_type = 'napoj';

-- wybierz po nazwie nazwe polki z produktem o nizszej dacie przydatnosci
SELECT
    placement.info
FROM
    placement
    INNER JOIN package ON placement.placement_id = package.placement_id
    INNER JOIN product ON package.product_id = product.product_id
WHERE
    product.name = 'Szynka drobiowa 100g'
ORDER BY
    package.expiration_date ASC
FETCH FIRST
    1 ROWS ONLY