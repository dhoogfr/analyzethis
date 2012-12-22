DECLARE

    l_job   binary_integer;

BEGIN

    dbms_job.submit
        ( job       =>  l_job,
          what      =>  'BEGIN analyzethis.gatherSchemaStats( p_schema => ''DBADMIN'', p_backup => TRUE, p_option => ''AUTO''); END;',
          next_date =>  trunc(sysdate) + 22/24,
          interval  =>  'trunc(sysdate) + 1 + 22/24'
        );
        
        
     dbms_job.submit
        ( job           =>  l_job,
          what          =>  'BEGIN analyzethis.PurgeHistory( p_days => 60, p_rh => TRUE, p_force => FALSE); END;',
          next_date     =>  trunc(sysdate) + 17/24,
          interval      =>  'trunc(sysdate) + 1 + 22/24'
       );
       
     commit;

END;
/