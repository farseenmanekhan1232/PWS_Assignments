CREATE TABLE customer(
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(40)
);

CREATE TABLE product(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(40),
    product_price INT
);

CREATE TABLE order_(
    order_id INT PRIMARY KEY,
    customer_id INT,
    ordered_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE
);


CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    product_id INT , 
    quantity INt,
    FOREIGN KEY (order_id ) REFERENCES order_(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE SET NULL
);

INSERT INTO customer VALUES(1,'John');
INSERT INTO customer VALUES(2,'Smith');
INSERT INTO customer VALUES(3,'Ricky');
INSERT INTO customer VALUES(4,'Walsh');
INSERT INTO customer VALUES(5,'Stefen');
INSERT INTO customer VALUES(6,'Fleming');
INSERT INTO customer VALUES(7,'Thomson');
INSERT INTO customer VALUES(8,'David');


INSERT INTO product VALUES(1, 'Television', 19000);
INSERT INTO product VALUES(2, 'DVD', 3600);
INSERT INTO product VALUES(3, 'Washing Machine', 7600);
INSERT INTO product VALUES(4, 'Computer',35900);
INSERT INTO product VALUES(5, 'Ipod',3210);
INSERT INTO product VALUES(6, 'Panasonic Phone',2100);
INSERT INTO product VALUES(7, 'Chair',360);
INSERT INTO product VALUES(8 , 'Table', 490);
INSERT INTO product VALUES(9, 'Sound System', 12050);
INSERT INTO product VALUES(10, 'Home theatre', 19350);

INSERT INTO order_ VALUES(1, 4, '2005-01-10');
INSERT INTO order_ VALUES(2, 2, '2006-02-10');
INSERT INTO order_ VALUES(3, 3, '2005-03-20');
INSERT INTO order_ VALUES(4, 3, '2006-03-10');
INSERT INTO order_ VALUES(5, 1, '2007-04-05');
INSERT INTO order_ VALUES(6, 7, '2006-12-13');
INSERT INTO order_ VALUES(7, 6, '2008-03-13');
INSERT INTO order_ VALUES(8, 6, '2004-11-29');
INSERT INTO order_ VALUES(9, 5, '2005-01-13');
INSERT INTO order_ VALUES(10, 1, '2007-12-12');

INSERT INTO order_details VALUES(1,1,3,1);
INSERT INTO order_details VALUES(2,1,2,3);
INSERT INTO order_details VALUES(3,2,10,2);
INSERT INTO order_details VALUES(4,3,7,10);
INSERT INTO order_details VALUES(5,3,4,2);
INSERT INTO order_details VALUES(6,3,5,4);
INSERT INTO order_details VALUES(7,4,3,1);
INSERT INTO order_details VALUES(8,5,1,2);
INSERT INTO order_details VALUES(9,5,2,1);
INSERT INTO order_details VALUES(10,6,5,1);
INSERT INTO order_details VALUES(11,7,6,1);
INSERT INTO order_details VALUES(12,8,10,2);
INSERT INTO order_details VALUES(13,8,3,1);
INSERT INTO order_details VALUES(14,9,10,3);
INSERT INTO order_details VALUES(15,10,1,1);


-- 1) Fetch all the Customer Details along with the product names that the customer has ordered.
SELECT customer.* , product.product_name , product.product_price
FROM product , customer
WHERE product.product_id IN(
    SELECT customer_id
    FROM customer
)
ORDER BY customer.customer_name;

-- 2) Fetch Order_Id, Ordered_Date, Total Price of the order (product price*qty).

SELECT order_.order_id , order_.ordered_date  , (product.product_price *order_details.quantity ) AS 'Total Price'
FROM order_
INNER JOIN order_details
ON order_.order_id = order_details.order_id
INNER JOIN product
ON product.product_id = order_details.product_id ;


-- 3) Fetch the Customer Name, who has not placed any order
SELECT * 
FROM customer
WHERE customer_id NOT IN(
    SELECT customer_id 
    FROM order_
);

-- 4) Fetch the Product Details without any order(purchase)
SELECT * 
FROM product 
WHERE product_id NOT IN(
    SELECT order_details.product_id
    FROM order_details
);

-- 5) Fetch the Customer name along with the total Purchase Amount

SELECT customer.customer_name, SUM(product.product_price *order_details.quantity ) AS 'Total Purchase'
FROM order_
INNER JOIN order_details
ON order_.order_id = order_details.order_id
INNER JOIN product
ON product.product_id = order_details.product_id
INNER JOIN customer
ON customer.customer_id = order_.customer_id
GROUP BY customer.customer_name;

-- 6) Fetch the Customer details, who has placed the first and last order

SELECT customer.customer_id , customer.customer_name 
FROM customer 
INNER JOIN order_ 
ON order_.customer_id = customer.customer_id
INNER JOIN order_details
ON order_details.order_id = order_.order_id 
WHERE order_details.order_details_id  IN (
    SELECT order_details.order_details_id
    FROM order_details
    WHERE order_details.order_details_id = 1 OR  order_details.order_details_id = 15  
);


-- 7) Fetch the customer details , who has placed more number of orders

SELECT customer.customer_name, COUNT(customer.customer_id) as No_of_orders
FROM order_details 
INNER JOIN order_
ON order_.order_id = order_details.order_id
INNER JOIN customer
ON customer.customer_id = order_.customer_id
GROUP BY customer.customer_id
ORDER BY No_of_orders DESC
LIMIT 1;


-- 8) Fetch the customer details, who has placed multiple orders in the same year

SELECT customer.customer_name,customer.customer_id , YEAR(order_.ordered_date) as year_ , COUNT(*)
FROM order_details
INNER JOIN order_ 
ON order_.order_id = order_details.order_id 
INNER JOIN customer
ON customer.customer_id = order_.customer_id
GROUP BY customer.customer_name,customer.customer_id , YEAR(order_.ordered_date)
HAVING COUNT(*)>1;

-- 9)Fetch the name of the month, in which more number of orders has been placed

SELECT customer.customer_name,customer.customer_id , MONTHNAME(order_.ordered_date) as month_
FROM order_details
INNER JOIN order_ 
ON order_.order_id = order_details.order_id 
INNER JOIN customer
ON customer.customer_id = order_.customer_id
GROUP BY customer.customer_name,customer.customer_id , MONTHNAME(order_.ordered_date) 
HAVING COUNT(*)>1;

-- 10) Fetch the maximum priced Ordered Product

SELECT product.product_id , product.product_name ,product.product_price
FROM order_details
INNER JOIN order_ 
ON order_.order_id = order_details.order_id 
INNER JOIN customer
ON customer.customer_id = order_.customer_id
INNER JOIN product
ON product.product_id = order_details.product_id
ORDER BY product.product_price DESC
LIMIT 1;