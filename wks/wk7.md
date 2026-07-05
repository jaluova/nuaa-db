## 基本概念

1. 数据
2. 数据库
3. 数据库管理系统

数据库系统的特点：
1. 整体数据的结构化
2. 数据的共享性强，冗余度低且易于扩充
3. 数据的独立性强
4. 数据由数据库管理系统统一管理和控制

## 数据模型

1. 概念模型（信息模型）
	1. 实体
	2. 属性
	3. 码
	4. 实体型
	5. 实体集
	6. 联系
2. 逻辑模型和物理模型
	1. 层次模型
	2. 网状模型
	3. 关系模型

## 三级模式与二级映像

<figure style="text-align: center; margin: 1em 0;">
  <img src="./img/three-schema-architecture.svg" alt="数据库系统三级模式与二级映像示意图" width="760" style="max-width: 100%; height: auto;">
  <figcaption style="margin-top: 0.5em;">数据库系统的三级模式与二级映像</figcaption>
</figure>

1. “型”和“值”
	1. “型”（type）
	2. “值”（value）
2. 模式（schema）
3. 实例（instance）

- 模式：描述数据全局逻辑结构
- 外模式（子模式、用户模式）：描述数据局部逻辑结构
- 内模式：数据物理结构和存储方式的描述

## 关系

1. 域
2. 笛卡尔积
	- $D_1 \times D_2 \times \cdots \times D_n$
3. 关系
	1. 定义：$D_1 \times D_2 \times \cdots \times D_n$的子集叫作在域$D_1 , D_2 , \cdots , D_n$上的关系，表示为$R(D_1 , D_2 , \cdots , D_n)$
	2. 元组：关系中的每个元素，通常用$t$表示
	3. 属性：关系中不同列可以对应相同的域，对每列加以区分，**$n$目关系必有$n$个属性**
4. 三类关系
	1. 基本关系（基本表或基表）：真实存在并实际存储数据的表。比如 student 表真的放在数据库里。
	2. 查询结果：执行 `SELECT` 后临时得到的一张结果表。它只是查询时产生，通常不会长期存着。
	3. 视图表：由基本表或其他视图导出的虚表。一般只存查询定义，不单独存真实数据。
5. 基本关系的性质
	1. 列是同质的（homogeneous），意思是一列里的数据必须是同一类。
	2. 不同的列可出自同一个域 ，域可以理解成“允许取值的范围或类型”。
	3. 列的顺序无所谓，列的次序可以任意交换。
	4. 行的顺序无所谓，行的次序可以任意交换。
	5. 任意两个元组的码不能相同，码就是能唯一标识一条记录的属性或属性组。
	6. 分量必须取原子值，也叫原子性，意思是每个单元格里只能放一个不可再分的值。

## 关系完整性

### 关系完整性规则

- 若属性$A$是基本关系$R$的主属性，则$A$不能取空值
- 空值就是“不知道”或“不存在”或“无意义”的值

### 参照完整性约束

若属性（或属性组）$F$是基本关系$R$的外码，它与基本关系$S$的主码$K_S$像对应(基本关系$R$和$S$不是同一关系)，则对于$R$中每个元组在$F$上的值必须为:
- 或者取空值（$F$的每个属性值均为空值）
- 或者等于$S$中某个元组的主码值

### 用户定义的完整性

数据有约束条件

## 关系代数

1. 常用运算符

<table style="border-collapse: collapse; text-align: center; width: 500px;">
  <tr>
    <th colspan="2" style="border: 1px solid #333; padding: 8px;">运算符</th>
    <th style="border: 1px solid #333; padding: 8px;">含义</th>
  </tr>
  <tr>
    <td rowspan="4" style="border: 1px solid #333; padding: 8px;">集合<br>运算符</td>
    <td style="border: 1px solid #333; padding: 8px;">∪</td>
    <td style="border: 1px solid #333; padding: 8px;">并</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">-</td>
    <td style="border: 1px solid #333; padding: 8px;">差</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">∩</td>
    <td style="border: 1px solid #333; padding: 8px;">交</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">×</td>
    <td style="border: 1px solid #333; padding: 8px;">笛卡儿积</td>
  </tr>
  <tr>
    <td rowspan="4" style="border: 1px solid #333; padding: 8px;">专门的<br>关系<br>运算符</td>
    <td style="border: 1px solid #333; padding: 8px;">σ</td>
    <td style="border: 1px solid #333; padding: 8px;">选择</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">π</td>
    <td style="border: 1px solid #333; padding: 8px;">投影</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">⋈</td>
    <td style="border: 1px solid #333; padding: 8px;">连接</td>
  </tr>
  <tr>
    <td style="border: 1px solid #333; padding: 8px;">÷</td>
    <td style="border: 1px solid #333; padding: 8px;">除</td>
  </tr>
