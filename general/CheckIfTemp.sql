create or replace function 
    CheckIfTemp
        ( p_owner       varchar2,
          p_table_name  varchar2
        )
        RETURN varchar2

IS

    l_isTemp    varchar2(1);

BEGIN

    select temporary
    into l_isTemp
    from dba_tables
    where owner = p_owner
          and table_name = p_table_name;
    
    RETURN l_isTemp;

EXCEPTION
    when no_data_found then
        raise_application_error(-20001, 'Table does not exists');

END;
/
