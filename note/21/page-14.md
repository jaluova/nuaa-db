第8页（共10页）

| 本题分数 | 10 |
| :--- | :--- |
| 得分 | |

六、查询优化（每小题5分，共10分）

假设关系 StarsIn(movieTitle, movieYear, starName)情况如下：（1）StarsIn 表占了 10 个磁盘块，一次磁盘读取只能读一个磁盘块的数据。（2）平均 1 个 star 出现在 3 个 movie 里，一个 movie 有 3 个 star（3 个 movie/star 记录均散落在表中）。（3）利用 Index 表辅助查询时，对 Index 表需要一次磁盘的读取。
在 StarsIn 上没有索引、只在 starName 上有索引、只在 movieTitle 上有索引、同时在 starName 和 movieTitle 上有索引这 4 种情况下，试分别估算下列查询操作需要多少次磁盘块读取。

1. SELECT movieTitle, movieYear FROM StarsIn WHERE starName=s; （5分）
2. SELECT starName FROM StarsIn WHERE movieTitle=t AND movieYear=y; （5分）
（注：上述查询中的 s、t、y 均为常数）

NUAA Guide
