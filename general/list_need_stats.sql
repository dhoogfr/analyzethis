create or replace
function list_needs_stats
    ( p_schema      in      varchar2,
      p_gather_sys  in      varchar2
    )
    RETURN dbms_stats.objecttab PIPELINED

IS

    PRAGMA AUTONOMOUS_TRANSACTION;
        
    l_need_stats    dbms_stats.ObjectTab;
    l_gather_sys    boolean;

BEGIN

    if (p_gather_sys = 'TRUE')
    then
        l_gather_sys := TRUE;
    else 
        l_gather_sys := FALSE;
    end if;

    if ( p_schema = '*' )
    then
        dbms_stats.gather_database_stats
            ( options       =>  'LIST AUTO',
              objlist       =>  l_need_stats,
              gather_sys    =>  l_gather_sys
            );
            
    else
        dbms_stats.gather_schema_stats
            ( ownname       =>  p_schema,
              options       =>  'LIST AUTO',
              objlist       =>  l_need_stats
            );
            
    end if;
   
    if l_need_stats.count > 0 
    then
        for i in l_need_stats.first .. l_need_stats.last
        loop
            pipe row(l_need_stats(i));
        end loop;
    end if;

    RETURN;

END;
/
