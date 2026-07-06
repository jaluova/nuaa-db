# 模拟卷 A · 参考答案

---

## 一、关系代数计算题

**关系 R**

| A | B | C |
|:---:|:---:|:---:|
| a | 3 | 5 |
| a | 3 | 6 |
| b | 4 | 5 |
| d | 3 | 5 |
| c | 2 | 4 |

**关系 S**

| B | C | D |
|:---:|:---:|:---:|
| 3 | 5 | x |
| 3 | 6 | y |

**1. π_A,B(R)**

先投影 A、B 两列，再去重：

| A | B |
|:---:|:---:|
| a | 3 |
| b | 4 |
| d | 3 |
| c | 2 |

**2. R ⋈ S（自然连接）**

公共属性 B、C，匹配后去掉重复列：

R(a,3,5) 匹配 S(3,5,x) → (a,3,5,x)
R(a,3,6) 匹配 S(3,6,y) → (a,3,6,y)
R(b,4,5) 无匹配 → 丢弃
R(d,3,5) 匹配 S(3,5,x) → (d,3,5,x)
R(c,2,4) 无匹配 → 丢弃

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| a | 3 | 5 | x |
| a | 3 | 6 | y |
| d | 3 | 5 | x |

**3. R ⋈_{R.B=S.B ∧ R.C > S.C} S（θ-连接）**

逐个检查 R 和 S 的笛卡尔积中满足 B 相等且 R.C > S.C 的组合：

R(a,3,5) vs S(3,5,x): B相同, 5>5? 否
R(a,3,5) vs S(3,6,y): B相同, 5>6? 否
R(a,3,6) vs S(3,5,x): B相同, 6>5? **是** → (a,3,6,3,5,x)
R(a,3,6) vs S(3,6,y): B相同, 6>6? 否
R(b,4,5) vs S: B=4，S 中没有 B=4 → 不匹配
R(c,2,4) vs S: B=2，S 中没有 B=2 → 不匹配

| R.A | R.B | R.C | S.B | S.C | D |
|:---:|:---:|:---:|:---:|:---:|:---:|
| a | 3 | 6 | 3 | 5 | x |

**4. R ÷ S**

先求 S 在 (B,C) 上的投影：{(3,5), (3,6)}

计算每个 A 值的象集：
- A='a': {(3,5), (3,6)} **包含** S 投影 ✓
- A='b': {(4,5)} 不包含 ✗
- A='d': {(3,5)} 不包含（缺少 (3,6)）✗
- A='c': {(2,4)} 不包含 ✗

结果：{a}

| A |
|:---:|
| a |

**5. R ⟕ S（左外连接）**

保留 R 的全部元组，S 无匹配时填 NULL：

R(a,3,5) 匹配 S(3,5,x) → (a,3,5,x)
R(a,3,6) 匹配 S(3,6,y) → (a,3,6,y)
R(b,4,5) 无匹配 → (b,4,5,NULL)
R(d,3,5) 匹配 S(3,5,x) → (d,3,5,x)
R(c,2,4) 无匹配 → (c,2,4,NULL)

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| a | 3 | 5 | x |
| a | 3 | 6 | y |
| b | 4 | 5 | NULL |
| d | 3 | 5 | x |
| c | 2 | 4 | NULL |

> 对比第 2 题自然连接：b 和 c 在自然连接中被丢弃，但左外连接中保留。

---

## 二、关系代数与关系演算

**1. 查询"计算机系"（CS）学生的学号和姓名。**

关系代数：

$$\pi_{Sno, Sname}(\sigma_{Sdept='CS'}(Student))$$

ALPHA 语言：

```
GET W(Student.Sno, Student.Sname): Student.Sdept = 'CS'
```

**2. 查询既选修了 1 号课程又选修了 2 号课程的学生的学号和姓名。**

> 注意：SQL 中 `WHERE cno='1' AND cno='2'` 永远为假。关系代数中用交集。

关系代数：

$$\pi_{Sno, Sname}(Student \bowtie (\pi_{Sno}(\sigma_{Cno='1'}(SC)) \cap \pi_{Sno}(\sigma_{Cno='2'}(SC))))$$

或使用除法：略（此题用交集更直观）

ALPHA 语言：

