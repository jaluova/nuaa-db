```markdown
1. 在数据库系统中有如下一个调度S，它涉及到3个不同的事务T1、T2和T3。请问调度S是冲突可串行化的吗？给出理由？如果调度S是冲突可串行化的，给出与之等价的一个串行调度序列。（5分）

| T1 | T2 | T3 |
| :---: | :---: | :---: |
| | Read(X) | |
| | Write(X) | |
| Read(X) | | |
| | Read(Y) | |
| Write(X) | | |
| | Write(Y) | |
| Read(Y) | | |
| | | Read(X) |
| Write(Y) | | |
| | | Read(Y) |
| | | Write(Y) |
| | | Write(X) |

图 调度S
```
