# 模拟卷 C · 参考答案

---

## 一、关系代数计算题

**关系 R**
| A | B | C |
|:---:|:---:|:---:|
| 2 | 3 | 4 |
| 2 | 3 | 5 |
| 3 | 2 | 3 |
| 2 | 3 | 3 |
| 4 | 2 | 3 |

**关系 S**
| B | C | D |
|:---:|:---:|:---:|
| 3 | 3 | m |
| 3 | 5 | n |

**1. π_A,C(R)** — 去重：

| A | C |
|:---:|:---:|
| 2 | 4 |
| 2 | 5 |
| 3 | 3 |
| 2 | 3 |
| 4 | 3 |

**2. σ_B='3'(R)**

| A | B | C |
|:---:|:---:|:---:|
| 2 | 3 | 4 |
| 2 | 3 | 5 |
| 2 | 3 | 3 |

**3. R ⋈ S（自然连接）**

公共属性 B、C：

R(2,3,4) → S 中无 B=3,C=4 → 丢弃
R(2,3,5) 匹配 S(3,5,n) → (2,3,5,n)
R(3,2,3) → S 中无 B=2 → 丢弃
R(2,3,3) 匹配 S(3,3,m) → (2,3,3,m)
R(4,2,3) → S 中无 B=2 → 丢弃

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| 2 | 3 | 5 | n |
| 2 | 3 | 3 | m |

**4. R ÷ S**

S 在 (B,C) 上投影：{(3,3), (3,5)}

各 A 值的象集（去重）：
- A=2: {(3,4), (3,5), (3,3)} → 包含 S ✓
- A=3: {(2,3)} → 不包含 ✗
- A=4: {(2,3)} → 不包含 ✗

| A |
|:---:|
| 2 |

**5. R ⟕ S（左外连接）**

保留 R 全部元组，S 无匹配填 NULL：

R(2,3,4): S 中无 B=3,C=4 → (2,3,4,NULL)
R(2,3,5): S(3,5,n) → (2,3,5,n)
R(3,2,3): S 中无 B=2 → (3,2,3,NULL)
R(2,3,3): S(3,3,m) → (2,3,3,m)
R(4,2,3): S 中无 B=2 → (4,2,3,NULL)

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| 2 | 3 | 4 | NULL |
| 2 | 3 | 5 | n |
| 3 | 2 | 3 | NULL |
| 2 | 3 | 3 | m |
| 4 | 2 | 3 | NULL |

**与自然连接的区别**：自然连接（第 3 题）只有 2 行（丢弃了不匹配的），左外连接保留全部 5 行 R 的记录，不匹配的 D 填 NULL。

---

## 二、关系代数与关系演算

**1. 查询年龄不大于 20 岁的男学生的学号和姓名。**

关系代数：

$$\pi_{Sno, Sname}(\sigma_{Sage \le 20 \;\land\; Ssex='男'}(Student))$$

ALPHA 语言：

```
GET W(Student.Sno, Student.Sname):
    Student.Sage <= 20 ∧ Student.Ssex = '男'
```

**2. 查询既选修了"数据库原理"又选修了"操作系统"的学生的学号和姓名。**

> SQL 陷阱：不能 `WHERE Cname='数据库原理' AND Cname='操作系统'`。同一行 Cname 只能等于一个值。

关系代数（交集法）：

$$\pi_{Sno, Sname}(
  Student \bowtie
  (\pi_{Sno}(\sigma_{Cname='数据库原理'}(SC \bowtie Course))
   \cap
   \pi_{Sno}(\sigma_{Cname='操作系统'}(SC \bowtie Course)))
)$$

ALPHA 语言：

```
RANGE SC SCX
      Course CX
GET W(Student.Sno, Student.Sname):
    ∃ SCX ∃ CX (SCX.Sno = Student.Sno ∧ SCX.Cno = CX.Cno
              ∧ CX.Cname = '数据库原理')
  ∧ ∃ SCX ∃ CX (SCX.Sno = Student.Sno ∧ SCX.Cno = CX.Cno
              ∧ CX.Cname = '操作系统')
```

**3. 查询只选修了一门课程的学生的学号和姓名。**

关系代数：

$$\pi_{Sno, Sname}(
  Student \bowtie
  (\pi_{Sno}(SC) - \pi_{Sno}(
    \sigma_{SC1.Cno \ne SC2.Cno}(
      \rho_{SC1}(SC) \bowtie_{SC1.Sno=SC2.Sno} \rho_{SC2}(SC)
    )
  ))
)$$

或更简洁：

