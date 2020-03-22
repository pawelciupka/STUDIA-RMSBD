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