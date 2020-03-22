-- wyswietlanie wspolnej wagi dla wszystkich produktow danego typu w bazie
select package.name, package.package_size, 
        product.name, product.weight, 
        product.producent, 
        product.food_type, 
        package.package_size * product.weight as laczna_waga from package
INNER JOIN  product
    ON package.product_id = product.product_id
WHERE product.food_type = 'napoj';

select SUM(package.package_size * product.weight) as laczna_waga from package
INNER JOIN  product
    ON package.product_id = product.product_id
WHERE product.food_type = 'napoj';

-- wybierz po nazwie nazwe polki z produktem o nizszej dacie przydatnosci
select placement.info from placement
inner join package 
on placement.placement_id = package.placement_id    
inner join product
on package.product_id = product.product_id
where product.name = 'Szynka drobiowa 100g'
ORDER BY package.expiration_date asc
FETCH FIRST 1 ROWS ONLY