DROP DATABASE IF EXISTS 2021_sql;
CREATE DATABASE 2021_sql;

USE 2021_sql;

-- 1. 创建部门表 dept
CREATE TABLE dept (
    deptno INT,
    dname VARCHAR(20),
    loc VARCHAR(50)
);

-- 2. 创建员工表 emp
CREATE TABLE emp (
    empno INT,
    ename VARCHAR(20),
    job VARCHAR(20),
    mgr INT,
    hiredate DATE,
    sal DECIMAL(10,2),
    comm DECIMAL(10,2),
    deptno INT
);

-- 3. 插入部门数据
INSERT INTO dept (deptno, dname, loc) VALUES
(10, 'Accounting', 'New York'),
(20, 'Research', 'Dallas'),
(30, 'Sales', 'Chicago'),
(40, 'Operations', 'Boston');

-- 4. 插入员工数据
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1980-12-01', 3000, NULL, 20),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20),
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 30),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 30),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300, NULL, 10);


ALTER TABLE emp ADD CONSTRAINT ck_hd check(hiredate < '2021-07-08');
ALTER TABLE emp ADD CONSTRAINT ck_sal check(sal >= 0);

ALTER TABLE dept ADD CONSTRAINT uk_deptno UNIQUE(deptno);
ALTER TABLE emp ADD CONSTRAINT fk_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno);


SELECT e.empno, e.ename, e.sal
FROM emp e
WHERE e.sal > (
    SELECT sal 
    FROM emp 
    WHERE emp.empno = e.mgr
);


SELECT e.empno, e.ename
FROM emp e
WHERE e.deptno IN (
    SELECT deptno
    FROM emp 
    GROUP BY deptno
    HAVING COUNT(*) >= ALL(
        SELECT COUNT(*) cnt
        FROM emp
        GROUP BY deptno
    )
);

CREATE VIEW empv(eid, ename, salary) AS
SELECT empno, ename, sal
FROM emp 
WHERE (sal BETWEEN 4000 AND 9000) AND deptno IN (
    SELECT deptno FROM dept WHERE dname = 'CS'
) AND ename LIKE '张%';



