/*
File to submit by each member: G028_2300517.sql

INDIVIDUAL ASSIGNMENT SUBMISSION
Submit one individual report with SQL statements only (*.docx)
and one sql script (*.sql for oOacle)

Template save as "G999_YourStudentID.sql"
e.g. G001_999999.sql

GROUP NUMBER : G028
PROGRAMME : CS
STUDENT ID :2300517
STUDENT NAME :Ng Xue En
Submission date and time: 16-4-2024

Your information should appear in both files one individual report docx & one individual sql script, then save as G01_99ACB999999.zip
Should be obvious different transaction among the members

*/


/* Query 1 */

--List all order details placed by male customers
WITH CusOrders AS (
    SELECT
        lastName || ' ' || firstName AS "Customer Name",
        foodName as "Food",
        orderQuantity as "Quantity",
        foodUnitPrice as "Unit Price",
	(orderQuantity*foodUnitPrice) as "Price",
	TO_CHAR(discount,'FM0.0') as "Discount",
        PayAmount as "Total",
        ROW_NUMBER() OVER (PARTITION BY p.personID ORDER BY oi.orderID) AS rn,
        COUNT(*) OVER (PARTITION BY p.personID) as totalfood
    FROM
        PERSON p, CUSTOMER c, ORDER_S ord, ORDER_ITEM oi, FOODITEM f, dual,payment pm
    WHERE
        p.personID = c.personID AND
        c.personID = ord.cusID AND
        ord.orderID = oi.orderID AND
        oi.itemID = f.itemID AND
        pm.orderID = ord.orderID AND
        p.Gender = 'M'
)
SELECT
    CASE
        WHEN rn = 1 THEN "Customer Name"
        ELSE ''
    END AS "Customer Name",
    "Food",
    "Quantity",
    "Unit Price",
    "Price",
    "Discount",
    CASE
        WHEN rn = totalfood THEN 'RM'||TO_CHAR("Total",'99.99')
        ELSE ' '
    END AS "Grand TotaL"
FROM
CusOrders;


/* Query 2 */
--Retrieve the details of the top 10 hot-selling food items
SELECT
    RANK() OVER (ORDER BY "Sold Quantity" DESC) AS "Rank",
    Food_Name,
    Unit_Price,
    "Initial Stock",
    "Sold Quantity",
    "Stock Left"
FROM (
    SELECT
        foodName AS Food_Name,
        TO_CHAR(foodUnitPrice,'99.99') AS Unit_Price,
        fQuantity AS "Initial Stock",
        SUM(ord.orderQuantity) AS "Sold Quantity",
        (fQuantity - SUM(ord.orderQuantity)) AS "Stock Left"
    FROM
        order_s o
        JOIN order_item ord ON o.orderID = ord.orderID
        JOIN fooditem fd ON fd.itemID = ord.itemID
    GROUP BY
        foodName, foodUnitPrice, fQuantity
    ORDER BY
        "Sold Quantity" DESC
) WHERE ROWNUM <= 10;

/* Query 3 */
--Retrieve information about orders that include pasta items
SELECT
       ori.orderID as Order_ID,
       foodName as "Name of food",
       lastName||' '||firstName as "Customer Name",
       Gender,
       COUNT(c.personID) as "Total"
FROM
       order_s os
       JOIN order_item ori ON os.orderID=ori.orderID
       JOIN fooditem fd ON fd.itemID=ori.itemID
       JOIN customer c ON c.personID=os.cusID
       JOIN person p ON p.personID=c.personID
       JOIN food_category fc ON fc.foodCategoryID=fd.foodCategoryID
WHERE
       foodCategoryName='Pasta'
GROUP BY
       ori.orderID, foodName, lastName||' '||firstName,Gender
ORDER BY
	"Name of food",Gender;



/* Stored procedure 1 */
--Generate daily sales report to identify the trend of sales
CREATE OR REPLACE PROCEDURE GenerateDailySalesReport AS
    CURSOR daily_sales_cur 
IS
        SELECT
            TO_CHAR(orderDate, 'YYYY-MM-DD') AS order_day,
            SUM(totalAmount) AS total_sales
        FROM
            order_s
        GROUP BY
            TO_CHAR(orderDate, 'YYYY-MM-DD')
        ORDER BY
            TO_CHAR(orderDate, 'YYYY-MM-DD');
    --declaration of variables
    prev_day_sales NUMBER;
BEGIN
    -- Print column headers
    DBMS_OUTPUT.PUT_LINE('Date' || CHR(9) || 'Total Sales' || CHR(9) || 'Daily Trend');

    -- Loop through the cursor to calculate trends
    FOR daily_sale IN daily_sales_cur LOOP
        -- Calculate trend (current day sales - previous day sales)
        SELECT
            SUM(totalAmount)
        INTO
            prev_day_sales
        FROM
            order_s
        WHERE
            TO_CHAR(orderDate, 'YYYY-MM-DD') = TO_CHAR(TO_DATE(daily_sale.order_day, 'YYYY-MM-DD') - 1, 'YYYY-MM-DD');

        -- Print the daily sales data
        DBMS_OUTPUT.PUT_LINE(
            daily_sale.order_day || CHR(9) || daily_sale.total_sales || CHR(9) ||
            (daily_sale.total_sales - NVL(prev_day_sales, 0))
        );
    END LOOP;
END;
/

--Ways to print out the result of procedure

--creating PL/SQL block
SET SERVEROUTPUT ON;
BEGIN 
	GenerateDailySalesReport;
END;
/


