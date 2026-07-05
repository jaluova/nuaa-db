-- ============================================
-- 实验五：SQL 语言的 DML 初步
-- ============================================

USE Demo;

-- 1. 建表 cc
DROP TABLE IF EXISTS cc;
CREATE TABLE cc (
    Cc1 VARCHAR(20),
    Cc2 INT,
    Cc3 DECIMAL(10, 2),
    Cc4 VARCHAR(60)
);
DESC cc;

-- 2. 插入 6 条记录
INSERT INTO cc VALUES
('赵一', 20, 580.00, '重邮宿舍12-3-5'),
('钱二', 19, 540.00, '南福苑5-2-9'),
('孙三', 21, 555.50, '学生新区21-5-15'),
('李四', 22, 480.00, '重邮宿舍8-2-22'),
('周五', 20, 495.50, '学生新区23-4-8'),
('吴六', 19, 435.00, '南福苑2-5-12');

SELECT * FROM cc;

-- 3. 更新：cc2 <= 20 的记录，cc3 加 5
UPDATE cc SET Cc3 = Cc3 + 5 WHERE Cc2 <= 20;
SELECT * FROM cc;

-- 4. 删除：cc2 >= 20 且 cc3 >= 500 的记录
DELETE FROM cc WHERE Cc2 >= 20 AND Cc3 >= 500;
SELECT * FROM cc;