```
RANGE SC SCX
GET W(Student.Sno, Student.Sname):
    ∃ SCX (SCX.Sno = Student.Sno ∧ SCX.Cno = '1')
  ∧ ∃ SCX (SCX.Sno = Student.Sno ∧ SCX.Cno = '2')
```

**3. 查询选修了所有课程的学生的学号。**

关系代数：

$$\pi_{Sno, Cno}(SC) \div \pi_{Cno}(Course)$$

如需姓名，再与学生表自然连接：$$\pi_{Sname}(Student \bowtie (\pi_{Sno, Cno}(SC) \div \pi_{Cno}(Course)))$$

ALPHA 语言（双重否定转化）：

```
RANGE Course CX
      SC SCX
GET W(Student.Sno):  ∀ CX ∃ SCX (SCX.Sno = Student.Sno ∧ SCX.Cno = CX.Cno)
```

即：对所有课程，都存在该学生的选课记录。

---

## 三、SQL 语言

**1. 查询比他/她的经理工资高的雇员的雇员号、雇员名以及工资。**

```sql
SELECT e1.empno, e1.ename, e1.sal
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno
  AND e1.sal > e2.sal;
```

**2. 查询在 2020 年之后入职的雇员的雇员号、雇员名和入职年份。**

```sql
SELECT empno, ename, YEAR(hiredate) AS hire_year
FROM emp
WHERE YEAR(hiredate) > 2020;
```

**3. 查询雇员人数最多的部门的部门号和部门名。**

```sql
SELECT d.deptno, d.dname
FROM dept d, emp e
WHERE d.deptno = e.deptno
GROUP BY d.deptno, d.dname
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM emp
    GROUP BY deptno
    ORDER BY COUNT(*) DESC
    LIMIT 1
);
```

**4. 查询平均工资超过 5000 的部门的部门号及平均工资，按平均工资降序排列。**

```sql
SELECT deptno, AVG(sal) AS avg_sal
FROM emp
GROUP BY deptno
HAVING AVG(sal) > 5000
ORDER BY avg_sal DESC;
```

> WHERE 用于分组前筛选原始记录，HAVING 用于分组后筛选组结果。此处 `AVG(sal) > 5000` 必须放 HAVING，放 WHERE 是严重逻辑错误。

**5. 利用派生表查询工资超过所在部门平均工资的雇员的雇员号和雇员名。**

```sql
SELECT e.empno, e.ename
FROM emp e, (
    SELECT deptno, AVG(sal) AS avg_sal
    FROM emp
    GROUP BY deptno
) AS dept_avg
WHERE e.deptno = dept_avg.deptno
  AND e.sal > dept_avg.avg_sal;
```

> 派生表 `dept_avg` 在 FROM 子句中作为临时表使用（教材第 107 页）。也可用相关子查询或窗口函数实现。

**6. 将 RESEARCH 部门所有雇员的基本工资增加 1500 元，但最高不超过 30000。**

```sql
UPDATE emp
SET sal = LEAST(sal + 1500, 30000)
WHERE deptno = (SELECT deptno FROM dept WHERE dname = 'RESEARCH');
```

> `LEAST(a, b)` 取两者中较小值，保证不超上限。若需兜底不低于某值，用 `GREATEST`。

---

## 四、关系数据理论

### 1. R(U, F)，U=ABCDE，F={AB→C，C→D，D→E，A→B，B→A}

**（1）计算 (AB)_F^+ 和 (AC)_F^+**

**(AB)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并结果 |
|:---|:---|:---|:---|
| 0 | {A, B} | — | {A, B} |
| 1 | {A, B} | AB→C 得 C；A→B 已有；B→A 已有 | {A, B, C} |
| 2 | {A, B, C} | C→D 得 D | {A, B, C, D} |
| 3 | {A, B, C, D} | D→E 得 E | {A, B, C, D, E} = U |

$$(AB)_F^+ = ABCDE = U$$

**(AC)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并结果 |
|:---|:---|:---|:---|
| 0 | {A, C} | — | {A, C} |
| 1 | {A, C} | A→B 得 B；C→D 得 D | {A, B, C, D} |
| 2 | {A, B, C, D} | D→E 得 E；B→A 已有 | {A, B, C, D, E} = U |

$$(AC)_F^+ = ABCDE = U$$

**（2）求所有候选码（属性分类法）**

