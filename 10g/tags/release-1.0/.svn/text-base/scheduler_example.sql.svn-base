BEGIN


    dbms_scheduler.create_job
        ( job_name             =>   'ANALYZETHIS.GATHER_STATS',
          job_type             =>   'PLSQL_BLOCK',
          job_action           =>   'analyzethis.GatherSchemaStats( p_schema => ''ASchema'', p_backup => TRUE, p_option => ''AUTO'');',
          start_date           =>   sysdate,
          repeat_interval      =>   'FREQ=DAILY;INTERVAL=1;BYHOUR=6;BYMINUTE=0;BYSECOND=0',
          enabled              =>   TRUE,
          auto_drop            =>   FALSE,
          comments             =>   'This job will gather statistics on the ASchema schema using the analyzethis package'
        );
        
    dbms_scheduler.create_job
        ( job_name             =>   'ANALYZETHIS.ANALYZETHIS_PURGEHISTORY',
          job_type             =>   'PLSQL_BLOCK',
          job_action           =>   'analyzethis.PurgeHistory( p_days => 60, p_rh => TRUE, p_force => FALSE);',
          start_date           =>   sysdate,
          repeat_interval      =>   'FREQ=DAILY;INTERVAL=1;BYHOUR=12;BYMINUTE=0;BYSECOND=0',
          enabled              =>   TRUE,
          auto_drop            =>   FALSE,
          comments             =>   'This job will purge the old backup statistics and run logs'
        );

END;
/
