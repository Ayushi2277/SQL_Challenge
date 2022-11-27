-- 51 Write an SQL query to report the name, population, and area of the big countries.

SELECT name, population,  area
FROM WORLD 
WHERE area>=3000000 OR population>=25000000;

--52 Write an SQL query to report the names of the customer that are not referred by the customer with id= 2.

select name
FROM CUSTOMER
WHERE referee_id <>2;

--53 Write an SQL query to report all customers who never order anything.
SELECT name as customers 
FROM customer 
where id not in (
select customerId from orders
);

--54 Write an SQL query to find the team size of each of the employees. 
-- same as 21

--55 Write an SQL query to find the countries where this company can invest.

SELECT Country.name country
FROM Calls c, Person p, Country 
WHERE (c.caller_id = p.id or c.callee_id = p.id) and 
	Country.country_code = SUBSTR(p.phone_number,1,3)
GROUP BY Country.name
HAVING avg(duration) > (SELECT AVG(duration) from Calls);

--56 Write an SQL query to report the device that is first logged in for each player.
-- same as 25

--57 Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.

select customer_number
from orders 
where order_number in (
	select max(order_number) from orders );
	
--58 Write an SQL query to report all the consecutive available seats in the cinema.Return the result table ordered by seat_id in ascending order

select distinct c1.seat_id
from cinema c1 ,cinema c2
where c1.free=1
and c2.free =1
and( c1.seat_id=c2.seat_id+1 or c1.seat_id=c2.seat_id-1);

--59 Write an SQL query to report the names of all the salespersons who did not have any orders related to the company with the name "RED".

select sp.name
from SalesPerson sp
where sp.sales_id not in (
select o.sales_id
from Orders o
inner join Company c
on o.com_id=c.com_id
where c.name ='RED'
);


--60 Write an SQL query to report for every three line segments whether they can form a triangle.

SELECT * , CASE WHEN (X + Y > Z) AND (Y + Z > X) AND (X + Z > Y)  THEN 'YES'
ELSE 'NO'
END AS triangle
FROM triangle
ORDER BY X DESC ;

--61 Write an SQL query to report the shortest distance between any two points from the Point table.

SELECT MIN(ABS(P1.X - P2.X)) as shortest
FROM POINT P1 , POINT P2
WHERE P1.X <> P2.X;

--62 Write a SQL query for a report that provides the pairs (actor_id, director_id) where the actor has cooperated with the director at least three times.


SELECT actor_id ,director_id
FROM actordirector 
WHERE actor_id =director_id
HAVING COUNT(*) >=3;

-- 63 Write an SQL query that reports the product_name, year, and price for each sale_id in the Sales table.Return the resulting table in any order.

SELECT product_name, year, price 
FROM SALES S
INNER JOIN PRODUCT P
ON S.product_id=P.product_id;

-- 64 Write an SQL query that reports the average experience years of all the employees for each project, rounded to 2 digits.

SELECT PROJECT_ID , ROUND(AVG(experience_years),2)
FROM PROJECT P 
INNER JOIN EMPLOYEE E 
ON P.employee_id = E.employee_id
GROUP BY PROJECT_ID;

--65 Write an SQL query that reports the best seller by total sales price, If there is a tie, report them all. Return the result table in any order.

SELECT seller_id
from (
select seller_id ,
RANK() OVER( ORDER BY sum(price) DESC) as rnk
from sales s
inner join product p 
on s.product_id = p.product_id
group by seller_id) a
where rnk=1;

-- 66 Write an SQL query that reports the buyers who have bought S8 but not iPhone. Note that S8 and iPhone are products present in the Product table.

SELECT buyer_id
from sales s
inner join product p 
on s.product_id = p.product_id
where product_name = 'S8' ;

--67 Write an SQL query to compute the moving average of how much the customer paid in a seven days window (i.e., current day + 6 days before). average_amount should be rounded to two decimal places.Return result table ordered by visited_on in ascending order.

