-- ============================================
-- 实验七：SQL 语言的 DCL
-- ============================================

-- Part 1: root 执行 — 创建用户并授权
DROP USER IF EXISTS 'dcl'@'localhost';
CREATE USER 'dcl'@'localhost' IDENTIFIED BY 'dcl';
GRANT ALL PRIVILEGES ON *.* TO 'dcl'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'dcl'@'localhost';

-- Part 2: 切换到 dcl 用户（Workbench 新建连接）执行
CREATE DATABASE IF NOT EXISTS DCLDemo CHARACTER SET utf8mb4;
USE DCLDemo;
CREATE TABLE Abc (
    A1 VARCHAR(20),
    B2 DECIMAL(4, 2),
    C3 INT
);
INSERT INTO Abc VALUES ('DCL测试', 90.5, 30);
SELECT * FROM Abc;

-- Part 3: 切回 root 执行 — 收回 A1 列的 UPDATE 权限
REVOKE ALL, GRANT OPTION FROM 'dcl'@'localhost';
GRANT CREATE, DROP ON DCLDemo.* TO 'dcl'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE (B2, C3) ON DCLDemo.Abc TO 'dcl'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'dcl'@'localhost';
