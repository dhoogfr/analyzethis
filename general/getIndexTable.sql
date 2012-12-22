create or replace procedure 
    getIndexTable
        ( p_owner       IN      varchar2,
          p_index_name  IN      varchar2,
          p_table_owner OUT     varchar2,
          p_table_name  OUT     varchar2
        )

IS

BEGIN

    select table_owner, table_name
    into p_table_owner, p_table_name
    from dba_indexes
    where owner = p_owner
          and index_name = p_index_name;
    

EXCEPTION
    when no_data_found then
        raise_application_error(-20001, 'Index does not exists');

END;
/
