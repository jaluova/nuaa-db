# 模拟卷 B · 参考答案

---

## 一、关系代数计算题

**关系 R**
| A | B | C |
|:---:|:---:|:---:|
| 5 | 6 | 8 |
| 5 | 6 | 6 |
| 6 | 5 | 6 |
| 5 | 6 | 7 |
| 6 | 1 | 8 |

**关系 S**
| B | C | D |
|:---:|:---:|:---:|
| 6 | 6 | p |
| 6 | 8 | q |

**1. π_B,C(R)** — 去重后：

| B | C |
|:---:|:---:|
| 6 | 8 |
| 6 | 6 |
| 5 | 6 |
| 6 | 7 |
| 1 | 8 |

**2. σ_{A≥5}(R)**

全部 5 行的 A 值都 ≥5 → 结果同 R（5 行全保留）。

**3. R ⋈ S（自然连接）**

公共属性 B、C，匹配后去重列：

R(5,6,8) 匹配 S(6,8,q) → (5,6,8,q)
R(5,6,6) 匹配 S(6,6,p) → (5,6,6,p)
R(5,6,7) → S 中无 B=6,C=7 → 丢弃
R(6,5,6) → S 中无 B=5 → 丢弃
R(6,1,8) → S 中无 B=1 → 丢弃

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| 5 | 6 | 8 | q |
| 5 | 6 | 6 | p |

**4. R ÷ S**

S 在 (B,C) 上投影：{(6,6), (6,8)}

各 A 值的象集：
- A=5: {(6,8), (6,6), (6,7)} → 包含 S 投影 ✓
- A=6: {(5,6), (1,8)} → 不包含 ✗

| A |
|:---:|
| 5 |

**5. R ⟖ S（右外连接）**

保留 S 的全部元组，R 无匹配时填 NULL：

S(6,6,p) → R 中有 (5,6,6) 匹配 → (5,6,6,p)
S(6,8,q) → R 中有 (5,6,8) 匹配 → (5,6,8,q)

| A | B | C | D |
|:---:|:---:|:---:|:---:|
| 5 | 6 | 6 | p |
| 5 | 6 | 8 | q |

> 与第 3 题自然连接结果相同，因为此例中 S 的所有 B,C 组合都能在 R 中找到匹配。

---

## 二、关系代数与关系演算

**1. 查询选修了"数据库原理"课程且成绩及格的学生的学号和姓名。**

关系代数：

$$\pi_{Sno, Sname}(
  Student \bowtie
  \sigma_{Cname='数据库原理' \;\land\; Grade \ge 60}(
    SC \bowtie Course
  )
)$$

ALPHA 语言：

```
RANGE SC SCX
      Course CX
GET W(Student.Sno, Student.Sname):
    ∃ SCX ∃ CX (SCX.Sno = Student.Sno
              ∧ SCX.Cno = CX.Cno
              ∧ CX.Cname = '数据库原理'
              ∧ SCX.Grade >= 60)
```

**2. 查询没有选修 5 号课程的学生的学号和姓名。**

关系代数：

$$\pi_{Sno, Sname}(Student) - \pi_{Sno, Sname}(
  Student \bowtie \sigma_{Cno='5'}(SC)
)$$

ALPHA 语言：

```
RANGE SC SCX
GET W(Student.Sno, Student.Sname):
    ¬∃ SCX (SCX.Sno = Student.Sno ∧ SCX.Cno = '5')
```

**3. 查询至少选修了学号为"S1"的学生所选全部课程的学生学号。**

关系代数：设 K = π_Cno(σ_Sno='S1'(SC))（S1 选的课程集合）

$$\pi_{Sno, Cno}(SC) \div K$$

ALPHA 语言（逻辑蕴含）：

```
RANGE SC SCX
      SC SCY
GET W(Student.Sno):
    ∀ SCX (SCX.Sno = 'S1'
        → ∃ SCY (SCY.Sno = Student.Sno
               ∧ SCY.Cno = SCX.Cno))
```

> 核心：P→Q ≡ ¬(P ∧ ¬Q)。"如果 S1 选了某门课，那么该学生也选了这门课"。等价于双重 NOT EXISTS。

