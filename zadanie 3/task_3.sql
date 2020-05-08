CREATE DIRECTORY XML_DIR AS '/home/oracle/Desktop/xml_dir';
COMMIT;
GRANT READ ON DIRECTORY XML_DIR TO PUBLIC;
GRANT read, write ON DIRECTORY XML_DIR TO hr;
COMMIT;

-- Table schema declaration
DROP TABLE product_xml;
CREATE TABLE product_xml
(
  product_id number primary key,
  name XMLTYPE,
  producent XMLTYPE,
  weight XMLTYPE,
  food_type XMLTYPE
);

DROP SEQUENCE product_xml_seq;
CREATE SEQUENCE product_xml_seq 
minvalue 1
maxvalue 9999
start WITH 1
increment BY 1;

INSERT INTO product_xml
    (product_id, name, producent, weight, food_type)
  VALUES
    (product_xml_seq.nextval, '<name>product_name</name>', '<producent>product_producent</producent>', '<weight>product_weight</weight>', '<food_type>product_food_type</food_type>');
  COMMIT;



-- Insert data from XML file
CREATE OR REPLACE PROCEDURE import_products (flname IN varchar2) IS
  xmlfile xmltype;
  product_id number;
  product_name xmltype;
  product_producent xmltype;
  product_weight xmltype;
  product_food_type xmltype;
BEGIN
  xmlfile := xmltype(bfilename('XML_DIR',flname),nls_charset_id('AL32UTF8'));

  product_name := xmlfile.extract('/product/name');
  product_producent := xmlfile.extract('/product/producent');
  product_weight := xmlfile.extract('/product/weight');
  product_food_type := xmlfile.extract('/product/food_type');

  INSERT INTO product_xml
    (product_id, name, producent, weight, food_type)
  VALUES
    (product_xml_seq.nextval, product_name, product_producent, product_weight, product_food_type);
  COMMIT;
END;
/

BEGIN 
  import_products('products.xml');
END;



-- Export table to XML file
create or replace procedure table_to_xml_file(table_name in varchar2) as
  ctx dbms_xmlgen.ctxhandle;
  clb clob;
  file utl_file.file_type;
  buffer varchar2(32767);
  position pls_integer := 1;
  chars pls_integer := 32767;
begin
  --ctx := dbms_xmlgen.newcontext('select * from "' || table_name|| '"');
  ctx := dbms_xmlgen.newcontext('select * from product');
  dbms_xmlgen.setrowsettag(ctx, 'RECORDS');
  dbms_xmlgen.setrowtag(ctx, 'RECORD');

  select xmlserialize(document
        xmlelement("XML",
          xmlelement(evalname(table_name),
            dbms_xmlgen.getxmltype(ctx)))
      indent size = 2)
  into clb
  from dual;

  dbms_xmlgen.closecontext(ctx);

  file := utl_file.fopen('XML_DIR', table_name|| '.xml', 'w', 32767);
  while position < dbms_lob.getlength(clb) loop
    dbms_lob.read(clb, chars, position, buffer);
    utl_file.put(file, buffer);
    utl_file.fflush(file);
    position := position + chars;
  end loop;
  utl_file.fclose(file);
end table_to_xml_file;
/

exec table_to_xml_file('product');



-- Get number of rows
SET serveroutput ON;
DECLARE
  query varchar2(255):='select product_id, name, producent, weight, food_type from product';
  fn DBMS_XMLGEN.ctxHandle; 
  row_amount number;
  xmlclob clob;
BEGIN
  fn := dbms_xmlgen.newcontext(query); -- Return identifiet of new context based on query
  dbms_lob.createtemporary(xmlclob, false);
  dbms_xmlgen.getXML(ctx => fn, tmpclob => xmlclob); -- Return data in XML based on created context
  row_amount := dbms_xmlgen.getNumRowsProcessed(ctx => fn);
  dbms_xmlgen.closeContext(ctx => fn); -- Close created context
  dbms_output.put_line('Number of rows: ' || row_amount);
  dbms_lob.freetemporary(xmlclob);
END;
/



-- Table schema declaration
DROP TABLE place_xml;
CREATE TABLE place_xml (
  place_id number primary key,
  details XMLTYPE
);

INSERT INTO place_xml
VALUES(1, XMLType(
'<place>
	<info>Zamieszkiwane przez rodzinę Nowakow</info>
	<street>Mickiewicza 69</street>
	<city>Lodz</city>
	<postal_code>93-583</postal_code>
</place>')
);
INSERT INTO place_xml
VALUES(2, XMLType(
'<place>
	<info>Zamieszkiwane przez rodzinę Piotrkowskich</info>
	<street>Warszawska 2</street>
	<city>Kalisz</city>
	<postal_code>62-800</postal_code>
</place>')
);
INSERT INTO place_xml
VALUES(3, XMLType(
'<place>
	<info>Zamieszkiwane przez rodzinę Kowalskich</info>
	<street>Aleja Politechniki 9</street>
	<city>Lodz</city>
	<postal_code>93-590</postal_code>
</place>')
);



-- Read one row from table place_xml
CREATE OR replace PROCEDURE get_one_row (selected_id IN number, path IN varchar2) IS
str_xml XMLType;
BEGIN
  SELECT p.details
  INTO str_xml
  FROM place_xml p
  WHERE p.place_id = selected_id;
  DBMS_OUTPUT.put_line
  (str_xml.extract
  ('/place/ ' || path).getStringVal
  ());
END;

BEGIN
get_one_row(1, 'info');
END;



-- Read node from table place_xml
CREATE OR replace PROCEDURE get_node(selected_id IN number) IS
str_xml XMLType;
BEGIN
  SELECT p.details
  INTO str_xml
  FROM place_xml p
  WHERE p.place_id = selected_id;
  DBMS_OUTPUT.put_line
  (str_xml.extract
  ('/place').getStringVal
  ());
END;

BEGIN
get_node(2);
END;
