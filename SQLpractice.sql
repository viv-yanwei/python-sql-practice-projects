
--------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Basic SQL
---------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE INSTRUCTOR
;

CREATE table INSTRUCTOR
	 (ins_id  INT PRIMARY KEY NOT NULL,
	lastname VARCHAR(15) NOT NULL,
	firstname VARCHAR(15) NOT NULL,
	city VARCHAR(15),
	country CHAR(2)
	)
;
	
INSERT INTO INSTRUCTOR
	(ins_id, lastname, firstname, city, country)
VALUES
	(1, 'Ahuja', 'Rav','Toronto', 'CA')
;

INSERT INTO INSTRUCTOR
VALUES
	(2, 'Chong', 'Raul','Toronto', 'CA'),
	(3, 'Vasuadevan','Hima','Chicago', 'US')
;

SELECT *  from INSTRUCTOR
;

SELECT firstname, lastname, country from INSTRUCTOR
	WHERE city = 'Toronto'
;

UPDATE INSTRUCTOR 
	SET city = 'Markham'
	WHERE firstname = 'Rav' and lastname = 'Ahuja'
;

DELETE from INSTRUCTOR
	WHERE ins_id = 2
;

SELECT * from INSTRUCTOR
;	
 
------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Sub-Queries and Nested-Selects
---------------------------------------------------------------------------------------------------------------------------------------

SELECT * from EMPLOYEES where ADDRESS LIKE '%Elgin,IL%'
; --Retrieve all employees whose address is in Elgin,IL

SELECT * from EMPLOYEES where B_DATE LIKE '197%'
; -- Retrieve all employees who were born during the 1970's.

SELECT * from EMPLOYEES where DEP_ID = 5 and (SALARY between 60000 and 70000)
; -- Retrieve all employees in department 5 whose salary is between 60000 and 70000.

SELECT * from EMPLOYEES ORDER BY DEP_ID
; -- Retrieve a list of employees ordered by department ID

SELECT * from EMPLOYEES ORDER BY DEP_ID DESC, L_NAME DESC
; -- Retrieve a list of employees ordered in descending order by department ID,
  -- and within each department ordered alphabetically in descending order by last name.

 SELECT D.DEP_NAME, E.F_NAME, E.L_NAME from EMPLOYEES as E, DEPARTMENTS as D 
 	WHERE E.DEP_ID = D.DEPT_ID_DEP 	
	ORDER BY D.DEP_NAME,  E.L_NAME DESC
;  -- Retrieve a list of employees ordered by department name, 
   -- and within each department ordered alphabetically in descending order by last name.

SELECT DEP_ID, COUNT(*) from EMPLOYEES GROUP BY DEP_ID
; --For each department ID retrieve the number of employees in the department.

SELECT DEP_ID, COUNT(*), AVG(SALARY) FROM EMPLOYEES GROUP BY DEP_ID
; -- For each department retrieve the number of employees in the department, 
  -- and the average employees salary in the department.

SELECT DEP_ID, COUNT(*) as "NUM_EMPLOYEES", AVG(SALARY) as "AVG_SALARY" 
	FROM EMPLOYEES 
	GROUP BY DEP_ID HAVING COUNT(*) < 4 ORDER BY AVG_SALARY 
; -- Label the computed columns in the result set 
  -- order the result set by Average Salary
  -- limit the result above to departments with fewer than 4
  
  
------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Sub-Queries and Nested-Selects
---------------------------------------------------------------------------------------------------------------------------------------


SELECT * from EMPLOYEES where SALARY > (SELECT AVG(SALARY) from EMPLOYEES)
; -- retrieve all employees whose salary is greater than the average salary

SELECT *,  (SELECT AVG(SALARY) from EMPLOYEES) as AVG_SALARY from EMPLOYEES
; --  Column Expression that retrieves all employees records and average salary in every row

SELECT * from (SELECT EMP_ID, F_NAME, L_NAME from EMPLOYEES)
; -- Table Expression that retrieves only the columns with non-sensitive employee data


 
------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Accessing Multiple Tables with Sub-Queries and Implicit Joins
---------------------------------------------------------------------------------------------------------------------------------------

SELECT E.* from EMPLOYEES as E, DEPARTMENTS as D 
	where D.DEPT_ID_DEP = E.DEP_ID
;
SELECT * from EMPLOYEES where DEP_ID IN 
	(SELECT DEPT_ID_DEP from DEPARTMENTS)
;-- Retrieve only the EMPLOYEES records that correspond to departments in the DEPARTMENTS table

SELECT E.EMP_ID, D.DEP_NAME from EMPLOYEES as E, DEPARTMENTS as D 
	where D.DEPT_ID_DEP = E.DEP_ID
;-- Retrieve only the Employee ID and Department name in the above query

SELECT E.* from EMPLOYEES as E, 
	(SELECT * from LOCATIONS where LOCT_ID = 'L0002') as L
	where E.DEP_ID = L.DEP_ID_LOC
;
SELECT * from EMPLOYEES where DEP_ID IN
	(SELECT DEP_ID_LOC from LOCATIONS where LOCT_ID = 'L0002')
;-- Retrieve only the list of employees from location L0002


SELECT DEPT_ID, DEP_NAME from  DEPARTMENTS 
	where DEPT_ID IN (SELECT DEP_ID from EMPLOYEES where SALARY > 70000 )
;-- Retrieve the department ID and name for employees who earn more than $70,000

SELECT * from EMPLOYEES, DEPARTMENTS
;-- Specify 2 tables in the FROM clause

 
 
------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Table Joints
---------------------------------------------------------------------------------------------------------------------------------------

SELECT E.f_name, E.l_name, JH.start_date from EMPLOYEES E
	INNER JOIN JOB_HISTORY JH on JH.empl_id = E.emp_id
	INNER JOIN JOBS J on J.job_ident = E.job_id
	where dep_id = 5 
;-- Select the names, job start dates, and job titles of all employees who work for the department number 5.

SELECT E.emp_id, E.l_name, D.dept_id_dep, D.dep_name from EMPLOYEES E
	LEFT JOIN DEPARTMENTS D on D.dept_id_dep = E.dep_id
;-- Select employee id, last name, department id and department name for all employees

SELECT E.emp_id, E.l_name, D.dept_id_dep, D.dep_name from EMPLOYEES E
	LEFT JOIN DEPARTMENTS D on D.dept_id_dep = E.dep_id
	where YEAR(E.b_date) < 1980
;-- limit the result set above to include only the rows for employees born before 1980.

SELECT E.emp_id, E.l_name, D.dept_id_dep, D.dep_name from EMPLOYEES E
	LEFT JOIN DEPARTMENTS D on D.dept_id_dep = E.dep_id
	and YEAR(E.b_date) < 1980
;-- the result set include all the employees but department names for only the employees who were born before 1980.

SELECT E.f_name, E.l_name, D.dep_name from EMPLOYEES E
	FULL JOIN DEPARTMENTS D on D.dept_id_dep = E.dep_id
;-- Full Join on the EMPLOYEES and DEPARTMENT tables and select the First name, Last name and Department name of all employees.

SELECT E.f_name, E.l_name, D.dep_name from EMPLOYEES E
	FULL JOIN DEPARTMENTS D on D.dept_id_dep = E.dep_id
	and E.sex = 'M'
;-- Have the result set above include all employee names but department id and department names only for male employees.


