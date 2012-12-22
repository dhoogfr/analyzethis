BEGIN

    dbms_scheduler.create_job
        ( job_name          =>  'ANALYZETHIS.ORAGLIMS_STATS',
          job_type          =>  'PLSQL_BLOCK',
          job_action        =>  'BEGIN analyzethis.GatherSchemaStats(p_schema => ''ORAGLIMS'', p_backup => true, p_option => ''AUTO''); END;',
          start_date        =>  trunc(sysdate) + 22/24,
          repeat_interval   =>  'FREQ=DAILY',
          enabled           =>  TRUE,
          comments          =>  'Gather new statistics on the ORAGLIMS schema'
        );

END;
/

BEGIN

    dbms_scheduler.create_job
        ( job_name          =>  'ANALYZETHIS.JOB_PURGE_HISTORY',
          job_type          =>  'PLSQL_BLOCK',
          job_action        =>  'BEGIN analyzethis.PurgeHistory(p_days => 30, p_rh => true); END;',
          start_date        =>  trunc(sysdate) + 17/24,
          repeat_interval   =>  'FREQ=DAILY',
          enabled           =>  TRUE,
          comments          =>  'removes the statistics history older then 30 days'
        );

END;
/
 