</table>

2. 连接（Join）
	1. 含义：从两个关系的笛卡儿积中，选取满足连接条件的元组，再按需要组成新的关系。
	2. 基本公式：$R \bowtie_{\theta} S = \sigma_{\theta}(R \times S)$
	3. 连接和笛卡儿积的区别：
		1. 笛卡儿积是把两个关系中所有元组两两配对。
		2. 连接是在笛卡儿积的基础上，再筛选出满足条件的元组。
	4. 常见连接
		1. $\theta$连接：连接条件是一般比较条件，如$=,\ >,\ <,\ \ge,\ \le,\ \ne$。
		2. 等值连接：$\theta$连接中，条件只含“=”。
		3. 自然连接：一种特殊的等值连接，要求两个关系中进行比较的属性同名，并且结果中重复属性只保留一份。
	5. 例子
		1. 设学生表$Student(Sno, Sname, Dept)$和选课表$SC(Sno, Cno, Grade)$
		2. 等值连接：$Student \bowtie_{Student.Sno = SC.Sno} SC$
		3. 含义：把学生信息和对应的选课信息按学号配对
		4. 自然连接：$Student \bowtie SC$
		5. 若连接属性同名且含义相同，自然连接结果中只保留一个$Sno$
	6. 连接的作用：把分散在多个关系中的相关数据按条件组合起来，便于查询和分析。

### 关系代数、ALPHA 与 QBE 查询写法总结

下面的例子默认使用 SPJ 数据库：

- $S(SNO,SNAME,STATUS,CITY)$：供应商表
- $P(PNO,PNAME,COLOR,WEIGHT)$：零件表
- $J(JNO,JNAME,CITY)$：工程项目表
- $SPJ(SNO,PNO,JNO,QTY)$：供应情况表

#### 1. 三种语言分别在写什么

1. 关系代数
	1. 偏“操作过程”：先从表中筛选元组，再连接表，最后投影出需要的属性。
	2. 常用模板：$\pi_{\text{输出列}}(\sigma_{\text{筛选条件}}(\text{表或连接结果}))$。
	3. 看到“选择满足条件的行”，用$\sigma$。
	4. 看到“只要某些列”，用$\pi$。
	5. 看到“多个表一起查”，用$\bowtie$。
	6. 看到“没有”，常用“全集 - 不满足条件的集合”。
	7. 看到“全部、至少包含全部”，优先想到除法$\div$。

2. ALPHA
	1. ALPHA 是元组关系演算，写法接近“找出所有满足条件的元组”。
	2. 基本模板：

```text
GET W(输出项) :
  X ∈ 表
  AND 条件
```

	3. 如果需要多张表，就引入多个元组变量：

```text
GET W(X.SNO) :
  X ∈ SPJ AND Y ∈ P
  AND X.PNO = Y.PNO
  AND Y.COLOR = '红'
```

	4. 这里$X$表示$SPJ$中的一行，$Y$表示$P$中的一行，$X.PNO=Y.PNO$表示连接条件。

3. QBE
	1. QBE 是 Query By Example，即“按例查询”。
	2. `P.`表示输出列，例如`P._s`表示输出变量`_s`。
	3. `_p`、`_j`等是示例变量。
	4. 同名变量表示相等，也就是连接条件。
	5. 例如：

```text
SPJ(SNO=P._s, PNO=_p, JNO=J1, QTY= )
P(PNO=_p, PNAME= , COLOR=红, WEIGHT= )
```

	6. 这表示：找出供应工程$J1$且零件颜色为红色的供应商代码。

#### 2. 翻译中文查询的步骤

1. 先确定输出什么。
	1. 输出供应商代码，就是$SNO$。
	2. 输出零件号，就是$PNO$。
	3. 输出工程号，就是$JNO$。
	4. 输出供应商姓名，就是$SNAME$。

2. 再确定需要哪些表。
	1. 只涉及供应关系，一般用$SPJ$。
	2. 涉及供应商姓名、状态、所在城市，用$S$。
	3. 涉及零件名、颜色、重量，用$P$。
	4. 涉及工程名、工程所在城市，用$J$。

3. 再写筛选条件。
	1. 工程$J1$：$JNO='J1'$。
	2. 零件$P1$：$PNO='P1'$。
	3. 红色零件：$COLOR='红'$。
	4. 天津供应商：$S.CITY='天津'$。
	5. 天津工程：$J.CITY='天津'$。

