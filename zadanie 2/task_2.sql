-- TO DO:
-- ADD PRODUCT_PHOTO TO PRODUCT TABLE
-- ADD DATA INSERT FOR PRODUCT PHOTO
-- PROCEDURE: LOAD ALL PHOTO FROM CATALOG 


CREATE DIRECTORY MEDIA_FILES AS '/home/oracle/Desktop/Obrazy';
commit;


-- add photo to product_photo and description table
set serveroutput on
CREATE OR REPLACE PROCEDURE add_photo ( file_name IN varchar, description IN varchar ) IS
BEGIN
    DECLARE
        obrazek ORDImage;
        ctx RAW(64) := NULL;
        row_id urowid;
    BEGIN
        INSERT INTO product_photo (filename, description, img)
                VALUES (file_name, description, ORDImage.init('FILE', 'MEDIA_FILES', file_name))
                                    RETURNING img, rowid INTO obrazek, row_id;
        obrazek.import(ctx); 
        UPDATE product_photo SET img = obrazek WHERE rowid = row_id; 
        COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.put_line('File not found or someting went wrong');
      ROLLBACK;
    END;
END;
/

BEGIN
add_photo('product.png', 'Default icon representing product.');
END;


-- get photo format, width and height
set serveroutput on;
CREATE OR REPLACE PROCEDURE show_photo_details ( id IN NUMBER ) IS
BEGIN
    DECLARE
        obrazek ORDSYS.ORDImage;
        wysokosc INTEGER;
    BEGIN
        SELECT img INTO obrazek FROM product_photo WHERE product_photo_id = id;
        obrazek.setProperties;
        DBMS_OUTPUT.PUT_LINE('Photo format: ' || obrazek.getFileFormat() || ', Photo width: ' || obrazek.getWidth() || ', Photo height: ' || obrazek.getHeight() );
        COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.put_line('Wrong ID');
      ROLLBACK;
    END;
END;
/

BEGIN
show_photo_details(1);
END;


-- change photo contrast 
ALTER TABLE product_photo ADD modyf_img ORDImage;
commit;

set serveroutput on
CREATE OR REPLACE PROCEDURE change_photo_contrast ( id IN NUMBER, value IN NUMBER ) IS
BEGIN
    DECLARE
        img0 ORDimage;
        img1 ORDimage;
        img2 ORDImage;
    BEGIN
        SELECT modyf_img INTO img0 FROM product_photo WHERE product_photo_id=id FOR UPDATE of modyf_img;
        UPDATE product_photo set modyf_img=ORDImage.init();
        COMMIT;

        SELECT img, modyf_img INTO img1,img2 FROM product_photo
        WHERE product_photo_id=id FOR UPDATE of img, modyf_img;
        img1.processCopy('maxScale 500 500', img2);
        img2.process('contrast = ' || value);
        UPDATE product_photo set modyf_img = img2 WHERE product_photo_id=1;
        COMMIT;
    EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.put_line('Something went wrong');
      ROLLBACK;
    END;
END;
/

BEGIN
change_photo_contrast(1, 100);
END;


-- export photo
set serveroutput on
CREATE OR REPLACE PROCEDURE export_modified_photo ( id IN NUMBER, output_filename in VARCHAR ) IS
BEGIN
    DECLARE
        img1 ORDSYS.ORDIMAGE;
        ctx raw(64) :=null;
    BEGIN
        SELECT modyf_img INTO img1 FROM product_photo WHERE product_photo_id = id;
        img1.export(ctx, 'FILE', 'MEDIA_FILES', output_filename);        
    EXCEPTION 
    WHEN OTHERS THEN 
      DBMS_OUTPUT.put_line('Something went wrong');
      ROLLBACK;
    END;
END;
/

BEGIN
export_modified_photo(1, 'output.png');
END;