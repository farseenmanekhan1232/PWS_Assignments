CREATE DATABASE SQLBasicsAssignment;
USE SQLBasicsAssignment;

CREATE TABLE Dept(
    dept_no INT PRIMARY KEY,
    dname VARCHAR(40),
    loc VARCHAR(40)
);

CREATE TABLE Emp(
    empno INT PRIMARY KEY,
    ename VARCHAR(40),
    sal INT,
    hire_date DATE ,
    commission INT,
    dept_no INT,
    mgr INT,
    FOREIGN KEY (dept_no) REFERENCES Dept(dept_no) ON DELETE SET NULL,
    FOREIGN KEY (mgr) REFERENCES Emp(empno) ON DELETE CASCADE
);
INSERT  Dept VALUES(10 , 'Accounts' , 'Bangalore');
INSERT  Dept VALUES(20 , 'IT' , 'Delhi');
INSERT  Dept VALUES(30 , 'Production' , 'Chennai');
INSERT  Dept VALUES(40 , 'Sales' , 'Hyd');
INSERT  Dept VALUES(50 , 'Admin' , 'London');

INSERT INTO Emp VALUES(1001 , 'Sachin' ,19000,'1980-01-01',2100,20,NULL);
INSERT INTO Emp VALUES(1002 , 'Kapil' ,15000,'1970-01-01',2300,10,NULL);
INSERT INTO Emp VALUES(1003 , 'Stefen' ,12000,'1990-01-01',500,20,NULL);
INSERT INTO Emp VALUES(1004 , 'Williams' ,9000,'2001-01-01',NULL,30,NULL);
INSERT INTO Emp VALUES(1005 , 'John' ,5000,'2005-01-01',NULL,30,NULL);
INSERT INTO Emp VALUES(1006 , 'Dravid' ,19000,'1985-01-01',2400,10,NULL);
INSERT INTO Emp VALUES(1007 , 'Martin' ,21000,'2000-01-01',1040,NULL,NULL);

UPDATE Emp SET mgr = 1003 WHERE empno  =1001;
UPDATE Emp SET mgr = 1003 WHERE empno  =1002;
UPDATE Emp SET mgr = 1007 WHERE empno  =1003;
UPDATE Emp SET mgr = 1007 WHERE empno  =1004;
UPDATE Emp SET mgr = 1006 WHERE empno  =1005;
UPDATE Emp SET mgr = 1007 WHERE empno  =1006;
UPDATE Emp SET mgr = NULL WHERE empno  =1007;


-- 1) Select Employee Details of dept number 10 or 30
SELECT * 
FROM Emp
WHERE dept_no=10 OR dept_no=30;


-- 2)  Write a query to fetch all the dept details with more than 1 Employee.

SELECT * 
FROM Dept
WHERE Dept.dept_no IN
(SELECT Emp.dept_no
FROM Emp
GROUP BY Emp.dept_no
HAVING COUNT(Emp.dept_no)>1
);

-- 3) Write a query to fetch employee details whose name starts with the letter "S"

SELECT * 
FROM Emp
WHERE Emp.ename LIKE "S%";

-- 4) Select Emp Details Whose experience is more than 2 years
SELECT *  , FLOOR(DATEDIFF(NOW() , Emp.hire_date )/365) as 'Experience in Years'
FROM Emp
WHERE FLOOR(DATEDIFF(NOW() , Emp.hire_date)/365)>2;


-- 5) Write a SELECT statement to replace the char "a" with "#" in Employee Name ( Ex:  Sachin as S#chin)

SELECT  REPLACE(Emp.ename , "a", "#")
FROM Emp;

-- 6) Write a query to fetch employee name and his/her manager name. 

SELECT A.ename as Employee  , B.ename as Manager
FROM Emp A , Emp B
WHERE A.mgr = B.empno;


-- 7) Fetch Dept Name , Total Salry of the Dept

SELECT SUM(A.sal) , B.dname
FROM Emp A , Dept B
WHERE A.dept_no = B.dept_no
GROUP BY B.dept_no;

-- 8) Write a query to fetch ALL the  employee details along with department name, department location, irrespective of employee existance in the department.

SELECT * 
FROM Emp
LEFT JOIN Dept ON Emp.dept_no = Dept.dept_no;


-- 9) Write an update statement to increase the employee salary by 10 %
UPDATE Emp SET Emp.sal = Emp.sal*1.1 ;


-- 10) Write a statement to delete employees belong to Chennai location.

DELETE FROM Emp WHERE Emp.dept_no IN(
    SELECT Dept.dept_no 
    FROM Dept
    WHERE Dept.loc = 'Chennai'
);

-- 11) Get Employee Name and gross salary (sal + comission) .
SELECT ename , (sal +commission) as Gross_Salary
FROM Emp ;


-- 12) Increase the data length of the column Ename of Emp table from  100 to 250 using ALTER statement
ALTER TABLE Emp
MODIFY COLUMN ename VARCHAR(250);

