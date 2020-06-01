
-- -----------------------------------------------------------------------
-- Table schema declaration
DROP TABLE place_details;
CREATE TABLE place_details
(
  place_id NUMBER PRIMARY KEY,
  info VARCHAR2(50) NOT NULL,
  street VARCHAR2(50) NOT NULL,
  city VARCHAR2(20) NOT NULL,
  postal_code VARCHAR2(6) NOT NULL,
  localization "SDO_GEOMETRY"
);

INSERT INTO USER_SDO_GEOM_METADATA
VALUES
  (
    'place_details',
    'localization',
    MDSYS.SDO_DIM_ARRAY(
      MDSYS.SDO_DIM_ELEMENT('X', 0, 50, 1),
      MDSYS.SDO_DIM_ELEMENT('Y', 0, 50, 1) ),
    8307
);

DROP INDEX place_details_index;
CREATE INDEX place_details_index ON place_details (localization) INDEXTYPE IS MDSYS.SPATIAL_INDEX;

DROP SEQUENCE place_details_seq;
CREATE SEQUENCE place_details_seq start WITH 1 increment BY 1;


-- -----------------------------------------------------------------------
-- Insert data into table
INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        'Zamieszkiwane przez rodzinę Kowalskich',
        'Aleja Politechniki 9',
        'Lodz',
        '93-590',
        MDSYS.SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(10, 10, NULL), NULL, NULL)
    );

INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        'Zamieszkiwane przez rodzinę Nowakow',
        'Mickiewicza 69',
        'Lodz',
        '93-583',
        MDSYS.SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(20, 20, NULL), NULL, NULL)
    );

INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        'Zamieszkiwane przez rodzinę Piotrkowskich',
        'Warszawska 2',
        'Kalisz',
        '62-800',
        MDSYS.SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(30, 30, NULL), NULL, NULL)
    );

INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        'Zamieszkiwane przez rodzinę Markowskich',
        'Krakowska 122',
        'Warszawa',
        '80-102',
        MDSYS.SDO_GEOMETRY(2001, 8307, SDO_POINT_TYPE(5, 50, NULL), NULL, NULL)
    );


SELECT * FROM place_details;


-- -----------------------------------------------------------------------
-- Display place details
CREATE OR REPLACE PROCEDURE display_place_details (id IN NUMBER) 
IS
place place_details%ROWTYPE;
BEGIN
  select * into place from place_details where place_id = id;
  DBMS_OUTPUT.PUT_LINE('Place identifier: ' || place.place_id);
  DBMS_OUTPUT.PUT_LINE('Information: ' || place.info);
  DBMS_OUTPUT.PUT_LINE('Street: ' || place.street);
  DBMS_OUTPUT.PUT_LINE('City: ' || place.city);
  DBMS_OUTPUT.PUT_LINE('Postal code: ' || place.postal_code);
  DBMS_OUTPUT.PUT_LINE('Localization point: ' || place.localization.Get_WKT());
end;

set serveroutput on;
begin
  display_place_details(2);
end;


-- -----------------------------------------------------------------------
-- Display all place details
CREATE OR REPLACE PROCEDURE display_all_place_details
IS
place place_details%ROWTYPE;
CURSOR cur IS SELECT * FROM place_details;
BEGIN
  FOR place IN cur
  LOOP
    DBMS_OUTPUT.PUT_LINE('Place identifier: ' || place.place_id);
    DBMS_OUTPUT.PUT_LINE('Information: ' || place.info);
    DBMS_OUTPUT.PUT_LINE('Street: ' || place.street);
    DBMS_OUTPUT.PUT_LINE('City: ' || place.city);
    DBMS_OUTPUT.PUT_LINE('Postal code: ' || place.postal_code);
    DBMS_OUTPUT.PUT_LINE('Localization point: ' || place.localization.Get_WKT());
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
  END LOOP;
end;

set serveroutput on;
begin
  display_all_place_details();
end;


-- -----------------------------------------------------------------------
-- Insert new place_detail (localization = point)
CREATE OR REPLACE PROCEDURE add_place_detail_point
  (info IN VARCHAR, 
  street IN VARCHAR, 
  city IN VARCHAR, 
  postal_code IN VARCHAR, 
  coordinates IN SDO_POINT_TYPE) 
IS
BEGIN
  INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        info,
        street,
        city,
        postal_code,
        SDO_GEOMETRY(2001, 8307, coordinates, null, null)
    );
END;

set serveroutput on;
begin
  add_place_detail_point('Willa pana Jaroslawa', 'Krakowskie Przedmiescie 48/50', 'Warszawa', '00-071', SDO_POINT_TYPE(13.37, 21.37, NULL) );
end;


-- -----------------------------------------------------------------------
-- Insert new place_detail (localization = line)
CREATE OR REPLACE PROCEDURE add_place_detail_line
  (info IN VARCHAR, 
  street IN VARCHAR, 
  city IN VARCHAR, 
  postal_code IN VARCHAR, 
  coordinates IN SYS.ODCINUMBERLIST) 
IS
  line_coordinates MDSYS.sdo_ordinate_array;
BEGIN
  SELECT CAST (coordinates AS  MDSYS.sdo_ordinate_array) INTO line_coordinates FROM dual;
  INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        info,
        street,
        city,
        postal_code,
        SDO_GEOMETRY(2002, 8307, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1, 2, 1), line_coordinates)
    );
END;

set serveroutput on;
begin
  add_place_detail_line('Droga z Baszty Dorotki do Ratusza', 'plac Jana Pawla II', 'Kalisz', '62-800', SYS.ODCINUMBERLIST(10, 0, 30, 0));
end;


-- -----------------------------------------------------------------------
-- Insert new place_detail (localization = polygon)
CREATE OR REPLACE PROCEDURE add_place_detail_polygon
  (info IN VARCHAR, 
  street IN VARCHAR, 
  city IN VARCHAR, 
  postal_code IN VARCHAR, 
  coordinates IN SYS.ODCINUMBERLIST) 
IS
  polygon_coordinates MDSYS.sdo_ordinate_array;
BEGIN
  SELECT CAST (coordinates AS  MDSYS.sdo_ordinate_array) INTO polygon_coordinates FROM dual;
  INSERT INTO
    place_details (place_id, info, street, city, postal_code, localization)
VALUES
    (
        place_details_seq.nextval,
        info,
        street,
        city,
        postal_code,
        SDO_GEOMETRY(2003, 8307, NULL, MDSYS.SDO_ELEM_INFO_ARRAY(1, 1003, 1), polygon_coordinates)
    );
END;

set serveroutput on;
begin
  add_place_detail_polygon('Obszar ratusza', 'Glowny Rynek 20', 'Kalisz', '62-800', SYS.ODCINUMBERLIST(10, 10, 20, 10, 20, 20, 10,20));
end;
