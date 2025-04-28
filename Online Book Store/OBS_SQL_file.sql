CREATE DATABASE Online_Book_Store;

CREATE TABLE IF NOT EXISTS Books (
		Book_ID SERIAL PRIMARY KEY,
        Title VARCHAR(100),
        Author VARCHAR(100),
        Genre VARCHAR(50),
        Published_Year INT,
        Price NUMERIC(10,2),
        Stock INT
        );
CREATE TABLE IF NOT EXISTS Customers (
			Customer_ID SERIAL PRIMARY KEY,
            Name VARCHAR(100),
            Email VARCHAR(100),
            Phone VARCHAR(20),
            City VARCHAR(100),
            Country VARCHAR(50)
            );
CREATE TABLE IF NOT EXISTS Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers (Customer_ID),
    BooK_ID INT REFERENCES Books (Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10 , 2 )
);
 
 SELECT *FROM Books;
 SELECT *FROM Customers;
 SELECT *FROM Orders;
 
-- BASICS
-- Retrieve all the books from "fiction" genre:
SELECT *from Books where Genre = "Fiction";

-- Find books published after the year 1950:
SELECT *FROM Books where Published_Year > 1950;

-- List all customers from the Canada:
SELECT *FROM Customers WHERE COUNTRY="CANADA";

-- Show orders placed in November 2023:
SELECT *FROM ORDERS WHERE MONTH(ORDER_DATE)=11 AND YEAR(ORDER_DATE)=2023;

-- Retrieve the total stock of books available:
SELECT SUM(STOCK) FROM BOOKS;

-- Find the details of the most expensive book:
SELECT *FROM Books ORDER BY Price DESC LIMIT 1;

-- Show all customers who ordered more than 1 quantity of a book:
SELECT *FROM ORDERS WHERE QUANTITY>1;

-- Retrieve all orders where the total amount exceeds $20:
SELECT *FROM ORDERS WHERE TOTAL_AMOUNT > 20;

-- List all genres available in the Books table:
SELECT DISTINCT GENRE FROM BOOKS;

-- Find the book with the lowest stock:
SELECT * FROM BOOKS ORDER BY STOCK LIMIT 1;

-- Calculate the total revenue generated from all orders:
SELECT SUM(TOTAL_AMOUNT) FROM ORDERS;

-- Advanced
-- Q1. Retrieve the total number of books sold for each genre:
SELECT B.GENRE, SUM(O.QUANTITY) FROM ORDERS AS O
JOIN BOOKS AS B ON O.BOOK_ID = B.BOOK_ID
GROUP BY GENRE;

-- Q2. Find the average price of books in the "Fantasy" genre:
SELECT GENRE, AVG(PRICE) FROM BOOKS
WHERE GENRE = "Fantasy";

-- Q3. List customers who have placed at least 2 orders:
SELECT C.CUSTOMER_ID,C.NAME,C.EMAIL,C.PHONE
FROM CUSTOMERS AS C JOIN ORDERS AS O 
ON C.CUSTOMER_ID = O.ORDER_ID
WHERE O.QUANTITY>2;

-- Q4. Find the most frequently ordered book:
SELECT O.BOOK_ID, B.TITLE, COUNT(O.ORDER_ID) AS C
FROM ORDERS O JOIN BOOKS B ON O.BOOK_ID=B.BOOK_ID
GROUP BY O.BOOK_ID, B.TITLE ORDER BY C DESC LIMIT 1;

-- Q5. Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT *FROM BOOKS WHERE GENRE = "Fantasy"
ORDER BY PRICE DESC LIMIT 3;

-- Q6. Retrieve the total quantity of books sold by each author:
SELECT B.Auther, SUM(O.QUANTITY) FROM BOOKS B
JOIN ORDERS O ON B.BOOK_ID=O.BOOK_ID
GROUP BY B.Auther ORDER BY B.Auther;

-- Q7. List the cities where customers who spent over $30 are located:
SELECT C.CITY, SUM(O.TOTAL_AMOUNT) FROM CUSTOMERS C 
JOIN ORDERS O ON C.CUSTOMER_ID=O.CUSTOMER_ID
WHERE O.TOTAL_AMOUNT>30 GROUP BY C.CITY
ORDER BY SUM(O.TOTAL_AMOUNT);

-- Q8. Find the customer who spent the most on orders:
SELECT C.CUSTOMER_ID,C.NAME,C.EMAIL,SUM(O.TOTAL_AMOUNT) AS T 
FROM CUSTOMERS C JOIN ORDERS O GROUP BY C.CUSTOMER_ID, C.NAME
ORDER BY T DESC LIMIT 1;

-- Q9. Calculate the stock remaining after fulfilling all orders:
SELECT B.BOOK_ID,B.TITLE,B.STOCK,COALESCE(SUM(O.QUANTITY),0),
B.STOCK-COALESCE(SUM(O.QUANTITY),0) AS REMAINING_STOCK
FROM BOOKS B JOIN ORDERS O ON B.BOOK_ID=O.BOOK_ID
GROUP BY B.BOOK_ID ORDER BY B.BOOK_ID;
