# 实验四：SQL 语言的 DDL（数据定义语言）

## 实验目的

- 掌握 `CREATE TABLE` / `DROP TABLE` 创建和删除表
- 掌握 `ALTER TABLE` 修改表结构（添加字段）
- 掌握 `CREATE VIEW` / `DROP VIEW` 创建和删除视图
- 掌握 `CREATE INDEX` / `DROP INDEX` 创建和删除索引

## 实验环境

| 项目 | 配置 |
|------|------|
| 操作系统 | macOS 15（ARM64） |
| 数据库 | MySQL Community Server 9.7.0 LTS |
| 管理工具 | MySQL Workbench 8.0 |

## 实验任务与过程

**任务1：创建表 aa**

```sql
CREATE TABLE aa (
    Aa1 VARCHAR(20),
    Aa2 INT,
    Aa3 DECIMAL(10, 2)
);
```

![建表aa及查看结构](../实验四%20SQL语言的DDL/img/01-建表aa及查看结构.png)

**任务2：创建表 bb**

```sql
CREATE TABLE bb (
    Bb1 VARCHAR(30),
    Bb2 INT,
    Bb3 DECIMAL(6, 2)
);
```

![建表bb及查看结构](../实验四%20SQL语言的DDL/img/03-建表bb及查看结构.png)

**任务3：删除表 aa**

```sql
DROP TABLE IF EXISTS aa;
SHOW TABLES;  -- 确认仅剩 bb, customer, student
```

![删表aa及查看所有表](../实验四%20SQL语言的DDL/img/05-删表aa及查看所有表.png)

**任务4：修改表 bb，添加字段 Bb4 (VARCHAR 20)**

```sql
ALTER TABLE bb ADD Bb4 VARCHAR(20);
DESC bb;
```

![修改表bb添加字段](../实验四%20SQL语言的DDL/img/07-修改表bb添加字段.png)

**任务5：创建视图 Viewbb（字段 Viewbb1, Viewbb2 对应 Bb1, Bb4）**

```sql
CREATE VIEW Viewbb (Viewbb1, Viewbb2) AS
SELECT Bb1, Bb4 FROM bb;
SHOW FULL TABLES WHERE Table_type = 'VIEW';
```

![创建视图Viewbb](../实验四%20SQL语言的DDL/img/09-创建视图Viewbb.png)

**任务6：删除视图 Viewbb**

```sql
DROP VIEW IF EXISTS Viewbb;
```

**任务7：创建升序索引 Indexbb（Bb3 字段）**

```sql
CREATE INDEX Indexbb ON bb(Bb3 ASC);
SHOW INDEX FROM bb;
```

![删除视图及创建索引](../实验四%20SQL语言的DDL/img/11-删除视图及创建索引.png)

**任务8：删除索引 Indexbb**

```sql
DROP INDEX Indexbb ON bb;
SHOW INDEX FROM bb;
```

![删除索引Indexbb](../实验四%20SQL语言的DDL/img/13-删除索引Indexbb.png)

## 实验结果

| 操作 | 语句 | 结果 |
|------|------|------|
| 建表 aa | `CREATE TABLE aa (...)` | DESC 显示 3 字段 |
| 建表 bb | `CREATE TABLE bb (...)` | DESC 显示 3 字段 |
| 删表 aa | `DROP TABLE aa` | SHOW TABLES 仅含 bb, customer, student |
| 修改表 | `ALTER TABLE bb ADD Bb4` | DESC bb 显示 4 字段 |
| 建视图 | `CREATE VIEW Viewbb ...` | SHOW FULL TABLES 确认 Viewbb (VIEW) |
| 删视图 | `DROP VIEW Viewbb` | 成功 |
| 建索引 | `CREATE INDEX Indexbb ON bb(Bb3 ASC)` | BTREE 索引，Non_unique=1 |
| 删索引 | `DROP INDEX Indexbb ON bb` | SHOW INDEX 返回空 |

全部 8 项 DDL 操作均执行成功，验证符合预期。
