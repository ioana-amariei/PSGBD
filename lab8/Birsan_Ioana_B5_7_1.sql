--Creati doua tabele la alegere care sa fie legate printr-o cheie primara/straina 
--si un view care sa fie peste joinul dintre cele doua tabele. 
--Construiti triggere care sa permita realizarea de operatii de tipul INSERT, UPDATE, DELETE pe view. 

ALTER TABLE PRODUCTS
DROP CONSTRAINT shop_fk;
/
ALTER TABLE ONLINE_SHOP
DROP CONSTRAINT shop_pk;
/
DROP TABLE ONLINE_SHOP;
/
DROP TABLE PRODUCTS;
/
CREATE TABLE ONLINE_SHOP
( s_id numeric(6) not null,
  name varchar2(20) not null,
  web_address varchar2(50) not null,
  CONSTRAINT shop_pk PRIMARY KEY (s_id, name)
);
/
CREATE TABLE PRODUCTS
( p_id numeric(10) not null,
  shop_id numeric(6) not null,
  shop_name varchar2(20) not null,
  product_type varchar2(20),
  min_price numeric(5),
  max_price numeric(5),
  CONSTRAINT shop_fk FOREIGN KEY (shop_id, shop_name) REFERENCES ONLINE_SHOP(s_id, name) ON DELETE CASCADE
);
/
DROP VIEW shop_orders_view;
/
CREATE VIEW shop_orders_view AS
  SELECT ONLINE_SHOP.name, ONLINE_SHOP.web_address, PRODUCTS.p_id, PRODUCTS.product_type, PRODUCTS.min_price, PRODUCTS.max_price
  FROM ONLINE_SHOP, PRODUCTS
  WHERE ONLINE_SHOP.s_id = PRODUCTS.shop_id
  AND 
  ONLINE_SHOP.name = PRODUCTS.shop_name;
/
  
INSERT INTO ONLINE_SHOP (s_id, name, web_address) VALUES (1, 'emag', 'https://www.emag.ro/');
INSERT INTO ONLINE_SHOP (s_id, name, web_address) VALUES (2, 'sephora', 'https://www.sephora.ro/');
INSERT INTO ONLINE_SHOP (s_id, name, web_address) VALUES (3, 'tekadvice', 'https://tekadvice.ro/');
INSERT INTO ONLINE_SHOP (s_id, name, web_address) VALUES (4, 'mobexpert', 'https://www.mobexpert.ro/');
  
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'laptop', 250, 45000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'telefoane', 80, 12000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'periferice', 1, 5000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'electrocasnice', 10, 20000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'fashion', 25, 2500);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 1, 'emag', 'ingrijire personala', 5, 1200);
  
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 2, 'sephora', 'machiaj', 10, 1200);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 2, 'sephora', 'parfumerie', 50, 1000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 2, 'sephora', 'baie si corp', 5, 550);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 2, 'sephora', 'par', 10, 400);

INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 3, 'tekadvice', 'laptop gaming', 2000, 25000); 
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 3, 'tekadvice', 'laptop profesional', 1750, 12000);

INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 4, 'mobexpert', 'mobilier', 150, 30000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 4, 'mobexpert', 'canapele', 150, 9000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 4, 'mobexpert', 'covoare', 50, 4500);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 4, 'mobexpert', 'masa', 10, 5000);
INSERT INTO PRODUCTS (p_id, shop_id, shop_name, product_type, min_price, max_price) VALUES (1, 4, 'mobexpert', 'decoratiuni', 5, 500);
/

set serveroutput on;
set pagesize 100;

CREATE OR REPLACE TRIGGER shop_orders_insert_trigger
   INSTEAD OF INSERT ON shop_orders_view
BEGIN  
  dbms_output.put_line('Insert TRIGGER');
END;

/

CREATE OR REPLACE TRIGGER shop_orders_update_trigger
   INSTEAD OF UPDATE ON shop_orders_view
BEGIN  
  dbms_output.put_line('Update TRIGGER');
END;
/

CREATE OR REPLACE TRIGGER shop_orders_delete_trigger
   INSTEAD OF DELETE ON shop_orders_view
BEGIN  
  dbms_output.put_line('Delete TRIGGER');
END;
/

update shop_orders_view set web_address='www.new-emag.ro' where name like '%emag%';
delete from shop_orders_view where name like '%tekadvice%';
insert into shop_orders_view(name) values ('test');

select * from shop_orders_view;
  