4. 最后补连接条件。
	1. $S$和$SPJ$按$SNO$连接。
	2. $P$和$SPJ$按$PNO$连接。
	3. $J$和$SPJ$按$JNO$连接。

#### 3. 基础例子：单表查询

例1：求供应工程$J1$零件的供应商代码$SNO$。

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1'}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO) :
  X ∈ SPJ
  AND X.JNO = 'J1'
```

QBE：

```text
SPJ(SNO=P._s, PNO= , JNO=J1, QTY= )
```

例2：求供应工程$J1$且供应零件$P1$的供应商代码$SNO$。

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1' \land PNO='P1'}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO) :
  X ∈ SPJ
  AND X.JNO = 'J1'
  AND X.PNO = 'P1'
```

QBE：

```text
SPJ(SNO=P._s, PNO=P1, JNO=J1, QTY= )
```

例3：求供应数量大于$300$的供应商代码和工程号。

关系代数：

$$
\pi_{SNO,JNO}(\sigma_{QTY>300}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO, X.JNO) :
  X ∈ SPJ
  AND X.QTY > 300
```

QBE：

```text
SPJ(SNO=P._s, PNO= , JNO=P._j, QTY=>300)
```

#### 4. 连接查询

例4：求供应工程$J1$的红色零件的供应商代码$SNO$。

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1' \land COLOR='红'}(SPJ \bowtie P))
$$

ALPHA：

```text
GET W(X.SNO) :
  X ∈ SPJ AND Y ∈ P
  AND X.JNO = 'J1'
  AND X.PNO = Y.PNO
  AND Y.COLOR = '红'
```

QBE：

```text
SPJ(SNO=P._s, PNO=_p, JNO=J1, QTY= )
P(PNO=_p, PNAME= , COLOR=红, WEIGHT= )
```

例5：求天津供应商供应过的零件号。

关系代数：

$$
\pi_{PNO}(\sigma_{S.CITY='天津'}(S \bowtie SPJ))
$$

ALPHA：

```text
GET W(X.PNO) :
  X ∈ SPJ AND Y ∈ S
  AND X.SNO = Y.SNO
  AND Y.CITY = '天津'
```

QBE：

```text
S(SNO=_s, SNAME= , STATUS= , CITY=天津)
SPJ(SNO=_s, PNO=P._p, JNO= , QTY= )
```

例6：求供应红色零件的供应商姓名。

关系代数：

$$
\pi_{SNAME}(\sigma_{COLOR='红'}(S \bowtie SPJ \bowtie P))
$$

ALPHA：

```text
GET W(SX.SNAME) :
  SX ∈ S AND X ∈ SPJ AND PX ∈ P
  AND SX.SNO = X.SNO
  AND X.PNO = PX.PNO
  AND PX.COLOR = '红'
```

QBE：

```text
S(SNO=_s, SNAME=P._name, STATUS= , CITY= )
SPJ(SNO=_s, PNO=_p, JNO= , QTY= )
P(PNO=_p, PNAME= , COLOR=红, WEIGHT= )
```

例7：求给天津工程供应零件的供应商代码。

关系代数：

$$
\pi_{SNO}(\sigma_{J.CITY='天津'}(SPJ \bowtie J))
$$

ALPHA：

```text
GET W(X.SNO) :
  X ∈ SPJ AND JX ∈ J
  AND X.JNO = JX.JNO
  AND JX.CITY = '天津'
```

QBE：

```text
SPJ(SNO=P._s, PNO= , JNO=_j, QTY= )
J(JNO=_j, JNAME= , CITY=天津)
```

注意：$S.CITY$表示供应商所在城市，$J.CITY$表示工程所在城市，不能混用。

#### 5. 同时满足多个条件

例8：求同时给工程$J1$和工程$J2$供过货的供应商代码。

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1'}(SPJ)) \cap \pi_{SNO}(\sigma_{JNO='J2'}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO) :
  X ∈ SPJ AND Y ∈ SPJ
  AND X.SNO = Y.SNO
  AND X.JNO = 'J1'
  AND Y.JNO = 'J2'
```

QBE：

```text
SPJ(SNO=P._s, PNO= , JNO=J1, QTY= )
SPJ(SNO=_s,   PNO= , JNO=J2, QTY= )
```

QBE 中两行使用同一个变量`_s`，表示同一个供应商既给$J1$供过货，也给$J2$供过货。

#### 6. “没有”类型查询

例9：求没有给工程$J3$供货的供应商代码。

关系代数：

$$
\pi_{SNO}(S)-\pi_{SNO}(\sigma_{JNO='J3'}(SPJ))
$$

