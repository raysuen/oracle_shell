CREATE OR REPLACE procedure dropPartitions
(
    t_name varchar2,        --ָ��ɾ�������ı�
    beforedays number       --ָ��ɾ�����֮ǰ������
)
is
  l_date_to_drop DATE DEFAULT (sysdate-beforedays);--��ȡָ����ʱ�䣬����ָɾ������ʱ��֮ǰ��ʱ�䣬to_date('2019-08-11','yyyy-mm-dd');
  l_date_partition        DATE;  --��ȡ��Ӧ��high_valueʱ���ʽ��ֵ
  l_date_str    VARCHAR2(128);  --��ȡ��Ӧ��high_valueֵ
  l_drop_stmt    VARCHAR2(128);  --���ɵĶ�Ӧsql
  CURSOR c_partitions
  IS
    SELECT table_name,partition_name,
      HIGH_VALUE
    FROM all_tab_partitions
    WHERE table_name = t_name and partition_position <> 1;--��ȡ��ر�ķ�����Ϣ ;
BEGIN
  FOR row_ IN c_partitions
  LOOP
    l_date_str    := SUBSTR(row_.HIGH_VALUE,1,128);
    l_date_partition       := to_date(SUBSTR(l_date_str,11,10),'yyyy-mm-dd');
    IF l_date_partition <= l_date_to_drop THEN
      l_drop_stmt := 'alter table '||row_.table_name||' drop partition '||row_.partition_name||' update global indexes';
      --dbms_output.put_line(SUBSTR(l_date_str,11,10));
      --dbms_output.put_line(l_drop_stmt||',    '||l_date_str);
      execute immediate l_drop_stmt;
    END IF;
  END LOOP;
END;
