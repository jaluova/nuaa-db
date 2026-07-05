# 实验八：SQL 语言综合练习

## 实验目的

- 综合复习 SQL 语言的 DDL、DML、DQL 操作
- 练习多表 JOIN 连接查询与聚合统计（AVG、GROUP BY）
- 初步了解小型数据库管理系统的需求分析与设计

## 实验环境

| 项目 | 配置 |
|------|------|
| 操作系统 | macOS 15（ARM64） |
| 数据库 | MySQL Community Server 9.7.0 LTS |
| 管理工具 | MySQL Workbench 8.0 |

## 实验任务与过程

**任务1：创建 Exam 表并插入 6 条记录**

```sql
USE Demo;
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

INSERT INTO Exam VALUES
('A0001', '赵一', '男', 20, 580.00, '重邮宿舍12-3-5', '学习委员'),
('B0002', '钱二', '女', 19, 540.00, '南福苑5-2-9', '班长'),
('C0003', '孙三', '男', 21, 555.50, '学生新区21-5-15', '优秀共青团员'),
('D0004', '李四', '男', 22, 480.00, '重邮宿舍8-2-22', '暂无相关信息'),
('E0005', '周五', '女', 20, 495.50, '学生新区23-4-8', '暂无相关信息'),
('F0006', '吴六', '男', 19, 435.00, '南福苑2-5-12', '暂无相关信息');
```

![建表Exam及插入数据](../实验八%20SQL语言综合练习/img/01-建表Exam及插入数据.png)

**任务2：创建升序索引 IndexScore（Score 字段）**

```sql
CREATE INDEX IndexScore ON Exam(Score ASC);
SHOW INDEX FROM Exam;
```

![创建索引IndexScore](../实验八%20SQL语言综合练习/img/03-创建索引IndexScore.png)

| Key_name | Column_name | Non_unique | Index_type |
|----------|-------------|-----------|------------|
| PRIMARY | id | 0 | BTREE |
| IndexScore | score | 1 | BTREE |

**任务3：创建视图 ViewExam（ViewExam1→name, ViewExam2→address）**

```sql
DROP VIEW IF EXISTS ViewExam;
CREATE VIEW ViewExam (ViewExam1, ViewExam2) AS
SELECT name, address FROM Exam;
SELECT * FROM ViewExam;
```

![创建视图ViewExam](../实验八%20SQL语言综合练习/img/05-创建视图ViewExam.png)

**任务4：电话局话费多表查询**

原实验所需 `jm.sql`/`zjm.sql`/`dhshow.sql` 文件缺失，根据任务文档中的表结构自行模拟三表及测试数据。

```sql
-- jm（局名表）：拉萨(0891)、阿里(0897)、日喀则(0892)
-- zjm（子局名表）：4 个子局，通过 Jmbm 关联 jm
-- dhshow（话费表）：7 条通话记录，Sl1 长话费、Sl3 市话费

-- 查询1：拉萨地区长话平均消费（分）
SELECT j.Jmhz AS 地区, ROUND(AVG(d.Sl1) * 100, 0) AS 长话平均消费_分
FROM dhshow d
JOIN zjm z ON d.Sl40 = z.Zjmbm
JOIN jm  j ON z.Jmbm  = j.Jmbm
WHERE j.Jmhz = '拉萨'
GROUP BY j.Jmhz;
```

![模拟三表及拉萨查询](../实验八%20SQL语言综合练习/img/07-模拟三表及拉萨查询.png)

| 地区 | 长话平均消费_分 |
|------|---------------|
| 拉萨 | 2500 |

```sql
-- 查询2：阿里地区市话消费 > 10 元且长话消费不为零的电话号码
SELECT d.Dhh AS 电话号码,
       d.Sl3 / 100 AS 市话消费_元,
       d.Sl1 / 100 AS 长话消费_元
FROM dhshow d
JOIN zjm z ON d.Sl40 = z.Zjmbm
JOIN jm  j ON z.Jmbm  = j.Jmbm
WHERE j.Jmhz = '阿里' AND d.Sl3 / 100 > 10 AND d.Sl1 > 0;
```

![阿里地区筛选查询](../实验八%20SQL语言综合练习/img/09-阿里地区筛选查询.png)

| 电话号码 | 市话消费_元 | 长话消费_元 |
|----------|-----------|-----------|
| 0897-7000001 | 12.00 | 0.80 |

**任务5：小型数据库管理系统设计（选题：学生选课成绩管理系统）**

- **需求分析**：学生信息管理、课程信息管理（含先行课约束）、选课与成绩录入、成绩统计查询、用户权限控制
- **ER 设计**：Student（学生）— 1:N — Choose（选课）— N:1 — Course（课程）
- **数据库实现**：DDL 建表 + 外键约束 + 索引优化 + 视图封装常用统计
- **核心功能**：CRUD 操作、成绩统计、先行课冲突检测

## 实验结果

| 操作 | 结果 |
|------|------|
| CREATE TABLE Exam | 7 字段，id 为主键 |
| INSERT 6 行 | 全部成功 |
| CREATE INDEX IndexScore | BTREE 索引，升序 |
| CREATE VIEW ViewExam | 返回 6 行（姓名+地址） |
| 拉萨长话平均消费 | 2500 分（25.00 元） |
| 阿里市话 >10 元且长话 >0 | 仅 0897-7000001 满足 |

## 八次实验 SQL 知识体系总结

| 实验 | 主题 | 核心知识点 |
|------|------|-----------|
| 实验一 | 安装与配置 | MySQL 安装、服务启停、Workbench 连接 |
| 实验二 | 建库建表 | CREATE DATABASE、CREATE TABLE |
| 实验三 | DML 初步 | INSERT、SELECT、WHERE、GROUP BY |
| 实验四 | DDL | CREATE/DROP TABLE、ALTER TABLE、CREATE/DROP VIEW、CREATE/DROP INDEX |
| 实验五 | DML 进阶 | INSERT、UPDATE SET WHERE、DELETE FROM WHERE |
| 实验六 | 数据查询 | 简单查询、连接查询、嵌套查询、组合查询 |
| 实验七 | DCL | CREATE USER、GRANT、REVOKE、列级权限控制 |
| 实验八 | 综合练习 | 综合 DDL+DML+DQL+索引+视图+多表连接+聚合统计 |
