-- jak dodajesz na polke coś, sprawdź czy nie będzie za ciężko
CREATE
OR REPLACE trigger check_placement_capacity before
INSERT
    ON product