# 第2章 关系模型
## 一、简答题
1. 试述关系模型的三个组成部分。
2. 简述关系数据语言的特点和分类。
3. 定义并理解下列术语，说明它们之间的联系与区别：
    ① 域，笛卡尔积，关系，元组，属性；
    ② 主码，全码，候选码，外码，主属性、非主属性；
    ③ 关系模式，关系，关系数据库。
4. 举例说明关系模式和关系的区别。
5. 试述关系模型的完整性约束。在参照完整性中，什么情况下外码属性的值可以为空值？
6. 设有一个SPJ数据库，包括4个关系模式S、P、J和SPJ。
    S(SNO,SNAME,STATUS,CITY)；
    P(PNO,PNAME,COLOR,WEIGHT)；
    J(JNO,JNAME,CITY)；
    SPJ(SNO,PNO,JNO,QTY)。

    供应商表S由供应商代码（SNO）、供应商姓名（SNAME）、供应商状态（STATUS）、供应商所在城市（CITY）组成。
    零件表P由零件代码（PNO）、零件名（PNAME）、颜色（COLOR）、重量（WEIGHT）组成。
    工程项目表J由工程项目代码（JNO）、工程项目名（JNAME）、工程项目所在城市（CITY）组成。
    供应情况表SPJ由供应商代码（SNO）、零件代码（PNO）、工程项目代码（JNO）、供应数量（QTY）组成，表示某供应商供应某种零件给某工程项目的数量为QTY。

    今有若干数据如下：

### 表S（供应商表）
| SNO | SNAME | STATUS | CITY |
|-----|-------|--------|------|
| S1  | 精益  | 20     | 天津 |
| S2  | 盛锡  | 10     | 北京 |
| S3  | 东方红| 30     | 北京 |
| S4  | 丰泰盛| 20     | 天津 |
| S5  | 为民  | 30     | 上海 |

### 表P（零件表）
| PNO | PNAME | COLOR | WEIGHT |
|-----|-------|-------|--------|
| P1  | 螺母  | 红    | 12     |
| P2  | 螺栓  | 绿    | 17     |
| P3  | 螺丝刀| 蓝    | 14     |
| P4  | 螺丝刀| 红    | 14     |
| P5  | 凸轮  | 蓝    | 40     |
| P6  | 齿轮  | 红    | 30     |

### 表J（工程项目表）
| JNO | JNAME   | CITY   |
|-----|---------|--------|
| J1  | 三建    | 北京   |
| J2  | 一汽    | 长春   |
| J3  | 弹簧厂  | 天津   |
| J4  | 造船厂  | 天津   |
| J5  | 机车厂  | 唐山   |
| J6  | 无线电厂| 常州   |
| J7  | 半导体厂| 南京   |

### 表SPJ（供应情况表）
| SNO | PNO | JNO | QTY |
|-----|-----|-----|-----|
| S1  | P1  | J1  | 200 |
| S1  | P1  | J3  | 100 |
| S1  | P1  | J4  | 700 |
| S1  | P2  | J2  | 100 |
| S2  | P3  | J1  | 400 |
| S2  | P3  | J2  | 200 |
| S2  | P3  | J4  | 500 |
| S2  | P3  | J5  | 400 |
| S2  | P5  | J1  | 400 |
| S2  | P5  | J2  | 100 |
| S3  | P1  | J1  | 200 |
| S3  | P3  | J1  | 200 |
| S4  | P5  | J1  | 100 |
| S4  | P6  | J3  | 300 |
| S4  | P6  | J4  | 200 |
| S5  | P2  | J4  | 100 |
| S5  | P3  | J1  | 200 |
| S5  | P6  | J2  | 200 |
| S5  | P6  | J4  | 500 |

    试用关系代数、元组关系演算语言ALPHA和域关系演算语言QBE完成如下查询：
    ① 求供应工程J1零件的供应商代码SNO。
    ② 求供应工程J1零件P1的供应商代码SNO。
    ③ 求供应工程J1零件为红色的供应商代码SNO。
    ④ 求没有使用天津供应商生产的红色零件的工程号JNO。
    ⑤ 求至少使用了与供应商S1所供应的全部零件相同零件号的工程号JNO。

### 第6题答案

说明：QBE 中 `P.` 表示输出列，`_p`、`_j` 等表示示例变量，同名变量表示连接条件。

#### ① 求供应工程J1零件的供应商代码SNO

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1'}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO) : X ∈ SPJ AND X.JNO = 'J1'
```

QBE：

SPJ：

| SNO | PNO | JNO | QTY |
|---|---|---|---|
| P._s |  | J1 |  |

结果：$\{S1,S2,S3,S4,S5\}$

#### ② 求供应工程J1零件P1的供应商代码SNO

关系代数：

$$
\pi_{SNO}(\sigma_{JNO='J1' \land PNO='P1'}(SPJ))
$$

ALPHA：

```text
GET W(X.SNO) : X ∈ SPJ AND X.JNO = 'J1' AND X.PNO = 'P1'
```

QBE：

SPJ：

| SNO | PNO | JNO | QTY |
|---|---|---|---|
| P._s | P1 | J1 |  |

结果：$\{S1,S3\}$

#### ③ 求供应工程J1零件为红色的供应商代码SNO

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

SPJ：

| SNO | PNO | JNO | QTY |
|---|---|---|---|
| P._s | _p | J1 |  |

P：

| PNO | PNAME | COLOR | WEIGHT |
|---|---|---|---|
| _p |  | 红 |  |

结果：$\{S1,S3\}$

#### ④ 求没有使用天津供应商生产的红色零件的工程号JNO

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

J：

| JNO | JNAME | CITY |
|---|---|---|
| P._j |  |  |

条件框：

$$
\neg \exists s,p\big(S(s,\_,\_,'天津') \land P(p,\_,'红',\_) \land SPJ(s,p,\_j,\_)\big)
$$

结果：$\{J2,J5,J6,J7\}$

#### ⑤ 求至少使用了与供应商S1所供应的全部零件相同零件号的工程号JNO

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

J：

| JNO | JNAME | CITY |
|---|---|---|
| P._j |  |  |

条件框：

$$
\neg \exists p\big(SPJ('S1',p,\_,\_) \land \neg \exists s,q(SPJ(s,p,\_j,q))\big)
$$

结果：$\{J4\}$

7. 试述等值连接与自然连接的区别和联系。
8. 关系代数的基本运算有哪些？如何用这些基本运算来表示其他运算？
