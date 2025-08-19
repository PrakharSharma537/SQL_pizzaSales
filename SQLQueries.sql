-- Calculate the total revenue generated from pizza sales.
SELECT 
round(sum(orders_details.quantity * pizzas.price),2 ) as total_revenue
FROM orders_details
JOIN  pizzas 
    ON  pizzas.pizza_id = orders_details.pizza_id ;



--  Identify the highest-priced pizza.

select pi.price,pt.name from pizzas as pi
join pizza_types as pt on pt.pizza_type_id = pi.pizza_type_id
order by pi.price desc;



-- Identify the most common pizza size ordered.
select  quantity,count(order_id) from orders_details
group by quantity;



-- List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_id, 
    SUM(quantity) AS total
FROM orders_details
GROUP BY pizza_id
ORDER BY total DESC;



-- Join the necessary tables to find the total quantity of each pizza category ordered.

select  category, sum(quantity) as total_quantity from pizza_types
join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
join orders_details on pizzas.pizza_id = orders_details.pizza_id
group by category
order by total_quantity desc;



-- Determine the distribution of orders by hour of the day.
select hour(order_time),count(order_id) from orders
group  by hour(order_time);




-- Join relevant tables to find the category-wise distribution of pizzas.
select count(name),category from pizza_types
group by category;



-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT AVG(order_quantity) AS avg_quantity_per_day
FROM (
    SELECT SUM(quantity) AS order_quantity, order_date
    FROM orders_details
    JOIN orders 
        ON orders_details.order_id = orders.order_id
    GROUP BY order_date
) AS daily_orders;




-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_id ,sum(quantity) as revenue  from orders_details
group by pizza_id
order by revenue
limit 3;
 
 
 
 
-- Calculate the percentage contribution of each pizza type to total revenue. 
SELECT 
    pt.category AS pizza_type,
    ROUND(SUM(od.quantity * p.price), 2) AS revenue,
    ROUND(
        (SUM(od.quantity * p.price) / 
        (SELECT SUM(od2.quantity * p2.price)
         FROM orders_details od2
         JOIN pizzas p2 ON od2.pizza_id = p2.pizza_id)
        ) * 100, 2
    ) AS percentage_contribution
FROM pizza_types pt
JOIN pizzas p 
    ON pt.pizza_type_id = p.pizza_type_id
JOIN orders_details od 
    ON p.pizza_id = od.pizza_id
GROUP BY pt.category
ORDER BY percentage_contribution DESC;




-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select category,name,revenue from
(select name,category,revenue,
rank() over(partition by category order by revenue desc) as rn 
from(
select pt.name,pt.category,round(sum(od.quantity*pi.price),2)as revenue from orders_details as od
join pizzas as pi on od.pizza_id = pi.pizza_id
join pizza_types as pt on pi.pizza_type_id = pt.pizza_type_id
group by  category,name
order by revenue desc) as a) as b
where rn <= 3;










   