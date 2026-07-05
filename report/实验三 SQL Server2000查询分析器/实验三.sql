-- ============================================
-- 实验三：SQL 基本操作 —— 建表、插入、查询
-- ============================================

USE Demo;

-- 1. 建表 student
DROP TABLE IF EXISTS student;
CREATE TABLE student (
    id       VARCHAR(17) PRIMARY KEY,
    name     VARCHAR(10),
    sex      VARCHAR(2),
    age      INT,
    score    DECIMAL(6, 2),
    Joindate DATE
);

-- 验证表结构
DESC student;

-- 2. 插入 6 条记录
INSERT INTO student VALUES
('A0001', '赵一', '男', 20, 580.00, '2020-09-01'),
('B0002', '钱二', '女', 19, 540.00, '2021-09-01'),
('C0003', '孙三', '男', 21, 555.50, '2020-08-30'),
('D0004', '李四', '男', 22, 480.00, '2021-09-02'),
('E0005', '周五', '女', 20, 495.50, '2022-07-30'),
('F0006', '吴六', '男', 19, 435.00, '2021-09-01');

-- 验证插入
SELECT * FROM student;

-- 3. 查询：年龄 >= 20 且成绩 < 500
SELECT * FROM student
WHERE age >= 20 AND score < 500;

-- 4. 统计各入学年级人数
SELECT Joindate AS 入学年级, COUNT(*) AS 人数
FROM student
GROUP BY Joindate;