$$\pi_{Sno, Sname}(Student \bowtie
  (\pi_{Sno}(SC) - \pi_{Sno}(\sigma_{Cno1 \ne Cno2}(\rho_{SC1} \bowtie_{Sno} \rho_{SC2})))
)$$

> 思路：所有选课学生 - 选了 ≥2 门的学生 = 只选 1 门的学生。

ALPHA 语言：

```
RANGE SC SCX
      SC SCY
GET W(Student.Sno, Student.Sname):
    ∃ SCX (SCX.Sno = Student.Sno)
  ∧ ¬∃ SCX ∃ SCY (SCX.Sno = Student.Sno
                 ∧ SCY.Sno = Student.Sno
                 ∧ SCX.Cno ≠ SCY.Cno)
```

---

## 三、SQL 语言

**1. 查询比他/她的经理工资高且雇佣时间长的雇员的雇员号、雇员名以及工资。**

```sql
SELECT e1.empno, e1.ename, e1.sal
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno
  AND e1.sal > e2.sal
  AND e1.hiredate < e2.hiredate;
```

> hiredate 值越小 = 雇佣越早 = 雇佣时间越长。

**2. 查询比 RESEARCH 部门所有雇员收入都高的雇员的雇员号和雇员名。**

```sql
SELECT empno, ename
FROM emp
WHERE sal > ALL (
    SELECT sal
    FROM emp e, dept d
    WHERE e.deptno = d.deptno AND d.dname = 'RESEARCH'
);
```

等价写法：

```sql
SELECT empno, ename
FROM emp
WHERE sal > (
    SELECT MAX(sal)
    FROM emp e, dept d
    WHERE e.deptno = d.deptno AND d.dname = 'RESEARCH'
);
```

> `> ALL` = 大于所有 = 大于最大值。`> ANY` = 大于任意一个 = 大于最小值。

**3. 查询平均工资最高的部门的部门号、部门名和平均工资。**

```sql
SELECT d.deptno, d.dname, AVG(e.sal) AS avg_sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
GROUP BY d.deptno, d.dname
HAVING AVG(e.sal) = (
    SELECT MAX(avg_sal)
    FROM (
        SELECT AVG(sal) AS avg_sal
        FROM emp
        GROUP BY deptno
    ) AS tmp
);
```

**4. 递归 CTE——查询"张三"向下所有层级的下属。**

```sql
WITH RECURSIVE SubEmp(empno, ename, mgr, level) AS (
    -- 种子查询：找到"张三"自己
    SELECT empno, ename, mgr, 1
    FROM emp
    WHERE ename = '张三'

    UNION ALL

    -- 递归：找上一轮结果的下属
    SELECT e.empno, e.ename, e.mgr, s.level + 1
    FROM emp e
    JOIN SubEmp s ON e.mgr = s.empno
)
SELECT * FROM SubEmp;
```

> 种子找张三（level=1），递归找 mgr=张三的所有人（level=2），再找 mgr=level2 的所有人（level=3）…直到某轮返回空。

**5. 存储过程——返回部门中高于平均工资的人数。**

```sql
CREATE PROCEDURE GetAboveAvg(
    IN  p_deptno INT,
    OUT p_count  INT
)
BEGIN
    DECLARE dept_avg DECIMAL(10,2);

    SELECT AVG(sal) INTO dept_avg
    FROM emp
    WHERE deptno = p_deptno;

    SELECT COUNT(*) INTO p_count
    FROM emp
    WHERE deptno = p_deptno AND sal > dept_avg;
END;
```

调用：`CALL GetAboveAvg(10, @result); SELECT @result;`

**6. 触发器——工资更新时记录旧值到 salUpdate。**

```sql
CREATE TRIGGER log_sal_update
AFTER UPDATE ON emp
FOR EACH ROW
BEGIN
    IF :OLD.sal <> :NEW.sal THEN
        INSERT INTO salUpdate(eno, ename, oldSal, newSal, updateTime)
        VALUES (:OLD.empno, :OLD.ename, :OLD.sal, :NEW.sal, NOW());
    END IF;
END;
```

> `FOR EACH ROW`：行级触发器，每更新一行执行一次（N 行更新 → 执行 N 次）。`FOR EACH STATEMENT`：语句级，一条 UPDATE 只触发一次。`:OLD`=更新前的值，`:NEW`=更新后的值。DELETE 中 `:NEW` 为 NULL。

---

## 四、关系数据理论

### 1. R(U, F)，U=ABCDE，F={AB→C，C→B，A→D，E→A}

