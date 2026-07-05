# 实验七：SQL 语言的 DCL（数据控制语言）

## 实验目的

- 掌握 `CREATE USER` 创建数据库用户
- 掌握 `GRANT` 授予权限（全局权限 + 表级 + 列级）
- 掌握 `REVOKE` 收回权限
- 理解列级权限的精确配置与验证

## 实验环境

| 项目 | 配置 |
|------|------|
| 操作系统 | macOS 15（ARM64） |
| 数据库 | MySQL Community Server 9.7.0 LTS |
| 管理工具 | MySQL Workbench 8.0（root + dcl 双连接） |

## 实验任务与过程

**任务1：root 创建用户 dcl 并授予全部权限**

```sql
-- root 连接执行
DROP USER IF EXISTS 'dcl'@'localhost';
CREATE USER 'dcl'@'localhost' IDENTIFIED BY 'dcl';
GRANT ALL PRIVILEGES ON *.* TO 'dcl'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'dcl'@'localhost';
```

![root创建用户并授权](../实验七%20SQL语言的DCL/img/01-root创建用户并授权.png)

![全局权限验证](../实验七%20SQL语言的DCL/img/02-全局权限验证.png)

**任务2：dcl 用户建库、建表、插入数据**

```sql
-- dcl 连接执行
CREATE DATABASE IF NOT EXISTS DCLDemo CHARACTER SET utf8mb4;
USE DCLDemo;
CREATE TABLE Abc (
    A1 VARCHAR(20),
    B2 DECIMAL(4, 2),
    C3 INT
);
INSERT INTO Abc VALUES ('DCL测试', 90.5, 30);
SELECT * FROM Abc;
```

![dcl建库建表插入数据](../实验七%20SQL语言的DCL/img/03-dcl建库建表插入数据.png)

**任务3：root 收回 dcl 全局权限，细粒度授权（排除 A1 列 UPDATE）**

```sql
-- root 连接执行
REVOKE ALL, GRANT OPTION FROM 'dcl'@'localhost';
GRANT CREATE, DROP ON DCLDemo.* TO 'dcl'@'localhost';
GRANT SELECT, INSERT, DELETE, UPDATE (B2, C3) ON DCLDemo.Abc TO 'dcl'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'dcl'@'localhost';
```

![root收回权限并细粒度授权](../实验七%20SQL语言的DCL/img/05-root收回权限并细粒度授权.png)

![细粒度权限验证](../实验七%20SQL语言的DCL/img/06-细粒度权限验证.png)

**任务4：dcl 验证列级权限**

```sql
-- 以下语句应失败（A1 列无 UPDATE 权限）
UPDATE Abc SET A1 = '修改' WHERE C3 = 30;  -- ERROR 1142

-- 以下语句应成功（B2 列在授权范围内）
UPDATE Abc SET B2 = 88.8 WHERE C3 = 30;    -- 执行成功
```

## 实验结果

| 操作 | 执行者 | 结果 |
|------|--------|------|
| CREATE USER 'dcl'@'localhost' | root | 成功创建 |
| GRANT ALL PRIVILEGES ON *.* | root | dcl 获得全局权限（含 WITH GRANT OPTION） |
| CREATE DATABASE DCLDemo + CREATE TABLE Abc + INSERT | dcl | 全部成功 |
| REVOKE ALL, GRANT OPTION FROM | root | 全局权限已收回 |
| GRANT UPDATE (B2, C3) ON Abc | root | dcl 仅能 UPDATE B2 和 C3 列 |
| UPDATE Abc SET A1 = '修改' | dcl | **失败**（ERROR 1142，列级权限生效） |
| UPDATE Abc SET B2 = 88.8 | dcl | **成功**（B2 在授权列范围内） |

MySQL 通过 `GRANT UPDATE (列1, 列2)` 语法实现列级细粒度权限控制，未被列出的列自动排除在 UPDATE 权限之外。