---

## 三、SQL 语言

**1. 查询在 SALES 部门工作且工资高于其经理的雇员的雇员号和雇员名。**

```sql
SELECT e1.empno, e1.ename
FROM emp e1, emp e2, dept d
WHERE e1.mgr = e2.empno
  AND e1.sal > e2.sal
  AND e1.deptno = d.deptno
  AND d.dname = 'SALES';
```

**2. 查询那些没有下属雇员的经理的雇员号和雇员名。**

```sql
SELECT empno, ename
FROM emp
WHERE empno IN (SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL)
  AND empno NOT IN (SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL);
```

> 换思路——mgr 出现在 mgr 列中说明有下属。用 NOT IN：

```sql
SELECT empno, ename
FROM emp
WHERE empno NOT IN (
    SELECT DISTINCT mgr FROM emp WHERE mgr IS NOT NULL
);
```

> 注意：`NOT IN` 子查询中必须排除 NULL，否则结果为空。

**3. 查询雇员人数一样多的部门的部门号和雇员人数。**

```sql
SELECT deptno, COUNT(*) AS cnt
FROM emp
GROUP BY deptno
HAVING COUNT(*) IN (
    SELECT COUNT(*)
    FROM emp
    GROUP BY deptno
    HAVING COUNT(*) <> (SELECT COUNT(*) FROM emp GROUP BY deptno)
);
```

> 正确思路：选出人数出现超过 1 次的部门人数值。

```sql
SELECT deptno, COUNT(*) AS cnt
FROM emp
GROUP BY deptno
HAVING cnt IN (
    SELECT cnt
    FROM (SELECT COUNT(*) AS cnt FROM emp GROUP BY deptno) AS tmp
    GROUP BY cnt
    HAVING COUNT(*) > 1
);
```

**4. 统计各部门的平均工资、最高工资和最低工资，按部门号升序排列。**

```sql
SELECT deptno, AVG(sal) AS avg_sal, MAX(sal) AS max_sal, MIN(sal) AS min_sal
FROM emp
GROUP BY deptno
ORDER BY deptno ASC;
```

**5. 创建 IT 部门入职时间在 2021 年 1 月 1 日以后入职的姓"李"的雇员视图 empv。**

```sql
CREATE VIEW empv(eid, ename, salary) AS
SELECT empno, ename, sal
FROM emp e, dept d
WHERE e.deptno = d.deptno
  AND d.dname = 'IT'
  AND e.hiredate > '2021-01-01'
  AND e.ename LIKE '李%';
```

> CREATE VIEW 是 DDL，不是 DML。关键词不能写错。

**6. 查询工资超过所在部门平均工资的雇员的雇员号和雇员名。**

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

---

## 四、关系数据理论

### 1. R(U, F)，U=ABCDE，F={AB→C，C→D，D→B，A→E}

**（1）属性闭包**

**(AB)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并 |
|:---|:---|:---|:---|
| 0 | {A, B} | — | {A, B} |
| 1 | {A, B} | AB→C 得 C；A→E 得 E | {A, B, C, E} |
| 2 | {A, B, C, E} | C→D 得 D | {A, B, C, D, E} |
| 3 | {A, B, C, D, E} | D→B 已有 | = U |

**(AB)_F^+ = ABCDE = U**

**(AE)_F^+：**

| 轮次 | 当前集合 | 新增 | 合并 |
|:---|:---|:---|:---|
| 0 | {A, E} | — | {A, E} |
| 1 | {A, E} | A→E 已有 | {A, E} |

没有其他依赖可用（AB→C 需要 B；C→D 需要 C；D→B 需要 D）。

**(AE)_F^+ = AE**

**（2）候选码**

属性分类：

| 类别 | 属性 |
|:---|:---|
| L（仅左）| A |
| R（仅右）| E |
| LR | B, C, D |
| N | 无 |

L 类 A 必在候选码中。AE⁺=AE≠U。逐一加入 LR 属性：

