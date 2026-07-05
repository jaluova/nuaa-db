# 实验六：DML 的数据查询（简单查询、连接查询、嵌套查询、组合查询）

## 实验目的

- 掌握**简单查询**：单表 + WHERE 条件过滤
- 掌握**连接查询**：JOIN ... ON 多表关联
- 掌握**嵌套查询**：子查询作为条件值
- 掌握**组合查询**：集合交运算（MySQL 中用自连接替代 INTERSECT）

## 实验环境

| 项目 | 配置 |
|------|------|
| 操作系统 | macOS 15（ARM64） |
| 数据库 | MySQL Community Server 9.7.0 LTS |
| 管理工具 | MySQL Workbench 8.0 |

## 实验任务与过程

**建表与插入数据：**

```sql
-- Student 表（学生）
CREATE TABLE Student (
    ID VARCHAR(10) PRIMARY KEY, Name VARCHAR(10),
    Age INT, Department VARCHAR(20)
);
INSERT INTO Student VALUES
('00001', '张三', 20, '计算机系'),
('00002', '李四', 19, '计算机系'),
('00003', '王五', 21, '计算机系');

-- Course 表（课程）
CREATE TABLE Course (
    CourseID VARCHAR(5) PRIMARY KEY, CourseName VARCHAR(20),
    CourseBefore VARCHAR(5)
);
INSERT INTO Course VALUES
('C1', '计算机引论', NULL),
('C2', 'PASCAL语言', 'C1'),
('C3', '数据结构',   'C2');

-- Choose 表（选课）
CREATE TABLE Choose (
    ID VARCHAR(10), CourseID VARCHAR(5), Score DECIMAL(5, 2)
);
INSERT INTO Choose VALUES
('00001','C1',95),('00001','C2',80),('00001','C3',84),
('00002','C1',80),('00002','C2',85),
('00003','C1',78),('00003','C3',70);
```

![建表及插入数据](../实验六%20DML的数据查询/img/01-建表及插入数据.png)

**查询1（简单查询）：计算机系学生的学号和姓名**

```sql
SELECT ID AS 学号, Name AS 姓名 FROM Student
WHERE Department = '计算机系';
```

![简单查询-计算机系学生](../实验六%20DML的数据查询/img/03-简单查询-计算机系学生.png)

| 学号 | 姓名 |
|------|------|
| 00001 | 张三 |
| 00002 | 李四 |
| 00003 | 王五 |

**查询2（连接查询）：学生的学号、姓名、所选课程名及成绩**

```sql
SELECT S.ID AS 学号, S.Name AS 姓名,
       C.CourseName AS 课程名, CH.Score AS 成绩
FROM Student S
JOIN Choose CH ON S.ID = CH.ID
JOIN Course C ON CH.CourseID = C.CourseID;
```

![连接查询-JOIN三表](../实验六%20DML的数据查询/img/05-连接查询-JOIN三表.png)

| 学号 | 姓名 | 课程名 | 成绩 |
|------|------|--------|------|
| 00001 | 张三 | 计算机引论 | 95.00 |
| 00001 | 张三 | PASCAL语言 | 80.00 |
| 00001 | 张三 | 数据结构 | 84.00 |
| 00002 | 李四 | 计算机引论 | 80.00 |
| 00002 | 李四 | PASCAL语言 | 85.00 |
| 00003 | 王五 | 计算机引论 | 78.00 |
| 00003 | 王五 | 数据结构 | 70.00 |

**查询3（嵌套查询）：C1 课程成绩低于张三的学生的学号和成绩**

```sql
SELECT ID AS 学号, Score AS 成绩 FROM Choose
WHERE CourseID = 'C1'
  AND Score < (SELECT Score FROM Choose
               WHERE CourseID = 'C1' AND ID = '00001');
```

![嵌套查询-子查询](../实验六%20DML的数据查询/img/07-嵌套查询-子查询.png)

| 学号 | 成绩 |
|------|------|
| 00002 | 80.00 |
| 00003 | 78.00 |

**查询4（组合查询）：选了 C2 且选了 C3 的学生的学号**

```sql
SELECT DISTINCT a.ID AS 学号
FROM Choose a JOIN Choose b ON a.ID = b.ID
WHERE a.CourseID = 'C2' AND b.CourseID = 'C3';
```

![组合查询-INTERSECT替代](../实验六%20DML的数据查询/img/09-组合查询-INTERSECT替代.png)

| 学号 |
|------|
| 00001 |

## 实验结果

| 查询类型 | 返回行数 | 说明 |
|---------|---------|------|
| 简单查询 | 3 行 | 计算机系全部学生 |
| 连接查询 | 7 行 | 姓名-课程-成绩正确关联 |
| 嵌套查询 | 2 行 | 李四(80)、王五(78) 低于张三(95) |
| 组合查询 | 1 行 | 仅张三同时选了 C2 和 C3 |
