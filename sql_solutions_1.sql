
--Q1. Query all columns for all American cities in the CITY table with populations larger than 100000. The CountryCode for America is USA.

SELECT * 
FROM CITY
WHERE COUNTRYCODE = 'USA' AND POPULATION > 100000;

--Q2. Query the NAME field for all American cities in the CITY table with populations larger than 120000.The CountryCode for America is USA.

SELECT NAME 
FROM CITY
WHERE CountryCode = 'USA' AND population > 120000;

--Q3. Query all columns (attributes) for every row in the CITY table.

SELECT ID ,
NAME ,
COUNTRYCODE,
DISTRICT,
POPULATION
FROM CITY;

--Q4. Query all columns for a city in CITY with the ID 1661.

SELECT * 
FROM CITY
WHERE ID = 1661;

--Q6. Query the names of all the Japanese cities in the CITY table. The COUNTRYCODE for Japan is JPN.

SELECT NAME 
FROM CITY
WHERE CountryCode = 'JPN';

--Q7. Query a list of CITY and STATE from the STATION table.

SELECT CITY ,
STATE
FROM STATION ;

--Q8. Query a list of CITY names from STATION for cities that have an even ID number. Print the results in any order, but exclude duplicates from the answer.

SELECT distinct CITY
FROM STATION 
WHERE mod(ID,2) = 0
;

--Q9. Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.

SELECT (COUNT(CITY)-COUNT(DISTINCT CITY)) 
FROM STATION;

--Q10. Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or
--largest city, choose the one that comes first when ordered alphabetically.

--1ST way
(SELECT CITY  , MAX(LENGTH(CITY)) CITY_LENGTH FROM STATION GROUP BY CITY ORDER BY CITY_LENGTH DESC LIMIT 1)
UNION 
(SELECT CITY , MIN(LENGTH(CITY)) CITY_LENGTH FROM STATION GROUP BY CITY ORDER BY CITY_LENGTH , CITY LIMIT 1);

--OR
--2nd way
(SELECT CITY, LENGTH(CITY) AS CITY_LEN FROM STATION ORDER BY CITY_LEN ASC, CITY ASC LIMIT 1) 
UNION
(SELECT CITY, LENGTH(CITY) AS CITY_LEN FROM STATION ORDER BY CITY_LEN DESC, CITY ASC LIMIT 1);

--Q11. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT (CITY)
FROM STATION 
WHERE CITY LIKE 'a%' OR CITY LIKE 'A%' OR CITY LIKE 'e%' OR CITY LIKE 'E%' 
OR CITY LIKE 'i%' OR CITY LIKE'I%' OR CITY LIKE  'o%' OR CITY LIKE 'O%'OR CITY LIKE 'u%' OR CITY LIKE'U%';

--Q12. Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.

SELECT DISTINCT (CITY)
FROM STATION 
WHERE CITY LIKE '%a' OR CITY LIKE '%A' OR CITY LIKE '%e' OR CITY LIKE '%E' 
OR CITY LIKE '%i' OR CITY LIKE'%I' OR CITY LIKE  '%o' OR CITY LIKE '%O'OR CITY LIKE '%u' OR CITY LIKE '%U';

--Q13. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND
CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%';

--14 .Query the list of CITY names from STATION that do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT (CITY)
FROM STATION 
WHERE CITY NOT LIKE  '%a' AND CITY NOT LIKE '%A' AND CITY NOT LIKE '%e' AND CITY NOT LIKE '%E' 
AND CITY NOT LIKE '%i' AND CITY NOT LIKE'%I' AND CITY NOT LIKE  '%o' AND CITY NOT LIKE '%O' AND CITY NOT LIKE '%u' AND CITY NOT LIKE '%U';

--Q15. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE '[A,E,I,O,U]%' OR
CITY NOT LIKE '%[A,E,I,O,U]';

--Q16. Query the list of CITY names from STATION that do not start with vowels and do not end with vowels. Your result cannot contain duplicates.

SELECT DISTINCT CITY 
FROM STATION 
WHERE CITY NOT LIKE '[A,E,I,O,U]%' AND CITY NOT LIKE '%[A,E,I,O,U]';

-- NEW DATA SET
-- Q17 Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,between 2019-01-01 and 2019-03-31 inclusive.

SELECT P.product_id ,product_name 
FROM SALES S
INNER JOIN  PRODUCT P 
ON   S.product_id = P.product_id
WHERE  S.product_id NOT IN (
                        SELECT
					    product_id
                        FROM SALES
                        WHERE sale_date NOT BETWEEN '2019-01-01' AND '2019-03-31'
                        ); 
--Q18. Write an SQL query to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order. 

SELECT DISTINCT author_id
FROM VIEWS 
WHERE author_id=viewer_id
ORDER BY author_id;

--Q19.Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal places.

