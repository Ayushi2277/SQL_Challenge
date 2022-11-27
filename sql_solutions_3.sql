--- 101 Write an SQL query to show the second most recent activity of each user.If the user only has one activity, return that one. A user cannot perform more than one activity at the same time.
SELECT * FROM (
(select * 
from UserActivity
group by username
having count(1) = 1)
union
(select a.*
from UserActivity as a left join UserActivity as b
on a.username = b.username and a.endDate<b.endDate
group by a.username, a.endDate
having count(b.endDate) = 1) ) A
ORDER BY username;

-- 102 same as 101

---103 Query the Name of any student in STUDENTS who scored higher than 75 Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.

SELECT Name
FROM STUDENTS
where marks >75
ORDER BY SUBSTR(NAME,-3),ID;

--- 104 Write a query that prints a list of employee names (i.e.: the name attribute) for employees in Employee having a salary greater than $2000 per month who have been employees for less than 10 months. Sort your result by ascending employee_id.
SELECT name
FROM EMPLOYEE
WHERE SALARY >2000 and months <10
ORDER BY employee_id;

--105 Write a query identifying the type of each record in the TRIANGLES table using its three side lengths.

select case 
	when a+b < c or b+c<a or c+a <b then 'Not a Triangle'
    when a=b and b=c then 'Equilateral'
    when a=b or a=c or b=c then 'Isosceles'
    when a<>b or b<>c then 'Scalene'
    end as result
from triangles;

--106 Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realise her keyboard's 0 key was broken until after completing thecalculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.Write a query calculating the amount of error (i.e.: actual - miscalculated average monthly salaries),and round it up to the next integer.

select avg(Salary) - avg(replace(Salary,'0','')) as ouput
from employees;

-- 107 We define an employee's total earnings to be their monthly salary * months worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table.Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers

select max(months * salary) as max_eranings, count(months * salary) max_no_employee_earned
from Employee where (months * salary) 
= (select max(months * salary) from Employee);

--108 Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses).
--where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and[occupation] is the lowercase occupation name. If more than one Occupation has the same[occupation_count], they should be ordered alphabetically.

(select concat(name,"(",substr(occupation,1,1),")") as n from occupations)  
union
(select concat('There are total ',count(*),' ',lower(occupation),'s.') as n from occupations
group by occupation)
order by n asc;

--109 Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation. The output column headers should be Doctor,Professor, Singer, and Actor, respectively.

 select
        max(case Occupation when 'Doctor' then Name end) as Doctor,
        max(case Occupation when 'Professor' then Name end) as Professor,
        max(case Occupation when 'Singer' then Name end) as Singer,
        max(case Occupation when 'Actor' then Name end) as Actor
    from (
            select
                Occupation,
                Name,
                row_number() over(partition by Occupation order by Name ASC) as NameOrder
            from Occupations
         ) as NameLists
    group by NameOrder;

--110 You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, and P is the parent of N.

select N ,
case  when p is null then 'Root'
	  when N IN (SELECT P FROM BST) THEN 'Inner'
      else 'Leaf'
END 
FROM BST
order by N;

-- 111 write a query to print the company_code, founder name, total number of lead managers, total number of senior managers, total number of managers, and total number of employees.

SELECT c.company_code, c.founder,
 COUNT(DISTINCT e.lead_manager_code), COUNT(DISTINCT e.senior_manager_code),
 COUNT(DISTINCT e.manager_code), COUNT(DISTINCT e.employee_code) 
 FROM company c
JOIN employee e ON c.company_code = e.company_code GROUP BY c.company_code, c.founder ORDER BY c.company_code;

-- 112 pending

--113 
--114

-- 115 same as 103

---116 Write a query to output all such symmetric pairs in ascending order by the value of X. List the rows such that X1 ≤ Y1.

(SELECT X, Y FROM Functions WHERE X=Y GROUP BY X, Y HAVING COUNT(*)=2
union
SELECT f1.x,f1.y 
FROM FUNCTIONS F1, FUNCTIONS F2
WHERE f1.X < f1.Y 
AND f1.X=f2.Y 
AND f2.X=f1.Y )
order by x;

--116 Write a query that prints a list of employee names (i.e.: the name attribute) from the Employee table in alphabetical order.

SELECT name
from employee
order by name;

-- 117 same as 104 

-- 118 same as 105 

-- 119 same as 80

-- 120 same as 81

--- 121 same as 82

-- 122 same as 83 

-- 123 same as 84 

-- 124 same as 85 

-- 125 same as 86 

-- 126 same as 87

-- 127 same as 68 & 88 

-- 128 same as 55 & 89 

-- 129 same as 90 

-- 130 same as 91 

-- 131 same as 92

-- 132 same as 50

-- 133 same as 131 & 92 

-- 134 same as 133

-- 135 same as 101 

-- 136 same as 135 

-- 137 same as 106 

-- 138 same as 107 

-- 139 same as 108 

-- 140 same as 109 

-- 141 same as 110

-- 142 same as 111

-- 143 same as 116 

-- 144 
 