ALPHA：

```text
GET W(SX.SNO) :
  SX ∈ S
  AND NOT EXISTS X (
    X ∈ SPJ
    AND X.SNO = SX.SNO
    AND X.JNO = 'J3'
  )
```

QBE：

```text
S(SNO=P._s, SNAME= , STATUS= , CITY= )
```

条件框：

$$
\neg \exists p,q(SPJ(\_s,p,'J3',q))
$$

例10：求没有使用天津供应商生产的红色零件的工程号。

关系代数：

$$
\pi_{JNO}(J)-\pi_{JNO}(\sigma_{S.CITY='天津' \land P.COLOR='红'}(S \bowtie SPJ \bowtie P))
$$

ALPHA：

```text
GET W(JX.JNO) :
  JX ∈ J
  AND NOT EXISTS X, SX, PX (
    X ∈ SPJ AND SX ∈ S AND PX ∈ P
    AND X.JNO = JX.JNO
    AND X.SNO = SX.SNO
    AND X.PNO = PX.PNO
    AND SX.CITY = '天津'
    AND PX.COLOR = '红'
  )
```

QBE：

```text
J(JNO=P._j, JNAME= , CITY= )
```

条件框：

$$
\neg \exists s,p\big(S(s,\_,\_,'天津') \land P(p,\_,'红',\_) \land SPJ(s,p,\_j,\_)\big)
$$

“没有”题的关键是先确定全集，再减去不符合要求的集合。比如这里全集是所有工程$\pi_{JNO}(J)$，坏集合是“使用过天津供应商生产的红色零件的工程”。

#### 7. “全部”类型查询

例11：求至少使用了与供应商$S1$所供应的全部零件相同零件号的工程号。

关系代数：

$$
\pi_{JNO,PNO}(SPJ) \div \pi_{PNO}(\sigma_{SNO='S1'}(SPJ))
$$

ALPHA：

```text
GET W(JX.JNO) :
  JX ∈ J
  AND NOT EXISTS X (
    X ∈ SPJ
    AND X.SNO = 'S1'
    AND NOT EXISTS Y (
      Y ∈ SPJ
      AND Y.JNO = JX.JNO
      AND Y.PNO = X.PNO
    )
  )
```

QBE：

```text
J(JNO=P._j, JNAME= , CITY= )
```

条件框：

$$
\neg \exists p\big(SPJ('S1',p,\_,\_) \land \neg \exists s,q(SPJ(s,p,\_j,q))\big)
$$

这个题的意思是：对于$S1$供应过的每一种零件$p$，当前工程$j$也必须使用过$p$。所以 ALPHA 和 QBE 常写成“双重否定”：不存在某个$S1$供应的零件$p$，使得当前工程没有使用$p$。

例12：求至少供应了$S1$所供应全部零件的供应商代码。

关系代数：

$$
\pi_{SNO,PNO}(SPJ) \div \pi_{PNO}(\sigma_{SNO='S1'}(SPJ))
$$

ALPHA：

```text
GET W(SX.SNO) :
  SX ∈ S
  AND NOT EXISTS X (
    X ∈ SPJ
    AND X.SNO = 'S1'
    AND NOT EXISTS Y (
      Y ∈ SPJ
      AND Y.SNO = SX.SNO
      AND Y.PNO = X.PNO
    )
  )
```

QBE：

```text
S(SNO=P._s, SNAME= , STATUS= , CITY= )
```

条件框：

$$
\neg \exists p\big(SPJ('S1',p,\_,\_) \land \neg \exists j,q(SPJ(\_s,p,j,q))\big)
$$

#### 8. 常见错误

1. 把供应商城市和工程城市混在一起。
	1. “天津供应商”看$S.CITY$。
	2. “天津工程”看$J.CITY$。

2. 忘记连接需要的表。
	1. 查颜色必须连接$P$，因为$COLOR$在$P$表里。
	2. 查供应商姓名必须连接$S$，因为$SNAME$在$S$表里。
	3. 查工程名必须连接$J$，因为$JNAME$在$J$表里。

3. “没有”题不能只在$SPJ$中直接筛。
	1. $SPJ$只记录已经发生的供应事实。
	2. 如果要查“没有给某工程供货的供应商”，要从全部供应商$\pi_{SNO}(S)$出发，再减去已经供过货的供应商。

4. “全部”题不要简单写成很多个`AND`。
	1. 如果集合不固定，应使用关系代数的除法$\div$。
	2. 在 ALPHA 和 QBE 中，通常使用双重`NOT EXISTS`表达“全部满足”。