SELECT ROUND(100*B.IMMEDIATE_ORDERS/COUNT(A.Delivery_ID),2) AS IMMEDIATE_PERCENTAGE 
FROM Delivery A,
(SELECT COUNT(order_date) AS IMMEDIATE_ORDERS 
FROM Delivery 
WHERE  order_date = customer_pref_delivery_date )B;

--20.Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
--tie.

select distinct ad_id, coalesce(
        round(
            sum(action = 'Clicked') / (sum(action = 'Clicked') + sum(action = 'Viewed')) * 100, 2
        ) , 0
    ) as ctr
    from Ads
    group by ad_id
    order by ctr desc, ad_id;
	
--21.Write an SQL query to find the team size of each of the employees.Return result table in any order.

SELECT  A.employee_id ,COUNT(*) TEAM_SIZE 
FROM EMPLOYEE A 
INNER JOIN EMPLOYEE B
ON A.team_id=B.team_id
GROUP BY employee_id 
ORDER BY employee_id;

--22.Write an SQL query to find the type of weather in each country for November 2019.

SELECT   country_name,CASE 
		WHEN (SUM(weather_state)/COUNT(C.country_id)) <=15 THEN 'COLD'
		WHEN (SUM(weather_state)/COUNT(C.country_id)) >=25 THEN 'HOT'
        ELSE  'WARM' 
		END AS weather_type
FROM  WEATHER W 
INNER JOIN COUNTRIES C
ON  W.country_id =C.country_id 
WHERE DAY LIKE '2019-11%' 
GROUP BY C.country_id
ORDER BY weather_type ; 

--23 Write an SQL query to find the average selling price for each product. average_price should be rounded to 2 decimal places.

SELECT PRC.product_id ,ROUND(SUM(UNITS*PRICE)/SUM(UNITS),2) AS average_price 
FROM PRICES PRC
INNER JOIN UnitsSold  US
ON PRC.product_id = US.product_id
WHERE  purchase_date BETWEEN  start_date AND end_date 
GROUP BY PRC.product_id;


--24 Write an SQL query to report the first login date for each player.

SELECT LOGIN.PLAYER_ID,LOGIN.EVENT_DATE
FROM (
SELECT PLAYER_ID,EVENT_DATE,RANK() OVER(PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) AS FIRST_LOGIN_RNK 
FROM ACTIVITY
) LOGIN
WHERE FIRST_LOGIN_RNK = 1
GROUP BY LOGIN.PLAYER_ID ORDER BY LOGIN.PLAYER_ID;


--25 Write an SQL query to report the device that is first logged in for each player.

SELECT LOGIN_DEVICE.player_id,LOGIN_DEVICE.device_id
FROM (
SELECT player_id,device_id,row_number() OVER(partition BY player_id ORDER BY device_id) AS FIRST_LOGIN_ROW 
FROM ACTIVITY
) LOGIN_DEVICE
where FIRST_LOGIN_ROW = 1
GROUP BY LOGIN_DEVICE.player_id order by LOGIN_DEVICE.player_id;


---26 Write an SQL query to get the names of products that have at least 100 units ordered in February 2020 and their amount.


SELECT product_name,units
FROM (
SELECT product_name,sum(unit) as units,ORD.product_id,order_date
FROM Orders ord
INNER JOIN Products	prod
on ord.product_id=prod.product_id 
where order_date like '2020-02-%'
group by product_id) ORDS
where units >=100
;

--27 Write an SQL query to find the users who have valid emails.
select * 
from Users
where  mail regexp '^[a-zA-Z]+[a-zA-Z0-9_\./-]{0,}@leetcode.com$'
order by user_id;

--28 Write an SQL query to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020.

SELECT O.CUSTOMER_ID, C.NAME
FROM CUSTOMERS C, PRODUCT P, ORDERS O
WHERE C.CUSTOMER_ID = O.CUSTOMER_ID AND P.PRODUCT_ID = O.PRODUCT_ID
GROUP BY O.CUSTOMER_ID
HAVING 
(
    SUM(CASE WHEN O.ORDER_DATE LIKE '2020-06%' THEN O.QUANTITY*P.PRICE ELSE 0 END) >= 100
    AND
    SUM(CASE WHEN O.ORDER_DATE LIKE '2020-07%' THEN O.QUANTITY*P.PRICE ELSE 0 END) >= 100
);

--29 Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.

SELECT title
FROM TVProgram tvp
inner JOIN content con
on tvp.content_id=con.content_id
where Kids_content ='Y' AND 
program_date LIKE '2020-06-%';

--30  Write an SQL query to find the npv of each query of the Queries table.

SELECT n.id, n.year, npv
FROM NPV n
left JOIN Queries qr 
on n.id=qr.id
and  n.year=qr.year;

--31 same as 30

--32 Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just show null.

select unique_id  ,name
from employees emp
left join employeeuni euni
on emp.id=euni.id
order by unique_id ;

