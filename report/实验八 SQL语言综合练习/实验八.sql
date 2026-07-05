-- ============================================
-- 实验八：SQL 语言综合练习
-- ============================================

USE Demo;

-- 1. 建表 Exam
DROP TABLE IF EXISTS Exam;
CREATE TABLE Exam (
    id       VARCHAR(17) PRIMARY KEY,
    name     VARCHAR(10),
    sex      VARCHAR(2),
    age      INT,
    score    DECIMAL(6, 2),
    address  VARCHAR(50),
    memo     VARCHAR(100)
);

-- 2. 插入 6 条记录
INSERT INTO Exam VALUES
('A0001', '赵一', '男', 20, 580.00, '重邮宿舍12-3-5', '学习委员'),
('B0002', '钱二', '女', 19, 540.00, '南福苑5-2-9', '班长'),
('C0003', '孙三', '男', 21, 555.50, '学生新区21-5-15', '优秀共青团员'),
('D0004', '李四', '男', 22, 480.00, '重邮宿舍8-2-22', '暂无相关信息'),
('E0005', '周五', '女', 20, 495.50, '学生新区23-4-8', '暂无相关信息'),
('F0006', '吴六', '男', 19, 435.00, '南福苑2-5-12', '暂无相关信息');
SELECT * FROM Exam;

-- 3. 对 Score 字段建立升序索引 IndexScore
CREATE INDEX IndexScore ON Exam(Score ASC);
SHOW INDEX FROM Exam;

-- 4. 建立视图 ViewExam，字段对应 Exam 的 Name 和 Address
DROP VIEW IF EXISTS ViewExam;
CREATE VIEW ViewExam (ViewExam1, ViewExam2) AS
SELECT name, address FROM Exam;
SELECT * FROM ViewExam;

-- ============================================
-- 5. 模拟 jm / zjm / dhshow 三张表
-- 原实验需执行 jm.sql / zjm.sql / dhshow.sql，因缺失，根据文档结构模拟数据
-- ============================================

DROP TABLE IF EXISTS dhshow;
DROP TABLE IF EXISTS zjm;
DROP TABLE IF EXISTS jm;

SET FOREIGN_KEY_CHECKS = 0;

-- 局名表
CREATE TABLE jm (
    Jmbm  VARCHAR(10) PRIMARY KEY,
    Jmhz  VARCHAR(30),
    Jmbz  VARCHAR(10)
);

-- 子局名表（关联 jm）
CREATE TABLE zjm (
    Zjmbm VARCHAR(10) PRIMARY KEY,
    Zjmhz VARCHAR(30),
    Jmbm  VARCHAR(10),
    Zjmbz VARCHAR(10)
);

-- 电话话费表（关联 zjm）
CREATE TABLE dhshow (
    Dhh  VARCHAR(15) PRIMARY KEY,
    Sl1  DECIMAL(10, 2),
    Sl3  DECIMAL(10, 2),
    Sl39 VARCHAR(10),
    Sl40 VARCHAR(10)
);

INSERT INTO jm VALUES
('0891', '拉萨',   'LS'),
('0897', '阿里',   'AL'),
('0892', '日喀则', 'RKZ');

INSERT INTO zjm VALUES
('LS01', '拉萨城关',   '0891', 'LSCG'),
('LS02', '拉萨堆龙',   '0891', 'LSDL'),
('AL01', '阿里狮泉河', '0897', 'ALSQH'),
('RK01', '日喀则市',   '0892', 'RKZS');

INSERT INTO dhshow VALUES
('0891-6000001', 50.00,  800.00, '0891', 'LS01'),
('0891-6000002',  0.00, 1500.00, '0891', 'LS01'),
('0891-6000003', 30.00,  300.00, '0891', 'LSDL'),
('0897-7000001', 80.00, 1200.00, '0897', 'AL01'),
('0897-7000002',  0.00,  500.00, '0897', 'AL01'),
('0897-7000003', 45.00,  800.00, '0897', 'AL01'),
('0892-5000001', 20.00,  600.00, '0892', 'RK01');

-- 6. 查询：拉萨地区长话消费平均是多少分人民币
SELECT j.Jmhz AS 地区,
       ROUND(AVG(d.Sl1) * 100, 0) AS 长话平均消费_分
FROM dhshow d
JOIN zjm z ON d.Sl40 = z.Zjmbm
JOIN jm  j ON z.Jmbm  = j.Jmbm
WHERE j.Jmhz = '拉萨'
GROUP BY j.Jmhz;

-- 7. 查询：阿里地区市话消费总大于 10 元且长话消费不为零的电话号码
SELECT d.Dhh AS 电话号码,
       d.Sl3 / 100 AS 市话消费_元,
       d.Sl1 / 100 AS 长话消费_元
FROM dhshow d
JOIN zjm z ON d.Sl40 = z.Zjmbm
JOIN jm  j ON z.Jmbm  = j.Jmbm
WHERE j.Jmhz = '阿里'
  AND d.Sl3 / 100 > 10
  AND d.Sl1 > 0;
