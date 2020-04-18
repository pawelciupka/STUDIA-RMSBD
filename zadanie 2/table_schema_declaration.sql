-- Paweł Ciupka 234048
-- Maciej Majchrowski 234088
--
--
--------------------
DROP TABLE transaction;

DROP SEQUENCE transaction_seq;

DROP TABLE package;

DROP SEQUENCE package_seq;

DROP TABLE product_photo;

DROP SEQUENCE product_photo_seq;

DROP TABLE product;

DROP SEQUENCE product_seq;

DROP TABLE placement;

DROP SEQUENCE placement_seq;

DROP TABLE place;

DROP SEQUENCE place_seq;

DROP trigger check_placement_capacity;

--------------------
ALTER SESSION
SET
  nls_date_format = 'dd/MON/yyyy';

--------------------
-- PLACE TABLE
CREATE TABLE place (
  place_id number NOT NULL,
  info varchar2(50) NOT NULL,
  street varchar2(50) NOT NULL,
  city varchar2(20) NOT NULL,
  postal_code varchar2(6) NOT NULL
);

ALTER TABLE
  place
ADD
  CONSTRAINT place_pk PRIMARY KEY (place_id);

CREATE SEQUENCE place_seq START WITH 1;

CREATE TRIGGER place_trigger BEFORE
INSERT
  ON place FOR EACH ROW BEGIN
SELECT
  place_seq.NEXTVAL INTO :new.place_id
FROM
  dual;

END;
/ 

--------------------
-- PLACEMENT TABLE
CREATE TABLE placement (
  placement_id number NOT NULL,
  info varchar2(50) NOT NULL,
  weight_limit number NOT NULL,
  place_id number NOT NULL
);

ALTER TABLE
  placement
ADD
  CONSTRAINT placement_pk PRIMARY KEY (placement_id);

ALTER TABLE
  placement
ADD
  CONSTRAINT fk_place FOREIGN KEY (place_id) REFERENCES place(place_id);

CREATE SEQUENCE placement_seq START WITH 1;

CREATE TRIGGER placement_trigger BEFORE
INSERT
  ON placement FOR EACH ROW BEGIN
SELECT
  placement_seq.NEXTVAL INTO :new.placement_id
FROM
  dual;

END;
/ 

--------------------
-- PRODUCT PHOTO
CREATE TABLE product_photo (
  product_photo_id NUMBER NOT NULL,
  filename VARCHAR2(50) NOT NULL,
  description VARCHAR2(100) NOT NULL,
  img ORDimage,
  modyf_img ORDImage
);

ALTER TABLE
  product_photo
ADD
  CONSTRAINT product_photo_pk PRIMARY KEY (product_photo_id);

CREATE SEQUENCE product_photo_seq START WITH 1;

CREATE TRIGGER product_photo_trigger BEFORE
INSERT
  ON product_photo FOR EACH ROW BEGIN
SELECT
  product_photo_seq.NEXTVAL INTO :new.product_photo_id
FROM
  dual;

END;
/

--------------------
-- PRODUCT TABLE
CREATE TABLE product (
  product_id number NOT NULL,
  name varchar2(50) NOT NULL,
  producent varchar2(50) NOT NULL,
  weight number NOT NULL,
  food_type varchar(20) NOT NULL,
  product_photo_id number 
);

ALTER TABLE
  product
ADD
  CONSTRAINT check_food_type_name CHECK (
    food_type IN (
      'przyprawa',
      'bialko',
      'tluszcz',
      'warzywa',
      'weglowodany',
      'nabial',
      'napoj'
    )
  );

ALTER TABLE
  product
ADD
  CONSTRAINT check_food_weight CHECK (weight > 0);

ALTER TABLE
  product
ADD
  CONSTRAINT product_pk PRIMARY KEY (product_id);

ALTER TABLE
  product
ADD
  CONSTRAINT fk_product_photo FOREIGN KEY (product_photo_id) REFERENCES product_photo(product_photo_id);

CREATE SEQUENCE product_seq START WITH 1;

CREATE TRIGGER product_trigger BEFORE
INSERT
  ON product FOR EACH ROW BEGIN
SELECT
  product_seq.NEXTVAL INTO :new.product_id
FROM
  dual;

END;
/ 

--------------------
-- PACKAGE TABLE
CREATE TABLE package (
  package_id number NOT NULL,
  name varchar2(50) NOT NULL,
  product_id number NOT NULL,
  expiration_date date NOT NULL,
  placement_id number NOT NULL,
  package_size number DEFAULT 1 NOT NULL
);

ALTER TABLE
  package
ADD
  CONSTRAINT package_pk PRIMARY KEY (package_id);

ALTER TABLE
  package
ADD
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product(product_id);

ALTER TABLE
  package
ADD
  CONSTRAINT fk_placement FOREIGN KEY (placement_id) REFERENCES placement(placement_id);

CREATE SEQUENCE package_seq START WITH 1;

CREATE TRIGGER package_trigger BEFORE
INSERT
  ON package FOR EACH ROW BEGIN
SELECT
  package_seq.NEXTVAL INTO :new.package_id
FROM
  dual;

END;
/ 

-------------------
-- TRANSACTION TABLE
CREATE TABLE transaction (
  transaction_id number NOT NULL,
  info varchar2(50) NOT NULL,
  time_stamp timestamp NOT NULL,
  package_id number NOT NULL,
  number_of_taken_items number DEFAULT 1 NOT NULL
);

ALTER TABLE
  transaction
ADD
  CONSTRAINT transaction_pk PRIMARY KEY (transaction_id);

ALTER TABLE
  transaction
ADD
  CONSTRAINT fk_package FOREIGN KEY (package_id) REFERENCES package(package_id);

CREATE SEQUENCE transaction_seq START WITH 1;

CREATE TRIGGER transaction_trigger BEFORE
INSERT
  ON transaction FOR EACH ROW BEGIN
SELECT
  transaction_seq.NEXTVAL INTO :new.transaction_id
FROM
  dual;

END;
/