| 类别 | 属性 | 原因 |
|:---|:---|:---|
| L（仅左） | 无 | — |
| R（仅右） | E | E 只出现在右部（D→E） |
| LR（左右） | A, B, C, D | |
| N（都不） | 无 | |

R 类排除 E。LR 中逐一测试。由（1）知 AB⁺=U，AC⁺=U。

候选码：**AB**、**AC**。另外 B→A（B⁺=BADCE=U），**B** 也是候选码。同理 A→B 得 **A** 也是。

验证：A⁺=ABCDE=U，B⁺=BADCE=U。所以候选码为 **A** 和 **B**。

（注：A→B 且 B→A，它们互为决定因素且闭包均等于 U）

**（3）R 最高满足第几范式？**

R ∈ 1NF（自然）。候选码：A、B。

非主属性：C、D、E。

检查 2NF：非主属性对码是否有部分依赖？
- A→B→... 候选码是单属性，不存在真子集 → 无部分依赖。✓

检查 3NF：非主属性对码是否有传递依赖？
- A→C→D→E，C 不是候选码，但 C→D。存在传递依赖 A→C→D。✗

**R 最高属于 2NF。**

### 2. F={A→B，B→C，C→D，D→A，B→A，C→B}，求 F_min

步骤一（右部已单一，√）。

步骤二（去掉冗余依赖）：

逐一检查每个依赖可否由其余依赖推出。

- A→B：A⁺_{去掉A→B} = A, C→B 中 A 不在左部... A⁺ = {A}，B ∉ A⁺ → A→B **不可删**
- B→C：B⁺_{去掉B→C} = B, A→B 已有 B→A 有...检查其他的能推出 C 吗？无 → B→C **不可删**
- C→D：需要 C→D 连接 D→A 形成回路 → **不可删**
- D→A：**不可删**（回路需要）
- B→A：B→C→D→A，能推出。B⁺_{去掉B→A} = BCDA = U，A ∈ B⁺ → B→A **冗余，删**
- C→B：C→D→A→B，能推出。C⁺_{去掉C→B} = CDAB = U，B ∈ C⁺ → C→B **冗余，删**

去掉 B→A 和 C→B 后：F = {A→B, B→C, C→D, D→A}

步骤三（左部无冗余，均为单属性√）。

**F_min = {A→B, B→C, C→D, D→A}**

### 3. 模式分解到 3NF

R(Sno, Sdept, Mname, Cno, Grade)
F = {Sno→Sdept, Sdept→Mname, (Sno,Cno)→Grade}

**（1）候选码 & 范式**

属性分类：Sno 和 Cno 左右都不出现（N 类），必在候选码。

候选码：(Sno, Cno)。

非主属性：Sdept, Mname, Grade。

传递依赖：Sno→Sdept→Mname。Sno 是码的真子集 → Sdept 部分依赖码 → 违反 2NF。

**R 最高属于 1NF。**

**（2）分解到 3NF**

部分依赖 Sno→Sdept 剥离 + 传递依赖 Sdept→Mname 切断：

```
R1(Sno, Cno, Grade)      -- 码 (Sno,Cno)，Grade 完全依赖
R2(Sno, Sdept)            -- 码 Sno
R3(Sdept, Mname)          -- 码 Sdept
```

无损连接 ✓（通过 Sno 和 Sdept 自然连接还原）。保持依赖 ✓。

---

## 五、数据库设计

**（1）E-R 图**（文字描述）

实体及属性：
- 教师（工号, 姓名, 职称）
- 学生（学号, 姓名, 年级）
- 院系（院系编号, 院系名称）
- 课程（课程号, 课程名, 学分）
- 评价（评价编号, 教学态度, 教学内容, 教学方法）

联系：
- 教师 **属于** 院系（N:1）
- 学生 **属于** 院系（N:1）
- 教师 **讲授** 课程（M:N）
- 学生 **选修** 课程（M:N），属性：学期、成绩
- 学生 **评价** 讲授（M:N:1 或转为独立联系：学生+教师+课程 → 评价）

> 评分要点：实体用矩形、联系用菱形、属性用椭圆。M:N 的联系必须保留独立关系模式。

**（2）关系模型**