-- 13) Write query to get current datetime
SELECT CURRENT_TIMESTAMP();

-- 14) Write a statement to create STUDENT table, with related 5 columns
CREATE TABLE student(
    student_id INT PRIMARY KEY,
    sname VARCHAR(40),
    sclass INT,
    optional_1 VARCHAR(50),
    optional_2 VARCHAR(50)
);

-- 15) Write a query to fetch number of employees in who is getting salary more than 10000
SELECT * 
FROM Emp
WHERE Emp.sal >10000;

-- 16) Write a query to fetch minimum salary, maximum salary and average salary from emp table.
SELECT  MIN(sal) , MAX(sal) ,AVG(sal) 
FROM Emp;

--17) Write a query to fetch number of employees in each location

SELECT D.dname , COUNT(D.dept_no) 
FROM Emp E , Dept D
WHERE E.dept_no = D.dept_no
GROUP BY D.dept_no;

-- 18) Write a query to display emplyee names in descending order

SELECT *
FROM Emp
ORDER BY ename DESC;


--19) Write a statement to create a new table(EMP_BKP) from the existing EMP table 
CREATE TABLE IF NOT EXISTS Emp_BKP LIKE Emp;
INSERT Emp_BKP
SELECT * FROM Emp;


--20) Write a query to fetch first 3 characters from employee name appended with salary.
SELECT CONCAT(SUBSTRING(ename , 1 , 3),CONVERT(Emp.sal , char)) as NameWithSalary
FROM Emp;


-- 21) Get the details of the employees whose name starts with S
SELECT *
FROM Emp
WHERE Emp.ename LIKE 'S%';


-- 22) Get the details of the employees who works in Bangalore location
SELECT E.empno , E.ename ,E.sal , E.hire_date,E.commission,D.loc
FROM Emp E , Dept D
WHERE E.dept_no = D.dept_no;

-- 23) Write the query to get the employee details whose name started within  any letter between  A and K
SELECT *
FROM Emp
WHERE Emp.ename LIKE 'A%' OR Emp.ename LIKE 'K%';

-- 24) Write a query in SQL to display the employees whose manager name is Stefen 

SELECT E1.empno , E1.ename , E1.sal , E1.hire_date , E1.commission,E1.dept_no ,E1.mgr
FROM Emp E1 , Emp E2
WHERE E1.mgr = E2.empno AND E2.ename ='Stefen'; 

-- 25) Write a query in SQL to list the name of the managers who is having maximum number of employees working under him

SELECT E2.ename , COUNT(E1.empno)
FROM Emp E1 , Emp E2
WHERE E1.mgr = E2.empno
GROUP BY E2.empno 
ORDER BY COUNT(E1.empno) DESC
LIMIT 1; 

-- 26) Write a query to display the employee details, department details and the manager details of the employee who has second highest salary

SELECT Emp.empno , Emp.ename , Emp.sal , Emp.hire_date ,Emp.commission,  Emp.dept_no , Dept.dname , Dept.loc, E1.ename as MgrName 
FROM Emp 
LEFT JOIN Emp E1
ON Emp.mgr = E1.empno
LEFT JOIN Dept
ON Dept.dept_no = Emp.dept_no
WHERE Emp.sal = (
    SELECT Emp.sal
    FROM Emp
    GROUP BY Emp.sal 
    ORDER BY Emp.sal DESC
    LIMIT 1,1
);


--27) Write a query to list all details of all the managers

SELECT Emp.empno , Emp.ename , Emp.sal , Emp.hire_date , Emp.commission  , Emp.dept_no  , Dept.dname , Dept.loc
FROM Emp 
LEFT JOIN Dept 
ON Dept.dept_no  =  Emp.dept_no 
WHERE Emp.empno IN (
    SELECT Emp.mgr 
    FROM Emp
    GROUP BY Emp.mgr
);

-- 28) Write a query to list the details and total experience of all the managers
SELECT Emp.empno , Emp.ename , Emp.sal , Emp.hire_date , Emp.commission  , Emp.dept_no  , Dept.dname , Dept.loc ,  FLOOR(DATEDIFF(NOW() , Emp.hire_date )/365) as 'Experience(Years)'
FROM Emp 
LEFT JOIN Dept 
ON Dept.dept_no  =  Emp.dept_no 
WHERE Emp.empno IN (
    SELECT Emp.mgr 
    FROM Emp
    GROUP BY Emp.mgr
);


-- 29) Write a query to list the employees who is manager and  takes commission less than 1000 and works in Delhi
SELECT * 
FROM Emp 
WHERE Emp.empno IN (
    SELECT Emp.mgr
    FROM Emp 
) 
AND Emp.commission<1000;

-- 30) Write a query to display the details of employees who are senior to Martin 

SELECT * 
FROM Emp
WHERE FLOOR(DATEDIFF(NOW() , Emp.hire_date)) > FLOOR(DATEDIFF(NOW(), (SELECT Emp.hire_date FROM Emp WHERE Emp.empno = 1007)));

