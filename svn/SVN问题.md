#SVN问题
##cleanup failed–previous operation has not finished; run cleanup if it was interrupted
查询   
sqlite3 .svn/wc.db "select * from work_queue"

删除   
sqlite3 .svn/wc.db "delete from work_queue"