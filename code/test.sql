DROP DATABASE IF EXISTS test_sql;
CREATE DATABASE test_sql;

USE test_sql;

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
(10, 'IT', 'Beijing'),
(20, 'Business', 'Shanghai'),
(30, 'Sales', 'Guangzhou'),
(40, 'HR', 'Shenzhen');

-- 4. 插入员工数据
INSERT INTO emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
-- 总经理（无归属部门，不参与部门人数统计，mgr 为空用于外键测试）
(9001, '周总', '总经理', NULL, '2000-01-01', 20000, NULL, NULL),
(1001, '李经理', '部门经理', 9001, '2005-03-15', 5000, NULL, 10),
(1002, '张开发', '程序员', 1001, '2010-06-01', 2800, NULL, 10),
(1003, '王开发', '程序员', 1001, '2011-08-15', 2500, NULL, 10),
(1004, '赵运维', '运维工程师', 1001, '2012-04-20', 3500, NULL, 10),
(2001, '王经理', '部门经理', 9001, '2006-05-20', 6000, NULL, 20),
(2002, '孙商务', '商务专员', 2001, '2013-02-10', 3000, NULL, 20),
(2003, '周商务', '商务专员', 2001, '2014-07-08', 3500, NULL, 20),
(2004, '吴主管', '商务主管', 2001, '2009-11-20', 4500, NULL, 20),
(3001, '刘经理', '部门经理', 9001, '2004-07-10', 9000, 2000, 30),
(3002, '刘一', '销售代表', 3001, '2015-03-01', 7000, 1000, 30),
(3003, '张三', '销售代表', 3001, '2016-05-12', 4500, 800, 30),
(3004, '李四', '销售代表', 3001, '2017-08-23', 8000, 1500, 30),
(3005, '王五', '销售代表', 3001, '2018-01-15', 5500, 600, 30),
(3006, '赵六', '销售代表', 3001, '2019-09-09', 6500, 1200, 30),
(4001, '孙经理', '部门经理', 9001, '2007-09-01', 4000, NULL, 40),
(4002, '钱人事', '人事专员', 4001, '2020-04-05', 2800, NULL, 40);


ALTER TABLE emp ADD CONSTRAINT uk_empno UNIQUE(empno);
ALTER TABLE dept ADD CONSTRAINT uk_dname UNIQUE(dname);
ALTER TABLE emp ADD CONSTRAINT fk_mgr FOREIGN KEY(mgr) REFERENCES emp(empno);
ALTER TABLE emp ADD CONSTRAINT ck_sal CHECK(sal >= 0 AND sal <= 100000);

SELECT e.*
FROM emp e
JOIN dept d ON d.deptno = e.deptno
WHERE d.dname = 'IT' AND e.sal < 3000;

SELECT e.*
FROM emp e 
WHERE e.sal > ALL(
    SELECT sal 
    FROM emp
    JOIN dept d ON d.deptno = emp.deptno
    WHERE d.dname IN ('IT', 'Business')
);



SELECT e.ename, e.sal, e.empno
FROM emp e
WHERE deptno IN (
    SELECT deptno
    FROM emp 
    GROUP BY deptno 
    HAVING COUNT(*) = (
        SELECT MAX(cnt)
        FROM (
            SELECT COUNT(*) cnt
            FROM emp
            GROUP BY deptno
        ) t
    )
) AND e.ename LIKE "刘%";


CREATE VIEW dSal(deptno, avgSal) AS
SELECT deptno, AVG(sal)
FROM emp
GROUP BY deptno;

SELECT e.* 
FROM emp e
JOIN dSal ON dSal.deptno = e.deptno
WHERE e.sal > dSal.avgSal;


SELECT deptno, COUNT(*) 员工人数, AVG(sal) 平均工资, MAX(sal) 最高工资, MIN(sal) 最低工资
FROM emp e
GROUP BY deptno
ORDER BY 平均工资 DESC;