**（1）属性闭包**

**(AB)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并 |
|:---|:---|:---|:---|
| 0 | {A, B} | — | {A, B} |
| 1 | {A, B} | AB→C 得 C；A→D 得 D | {A, B, C, D} |
| 2 | {A, B, C, D} | C→B 已有 | = {A, B, C, D} |

E ∉ (AB)_F^+。

**(AB)_F^+ = ABCD**

**(AE)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并 |
|:---|:---|:---|:---|
| 0 | {A, E} | — | {A, E} |
| 1 | {A, E} | E→A 已有；A→D 得 D | {A, D, E} |
| 2 | 无更多可用依赖 | — | {A, D, E} |

**(AE)_F^+ = ADE**

**（2）候选码**

属性分类：

| 类别 | 属性 |
|:---|:---|
| L（仅左）| 无 |
| R（仅右）| D（只出现在右部 A→D） |
| LR | A, B, C, E |
| N | 无 |

R 类 D 排除。AB⁺ = ABCD ≠ U，还需加 E。ABE⁺：A→D, E→A→D, ...从 ABE 开始 → ABE⁺ = ABEDC = U。

具体验证 AE⁺ 加入 B 后：ABE⁺ = AE⁺ ∪ B = ADE + B = ABDE + AB→C → ABCDE = U。

候选码：**ABE**。

另外 CE⁺ = CE + A(E→A) + D(A→D) + B(C→B) → CEABD = U。**CE 也是候选码**。

候选码：**ABE、CE**。

**（3）范式判定**

候选码：ABE、CE。

非主属性：D（不出现在任何候选码里）。

- D 对 ABE：A→D，A ⊂ ABE，所以 D 部分依赖 ABE。→ 违反 2NF！

**R 最高属于 1NF。**

### 2. F={SJ→P，P→T，T→J}，求 F_min

步骤一（右部已单一，√）。

步骤二（删冗余依赖）：
- SJ→P：SJ⁺_{去SJ→P} = SJ（只有 SJ→? 被去掉后无其他依赖推出 P）= SJ，P ∉ SJ⁺ → **保留**
- P→T：P⁺_{去P→T} = PJ（检查 T→J 无帮助），T ∉ PJ⁺ → **保留**
- T→J：T⁺_{去T→J} = T（只有 T），J ∉ T⁺ → **保留**

无冗余依赖。步骤三（左部均为单属性，√）。

**F_min = {SJ→P，P→T，T→J}**（原 F 已经是最小依赖集）

### 3. 模式分解（BCNF）

R(U, F)，U={T, C, S}，F={SC→T，ST→C，T→C}

**（1）候选码 & 范式**

属性分类：S（仅左 L类）→ 必在候选码。C（仅右 R类）→ 排除。T（LR类）。

S⁺ = S ≠ U。SC⁺：S→? 无→S 依赖，SC→T 得 T。SC⁺ = SCT = U。**SC 是候选码**。

ST⁺：ST→C 得 C。ST⁺ = STC = U。**ST 也是候选码**。

候选码：**SC、ST**。

检查 BCNF：T→C 中 T 不含码（T 不是 SC 也不是 ST 的超集）→ **违反 BCNF**。

所有属性都是主属性（S, C, T 都在某候选码中），3NF 自动满足。但 T→C 违反 BCNF。

**R 最高属于 3NF**（不满足 BCNF）。

**（2）分解到 BCNF**

按 T→C 分解：T 是决定因子，把 C 从 T 的决定范围内拆出去。

```
R1(T, C)    -- T→C，T 包含码（二元关系）→ BCNF
R2(T, S)    -- 二元关系，无依赖 → BCNF
```

> 二元关系天然满足 BCNF（乃至 4NF）。

验证无损连接：R1 ⋈_{T} R2 = R ✓。
验证保持依赖：SC→T 是否保持？S 在 R2，C 在 R1，T 在两边。SC→T 能否由 R1+T→C 和 R2 推出？需要检查。若丢失则说明 BCNF 分解不一定保持函数依赖。

---

## 五、数据库设计

**（1）E-R 图**（文字描述）

实体：图书种类、图书册本、读者、借阅
- 图书种类（ISBN, 书名, 作者, 出版社, 分类）
- 图书册本（条码号, 书架号）——弱实体，依赖图书种类
- 读者（借书证号, 姓名, 联系电话, 可借上限）
- 借阅（借阅编号, 借书日期, 应还日期, 实际归还日期）——联系实体

