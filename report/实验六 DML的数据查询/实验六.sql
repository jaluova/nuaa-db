-- ============================================
-- 实验六：DML 的数据查询
-- ============================================

USE Demo;

-- 1. 建表 Student
DROP TABLE IF EXISTS Choose;
DROP TABLE IF EXISTS Course;
DROP TABLE IF EXISTS Student;
CREATE TABLE Student (
    ID         VARCHAR(20) PRIMARY KEY,
    Name       VARCHAR(10),
    Age        INT,
    Department VARCHAR(30)
);

-- 2. 建表 Course
CREATE TABLE Course (
    CourseID     VARCHAR(15) PRIMARY KEY,
    CourseName   VARCHAR(30),
    CourseBefore VARCHAR(15)
);

-- 3. 建表 Choose
CREATE TABLE Choose (
    ID       VARCHAR(20),
    CourseID VARCHAR(30),
    Score    DECIMAL(5, 2),
    PRIMARY KEY (ID, CourseID)
);

-- 4. 插入 Student 记录
INSERT INTO Student VALUES
('00001', '张三', 20, '计算机系'),
('00002', '李四', 19, '计算机系'),
('00003', '王五', 21, '计算机系');
SELECT * FROM Student;

-- 5. 插入 Course 记录
INSERT INTO Course VALUES
('C1', '计算机引论', NULL),
('C2', 'PASCAL语言', 'C1'),
('C3', '数据结构',   'C2');
SELECT * FROM Course;

-- 6. 插入 Choose 记录
INSERT INTO Choose VALUES
('00001', 'C1', 95),
('00001', 'C2', 80),
('00001', 'C3', 84),
('00002', 'C1', 80),
('00002', 'C2', 85),
('00003', 'C1', 78),
('00003', 'C3', 70);
SELECT * FROM Choose;

-- 7. 简单查询：计算机系学生的学号和姓名
SELECT ID AS 学号, Name AS 姓名
FROM Student
WHERE Department = '计算机系';

-- 8. 连接查询：学生的学号、姓名、选的课程名及成绩
SELECT S.ID AS 学号, S.Name AS 姓名, C.CourseName AS 课程名, CH.Score AS 成绩
FROM Student S
JOIN Choose CH ON S.ID = CH.ID
JOIN Course C ON CH.CourseID = C.CourseID;

-- 9. 嵌套查询：C1课程的成绩低于张三的学生的学号和成绩
SELECT ID AS 学号, Score AS 成绩
FROM Choose
WHERE CourseID = 'C1'
  AND Score < (SELECT Score FROM Choose WHERE CourseID = 'C1' AND ID = '00001');

-- 10. 组合查询：选了C2课程且也选了C3课程的学生的学号
SELECT DISTINCT a.ID AS 学号
  FROM Choose a JOIN Choose b ON a.ID = b.ID
  WHERE a.CourseID = 'C2' AND b.CourseID = 'C3';