/* Stored procedure 2 */
--Generate Reports for the Top 20 Least Selling Food Items
CREATE OR REPLACE PROCEDURE GetLeastSellingItems
AS
    CURSOR c_least_selling_items IS
        SELECT
            RANK() OVER (ORDER BY SUM(ori.orderQuantity)) AS rank_num,
            fd.itemID AS item_id,
            fd.foodName AS food_name,
            SUM(ori.orderQuantity) AS total_quantity_sold
        FROM
            order_item ori
            JOIN fooditem fd ON fd.itemID = ori.itemID
        GROUP BY
            fd.itemID,
            fd.foodName
        ORDER BY
            SUM(ori.orderQuantity);

    item_id   order_item.itemID%TYPE;
    food_name fooditem.foodName%TYPE;
    total_sold NUMBER;
    counter NUMBER := 0;
    max_rows NUMBER := 20; -- Change this value to adjust the number of rows to retrieve

BEGIN
    DBMS_OUTPUT.PUT_LINE('Top 20 Least Selling Items');

    DBMS_OUTPUT.PUT_LINE('Rank'||CHR(9)|| 'Item ID' || CHR(9) || 'Food Name' || CHR(9) || 'Total Quantity Sold');
    FOR item_rec IN c_least_selling_items LOOP
        EXIT WHEN counter >= max_rows; -- Exit the loop when reaching the maximum number of rows
        counter := counter + 1;
        item_id := item_rec.item_id;
        food_name := item_rec.food_name;
        total_sold := item_rec.total_quantity_sold;

        DBMS_OUTPUT.PUT_LINE(item_rec.rank_num || CHR(9) || item_id || CHR(9) || food_name || CHR(9) || total_sold);
     END LOOP;
END;
/

--ways to run the procedure

--executing procedure
EXEC GetLeastSellingItems;


/* Stored procedure 3 */
--Generate Food Sales Report for a specific food item

CREATE OR REPLACE PROCEDURE GenerateFoodSalesReport
(
   foodid IN ORDER_ITEM.itemID%TYPE
)
AS
   CURSOR f_sales_cur IS
   SELECT
           TO_CHAR(orderDate,'YYYY-MM-DD') AS order_day,
           fd.itemID AS "Item ID",
           fd.foodName AS "Food Name",
           SUM(ori.orderQuantity) AS "Total Sold"
   FROM
           order_s  ord
           JOIN order_item ori ON ord.orderID=ori.orderID
           JOIN fooditem fd ON fd.itemID=ori.itemID
           JOIN food_category  fc ON fc.foodCategoryID=fd.foodCategoryID
   WHERE
           fd.itemID=foodid
   GROUP BY
            TO_CHAR(orderDate, 'YYYY-MM-DD'),
            fd.itemID,
            fd.foodName
   ORDER BY
            TO_CHAR(orderDate, 'YYYY-MM-DD');

   -- Variable to store the total quantity sold
      total_quantity_sold NUMBER := 0; 

BEGIN
   DBMS_OUTPUT.PUT_LINE('Date' || CHR(9) || 'Item ID' || CHR(9) || 'Food Name'|| CHR(9) || 'Total Sold');
    -- Loop through the cursor to calculate total sales
    FOR food_sale IN f_sales_cur LOOP
        -- Print the daily sales data
        DBMS_OUTPUT.PUT_LINE(
            food_sale.order_day || CHR(9) || food_sale."Item ID" || CHR(9) ||food_sale."Food Name" || CHR(9) || food_sale."Total Sold"
        );
        -- Add the current total sold to the overall total
        total_quantity_sold := total_quantity_sold + food_sale."Total Sold";
    END LOOP;

    -- Print the total quantity sold
    DBMS_OUTPUT.PUT_LINE('Total Quantity Sold: ' || total_quantity_sold);
END;
/

--example 
EXEC GenerateFoodSalesReport('I009');


/* Function 1 */
--Calculate the total savings for specific customer
CREATE OR REPLACE FUNCTION total_saving_customer
( customerID IN Customer.personID%TYPE)
RETURN NUMBER
IS
   t_saving NUMBER(6,2) := 0; -- Initialize total savings
BEGIN
   SELECT SUM(Discount) INTO t_saving
   FROM ORDER_S ord
   JOIN customer c ON c.personID = ord.cusID
   WHERE c.personID = customerID;

   RETURN t_saving;
END;
/
--Example
SELECT total_saving_customer('C017') AS total_savings FROM dual;


/* Function 2 */
--Check whether is customer eligible for discount and what is the customer
CREATE OR REPLACE FUNCTION check_discount_eligibility
(
   customerID IN customer.personID%TYPE
)
RETURN VARCHAR2
IS
   eligibility VARCHAR2(50);
BEGIN
   SELECT
      CASE
         WHEN cusType = 'Member' THEN
            CASE
               WHEN membershipLevelID = 'ML001' THEN 'Basic Member, Discount Rate: 0.05'
               WHEN membershipLevelID = 'ML002' THEN 'Bronze Member, Discount Rate: 0.08'
               WHEN membershipLevelID = 'ML003' THEN 'Silver Member, Discount Rate: 0.10'
               WHEN membershipLevelID = 'ML004' THEN 'Gold Member, Discount Rate: 0.15'
               WHEN membershipLevelID = 'ML005' THEN 'Platinum Member, Discount Rate: 0.20'
               ELSE 'Not Eligible'
            END
         ELSE 'Not Eligible'
      END
   INTO eligibility
   FROM 
      customer c
      LEFT JOIN member m ON m.personID = c.personID
   WHERE
      TRIM(c.personID) = TRIM(customerID);

   IF eligibility IS NULL THEN
      RETURN 'Customer not found';
   ELSE
      RETURN eligibility;
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN 'Customer not found';
END;
/
--example
SELECT check_discount_eligibility('C018') AS eligibility FROM dual;
SELECT check_discount_eligibility('C001') AS eligibility FROM dual;
SELECT check_discount_eligibility('C000') AS eligibility FROM dual;