```
院系(院系编号, 院系名称)  PK: 院系编号

教师(工号, 姓名, 职称, 院系编号)  PK: 工号  FK: 院系编号→院系

学生(学号, 姓名, 年级, 院系编号)  PK: 学号  FK: 院系编号→院系

课程(课程号, 课程名, 学分)  PK: 课程号

讲授(工号, 课程号)  PK: (工号, 课程号)  FK: 工号→教师, 课程号→课程

选课(学号, 课程号, 学期, 成绩)  PK: (学号, 课程号)  FK: 学号→学生, 课程号→课程

评价(评价编号, 学号, 工号, 课程号, 教学态度, 教学内容, 教学方法)
  PK: 评价编号  FK: 学号→学生, 工号→教师, 课程号→课程
```

**（3）评价表 CREATE TABLE**

```sql
CREATE TABLE 评价 (
    评价编号   VARCHAR(20) PRIMARY KEY,
    学号       VARCHAR(10) NOT NULL,
    工号       VARCHAR(10) NOT NULL,
    课程号     VARCHAR(10) NOT NULL,
    教学态度   INT CHECK (教学态度 >= 1 AND 教学态度 <= 5),
    教学内容   INT CHECK (教学内容 >= 1 AND 教学内容 <= 5),
    教学方法   INT CHECK (教学方法 >= 1 AND 教学方法 <= 5),
    FOREIGN KEY (学号) REFERENCES 学生(学号),
    FOREIGN KEY (工号) REFERENCES 教师(工号),
    FOREIGN KEY (课程号) REFERENCES 课程(课程号)
);
```

---

## 六、B+ 树索引与查询优化

### 1. B+ 树构建（n=4，最多 3 键值/4 指针）

插入序列：12, 5, 8, 20, 3, 7, 15, 25, 10

**（1）最终 B+ 树结构**

```
              [7, 12, 20]
             /    |     |     \
        [3,5]  [7,8,10] [12,15] [20,25]
         叶子      叶子      叶子     叶子
           ↓         ↓         ↓        ↓
        数据块     数据块    数据块    数据块

叶子节点间有指针链：叶1 → 叶2 → 叶3 → 叶4
根节点（非叶子）：p1→[3,5], p2→[7,8,10], p3→[12,15], p4→[20,25]
```

构建过程：

| 插入 | 操作 |
|------|------|
| 12,5,8 | [5,8,12]，3 个键值，刚好满 |
| 20 | [5,8,12,20] 满 4 个，**分裂**。⌈4/2⌉=2，左保留 2 个 [5,8]，右 [12,20]，上提 12 到新根。根: [12] |
| 3 | 3<12 走左，[3,5,8]，满 |
| 7 | 7<12 走左，[3,5,7,8] 满，**分裂**。左 [3,5] 右 [7,8]，上提 7。根: [7,12] |
| 15 | 15≥12 走右，[12,15,20]，满 |
| 25 | 25≥12 走右，[12,15,20,25] 满，**分裂**。左 [12,15] 右 [20,25]，上提 20。根: [7,12,20] |
| 10 | 7≤10<12，走 p2，[7,8]→[7,8,10]，3 个刚好 |

**（2）查询键值 15 的 I/O**

- 第 1 次：读根节点 [7,12,20]，15 在 (12,20) 区间 → 走 p3
- 第 2 次：读叶子 [12,15]，找到 15，获取指针
- 第 3 次：根据指针**读数据块本身** ← 极易漏

**共 3 次 I/O。** B+ 树 I/O = 树高度(2) + 1 次数据块读取 = 3。

> 主键 B+ 树等值查询代价通用公式：L + 1（L=树层数，+1=数据块）。

**（3）删除键值 8**

8 在叶子 [7,8,10] 中。删除 8 → [7,10]，仍有 2 个键值 ≥ ⌈4/2⌉-1 = 1，无需借调或合并。

根节点 [7,12,20] 中指向该叶子的分隔键为 7，该叶子的最小键值仍为 7，无需调整。

删除后树不变（仅叶子 [7,8,10] 变为 [7,10]）。

### 2. 查询优化

**查询：检索 CS 系选修 DB 课程且成绩 90 分以上的男学生的姓名和学号。**

**（1）初始关系代数表达式**

$$\pi_{Sname, Sno}(
  \sigma_{Sdept='CS' \;\land\; Cname='DB' \;\land\; Grade>90 \;\land\; Ssex='男'
  \;\land\; Student.Sno=SC.Sno \;\land\; SC.Cno=Course.Cno}
  (Student \times SC \times Course)
)$$