- AB⁺=ABCDE=U → **AB 是候选码**
- AC⁺=? AC→AB（因...需要验证），AC⁺: A,C → C→D 得 D → D→B 得 B → A→E 得 E。AC⁺=ABCDE=U → **AC 也是候选码**
- AD⁺: A,D → A→E 得 E → D→B 得 B → ...AD⁺ 验证... → **AD 也是候选码**

候选码：**AB、AC、AD**。

**（3）范式判定**

候选码包含 A。非主属性：B、C、D、E（这些都不在任何候选码中...等等，B 在 AB 中所以 B 在候选码 AB 中 → B 是主属性。C 在 AC 中 → 主属性。D 在 AD 中 → 主属性）。

非主属性：**E**（只出现在右部，不在任何候选码中）。

E 对每个候选码都是直接依赖（如 A→E）且 A 包含于所有候选码 → 无传递依赖。

但需要检查 BCNF：如 D→B 中 D 不是超码（D⁺=DB ≠ U）→ R ∉ BCNF。

**R ∈ 3NF**（所有非主属性不传递依赖码，所有属性都是主属性...不对，E 是非主属性，E 对 AB 完全依赖且无传递依赖）。

严格判定：非主属性只有 E。E 完全依赖于 A（A 包含在所有候选码中），无部分依赖。无传递依赖（A→E 直接）。满足 3NF。D→B 中 D 不是超码但 B 是主属性 → 3NF 允许（BCNF 不允许）。

**R 最高属于 3NF。**

### 2. F={A→BE，D→A，A→C，BD→C}，求 F_min

步骤一（右部单一化）：
- A→BE → A→B, A→E
- F = {A→B, A→E, D→A, A→C, BD→C}

步骤二（删冗余依赖）：
- A→B：A⁺_{去A→B} = ACE，B ∉ ACE → **保留**
- A→E：A⁺_{去A→E} = ABC，E ∉ ABC → **保留**
- D→A：D⁺_{去D→A} = D，A ∉ D⁺ → **保留**
- A→C：A⁺_{去A→C} = ABE，C ∉ ABE → **保留**
- BD→C：B 无法由其他推出...BD⁺_{去BD→C} = BD, B... D→A→B→C? 需要计算。D⁺ = DABCE... 所以 D→A→C，即 D→C 可推出。则 BD→C 中 B 多余？

步骤三（删左部冗余）：
- BD→C：计算 B⁺=B（只有 B），D⁺=DABCE（C∈D⁺），所以 D→C 已成立 → B 冗余。BD→C 改为 **D→C**。

**F_min = {A→B, A→E, D→A, A→C, D→C}**

> 再检查 A→C 是否可由 D→A 推出：D→A→C，所以 A→C 也可由 D→A 代替？不，D→A 和 A→C 推出 D→C，但 A→C 本身作为直接依赖仍需要。D→C 可由 D→A 和 A→C 推出，故 D→C 是新加的但可由已有推出 → D→C 是否冗余？
>
> 检查 D→C：去掉它，D⁺=DABCE → C ∈ D⁺，所以 D→C **冗余**。
>
> **最终 F_min = {A→B, A→E, D→A, A→C}**

### 3. 模式分解

R(U, F)，U={S, T, J, P}，F={SJ→P，P→T，T→J}

**（1）候选码 & 范式**

属性分类：S 仅左(L类) → 必在候选码。P, T, J 都是 LR 类。

S⁺ = S ≠ U。测试 SJ⁺：SJ→P 得 P，P→T 得 T，T→J...已有。SJ⁺=SJPT=U → **SJ 是候选码**。

同理 ST⁺：ST→无法直接推导（无直接依赖）→ ST⁺=ST ≠ U? 需检查：SJ 是码，ST 不是。

候选码：**SJ**。

非主属性：P, T（J 包含于 SJ 所以 J 是主属性）。

传递依赖：SJ→P→T。P 不是候选码但 P→T → T 对码传递依赖。

**R ∈ 2NF**（存在传递依赖，最高 2NF）。

**（2）分解到 3NF**

从传递依赖链 SJ→P→T→J 的中间切断：

```
R1(S, J, P)    -- 码 SJ，SJ→P
R2(P, T)       -- 码 P，P→T
R3(T, J)       -- 码 T，T→J
```

