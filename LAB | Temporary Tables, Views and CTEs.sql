use sakila;

-- 1.Create a view that summarizes rental information for each customer.

CREATE VIEW customer_rentals as 
SELECT 
    customer.customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name,
    customer.email,
    COUNT(rental.rental_id) AS rental_count
FROM 
    customer
LEFT JOIN 
    rental ON customer.customer_id = rental.customer_id
GROUP BY 
    customer.customer_id;
    
Select * from customer_rentals;

-- 2.Create a Temporary Table that calculates the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payments AS
SELECT 
    customer.customer_id,
    SUM(payment.amount) AS total_paid
FROM 
    customer
JOIN 
    payment ON customer.customer_id = payment.customer_id
GROUP BY 
    customer.customer_id;
    
select * from customer_payments;

-- 3. Create a CTE and the Customer Summary Report.

WITH customer_summary AS (
SELECT 
    cr.customer_name,
    cr.email,
    cr.rental_count,
    cp.total_paid
FROM 
    customer_rentals cr
JOIN 
    customer_payments cp ON cr.customer_id = cp.customer_id
)
SELECT 
    customer_name,
    email,
    rental_count,
    total_paid,
    total_paid / NULLIF(rental_count, 0) AS average_payment_per_rental
FROM 
    customer_summary;