--33 Write an SQL query to report the distance travelled by each user.Return the result table ordered by travelled_distance in descending order, if two or more users travelled the same distance, order them by their name in ascending order.

select name , sum(distance) as travlled_distance
from  users u
inner join  rides r
on u.id = r.user_id
group by user_id
order by travlled_distance desc ,name;

--34 orders table data is missing 

--35 Write an SQL query to:
/*● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name.*/

SELECT NAME AS results
FROM MovieRating MR
INNER JOIN MOVIES M
ON MR.movie_id=M.movie_id
INNER JOIN user U
ON MR.USER_ID=U.USER_ID
HAVING MAX(rating)

UNION

SELECT TITLE AS results FROM (
SELECT TITLE ,AVG(rating) AS AVG_RATING
FROM MovieRating MR
INNER JOIN MOVIES M
ON MR.movie_id=M.movie_id
INNER JOIN user U
ON MR.USER_ID=U.USER_ID
WHERE created_at LIKE '2020-02-%'
GROUP BY U.USER_ID 
ORDER BY AVG_RATING DESC ,TITLE LIMIT 1)A;

--36 same as 33

--- 37 same as 32

--38 Write an SQL query to find the id and the name of all students who are enrolled in departments that no longer exist.

SELECT ID,NAME 
FROM STUDENTS 
WHERE department_id NOT IN (
SELECT ID FROM DEPARTMENTS 
);

--39 Write an SQL query to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.

SELECT PERSON1,PERSON2,count(*) as CALL_COUNT,sum(duration) as TOTAL_DURATION
FROM 
(select from_id as person1, to_id as person2, duration
    from Calls
    UNION ALL
    select to_id as person1, from_id as person2, duration
    from Calls) caller
   where person1 < person2 
   group by person1, person2;


--40 same as 23 

--41 Write an SQL query to report the number of cubic feet of volume the inventory occupies in each warehouse.
SELECT Name as  warehouse_name , sum(units * p.volm) as volume 
FROM warehouse W
INNER JOIN (
SELECT product_id,Width*Length*Height  as volm from PRODUCTs 
) P 
ON W.product_id = P.product_id
group by name ;

--42 Write an SQL query to report the difference between the number of apples and oranges sold each day

select a.sale_date, a.sold_num - b.sold_num as diff
from Sales a left join Sales b
on a.sale_date = b.sale_date
where a.fruit = 'apples' and b.fruit = 'oranges';

--43 same as 24

-- 44 Write an SQL query to report the managers with at least five direct reports.

select e.name 
from employees e
inner join employees e1 
on e.id = e1.managerId
group by e.id;

--45 Write an SQL query to report the respective department name and number of students majoring in each department for all departments in the Department table (even ones with no current students).Return the result table ordered by student_number in descending order. In case of a tie, order them bydept_name alphabetically

SELECT dept_name , count(student_id) as student_number 
from  department dept
left JOIN student stU
on dept.dept_id=stu.dept_id
group by dept_name;

--46 Write an SQL query to report the customer ids from the Customer table that bought all the products in the Product table.

SELECT customer_id 
FROM (
select customer_id, count(distinct product_key) as num
from Customer
group by customer_id ) cust
where cust.num = (
select count(distinct product_key) from Product);

--47 Write an SQL query that reports the most experienced employees in each project. In case of a tie,report all employees with the maximum number of experience years.

SELECT  project_id,employee_id
FROM (
SELECT
        p.project_id,
        p.employee_id,
        DENSE_RANK() OVER(PARTITION BY p.project_id ORDER BY e.experience_years DESC) as rnk
    FROM project as p 
    INNER JOIN employee as e
    ON p.employee_id = e.employee_id
    ) Max_exp
where rnk =1;


--48 Write an SQL query that reports the books that have sold less than 10 copies in the last year,excluding books that have been available for less than one month from today. Assume today is 2019-06-23.

select book_id, name
from Books
where book_id not in (
    select book_id
    from Orders
    where dispatch_date >= '2018-06-23' and dispatch_date <= '2019-06-22'
    group by book_id
    having sum(quantity) >= 10)
and available_from < '2019-05-23';

--49Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id.

select e.student_id, e.course_id, e.grade
from (
  select *, row_number() over (partition by student_id order by grade desc) rnk
  from Enrollments
) e
where e.rnk = 1;



-- Quesn - 50 Write an SQL query to find the winner in each group.
SELECT group_id,player_id
FROM (
select m.match_player AS player_id,p.group_id as group_id ,sum(m.score) as max_score
from Players p , (
    select first_player as match_player, first_score as score 
    from Matches
    union all 
    select second_player as match_player , second_score as score
    from Matches
) m
where p.player_id= m.match_player
group by player_id order by group_id,max_score DESC
) score_per_group
group by group_id 
;

