select package.name, package.expiration_date, product.name, product.producent, product.name from package
INNER JOIN  product
    ON package.product_id = product.product_id