联系：
- 图书种类 **含** 图书册本（1:N）
- 读者 **借阅** 图书册本（M:N），属性通过"借阅"联系表达
- 一次借阅可包含多册图书，一册图书在某一时间只能属于一次借阅

**（2）关系模型**

```
图书种类(ISBN, 书名, 作者, 出版社, 分类)
  PK: ISBN

图书册本(条码号, 书架号, ISBN)
  PK: 条码号  FK: ISBN→图书种类

读者(借书证号, 姓名, 联系电话, 可借上限)
  PK: 借书证号

借阅(借阅编号, 借书证号, 借书日期, 应还日期)
  PK: 借阅编号  FK: 借书证号→读者

借阅明细(借阅编号, 条码号, 实际归还日期)
  PK: (借阅编号, 条码号)  FK: 借阅编号→借阅, 条码号→图书册本
```

**（3）CREATE TABLE**

```sql
CREATE TABLE 读者 (
    借书证号   VARCHAR(10) PRIMARY KEY,
    姓名       VARCHAR(20) NOT NULL,
    联系电话   VARCHAR(15),
    可借上限   INT DEFAULT 5 CHECK (可借上限 >= 0)
);

CREATE TABLE 借阅明细 (
    借阅编号    VARCHAR(20),
    条码号      VARCHAR(20),
    实际归还日期 DATE,
    PRIMARY KEY (借阅编号, 条码号),
    FOREIGN KEY (借阅编号) REFERENCES 借阅(借阅编号),
    FOREIGN KEY (条码号) REFERENCES 图书册本(条码号),
    CHECK (实际归还日期 >= 借书日期 OR 实际归还日期 IS NULL)
);
```

**（4）游标**

- 单条记录查询 → 通过**变量**/主变量传递
- 多条记录查询 → 通过**游标**传递

游标四步：**DECLARE**（声明+绑定 SELECT）→ **OPEN**（执行查询，数据取回）→ **FETCH**（逐行读取到变量）→ **CLOSE**（释放资源）。

---

## 六、B+ 树索引与查询优化

### 1. B+ 树（n=4，最多 3 键值/4 指针）

插入序列：15, 6, 25, 10, 3, 8, 20, 30, 12

**（1）最终 B+ 树**

n=4，每节点最多 3 键值 4 指针。⌈4/2⌉=2，叶子分裂左保留 2 个键值，上提右叶第一个。

| 插入 | 操作 |
|------|------|
| 15,6,25 | [6,15,25]，3 个满 |
| 10 | [6,10,15,25] → 4 个，**分裂**。左[6,10]，右[15,25]，上提 15。根: [15] |
| 3 | 3<15→左[3,6,10]，3 个满 |
| 8 | 8<15→左[3,6,8,10] → **分裂**。左[3,6]，右[8,10]，上提 8。根: [8,15] |
| 20 | 20≥15→右[15,20,25]，3 个满 |
| 30 | 30≥15→右[15,20,25,30] → **分裂**。左[15,20]，右[25,30]，上提 25。根: [8,15,25] |
| 12 | 8≤12<15，走 p2 叶[8,10]→[8,10,12]，3 个满 |

最终结构：
```
           [8, 15, 25]
          /   |    |    \
     [3,6] [8,10,12] [15,20] [25,30]
      叶子      叶子      叶子     叶子
```

叶子间指针链：叶1→叶2→叶3→叶4。

**（2）查询键值 20 的 I/O**

1. 读根 [8,15,25]，15<20≤25 → 走 p3
2. 读叶 [15,20]，找到 20，获指针
3. **读数据块本身** ← 千万别漏

**共 3 次 I/O**（2 层树高 + 1 次数据块读取）。

**（3）主键 vs 非主键查询代价**

学生表 10000 条，每块 100 条 → 全表 100 块。

主键学号 B+ 树 3 层：代价 = 3 + 1 = **4 次 I/O**。

非主键姓名无索引：**全表扫描 = 100 次 I/O**（读了所有数据块）。

差距：4 vs 100。这就是为什么频繁查询的列要建索引。

### 2. 查询优化

**查询：检索选修了"数据库原理"课程且成绩 > 85 的 CS 系学生的姓名和成绩。**

**（1）初始关系代数表达式**

$$\pi_{Sname, Grade}(
  \sigma_{Sdept='CS' \;\land\; Cname='数据库原理' \;\land\; Grade>85
  \;\land\; Student.Sno=SC.Sno \;\land\; SC.Cno=Course.Cno}
  (Student \times SC \times Course)
)$$

**（2）初始查询树**

