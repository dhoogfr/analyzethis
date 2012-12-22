
CREATE OR REPLACE
PROCEDURE analyzethis.gatherAll
    ( p_backup      in      boolean     default TRUE
    )

IS
    
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GatherAll </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Gather statistics for all, non dictionary, objects
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/


    
    l_obj_cursor    AnalyzeThis.rfc_statsinput;
    l_log_msg       varchar2(50);

BEGIN

    debug.f('Begin of procedure GatherAll');
    debug.f('  input parameters p_backup: %s', case when p_backup = TRUE then 'TRUE' else 'FALSE' end); 
    
    debug.f('Check if p_backup is true');
    if p_backup
    then
        for r_schemas in
            ( select distinct owner
              from dba_segments
              where owner not in
                        ( select schema
                          from dba_registry
                        )
            )
        loop
            debug.f('Calling procedure analyzethis.BackupSchemaStats');
            debug.f('passing p_schema: %s', r_schemas.owner);
            analyzethis.BackupSchemaStats
                ( p_schema  =>  r_schemas.owner 
                );
            debug.f('Finished calling procedure analyzethis.BackupSchemaStats');
        end loop;
    else
        debug.f('No backup requested');
    end if;
    
    l_log_msg := 'GATHER FULL DB STATS';

    debug.f('Open the l_obj_cursor ref cursor');
    open l_obj_cursor for
        select ownname, objtype, objname, partname, subpartname, 100 confidence
        from ( select owner ownname, 'TABLE' objtype, table_name objname, null partname, null subpartname
               from dba_tables
               union all
               select table_owner ownname, 'TABLE' objtype, table_name objname, partition_name partname, null subpartname
               from dba_tab_partitions
               union all
               select table_owner ownname, 'TABLE' objtype, table_name objname, partition_name partname, subpartition_name subpartname
               from dba_tab_subpartitions
               union all
               select owner ownname, 'INDEX' objtype, index_name objname, null partname, null subpartname
               from dba_indexes
               union all
               select index_owner ownname, 'INDEX' objtype, index_name objname, partition_name partname, null subpartname
               from dba_ind_partitions
               union all
               select index_owner ownname, 'INDEX' objtype, index_name objname, partition_name partname, subpartition_name subpartname
               from dba_ind_subpartitions
             )
        where ownname not in 
                ( select schema
                  from dba_registry
                )
              and ownname != 'SYSTEM'
        order by ownname, objtype desc, objname asc, partname asc nulls first, subpartname asc nulls first;        
    
    debug.f('Calling procedure GatherStats'); 
    analyzethis.GatherStats
        ( p_obj_cursor  =>  l_obj_cursor,
          p_log_message =>  l_log_msg
        );
    debug.f('Finished calling procedure analyzethis.GatherStats');
    
    debug.f('Closing reference cursor l_obj_cursor');
    if l_obj_cursor%ISOPEN
    then
        close l_obj_cursor;
    end if; 

    debug.f('End of procedure GatherAll');

    
END;
/
