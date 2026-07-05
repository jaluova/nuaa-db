-- ============================================
-- 实验四：SQL 语言的 DDL
-- ============================================

USE Demo;

-- 1. 建表 aa
DROP TABLE IF EXISTS aa;
CREATE TABLE aa (
    Aa1 VARCHAR(20),
    Aa2 INT,
    Aa3 DECIMAL(10, 2)
);
DESC aa;

-- 2. 建表 bb
DROP TABLE IF EXISTS bb;
CREATE TABLE bb (
    Bb1 VARCHAR(30),
    Bb2 INT,
    Bb3 DECIMAL(6, 2)
);
DESC bb;

-- 3. 删除表 aa
DROP TABLE IF EXISTS aa;
SHOW TABLES;

-- 4. 修改表 bb，添加字段 Bb4
ALTER TABLE bb ADD Bb4 VARCHAR(20);
DESC bb;

-- 5. 对表 bb 的 Bb1 和 Bb4 建立视图 Viewbb
DROP VIEW IF EXISTS Viewbb;
CREATE VIEW Viewbb (Viewbb1, Viewbb2) AS
SELECT Bb1, Bb4 FROM bb;
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- 6. 删除视图 Viewbb
DROP VIEW IF EXISTS Viewbb;

-- 7. 对表 bb 的 Bb3 字段建立升序索引 Indexbb
CREATE INDEX Indexbb ON bb(Bb3 ASC);
SHOW INDEX FROM bb;

-- 8. 删除索引 Indexbb
DROP INDEX Indexbb ON bb;
SHOW INDEX FROM bb;
