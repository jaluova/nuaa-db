-- Active: 1782914094366@@127.0.0.1@3306
-- ============================================================
-- 2020 SQL 练习题：建库 + 造数据
-- 基于 emp/dept 关系模式（Oracle SCOTT 风格，MySQL 版本）
-- ============================================================

DROP DATABASE IF EXISTS 2020_sql;
CREATE DATABASE 2020_sql;
USE 2020_sql;

-- -----------------------------
-- 1. 建表
-- -----------------------------
CREATE TABLE dept (
    deptno INT PRIMARY KEY,
    dname  VARCHAR(20),
    loc    VARCHAR(20)
);

CREATE TABLE emp (
    empno    INT PRIMARY KEY,
    ename    VARCHAR(20),
    job      VARCHAR(20),
    mgr      INT,
    hiredate DATE,
    sal      DECIMAL(10, 2),
    comm     DECIMAL(10, 2),
    deptno   INT,
    FOREIGN KEY (deptno) REFERENCES dept(deptno)
);

-- mgr 自引用外键（所有雇员已插入后再加）
-- ALTER TABLE emp ADD FOREIGN KEY (mgr) REFERENCES emp(empno);

-- -----------------------------
-- 2. 插入部门
-- -----------------------------
INSERT INTO dept VALUES
(10, 'ACCOUNTING', 'NEW YORK'),
(20, 'RESEARCH',   'DALLAS'),
(30, 'SALES',      'CHICAGO'),
(40, 'OPERATIONS', 'BOSTON');

-- -----------------------------
-- 3. 插入雇员（按层级顺序，保证 mgr 引用的行先存在）
-- -----------------------------

-- 第一层：无经理
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7839, 'KING',  'PRESIDENT', NULL, '2011-11-17', 5000, NULL, 10);

-- 第二层：直属 KING
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7566, 'JONES', 'MANAGER', 7839, '2014-04-02', 4500, NULL, 20),
(7698, 'BLAKE', 'MANAGER', 7839, '2014-05-01', 4200, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '2014-06-09', 4000, NULL, 10);

-- 第三层：直属经理
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7902, 'FORD',   'ANALYST',  7566, '2017-12-03', 4200, NULL,  20),
(7788, 'SCOTT',  'ANALYST',  7566, '2018-04-19', 5000, NULL,  20),  -- 比经理 JONES(4500) 高
(7499, 'ALLEN',  'SALESMAN', 7698, '2016-02-20', 3500, 300,   30),
(7521, 'WARD',   'SALESMAN', 7698, '2016-02-22', 3500, 500,   30),
(7654, 'MARTIN', 'SALESMAN', 7698, '2016-09-28', 3500, 1400,  30),
(7844, 'TURNER', 'SALESMAN', 7698, '2019-09-08', 3200, 0,     30),
(7900, 'JAMES',  'CLERK',    7698, '2017-12-03', 2800, NULL,  30),
(7934, 'MILLER', 'CLERK',    7782, '2018-01-23', 3000, NULL,  10);

-- 第四层：底层职员
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '2021-12-17', 2200, NULL, 20),
(7876, 'ADAMS', 'CLERK', 7788, '2020-05-23', 2500, NULL, 20);

-- -----------------------------
-- 4. 数据验证
-- -----------------------------
SELECT '=== dept ===' AS info;
SELECT * FROM dept;

SELECT '=== emp ===' AS info;
SELECT * FROM emp ORDER BY deptno, empno;

SELECT '=== 各部门人数 ===' AS info;
SELECT d.deptno, d.dname, COUNT(e.empno) AS cnt
FROM dept d LEFT JOIN emp e ON d.deptno = e.deptno
GROUP BY d.deptno, d.dname
ORDER BY cnt DESC;



SELECT * FROM emp;


SELECT e.empno, e.ename
FROM emp e
JOIN dept d ON d.deptno = e.deptno
WHERE d.dname = 'ACCOUNTING';


SELECT e.empno, e.ename
FROM emp e
WHERE e.hiredate < (
    SELECT hiredate
    FROM emp
    WHERE ename = 'FORD'
);

SELECT e.empno, e.ename, e.sal
FROM emp e
JOIN emp mg ON mg.empno = e.mgr
WHERE e.sal > mg.sal;

SELECT d.deptno, d.dname
FROM dept d
WHERE d.deptno IN (
    SELECT MAX(cnt) 
    FROM (
        SELECT COUNT(*) cnt
        FROM emp
        GROUP BY deptno
    ) t
);

SELECT MAX(cnt) 
FROM (
    SELECT COUNT(*) cnt
    FROM emp
    GROUP BY deptno
) t;

SELECT COUNT(*) cnt
    FROM emp
    GROUP BY deptno;

DROP VIEW IF EXISTS empv;
CREATE VIEW empv(empno, ename, salary) AS
SELECT e.empno, e.ename, e.sal
FROM emp e
JOIN dept d ON e.deptno = d.deptno
WHERE d.dname = 'ACCOUNTING';

UPDATE emp e
SET e.sal = e.sal + 1500
WHERE e.deptno = (
    SELECT deptno
    FROM dept
    WHERE dname = 'ACCOUNTING'
);