```
        π[Sname, Grade]
             |
     σ[Sdept='CS' ∧ Cname='数据库原理' ∧ Grade>85
       ∧ Student.Sno=SC.Sno ∧ SC.Cno=Course.Cno]
             |
           ×
          / \
         ×  Course
        / \
   Student SC
```

**（3）优化后**

拆分选择条件 → 分别下推 → 笛卡尔积替换为自然连接：

```
       π[Sname, Grade]
            |
       ⋈[Student.Sno=SC.Sno]
          / \
     π[Sno,Sname]  π[Sno,Grade]
     σ[Sdept='CS']    |
       Student      ⋈[SC.Cno=Course.Cno]
                      / \
                  SC    π[Cno]
                      σ[Cname='数据库原理']
                        Course
```

优化后关系代数表达式：

$$\pi_{Sname, Grade}(
  (\sigma_{Sdept='CS'}(Student))
  \bowtie
  (\pi_{Sno, Grade}(\sigma_{Grade>85}(SC))
   \bowtie
   \pi_{Cno}(\sigma_{Cname='数据库原理'}(Course)))
)$$

> 核心原则：**选择运算尽可能先做**——这是代数优化最基本、最重要的一条。

---

## 七、并发控制与数据库恢复

### 1. 冲突可串行化

调度 S（按时间）：
T1: R(X),W(X),R(Y),W(Y)
T2: R(X),W(X),R(Y),W(Y)
T3: R(Y),R(X),W(X),W(Y)

分析冲突：T1 W(X) 先于 T2 R(X)（冲突）→ T1 先于 T2。T2 W(X) 先于 T3 R(X)（冲突）→ T2 先于 T3。T3 W(Y) 先于 T1 R(Y)（冲突）→ T3 先于 T1。形成 T1→T2→T3→T1 **回路** → 不能通过交换转化为串行。

**该调度不是冲突可串行化的。**

**（2）冲突可串行化 vs 可串行化**

- 冲突可串行化 ⇒ 可串行化（充分条件）：冲突可串行化一定正确
- 可串行化 ⇏ 冲突可串行化（非必要条件）：不冲突可串行化不代表一定错误。有些正确调度虽不能通过交换非冲突操作转化为串行，但执行结果仍等价于某种串行。

### 2. 并发调度正确性

T1: R(B), A=B+2, W(A)
T2: R(A), B=A×2, W(B)
初值 A=6, B=6。

串行 1（T1→T2）：B=6, A=8, A=8, B=16 → **(8, 16)**
串行 2（T2→T1）：A=6, B=12, B=12, A=14 → **(14, 12)**

执行结果 **(8, 12)** 不等于任何一种串行 → **错误调度**。
执行结果 **(8, 16)** = 串行 1 → **正确调度**（可能是串行 T1→T2）。

### 3. 日志恢复

**（1）故障在 16 之后（检查点在 11）：**

从检查点（序号 11）正向扫描：
- 检查点时刻活动事务：T3（T1 已 COMMIT(6)，T2 只有 START(3)无 COMMIT...等等，T2 在序号 12 COMMIT）。
- 序号 11 检查点时：T1 COMMIT(6)在检查点前→无需处理。T2 未 COMMIT（在 12），T3 未 COMMIT（在 14）。

从检查点扫描 12-16：
- T2 COMMIT(12) → **REDO**
- T3 COMMIT(14) → **REDO**
- T4 START(15) → 无 COMMIT 无 ROLLBACK → **UNDO**

**REDO：T2、T3。UNDO：T4。无需处理：T1。**

恢复后值：T2 REDO（A=?, B=25, C=50），T3 REDO（A=40, B=60, C 被 T2 覆盖...注意执行序）。按日志序重做：T2 A 未有写入所以不变，T2 B=25，T2 C=50；T3 A=40(覆盖)，T3 B=60(覆盖)。T4 UNDO → 撤销 A=70。A 回退到 T3 的 40。

**恢复后：A=40, B=60, C=50。**

**（2）故障在 10 之后（检查点在 11，故障在 10 → 检查点尚未建立）：**

正向扫描全部日志 1-10：

- T1: COMMIT(6) → REDO
- T2: 有 START(3)，到序号 10 时有 COMMIT? 无，T2 COMMIT 在 12 → **UNDO**（序号 10 是 T2 Write(C)，T2 尚未 COMMIT）
- T3: START(7)，到 10 时无 COMMIT → **UNDO**

复核：序号 10 是 T2: Write(C), C=50。T2 COMMIT 在 12，故障在 10 → T2 未完成。

**REDO：T1。UNDO：T2、T3。**

---