SELECT visited_on,amount,AVERAGE_AMOUNT
FROM (
   SELECT visited_on ,
   SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount,
   round(avg(amount) over(order by visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2)AS AVERAGE_AMOUNT,
   DENSE_RANK() OVER(ORDER BY visited_on) as rnk
   FROM (
     SELECT visited_on,SUM(amount) AS amount 
     FROM CUSTOMERS
	 GROUP BY visited_on
      ) CUST_INFO 
) CUTOMER
WHERE rnk > 6;

-- 68 Write an SQL query to find the total score for each gender on each day.Return the result table ordered by gender and day in ascending order.

SELECT gender ,day ,SUM(score_points) AS total
FROM SCORES
GROUP BY gender,DAY
order by gender , day  asc; 

-- 69 Write an SQL query to find the start and end number of continuous ranges in the table Logs.Return the result table ordered by start_id.

select
    min(log_id) as start_id,
    max(log_id) as end_id
from
(
    select
        log_id,
        log_id - row_number() over (order by log_id) as rnk
    from logs
) t
group by rnk;
	
--70 Write an SQL query to find the number of times each student attended each exam.
SELECT st.student_id ,student_name ,sub.subject_name ,count(exm.subject_name) as attended_exams
FROM Students st
join Subjects sub
left join  Examinations exm
on   st.student_id = exm.student_id and sub.subject_name= exm.subject_name
group by st.student_id,sub.subject_name;	

--71 Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

select employee_id as EMPLOYEE_ID from Employees where manager_id in
(select employee_id from Employees WHERE manager_id in
(select employee_id from Employees where manager_id =1))
and employee_id !=1;

-- 72 Write an SQL query to find for each month and country, the number of transactions and their total amount, the number of approved transactions and their total amount.
SELECT date_format(trans_date, '%Y-%m') as month,country,
COUNT(*) AS trans_count,
SUM(CASE WHEN STATE ='approved' THEN 1 ELSE 0 END )AS  approved_count,
SUM(amount) AS trans_total_amount ,
SUM(CASE WHEN STATE ='approved' THEN amount ELSE 0 END) AS aproved_total_amount
from transactions
GROUP BY country,date_format(trans_date, '%Y-%m') ;

--73 Write an SQL query to find the average daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

SELECT  ROUND(AVG(daily_count),2) AS average_daily_percent
FROM(
SELECT count(distinct R.post_id)/count(distinct A.post_id)*100 as daily_count
FROM ACTIONS A
LEFT JOIN REMOVALS R
ON A.post_id =R.post_id
WHERE extra = 'spam'
GROUP BY action_date) A;

--74 Write an SQL query to report the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places.

select 
    round(
        count(distinct player_id) / 
        (select count(distinct player_id) from activity)
    , 2) as fraction 
from (
select 
        player_id, 
        event_date, 
        datediff(
            event_date,
            min(event_date) over(partition by player_id)
        ) as date_diff
    from activity
)activity_stats 
where date_diff = 1;


--- 75 same as 74 

-- 76 Write an SQL query to find the salaries of the employees after applying taxes. Round the salary to the nearest integer.

SELECT company_id ,employee_id ,employee_name ,
round(CASE WHEN salary BETWEEN 1000 AND 10000 THEN salary - (24 / 100) * salary 
	 WHEN salary >= 10000 THEN salary - (49 / 100) * salary  
	 ELSE salary
END,0)AS salary
FROM Salaries ;

--77 Write an SQL query to evaluate the boolean expressions in Expressions table.

select e.left_operand, e.operator, e.right_operand,
     CASE WHEN operator = '>' THEN (CASE WHEN V1.value > v2.value then 'true' else 'false' end)
      WHEN operator = '<' THEN (CASE WHEN V1.value < v2.value then 'true' else 'false' end)
	  else (CASE WHEN V1.value = v2.value then 'true' else 'false' end) 
end  as value
from expressions e 
left join variables v1 on e.left_operand = v1.name 
left join variables v2 on e.right_operand = v2.name;

--78 Write an SQL query to find the countries where this company can invest.
-- same as 55

--- 79 Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.

SELECT NAME 
FROM Employee
ORDER BY NAME;

--80 Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

SELECT Year,product_id,curr_year_spend,prev_year_spend,
round(((curr_year_spend-prev_year_spend)/prev_year_spend)*100,2) as yoy_rate
FROM (
	SELECT date_format(transaction_date,'%y') Year ,product_id ,
	round(spend,2) as curr_year_spend,
	round(lag(spend, 1) over(partition by product_id order by transaction_date),2) AS prev_year_spend
	from USER_TRANSACTIONS) USER_TRANSACTIONS;

--81 Write a SQL query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. Output the item type and number of items to be stocked.

WITH inventory_info AS (  
  SELECT  
    item_type,  
    SUM(square_footage) AS total_ar,  
    COUNT(*) AS item_count  
  FROM inventory  
  GROUP BY item_type
)

select item_type,prime_item_count AS ITEM_COUNT FROM (
SELECT  
    DISTINCT item_type,
    total_ar,
    round(500000/total_ar,0) AS prime_item_ar,
    (round(500000/total_ar,0) * item_count) AS prime_item_count
  FROM inventory_info  
  WHERE item_type = 'prime_eligible') prime_eligible
union
select item_type,non_prime_item_count AS ITEM_COUNT FROM (
SELECT
    DISTINCT item_type,
    total_ar,  
    round(
      (500000 - (SELECT (round(500000/total_ar,0) * total_ar) FROM inventory_info 
				WHERE item_type = 'prime_eligible'))  
      / total_ar, 0) as left_ar,
       round(
      (500000 - (SELECT (round(500000/total_ar,0) * total_ar) FROM inventory_info 
				WHERE item_type = 'prime_eligible'))  
      / total_ar, 0) * item_count AS non_prime_item_count  
  FROM inventory_info
  WHERE item_type = 'not_prime')not_prime;
 

---82 Assume you have the table below containing information on Facebook user actions. Write a query to obtain the active user retention in July 2022. Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).

