第10页（共10页）
3. 考虑下图所示的带有检查点的日志记录： （5 分）

| 序号 | 日志 | 序号 | 日志 |
| :--- | :--- | :--- | :--- |
| 1 | T1: Start | 13 | T5: Write(A) |
| 2 | T3: Start | 14 | T2: Commit |
| 3 | T2: Start | 15 | T4: Rollback |
| 4 | T1: Write(A) | 16 | T5: Write(B) |
| 5 | T3: Write(C) | 17 | T8: Start |
| 6 | T1: Rollback | 18 | T6: Write(A) |
| 7 | T3: Commit | 19 | T6: Commit |
| 8 | T2: Write(C) | 20 | Checkpoint |
| 9 | T5: Start | 21 | T8: Write(A) |
| 10 | T7: Start | 22 | T8: Commit |
| 11 | T4: Start | 23 | T7: Write(B) |
| 12 | T6: Start | 24 | T5: Write(C) |

图 日志记录

(1) 如果系统故障发生在 14 之后，说明系统如何进行恢复。

(2) 如果系统故障发生在 21 之后，说明如系统何进行恢复。

NUAA Guide
