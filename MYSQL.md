#MySQL��������������

1. Error: 1114 SQLSTATE: HY000 The table '%s' is full
> Error: 1114 SQLSTATE: HY000 (ER_RECORD_FILE_FULL)
Message: The table '%s' is full

���������� memory���Ϳ�����my.cnf���� max_heap_table_size=1024M�������
����������� innodb���������

2. ����������source��������ʱ����ʾ server gone away����������Ϊ����İ�̫С�ˣ��޸�max_allowed_packet����������ز���