无损连接 ✓（P 连接 R1-R2，T 连接 R2-R3）。保持依赖 ✓。

---

## 五、数据库设计

**（1）E-R 图**（文字描述）

实体：科室、病房、医生、病人
- 科室（科室编号, 科室名称, 联系电话）
- 病房（病房号, 床位数量）——弱实体，依赖科室
- 医生（工号, 姓名, 职称）
- 病人（住院号, 姓名, 性别, 出生日期）

联系：
- 科室 **包含** 病房（1:N）
- 科室 **拥有** 医生（1:N）→ 或医生**属于**科室(N:1)
- 病人 **入住** 病房（M:N），属性：入院日期、出院日期
- 医生 **诊治** 病人（M:N），属性：诊治日期、诊断结果

**（2）关系模型**

```
科室(科室编号, 科室名称, 联系电话)  PK: 科室编号

病房(病房号, 床位数量, 科室编号)  PK: 病房号  FK: 科室编号→科室

医生(工号, 姓名, 职称, 科室编号)  PK: 工号  FK: 科室编号→科室

病人(住院号, 姓名, 性别, 出生日期)  PK: 住院号

入住(住院号, 病房号, 入院日期, 出院日期)
  PK: (住院号, 入院日期)  FK: 住院号→病人, 病房号→病房

诊治(工号, 住院号, 诊治日期, 诊断结果)
  PK: (工号, 住院号, 诊治日期)  FK: 工号→医生, 住院号→病人
```

**（3）诊治表 CREATE TABLE**

```sql
CREATE TABLE 诊治 (
    工号     VARCHAR(10) NOT NULL,
    住院号   VARCHAR(10) NOT NULL,
    诊治日期 DATE NOT NULL,
    诊断结果 TEXT,
    PRIMARY KEY (工号, 住院号, 诊治日期),
    FOREIGN KEY (工号) REFERENCES 医生(工号),
    FOREIGN KEY (住院号) REFERENCES 病人(住院号),
    CHECK (入院日期 < 出院日期 OR 出院日期 IS NULL)
);
```

> 参考教材第 159 页例 5.9——CHECK 约束可涉及多记录间约束。例如"入院日期 < 出院日期"保证了数据合理性和完整性。

---

## 六、B+ 树索引与查询优化

### 1. B+ 树（n=3，最多 2 键值/3 指针）

插入序列：8, 3, 12, 5, 15, 1, 9, 20, 7

**（1）最终 B+ 树**

n=3，每节点最多 2 键值 3 指针。⌈3/2⌉=2，叶子分裂时左保留 2 个键值，上提右叶第一个。

| 插入 | 操作 |
|------|------|
| 8,3 | [3,8]（根=叶，2 个满） |
| 12 | [3,8,12] → 3个，**分裂**。左[3,8]，右[12]，上提 12。根: [12] |
| 5 | 5<12→左[3,5,8]→**分裂**。左[3,5]，右[8]，上提 8。根: [8,12] |
| 15 | 15≥12→右[12,15] |
| 1 | 1<8→左[1,3,5]→**分裂**。左[1,3]，右[5]，上提 5。根[5,8,12]→**根分裂**。左[5]，右[12]，上提 8。新根: [8] |
| 9 | 9≥8→右[12]→左子[8]→[8,9] |
| 20 | 20≥8→右[12]→右子[12,15]→[12,15,20]→**分裂**。左[12,15]，右[20]，上提 20 到父[12]→[12,20] |
| 7 | 7<8→左[5]→右子[5]→[5,7] |

最终 B+ 树（3 层）：

```
               [8]
             /     \
          [5]       [12,20]
         /   \      /   |   \
      [1,3] [5,7] [8,9] [12,15] [20]
       叶子    叶子   叶子    叶子    叶子
```

叶子间指针链：叶1→叶2→叶3→叶4→叶5。

**（2）查询键值 9 的 I/O**

1. 根 [8]：9≥8，走右指针
2. 非叶 [12,20]：9<12，走 p1
3. 叶 [8,9]：找到 9，获指针
4. **读数据块本身** ← 千万别漏

