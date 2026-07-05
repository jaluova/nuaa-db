```markdown
3. 考虑下图所示的日志记录，假设开始时 A、B 和 C 的初始值均为 0：
(5分)

| 序号 | 日志 |
| :--- | :--- |
| 1 | T1: Start |
| 2 | T1: Write(A), A=9 |
| 3 | T3: Start |
| 4 | T3: Write(C), C=10 |
| 5 | T1: Write(B), B=11 |
| 6 | T1: Rollback |
| 7 | T3: Write(B), B=12 |
| 8 | T2: Start |
| 9 | T2: Write(A), A=8 |
| 10 | T3: Commit |
| 11 | T2: Write(B), B=7 |
| 12 | T4: Start |
| 13 | T2: Commit |
| 14 | T4: Write(C), C=13 |
| 15 | T4: Write(B), B=15 |

图 日志记录
```
