https://zh.wikipedia.org/zh-tw/ACID

- Atomicity（原子性）：一個事務（transaction）中的所有操作，或者全部完成，或者全部不完成，不會結束在中間某個環節。事務在執行過程中發生錯誤，會被[回滾](https://zh.wikipedia.org/wiki/回滚_(数据管理))（Rollback）到事務開始前的狀態，就像這個事務從來沒有執行過一樣。即，事務不可分割、不可約簡。[[1\]](https://zh.wikipedia.org/zh-tw/ACID#cite_note-acid-1)
- Consistency（一致性）：在事務開始之前和事務結束以後，資料庫的完整性沒有被破壞。這表示寫入的資料必須完全符合所有的預設[約束](https://zh.wikipedia.org/wiki/数据完整性)、[觸發器](https://zh.wikipedia.org/wiki/触发器_(数据库))、[級聯回滾](https://zh.wikipedia.org/wiki/级联回滚)等。[[1\]](https://zh.wikipedia.org/zh-tw/ACID#cite_note-acid-1)
- Isolation（隔離性）：資料庫允許多個並發事務同時對其數據進行讀寫和修改的能力，隔離性可以防止多個事務並發執行時由於交叉執行而導致數據的不一致。事務隔離分為不同級別，包括未提交讀（Read uncommitted）、提交讀（read committed）、可重複讀（repeatable  read）和串行化（Serializable）。[[1\]](https://zh.wikipedia.org/zh-tw/ACID#cite_note-acid-1)
- Durability（持久性）：事務處理結束後，對數據的修改就是永久的，即便系統故障也不會丟失。[[1\]](https://zh.wikipedia.org/zh-tw/ACID#cite_note-acid-1)

