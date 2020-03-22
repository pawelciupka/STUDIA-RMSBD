-- Paweł Ciupka 234048
-- Maciej Majchrowski 234
--
--
--------------------

create or replace function quantityOfSelectedFoodType(food_name IN varchar2(50))
RETURN number
IS
    food_type_count number;
begin
  select count(*) from food_type into 
end;

-- dodawanie do pólek rzeczy według nazy produktu, nie ID

-- wyciąganie rzeczy z konkretnej ilości, nie pojedynczo

-- agregowanie rzeczy o tej samej dacie ważności i produkcie

-- szukaj rzecz na polkach o krótszym terminie przydatności

-- jak dodajesz na polke coś, sprawdź czy nie będzie za ciężko

-- produkt może mieć food_type tylko z określonego zakresu. 