**（2）初始查询树**

```
        π[Sname, Sno]
             |
        σ[Sdept='CS' ∧ Cname='DB' ∧ Grade>90 ∧ Ssex='男'
          ∧ Student.Sno=SC.Sno ∧ SC.Cno=Course.Cno]
             |
           ×
          / \
         ×  Course
        / \
   Student SC
```

**（3）优化后查询树**

① 拆分复杂选择条件
② 选择下推：σ_Sdept='CS' ∧ Ssex='男' 推到 Student 上方，σ_Cname='DB' 推到 Course 上方，σ_Grade>90 推到 SC 上方
③ 笛卡尔积 + 连接条件 → 自然连接

```
     π[Sname, Sno]
          |
     ⋈[Student.Sno=SC.Sno]
        / \
       /   π[Sno]
  π[Sno,Sname]  |
  σ[Sdept='CS'  σ[SC.Cno=Course.Cno]
   ∧ Ssex='男']    / \
      |        ⋈[Cno]  π[Sno]
   Student     / \     σ[Grade>90]
           Course  SC      |
         σ[Cname='DB']
```

优化后关系代数：

$$\pi_{Sname, Sno}(
  (\sigma_{Sdept='CS' \land Ssex='男'}(Student))
  \bowtie
  (\pi_{Sno}(\sigma_{Grade>90}(SC) \bowtie \sigma_{Cname='DB'}(Course)))
)$$

---

## 七、并发控制与数据库恢复

### 1. 冲突可串行化判定

调度 S（按时间从上到下）：

| 时刻 | T1 | T2 | T3 |
|:---|:---|:---|:---|
| 1 | | R(Y) | |
| 2 | | W(Y) | |
| 3 | R(X) | | |
| 4 | | | R(Y) |
| 5 | W(X) | | |
| 6 | | | W(Y) |
| 7 | | R(Z) | |
| 8 | | | R(X) |
| 9 | | W(Z) | |
| 10 | | | W(X) |
| 11 | R(Z) | | |
| 12 | W(Z) | | |

分析冲突操作：

| 数据 | 冲突 | 方向 |
|------|------|:--:|
| X | T1 W(X)@5 → T3 R(X)@8, W(X)@10 | T1→T3 |
| Y | T2 W(Y)@2 → T3 R(Y)@4, W(Y)@6 | T2→T3 |
| Z | T2 W(Z)@9 → T1 R(Z)@11, W(Z)@12 | T2→T1 |

冲突图：T2 → T1 → T3，无回路。

**该调度是冲突可串行化的**，等价串行序列：**T2, T1, T3**。

### 2. 两段锁协议

**内容**：事务分为两个阶段——扩展阶段（只加锁不释放）和收缩阶段（一旦释放就不再加锁）。

**能否防死锁**：**不能**。两个事务都遵循 2PL（T1 锁 A 申请 B，T2 锁 B 申请 A）仍可能死锁。2PL 保证调度正确性，不保证死锁避免。

### 3. 日志恢复

**（1）故障发生在 19 之后：**

正向扫描日志到检查点（序号 13）：

检查点时刻活动事务：T3（T1、T2 已结束？不对，检查点在 13，之前 T1 COMMIT(6), T2 COMMIT(11)）。检查点记录中的活动事务需结合上下文判断。

从检查点正向扫描（从序号 14 开始）：
- T3 有 COMMIT(17) → REDO 队列
- T4 START(15) → 无 COMMIT/ROLLBACK 只有 ROLLBACK(19) → 已回滚，无需处理

从检查点前：T1 COMMIT(6) 在检查点前 → 无需处理（检查点强制写盘保证）。T2 COMMIT(11) 在检查点前 → 同样无需处理。

**REDO：T3。UNDO：无（T4 已 ROLLBACK）。无需处理：T1、T2。**

**（2）故障发生在 12 之后：**

检查点在序号 13，故障在 12，检查点还未建立 → 从日志头正向扫描。

- T1: COMMIT(6) → REDO
- T2: 到序号 12 时 T2 COMMIT 在序号 11 → REDO
- T3: 只有 START(7)，无 COMMIT → UNDO

**REDO：T1、T2。UNDO：T3。**

---