**共 4 次 I/O**（3 层树高 + 1 次数据块读取）。

**B+ 树适合范围查询的原因**：叶子节点按顺序链接（兄弟指针），找到下限后沿链表顺序扫描即可，无需回溯。

**（3）定长 vs 变长记录**

| | 定长记录 | 变长记录 |
|:---|:---|:---|
| 存储方式 | 每条记录占固定字节 | 每条长度不同 |
| 定位方式 | 直接计算偏移（第n条=首地址+n×长度） | 需偏移量表记录每条起始位置 |
| 空间效率 | 低（VARCHAR 和 NULL 也占满） | 高 |
| 插入方向 | 追加到尾部空闲处 | 从块尾部向头部推进 |

### 2. 查询优化：IO 代价计算

R: 20000 元组，40 元组/块 → **B_R = 500 块**
S: 1200 元组，30 元组/块 → **B_S = 40 块**
K = 6，外 K-1=5 块，内 1 块

**（1）主键 B+ 树等值查询**

$$\text{代价} = L + 1 = 3 + 1 = 4 \text{ 次}$$

> L=3 为 B+ 树层数（根→中间→叶子），+1 为数据块本身。**千万别漏。**

**（2）嵌套循环连接**

$$\text{总 IO} = B_R + \frac{B_R}{k-1} \times B_S$$

以小表为外表（B_S=40 更小）：
$$= 40 + \frac{40}{5} \times 500 = 40 + 4000 = 4040 \text{ 次}$$

若以 R 为外表：$$500 + \frac{500}{5} \times 40 = 500 + 4000 = 4500 \text{ 次}$$

**选 S 为外表**，代价更小（4040 < 4500）。外表块数小 → 更多块一次装入内存 → 内表读的遍数少。

**（3）排序归并连接**

$$\text{代价} = B_R + B_S = 500 + 40 = 540 \text{ 次}$$

相比嵌套循环（4040 次），节省了约 3500 次 I/O。原因：排序后两表各只读一遍，消除了嵌套循环中内表被反复读的倍数因子。

---

## 七、并发控制与数据库恢复

### 1. 三级模式结构

- **内模式**（存储模式）：数据在磁盘上的物理存储方式
- **模式**（逻辑模式）：全局逻辑结构，一个数据库只有一个
- **外模式**（子模式/用户模式）：面向应用的局部视图，可有多个

两级映射：
- 外模式-模式映射 → 保证**逻辑独立性**
- 模式-内模式映射 → 保证**物理独立性**

### 2. 冲突可串行化判定

调度 S（按时间从上到下）：

分析冲突操作：T1 R(X),W(X) 与 T3 R(X),W(X) 冲突 → T1 先于 T3。T2 R(Y),W(Y) 和 T2 R(Z),W(Z) 可交换聚集。

通过交换非冲突操作，可得到等价串行 **T2 → T1 → T3**。

**该调度是冲突可串行化的。**

### 3. 两段锁协议 & 死锁

**两段锁协议**：扩展阶段（只加锁不释放）+ 收缩阶段（一旦释放不再加锁）。

**能否防死锁**：不能。2PL 保证调度正确性，不防止死锁。

**死锁诊断**：**等待图法**。构建事务等待有向图，出现回路即死锁。解除方法：选代价最小的边撤销（回滚对应事务）。

### 4. 并发调度正确性

T1: R(B), A=B+2, W(A)
T2: R(A), B=A-2, W(B)
初值 A=4, B=4。

两种串行结果：
- 先 T1 后 T2：T1: B=4, A=6；T2: A=6, B=4。结果 A=6, B=4。
- 先 T2 后 T1：T2: A=4, B=2；T1: B=2, A=4。结果 A=4, B=2。

**正确调度示例**：T1 全做再 T2 → (A=6, B=4)
**错误调度示例**：T1 R(B)=4, T2 R(A)=4, T1 W(A)=6, T2 W(B)=2 → (A=6, B=2)。此结果不等价于任何串行 → 错误。

> 错误原因：T1 和 T2 交叉执行，各自读到对方修改前的值，产生不一致结果。

---