SELECT abs(date_format(event_date,'%m')),count(distinct user_id)monthly_active_users
from user_actions a1 
where exists(
SELECT a2.user_id
from user_actions a2
where a2.user_id = a1.user_id 
AND date_format(a2.event_date,'%m') = date_format(a1.event_date,'%m') -1 );


--83  -- pending 

--- 84 Write a query to update the Facebook advertiser's status using the daily_pay table. Advertiser is a two-column table containing the user id and their payment status based on the last payment and daily_pay table has current information about their payment. Only advertisers who paid will show up in this table

SELECT CASE WHEN a.user_id IS NOT NULL THEN a.user_id ELSE d.user_id END AS user_id,
CASE WHEN d.user_id IS NULL THEN 'CHURN'
WHEN a.user_id IS NULL THEN 'NEW'
WHEN a.status = 'CHURN' THEN 'RESURRECT'
ELSE 'EXISTING' END AS status
FROM advertiser a  left JOIN daily_pay d ON a.user_id = d.user_id
ORDER BY user_id;

--85 

-- 86 

-- 87 

---89 same as 55

--88 same as 68

-- 90 

-- 91 Write an SQL query to report the comparison result (higher/lower/same) of the average salary of employees in a department to the company's average salary.

select 
    pay_month,
    department_id, 
    case when dept_avg > comp_avg then 'higher' when dept_avg < comp_avg then 'lower' else 'same' end comparison
from (
        select  date_format(b.pay_date, '%Y-%m') pay_month, a.department_id, avg(b.amount) dept_avg,  d.comp_avg
        from employee a 
        inner join salary b
            on (a.employee_id = b.employee_id) 
        inner join (select date_format(c.pay_date, '%Y-%m') pay_month, avg(c.amount) comp_avg 
                    from salary c 
                    group by date_format(c.pay_date, '%Y-%m')) d 
            on ( date_format(b.pay_date, '%Y-%m') = d.pay_month)
group by date_format(b.pay_date, '%Y-%m'), department_id, d.comp_avg) final;

-- 92 
-- 93 same as 50 

-- 94 Write an SQL query to report the students (student_id, student_name) being quiet in all exams. Do not return the student who has never taken any exam.

select s.*
from student s
inner join (
    select e.*, 
        rank() over(partition by exam_id order by score) as rn_asc,
        rank() over(partition by exam_id order by score desc) as rn_desc
    from exam e
) e on e.student_id = s.student_id
group by s.student_id
having min(rn_asc) > 1 and min(rn_desc) > 1;

-- 95 same as 94 


