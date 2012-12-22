CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..AnalyzeThis

IS

/*
  Copyright (C) 2006, 2007  Freek D'Hooge

    This file is part of AnalyzeThis.
    AnalyzeThis is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    AnalyzeThis is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global constants
*/

    g_stattab    constant   varchar2(30) :=  'STATISTICS_HISTORY' ;
    g_ok_msg     constant   varchar2(30) :=  'VALID';
    g_owner                 varchar2(30);  -- owner of this package, used to specify the owner 
                                           -- of the statistics_history table containing the old statistics
                                           -- is set by a call to sys_context('USERENV', 'CURRENT_USER') when this package is loaded

/* END declaration of global constants
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global variables
*/


/*      END declaration of global variables
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN type declarations
*/

    SUBTYPE rec_statoptions is statoptions%rowtype;
    SUBTYPE st_rh_statid is run_history.statid%TYPE;
    SUBTYPE st_rh_calcfailures is run_history.calcfailures%type;
    SUBTYPE st_rh_expfailures is run_history.expfailures%type;
    SUBTYPE st_rhd_statid is run_history_details.statid%TYPE;
    SUBTYPE st_rhd_calc_status is run_history_details.calc_status%type;
    SUBTYPE st_rhd_exp_status is run_history_details.exp_status%type;
    SUBTYPE st_rh_operation is run_history.operation%type;
/*
        END type declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception declaration
*/

    e_invalid_list_option   exception;
    PRAGMA EXCEPTION_INIT(e_invalid_list_option, -20001);

    e_dictionary_schema     exception;
    PRAGMA EXCEPTION_INIT(e_dictionary_schema, -20002);
    
    e_invalid_gather_temp     exception;
    PRAGMA EXCEPTION_INIT(e_invalid_gather_temp, -20003);
            
/*
        END global exception declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception messages declaration
*/

    e_dictionary_schema_msg     constant    varchar2(100) := 'The schema for this object is a dictionary schema';
    e_invalid_list_option_msg   constant    varchar2(100) := 'The option passed must be AUTO, STALE or EMPTY';
    e_invalid_gather_temp_msg   constant    varchar2(100) := 'The option passed must be TRUE or FALSE';

/*
        END global exception messages declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN forward declarations
*/


    PROCEDURE GatherIt
        ( p_statid          in      varchar2,
          p_ownname         in      varchar2,
          p_objtype         in      varchar2,
          p_objname         in      varchar2,
          p_partname        in      varchar2,
          p_subpartname     in      varchar2,
          p_startdate       in      date,
          p_calcfailures    in out  number,
          p_expfailures     in out  number
        );


    PROCEDURE logStartRun
        ( p_statid          in      varchar2,
          p_starttime       in      date,
          p_operation       in      varchar2
        );


    PROCEDURE logEndRun
        ( p_statid          in      varchar2,
          p_endtime         in      date,
          p_calcfailures    in      number,
          p_expfailures     in      number
        );


    FUNCTION GenNewID
        Return st_rh_statid;

    /* This function retrieves the statistics options that will be used for a given object when new statistics for that object will be generated.
       It can be used to check the settings in the statoptions table
         p_ownname:      owner of the object 
         p_objtype:      type of the object (TABLE OR INDEX)
         p_objname:      name of the object
         p_partname:     partname of the object (if applicable)
         p_subpartname:  sub-partname of the object (if applicable)
    */        
    FUNCTION GetStatOptions
        ( p_ownname         IN      varchar2,
          p_objtype         IN      varchar2,
          p_objname         IN      varchar2,
          p_partname        IN      varchar2,
          p_subpartname     IN      varchar2
        )
        RETURN rec_statoptions;

    /* This function checks if the object has been protected against update of the statistics
       For a table it checks if the locked field in the statoptions table has been set
       For an index is also checks if the locked field has been set on the base table for this index
         p_obj_owner:           owner of the object for which the locking must be checked
         p_obj_type:            type of the object for which the locking must be checked (TABLE / INDEX)
         p_obj_name:            name of the object  for which the locking must be checked
         p_obj_part_name:       partition name of the object for which the locking must be checked
         p_obj_subpart_name:    subpartition name of the object for which the locking must be checked
         p_obj_locked:          statoptions.locked field for this object (retrieved via the getStatOptions function)
    */
    FUNCTION isLocked
        ( p_obj_owner           IN      varchar2,
          p_obj_type            IN      varchar2,
          p_obj_name            IN      varchar2,
          p_obj_part_name       IN      varchar2    default NULL,
          p_obj_subpart_name    IN      varchar2    default NULL,
          p_obj_locked          IN      varchar2
        )
        RETURN boolean;

    /* This function checks if the object is part of a dictionary schema.
       It does this by checking if the schema is listed in the dictionary_schemas view,
       which constains the schemas from dba_registry and the 'SYSTEM' schema.
       Returns TRUE if the schema passed is listed in this view
       Returns FALSE if otherwise
         p_schema       the schema to check
    */
/*    FUNCTION isDictionary
        ( p_schema      in      varchar2
        )
        RETURN boolean;
*/

/*
        END forward declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> NeedStatsList </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            This pipelined function returns the list of objects that have
            stale or empty statistics.

            p_schema = for which schema, * for all schema's
            p_option = AUTO, STALE or EMPTY
            p_gather_temp = FALSE | TRUE ; whether or not statistics should be calculated on temporary tables
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 18/02/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> enhanced the exception handling </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 07/03/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> added the p_gather_temp
                </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 21/12/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> enclosed the passed owner, object and partition to the dbms_stats package with '"',
                       to allow non standard names
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION NeedStatsList
        ( p_schema      in      varchar2    default user,               --> name of the schema
          p_option      in      varchar2    default 'AUTO',             --> AUTO, STALE or EMPTY,
          p_gather_temp in      varchar2    default 'FALSE'
        )
        RETURN dbms_stats.objecttab PIPELINED

    IS

        PRAGMA AUTONOMOUS_TRANSACTION;

        l_need_stats            dbms_stats.ObjectTab;
        l_option                varchar2(10);

    BEGIN
    
        debug.f('Begin of pipelined function NeedStatsList');
        debug.f('  input parameter p_schema: %s', p_schema);
        debug.f('  input parameter p_option: %s', p_option);
        debug.f('  input parameters p_gather_temp: %s', p_gather_temp);
        
        -- check if the p_gather_temp parameter is one of 'TRUE', 'FALSE' or NULL
        if nvl(p_gather_temp,'TRUE') not in ('TRUE', 'FALSE')
        then
            raise e_invalid_gather_temp;
        end if;
        
        -- convert the p_option into the correct dbms_stats.options parameter
        if p_option = 'AUTO'
        then
            debug.f('p_option: %s => l_option: %s', p_option, 'LIST AUTO');
            l_option := 'LIST AUTO';
        elsif p_option = 'STALE'
        then
            debug.f('p_option: %s => l_option: %s', p_option, 'LIST STALE');
            l_option := 'LIST STALE';
        elsif p_option = 'EMPTY' 
        then
            debug.f('p_option: %s => l_option: %s', p_option, 'LIST EMPTY');
            l_option := 'LIST EMPTY';
        else
            debug.f('p_option: %s is invalid', p_option);
            raise e_invalid_list_option;
        end if;

        debug.f('Calling procedure dbms_stats.gather_schema_stats to retrieve the objects with empty or stale stats');
        dbms_stats.gather_schema_stats
            ( ownname       =>  '"' || p_schema || '"',
              options       =>  l_option,
              granularity   =>  'ALL',
              cascade       =>  true,
              gather_temp   =>  case when nvl(p_gather_temp, 'TRUE') = 'TRUE' then TRUE else FALSE end,
              objlist       =>  l_need_stats
            );
        debug.f('Finished calling procedure dbms_stats');
        -- if there is at least one object returned, then pipe the rows
        debug.f('if l_need_stats.count: %s > 0', l_need_stats.count);
        if l_need_stats.count > 0
        then
            debug.f('loop through the retrieved records');
            for i in l_need_stats.first .. l_need_stats.last
            loop
                debug.f('Pipe row number %s', i);
                pipe row(l_need_stats(i));
            end loop;
            debug.f('Finished looping through the retrieved records');
        end if;

        debug.f('End of pipelined function NeedStatsList');
        
        RETURN;

    EXCEPTION
        when e_invalid_list_option then
            raise_application_error(SQLCODE, e_invalid_list_option_msg, false);
        when e_invalid_gather_temp then
            raise_application_error(SQLCODE, e_invalid_gather_temp_msg, false);

    END NeedStatsList;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GetStatOptions </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            This function gets the defined statistics options
            for the passed object from the statoptions table
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 08/01/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> changed the inline procedures GetSubpartOpt and GetPartOpt, to correct the ordering of the resultset
                       when a "*" is used in the statoptions table
                </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 13/02/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> changed the inline procedure GetPartOpt to filter out option records where the subpartition field is not null 
                       and the GetOpt procedure to filter out records for which the partition or the subpartition fields are not null.
                       Otherwise if a record exists for the subpartitions and for the partitions of the same object, it would have been possible
                       that the options selected where thos of the subpartition record and not of the partition record.
                       The same is true for partitions and object level options. 
                </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 21/12/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> Changed the sql statements to change the possibility for an empty owner field, with the owner field set to '*'
                       This way it is more consistent with the other options.
                       The statoptions table has to be changed to add a "not null" check to the owner column
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION GetStatOptions
        ( p_ownname         IN      varchar2,
          p_objtype         IN      varchar2,
          p_objname         IN      varchar2,
          p_partname        IN      varchar2,
          p_subpartname     IN      varchar2
        )
        RETURN rec_statoptions
    IS

        l_StatOptions       rec_statoptions;

-- FORWARD DECLARATION OF INLINE MODULES
        PROCEDURE GetSubpartOpt;
        PROCEDURE GetPartOpt;
        PROCEDURE GetOpt;
        PROCEDURE SetDefaultOpt;

-- START OF INLINE MODULES
        -- get the statistics options for a sub-partition
        -- The following table shows which option combination are possible and 
        -- in which order they will be searched for
        -- Owner       Table       Partition       SubPartition
        -- ----------------------------------------------------
        --  A           T           T1              T1_1
        --  A           T           T1              *
        --  A           T           *               *
        --  A           *           *               *
        --  *           NULL        NULL            NULL
        -- If none of these combinations exists then build in defaults will be used
        PROCEDURE GetSubpartOpt

        IS

        BEGIN

            debug.f('Begin of inline procedure GetSubpartOpt');
            
            select *
            into l_StatOptions
            from ( select *
                   from statoptions
                   where ( owner = p_ownname
                           and object_name = p_objname
                           and part_name = p_partname
                           and decode(subpart_name, '*', p_subpartname, subpart_name) = p_subpartname
                           and object_type = p_objtype
                         )
                         or ( owner = p_ownname
                              and object_name = p_objname
                              and decode(part_name, '*', p_partname, part_name) = p_partname
                              and ( subpart_name is null
                                    or subpart_name = '*'
                                  )
                              and object_type = p_objtype
                            )
                         or ( owner = p_ownname
                              and object_name = p_objname
                              and part_name is null
                              and subpart_name is null
                              and object_type = p_objtype
                            )
                         or ( owner = p_ownname
                              and object_name is null
                              and part_name is null
                              and subpart_name is null
                              and object_type = p_objtype
                            )
                         or ( owner = '*'
                              and object_name is null
                              and part_name is null
                              and subpart_name is null
                              and object_type = p_objtype
                            )
                   order by decode (owner, '*', 2, 1), owner nulls last, object_name nulls last,
                            decode (nvl(part_name,'*'), '*', 2, 1), 
                            part_name desc nulls last, 
                            decode (nvl(subpart_name,'*'), '*', 2, 1), 
                            subpart_name desc nulls last 
                 )
            where rownum = 1;
            
            debug.f('End of inline procedure GetSubpartOpt');
            
        EXCEPTION
            when no_data_found then
                debug.f('Exception; no_data_found');
                debug.f('Calling procedure SetDefaultOpt');
                SetDefaultOpt;
                debug.f('Finished procedure SetDefaultOpt');

        END GetSubpartOpt;

        -- get the statistics options for a given partition
        -- The following table shows which option combination are possible and 
        -- in which order they will be searched for
        -- Owner       Table       Partition       SubPartition
        -- ----------------------------------------------------
        -- A           T           T1              NULL        
        -- A           T           *               NULL        
        -- A           *           *               NULL        
        -- *           NULL        NULL            NULL        
        -- If none of these combinations exists then build in defaults will be used
        PROCEDURE GetPartOpt

        IS

        BEGIN

            debug.f('Begin of inline procedure GetpartOpt');
            
            select *
            into l_StatOptions
            from ( select *
                   from statoptions
                   where ( owner = p_ownname
                           and object_name = p_objname
                           and decode(part_name,'*', p_partname, part_name) = p_partname
                           and object_type = p_objtype
                           and subpart_name is null
                         )
                         or ( owner = p_ownname
                              and object_name = p_objname
                              and part_name is null
                              and object_type = p_objtype
                              and subpart_name is null
                            )
                         or ( owner = p_ownname
                              and object_name is null
                              and part_name is null
                              and object_type = p_objtype
                              and subpart_name is null
                            )
                         or ( owner = '*'
                              and object_name is null
                              and part_name is null
                              and object_type = p_objtype
                              and subpart_name is null
                            )
                   order by decode (owner, '*', 2, 1), owner nulls last, object_name nulls last,
                            decode (nvl(part_name,'*'), '*', 2, 1), part_name desc nulls last
                 )
            where rownum = 1;
            
            debug.f('End of inline procedure GetpartOpt');

        EXCEPTION
            when no_data_found then
                debug.f('Exception; no_data_found');
                debug.f('Calling procedure SetDefaultOpt');
                SetDefaultOpt;
                debug.f('Finished procedure SetDefaultOpt');

        END GetPartOpt;

        -- get the statistics options for a given object
        -- The following table shows which option combination are possible and 
        -- in which order they will be searched for
        -- Owner       Table       Partition       SubPartition
        -- ----------------------------------------------------
        -- A           T           NULL            NULL        
        -- A           *           NULL            NULL        
        -- *           NULL        NULL            NULL        
        -- If none of these combinations exists then build in defaults will be used
        PROCEDURE GetOpt

        IS

        BEGIN

            debug.f('Begin of inline procedure GetOpt');

            select *
            into l_StatOptions
            from ( select *
                   from statoptions
                   where ( owner = p_ownname
                           and object_name = p_objname
                           and object_type = p_objtype
                           and subpart_name is null
                           and part_name is null
                         )
                         or ( owner = p_ownname
                              and object_name is null
                              and object_type = p_objtype
                              and subpart_name is null
                              and part_name is null
                            )
                         or ( owner = '*'
                              and object_name is null
                              and object_type = p_objtype
                              and subpart_name is null
                              and part_name is null
                            )
                   order by decode (owner, '*', 2, 1), owner nulls last, object_name nulls last
                 )
            where rownum = 1;
            
            debug.f('End of inline procedure GetOpt');

        EXCEPTION
            when no_data_found then
                debug.f('Exception; no_data_found');
                debug.f('Calling procedure SetDefaultOpt');
                SetDefaultOpt;
                debug.f('Finished procedure SetDefaultOpt');

        END GetOpt;

        -- Set hardcoded default options
        -- This procedure is only called when no statistics options could
        -- be found by the GetOpt, GetPartOpt or GetSubpartOpt procedures.
        -- But normally there should always be a database level default record
        -- in the statoptions table
        PROCEDURE SetDefaultOpt

        IS

        BEGIN

            debug.f('Begin of inline procedure SetDefaultOpt');

            l_StatOptions.locked            :=  'FALSE';
            l_StatOptions.auto_sample_size  :=  'FALSE';
            l_StatOptions.estimate_percent  :=  NULL;
            l_StatOptions.block_sample      :=  'FALSE';
            l_StatOptions.method_opt        :=  'FOR ALL COLUMNS SIZE 1';
            l_StatOptions.default_degree    :=  'FALSE';
            l_StatOptions.degree            :=  NULL;
            l_StatOptions.granularity       :=  'DEFAULT';
            l_StatOptions.cascade           :=  'FALSE';
            l_StatOptions.no_invalidate     :=  'FALSE';

            debug.f('End of inline procedure SetDefaultOpt');

        END SetDefaultOpt;

-- START OF MAIN PROGRAM HERE
    BEGIN
        debug.f('Begin of function GetStatOptions');
        debug.f('  input parameter p_ownname: %s', p_ownname);
        debug.f('  input parameter p_objtype: %s', p_objtype);
        debug.f('  input parameter p_objname: %s', p_objname);
        debug.f('  input parameter p_partname: %s', p_partname);
        debug.f('  input parameter p_subpartname: %s', p_subpartname);

        if p_subpartname is not null
        then
            debug.f('Calling inline procedure GetSubpartOpt');
            GetSubpartOpt;
            debug.f('Finished inline procedure GetSubpartOpt');
        elsif p_partname is not null
        then
            debug.f('Calling inline procedure GetPartOpt');
            GetPartOpt;
            debug.f('Finished inline procedure GetpartOpt');
        else
            debug.f('Calling inline procedure GetOpt');
            GetOpt;
            debug.f('Finished inline procedure GetOpt');
        end if;
        
        debug.f('Returning l_StatOptions');
        debug.f('  l_StatOptions.locked: %s',l_StatOptions.locked);
        debug.f('  l_StatOptions.auto_sample_size: %s',l_StatOptions.auto_sample_size);
        debug.f('  l_StatOptions.estimate_percent: %s',l_StatOptions.estimate_percent);
        debug.f('  l_StatOptions.block_sample: %s',l_StatOptions.block_sample);
        debug.f('  l_StatOptions.method_opt: %s',l_StatOptions.method_opt);
        debug.f('  l_StatOptions.default_degree: %s',l_StatOptions.default_degree);
        debug.f('  l_StatOptions.degree: %s',l_StatOptions.degree);
        debug.f('  l_StatOptions.granularity: %s',l_StatOptions.granularity);
        debug.f('  l_StatOptions.cascade: %s',l_StatOptions.cascade);
        debug.f('  l_StatOptions.no_invalidate: %s',l_StatOptions.no_invalidate);
        debug.f('End of function GetStatOptions');
        RETURN l_StatOptions;

    END GetStatOptions;
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> logStartRun </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Logs the start of a statistics run
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE logStartRun
        ( p_statid          in      varchar2,
          p_starttime       in      date,
          p_operation       in      varchar2
        )
    IS
    
    BEGIN
    
        debug.f('Begin of procedure logStartRun');
        debug.f('  input parameter p_statid: %s', p_statid);
        debug.f('  input parameter p_starttime: %s', to_char(p_starttime, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f('  input parameter p_operation: %s', p_operation);
        
        debug.f('inserting new record in run_history');
        insert into run_history
            ( statid, starttime, operation)
        values ( p_statid, p_starttime, p_operation);
        debug.f('inserted %s records', SQL%ROWCOUNT);
        
        debug.f('committing insert');
        commit;
        
        debug.f('End of procedure logStartRun');
    
    END logStartRun;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> logEndRun </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Logs the start of a statistics run
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE logEndRun
        ( p_statid          in      varchar2,
          p_endtime         in      date,
          p_calcfailures    in      number,
          p_expfailures     in      number
        )
    IS
    
    BEGIN
    
        debug.f('Begin of procedure logEndRun');
        debug.f('  input parameter p_statid: %s', p_statid); 
        debug.f('  input parameter p_endtime %s', to_char(p_endtime, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f('  input parameter p_calcfailures: %s', p_calcfailures);
        debug.f('  input parameter p_expfailures: %s', p_expfailures);

        
        debug.f('updating run_history');
        update run_history
        set endtime = p_endtime,
            calcfailures = p_calcfailures,
            expfailures = p_expfailures
        where statid = p_statid;
        debug.f('updated %s records', SQL%ROWCOUNT);
        
        debug.f('committing update');
        commit;
        
        debug.f('End of procedure logEndRun');
        
    END logEndRun;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> BackupSchemaStats </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Backup the existing statistics of a schema before 
            generating new statistics on an object in that schema
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 21/12/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> enclosed the passed owner, object and partition to the dbms_stats package with '"',
                       to allow non standard names
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE BackupSchemaStats
        ( p_schema          in      varchar2
        )
    IS
    
        l_statid        st_rh_statid;
        l_log_msg       varchar2(50);
    
    BEGIN
    
        debug.f('Begin of procedure BackupSchemaStats');
        debug.f('  input parameter p_schema: %s', p_schema);
        
        l_log_msg := 'BACKUP SCHEMA STATS - ' || p_schema; 

        -- get a new statid
        debug.f('Calling function GenNewID');
        l_statid := GenNewID;
        debug.f('Finished calling GenNewID');
        debug.f('retrieved statid %s', l_statid);
        
        -- log the start of the backup run
        debug.f('calling procedure logStartRun');
        debug.f('  p_statid: %s', l_statid);
        debug.f('  p_starttime: %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI;SS'));
        debug.f('  l_log_msg: %s', l_log_msg);
        debug.f('  p_schema: %s', p_schema); 
        logStartRun
            ( p_statid          =>      l_statid,
              p_starttime       =>      sysdate,
              p_operation       =>      l_log_msg
            );
        
        BEGIN
        
            -- backup the old statistics
            debug.f('Calling procedure dbms_stats.export_schema_stats');
            debug.f('  ownname: %s', p_schema);
            debug.f('  statown: %s', g_owner);
            debug.f('  stattab: %s', g_stattab);
            debug.f('  statid:  %s', l_statid);
            dbms_stats.export_schema_stats
                ( ownname   =>      '"' || p_schema || '"',
                  statown   =>      g_owner,
                  stattab   =>      g_stattab,
                  statid    =>      l_statid
                );
            debug.f('Finished calling procedure dbms_stats.export_schema_stats');
        
        EXCEPTION
            when others then
                debug.f('Exception occured during the backup of the statistics: %s - %s', SQLCODE, SQLERRM);
                -- log the end of the backup statistics
                debug.f('Calling procedure logEndRun with errors');
                debug.f(' p_statid: %s', l_statid);
                debug.f(' p_endtime: %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
                debug.f(' p_calcfailures: 0');
                debug.f(' p_expfailures: 1');
                logEndRun
                    ( p_statid          =>      l_statid,
                      p_endtime         =>      sysdate,
                      p_calcfailures    =>      0,
                      p_expfailures     =>      1
                    );
                debug.f('Finished calling procedure logEndRun');
                --rereaise the problem
                debug.f('reraising the problem');
                
                raise;
        END;
              
        -- log the end of the backup run
        debug.f('Calling procedure logEndRun');
        debug.f(' p_statid: %s', l_statid);
        debug.f(' p_endtime; %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f(' p_calcfailures: 0');
        debug.f(' p_expfailures: 0');
        logEndRun
            ( p_statid          =>      l_statid,
              p_endtime         =>      sysdate,
              p_calcfailures    =>      0,
              p_expfailures     =>      0
            );
        debug.f('Finished calling procedure logEndRun');

        debug.f('End of procedure BackupSchemaStats');
        
    END BackupSchemaStats;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GatherObjStats </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Gather statistics for a given object
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 18/02/2007 </DATE>
                <AUTHOR> Freek D' Hooge </AUTHOR>
                <WHAT> added a check to verify if the object's schema is a dictionary schema or not 
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE GatherObjStats
        ( p_object_type     in      varchar2,                      -- object type, either TABLE or INDEX
          p_owner           in      varchar2,                      -- owner of the object
          p_object_name     in      varchar2,                      -- the object name
          p_part_name       in      varchar2    default NULL,      -- the partname of the object (if applicable)
          p_subpart_name    in      varchar2    default NULL,      -- the subpart name of the object (if applicable)
          p_backup          in      boolean     default TRUE       -- if the current statistics of all objects of p_owner must backed up or not
        )
    IS
    
        l_obj_cursor    AnalyzeThis.rfc_statsinput;    
        l_log_msg       st_rh_operation;

    BEGIN

        debug.f('Begin of procedure GatherObjStats');
        debug.f('  input parameters p_object_type: %s', p_object_type);
        debug.f('  input parameters p_owner: %s', p_owner);
        debug.f('  input parameters p_object_name: %s', p_object_name);
        debug.f('  input parameters p_part_name: %s', p_part_name);
        debug.f('  input parameters p_subpart_name: %s', p_subpart_name);
        debug.f('  input parameters p_backup: %s', case when p_backup = TRUE then 'TRUE' else 'FALSE' end); 
/*        
        debug.f('check if the object is not part of a dictionary schema');
        if isDictionary(p_owner) then
            debug.f('The object is part of a dictionary schema, raising e_dictionary_schema');
            raise e_dictionary_schema;
        end if;
*/
        debug.f('Check if p_backup is true');
        if p_backup
        then
            debug.f('Calling procedure BackupSchemaStats');
            debug.f('passing p_schema: %s', p_owner);
            BackupSchemaStats
                ( p_schema  =>  p_owner
                );
            debug.f('Finished calling procedure BackupSchemaStats');
        else
            debug.f('No backup requested');
        end if;
        
        select 'GATHER OBJ STATS - ' || p_owner || '.' || p_object_name || nvl2(p_part_name, '.' || p_part_name, '') 
               || nvl2(p_subpart_name, '.' || p_subpart_name, '')
        into l_log_msg
        from dual;

        debug.f('Open the l_obj_cursor ref cursor');
        open l_obj_cursor for
            select p_owner as ownname, p_object_type as objtype, p_object_name as objname, p_part_name as partname, 
                   p_subpart_name as subpartname, 100 as confidence
            from dual;
        
        debug.f('Calling procedure GatherStats'); 
        GatherStats
            ( p_obj_cursor  =>  l_obj_cursor,
              p_log_message =>  l_log_msg
            );
        debug.f('Finished calling procedure GatherStats');
        
        debug.f('Closing reference cursor l_obj_cursor');
        if l_obj_cursor%ISOPEN
        then
            close l_obj_cursor;
        end if; 

        debug.f('End of procedure GatherObjStats');
        
    EXCEPTION
        when e_dictionary_schema then
            raise_application_error(SQLCODE, e_dictionary_schema_msg, false);
        
    END GatherObjStats;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GatherSchemaStats </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Gather statistics for the objects in the given schema,
            for which the statistics are stale or empty
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 18/02/2007 </DATE>
                <AUTHOR> Freek D' Hooge </AUTHOR>
                <WHAT> added a check to verify if the object's schema is a dictionary schema or not 
                </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 07/03/2007 </DATE>
                <AUTHOR> Freek D' Hooge </AUTHOR>
                <WHAT> added the p_gather_temp parameter 
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE GatherSchemaStats
        ( p_schema      in  varchar2,
          p_backup      in  boolean     default TRUE,
          p_option      in  varchar2    default 'AUTO',
          p_GatherTemp  in  boolean     default FALSE
        )
    IS
    
        l_obj_cursor    AnalyzeThis.rfc_statsinput;
        l_log_msg       varchar2(50);
        l_GatherTemp   varchar2(5);

    BEGIN

        debug.f('Begin of procedure GatherSchemaStats');
        debug.f('  input parameters p_schema: %s', p_schema);
        debug.f('  input parameters p_backup: %s', case when p_backup = TRUE then 'TRUE' else 'FALSE' end);
        debug.f('  input parameters p_option: %s', p_option);
        debug.f('  input parameters p_GatherTemp: %s', case when p_GatherTemp = TRUE then 'TRUE' else 'FALSE' end); 
        
        --convert the p_gather_temp boolean to a string
        l_GatherTemp := case when p_GatherTemp = TRUE then 'TRUE' else 'FALSE' end;
/*
        debug.f('check if the object is not part of a dictionary schema');
        if isDictionary(p_schema) then
            debug.f('The object is part of a dictionary schema, raising e_dictionary_schema');
            raise e_dictionary_schema;
        end if;
*/        
        debug.f('Check if p_backup is true');
        if p_backup
        then
            debug.f('Calling procedure BackupSchemaStats');
            debug.f('passing p_schema: %s', p_schema);
            BackupSchemaStats
                ( p_schema  =>  p_schema 
                );
            debug.f('Finished calling procedure BackupSchemaStats');
        else
            debug.f('No backup requested');
        end if;
        
        l_log_msg := 'GATHER SCHEMA STATS - ' || p_schema;

        debug.f('Open the l_obj_cursor ref cursor');
        -- don't use * in the query below as it oracle will throw an ORA-22905: cannot access rows from a non-nested table item
        open l_obj_cursor for
            select ownname, objtype, objname, partname, subpartname, confidence
            from table(AnalyzeThis.NeedStatsList(p_schema, p_option, l_GatherTemp))
            order by ownname, objtype desc, objname asc, partname asc nulls first, subpartname asc nulls first;
            
        debug.f('Calling procedure GatherStats'); 
        GatherStats
            ( p_obj_cursor  =>  l_obj_cursor,
              p_log_message =>  l_log_msg
            );
        debug.f('Finished calling procedure GatherStats');
        
        debug.f('Closing reference cursor l_obj_cursor');
        if l_obj_cursor%ISOPEN
        then
            close l_obj_cursor;
        end if; 

        debug.f('End of procedure GatherSchemaStats');

    EXCEPTION
        when e_dictionary_schema then
            raise_application_error(SQLCODE, e_dictionary_schema_msg, false);
        
    END GatherSchemaStats;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> genNewID </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Generate a new id
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION GenNewID
        Return st_rh_statid 
        
    IS
    
        l_statid    st_rh_statid;

    BEGIN

        debug.f('Begin of function GetNewID');

        -- get a new statid
        debug.f('get a new id from seq_statid');
        select seq_statid.nextval
        into l_statid
        from dual;
        debug.f('retrieved statid %s', l_statid);
        
        -- add a character to the given statid, because the export 
        -- procedures in dbms_stats gives an error if a pure number
        -- is passed as statid
        debug.f('add a character to the statid');
        l_statid := 'A' || l_statid;
                
        debug.f('End of function GetNewID');
        debug.f('  Returning l_statid: %s', l_statid);
        RETURN l_statid;

    END GenNewID;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GatherStats </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Gather statistics for the objects in the passed reference cursors
            One cursor is for the tables, the other for the indexes
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 14/02/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT>  Moved the check if the object already has been analyzed during the current analyze run 
                        from the gatherstats procedure to the gatherit procedure.
                        This way the skipping of objects because they are already analyzed 
                        (because of the cascade and granularity parameter), can be logged
                        in the run_history_details   
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE GatherStats
        ( p_obj_cursor   in out     rfc_statsinput,
          p_log_message  in         varchar2
        )

    IS

        l_statid                    st_rhd_statid;
        l_startdate                 date;
        l_calcfailures              st_rh_calcfailures;
        l_expfailures               st_rh_expfailures;
        l_obj                       dbms_stats.ObjectElem;

-- FORWARD DECLARATION OF INLINE MODULES
        PROCEDURE CheckCursor;

-- START OF INLINE MODULES
        -- check if the cursors are open,
        -- return an error if not.
        PROCEDURE CheckCursor

        IS

        BEGIN
            
            debug.f('Begin of inline procedure checkCursor');

            debug.f('Check if the p_obj_cursor is open');
            if not p_obj_cursor%ISOPEN
            then
                debug.f('The p_obj_cursor was not open');
                raise INVALID_CURSOR;
            end if;

            debug.f('End of inline procedure checkCursor');
            
        END checkCursor;


-- START OF MAIN PROGRAM HERE

    BEGIN

        debug.f('Begin of procedure GatherStats');

        -- get a new statid
        debug.f('Calling function GenNewID');
        l_statid := GenNewID;
        debug.f('Finished calling GenNewID');
        debug.f('retrieved statid %s', l_statid);

        -- initilize variables
        debug.f('initializing variables');
        l_calcfailures      := 0;
        l_expfailures       := 0;
        l_startdate         := sysdate;   
             
        --check if the passed cursor is open
        debug.f('Calling inline procedure checkCursor');
        checkCursor;
        debug.f('Finished calling inline procedure checkCursor');

        -- log the start of the new statistics run
        debug.f('calling procedure logStartRun');
        debug.f('  p_statid: %s', l_statid);
        debug.f('  p_starttime: %s', to_char(l_startdate, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f('  p_operation: %s', p_log_message); 
        logStartRun
            ( p_statid          =>      l_statid,
              p_starttime       =>      l_startdate,
              p_operation       =>      p_log_message
            );

        -- loop through the objects in the p_obj_cursor
        debug.f('Start looping through the objects in the p_obj_cursor');
        loop 

            fetch p_obj_cursor
            into l_obj;
            
            exit when p_obj_cursor%NOTFOUND;
            
            debug.f('Calling procedure GatherIt');
            debug.f('  p_statid: %s', l_statid);
            debug.f('  l_stardate: %s', l_startdate);
            debug.f('  p_ownname: %s', l_obj.ownname);
            debug.f('  p_objtype: %s', l_obj.objtype);
            debug.f('  p_objname: %s', l_obj.objname);
            debug.f('  p_partname: %s', l_obj.partname);
            debug.f('  p_subpartname: %s', l_obj.subpartname);
            debug.f('  l_calcfailures: %s', l_calcfailures);
            debug.f('  l_expfailures: %s', l_expfailures);
            GatherIt
                ( p_statid          =>  l_statid,
                  p_ownname         =>  l_obj.ownname,
                  p_objtype         =>  l_obj.objtype,
                  p_objname         =>  l_obj.objname,
                  p_partname        =>  l_obj.partname,
                  p_subpartname     =>  l_obj.subpartname,
                  p_startdate       =>  l_startdate,
                  p_calcfailures    =>  l_calcfailures,
                  p_expfailures     =>  l_expfailures
                );
            debug.f('Finished calling procedure GatherIt');
            debug.f('  l_calcfailures: %s', l_calcfailures);
            debug.f('  l_expfailures: %s', l_expfailures);
            
        end loop;
        debug.f('Finished looping through the objects in the p_obj_cursor');
        
        -- log the end of the statistics run
        debug.f('Calling procedure logEndRun');
        debug.f(' p_statid: %s', l_statid);
        debug.f(' p_endtime; %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f(' p_calcfailures: %s', l_calcfailures);
        debug.f(' p_expfailures: %s', l_expfailures);
        logEndRun
            ( p_statid          =>      l_statid,
              p_endtime         =>      sysdate,
              p_calcfailures    =>      l_calcfailures,
              p_expfailures     =>      l_expfailures
            );
        debug.f('Finished calling procedure logEndRun');
        
        debug.f('End of procedure GatherStats');

    END GatherStats;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> isLocked </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            checks if a table or index has been locked against statistic updates
            In case of a table it just checks the locked field in the statoptions table
            In case of an index it also checks on if the table on which the index was created is locked
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION isLocked
        ( p_obj_owner           IN      varchar2,
          p_obj_type            IN      varchar2,
          p_obj_name            IN      varchar2,
          p_obj_part_name       IN      varchar2    default NULL,
          p_obj_subpart_name    IN      varchar2    default NULL,
          p_obj_locked          IN      varchar2
        )
        RETURN boolean

    IS
    
        l_locked                    boolean;
        l_tab_owner                 varchar2(30);
        l_tab_name                  varchar2(30);
        l_tab_part_name             varchar2(30);
        l_tab_subpart_name          varchar2(30);
        l_statoptions               rec_statoptions;
    
    BEGIN
    
        debug.f('Begin of procedure isLocked');
        debug.f('  input param p_obj_owner: %s', p_obj_owner);
        debug.f('  input param p_obj_type: %s', p_obj_type);
        debug.f('  input param p_obj_name: %s', p_obj_name);
        debug.f('  input param p_obj_part_name: %s', p_obj_part_name);
        debug.f('  input param p_obj_subpart_name: %s', p_obj_subpart_name);
        debug.f('  input param p_obj_locked: %s', p_obj_locked);
        
        -- initialize the variabelen
        l_locked := FALSE;
        
        debug.f('If p_obj_locked: %s = ''TRUE''', p_obj_locked);
        if p_obj_locked = 'TRUE'
        then
            debug.f('Object is locked');
            l_locked := TRUE;
        elsif p_obj_type = 'INDEX'
        then
        
            debug.f('Object itself is not locked, but object type is INDEX, so check the base table');
        -- get the info on the base table of this index
            debug.f('Calling procedure getIndexTable.getTableInfo');
            debug.f('  p_ind_owner: %s', p_obj_owner);
            debug.f('  p_obj_name: %s', p_obj_name);
            debug.f('  p_obj_part_name: %s', p_obj_part_name);
            debug.f('  p_obj_subpart_name: %s', p_obj_subpart_name);
            getIndexTable.getTableInfo
                ( p_ind_owner           =>  p_obj_owner,
                  p_ind_name            =>  p_obj_name,
                  p_ind_part_name       =>  p_obj_part_name,
                  p_ind_subpart_name    =>  p_obj_subpart_name,
                  p_tab_owner           =>  l_tab_owner,
                  p_tab_name            =>  l_tab_name,
                  p_tab_part_name       =>  l_tab_part_name,
                  p_tab_subpart_name    =>  l_tab_subpart_name
                );
            debug.f('Finished calling procedure getIndexTable.getTableInfo');
            debug.f(' p_tab_owner: %s', l_tab_owner);
            debug.f(' p_tab_name: %s', l_tab_name);
            debug.f(' p_tab_part_name: %s', l_tab_part_name);
            debug.f(' p_tab_subpart_name: %s', l_tab_subpart_name);
        
        -- get the statoptions for the retrieved base table
            debug.f('Calling function GetStatOptions, passing values');
            debug.f('  p_ownname: %s', l_tab_owner);
            debug.f('  p_objtype: TABLE');
            debug.f('  p_objname: %s', l_tab_name);
            debug.f('  p_partname: %s', l_tab_part_name);
            debug.f('  p_subpartname: %s', l_tab_subpart_name);
            l_statoptions := getStatOptions
                                ( p_ownname     =>  l_tab_owner,
                                  p_objtype     =>  'TABLE',
                                  p_objname     =>  l_tab_name,
                                  p_partname    =>  l_tab_part_name,
                                  p_subpartname =>  l_tab_subpart_name
                                );
            debug.f('Finished calling function getStatOptions, retrieving l_StatOptions');
            debug.f('  l_StatOptions.locked: %s',l_StatOptions.locked);
            debug.f('  l_StatOptions.auto_sample_size: %s',l_StatOptions.auto_sample_size);
            debug.f('  l_StatOptions.estimate_percent: %s',l_StatOptions.estimate_percent);
            debug.f('  l_StatOptions.block_sample: %s',l_StatOptions.block_sample);
            debug.f('  l_StatOptions.method_opt: %s',l_StatOptions.method_opt);
            debug.f('  l_StatOptions.default_degree: %s',l_StatOptions.default_degree);
            debug.f('  l_StatOptions.degree: %s',l_StatOptions.degree);
            debug.f('  l_StatOptions.granularity: %s',l_StatOptions.granularity);
            debug.f('  l_StatOptions.cascade: %s',l_StatOptions.cascade);
            debug.f('  l_StatOptions.no_invalidate: %s',l_StatOptions.no_invalidate);
        
        -- check if the base table has been locked
            debug.f('If l_statoptions.locked: %s = ''TRUE''', l_statoptions.locked);
            if l_statoptions.locked = 'TRUE'
            then
                debug.f('Index has been locked through its base table');
                l_locked := TRUE;
            end if;
        
        end if;
        
        debug.f('End of function isLocked');
        debug.f('  Returning l_locked: %s', case when l_locked = TRUE then 'TRUE' else 'FALSE' end);
        return l_locked;
        
    
    END isLocked;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> GatherIt </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            This module is responsible for the actual gathering of the
            statistics, as well as the backup and  the logging of the start
            and end time of the gathering. Together with this, it will log the
            used options and the result status.
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> 14/02/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT>  Moved the check if the object already has been analyzed during the current analyze run 
                        from the gatherstats procedure to the gatherit procedure.
                        This way the skipping of objects because they are already analyzed 
                        (because of the cascade and granularity parameter), can be logged
                        in the run_history_details   
                </WHAT>
            </MODIFICATION>
            <MODIFICATION>
                <DATE> 21/12/2007 </DATE>
                <AUTHOR> Freek D'Hooge </AUTHOR>
                <WHAT> enclosed the passed owner, object and partition to the dbms_stats package with '"',
                       to allow non standard names
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE GatherIt
        ( p_statid          in      varchar2,
          p_ownname         in      varchar2,
          p_objtype         in      varchar2,
          p_objname         in      varchar2,
          p_partname        in      varchar2,
          p_subpartname     in      varchar2,
          p_startdate       in      date,
          p_calcfailures    in out  number,
          p_expfailures     in out  number
        )

    IS

        l_StatOptions     rec_statoptions;
        l_calc_status     st_rhd_calc_status;
        l_exp_status      st_rhd_exp_status;

-- FORWARD DECLARATION OF INLINE MODULES
        PROCEDURE BackupPostStats;
        PROCEDURE CalcStats;
        PROCEDURE LogStart;
        PROCEDURE LogStop;
        PROCEDURE GetOptions;
        FUNCTION AlreadyAnalyzed
                RETURN boolean;

-- START OF INLINE MODULES

        -- exports the table/index stats into the statistics table, to create a history.
        -- The statid is used to group all statistics for a certain run together
        PROCEDURE BackupPostStats

        IS

        BEGIN

            debug.f('Begin of inline procedure BackupPostStats');

            debug.f('check p_objtype: %s', p_objtype);
            debug.f('if table then');
            if ( p_objtype = 'TABLE' )
            then
                debug.f('export the table statistics');
                -- the cascade option is used to export the column statistics
                -- as well, although tests have shown that (at least in the xe beta)
                -- the column statistics have been exported regardless of the
                -- cascade parameter.
                -- By setting this parameter the index statistics are exported as well.
                -- If the indexes are later during this run
                debug.f('calling procedure dbms_stats.export_table_stats');
                debug.f('  ownname:  %s', p_ownname);
                debug.f('  tabname:  %s', p_objname);
                debug.f('  partname: %s', nvl(p_subpartname, p_partname));
                debug.f('  statown:  %s', g_owner);
                debug.f('  stattab:  %s', g_stattab);
                debug.f('  statid:   %s', p_statid);
                debug.f('  cascade:  %s', 'TRUE');
                dbms_stats.export_table_stats
                    ( ownname       =>  '"' || p_ownname || '"',
                      tabname       =>  '"' || p_objname || '"',
                      partname      =>  '"' || nvl(p_subpartname, p_partname) || '"',
                      statown       =>  g_owner,
                      stattab       =>  g_stattab,
                      statid        =>  p_statid,
                      cascade       =>  true
                    );
            else
                debug.f('else export the index stats');
                debug.f('calling procedure dbms_stats.export_index_stats');
                debug.f('  ownname:  %s', p_ownname);
                debug.f('  tabname:  %s', p_objname);
                debug.f('  partname: %s', nvl(p_subpartname, p_partname));
                debug.f('  statown:  %s', g_owner);
                debug.f('  stattab:  %s', g_stattab);
                debug.f('  statid:   %s', p_statid);
                dbms_stats.export_index_stats
                    ( ownname       =>  '"' || p_ownname || '"',
                      indname       =>  '"' || p_objname || '"',
                      partname      =>  '"' || nvl(p_subpartname, p_partname) || '"',
                      statown       =>  g_owner,
                      stattab       =>  g_stattab,
                      statid        =>  p_statid
                    );
            end if;

            debug.f('End of inline procedure BackupPostStats');

        END BackupPostStats;

        -- invokes the dbms_stats.gather_table_stats procedure to calculate
        -- new statstics, using the retrieved options
        PROCEDURE CalcStats

        IS

        BEGIN

            debug.f('Begin of inline procedure CalcStats');
            
            debug.f('check p_objtype: %s',p_objtype);
            debug.f('If TABLE then');
            if ( p_objtype = 'TABLE' )
            then
                debug.f('Calling procedure dbms_stats.gather_table_stats');
                dbms_stats.gather_table_stats
                    ( ownname           =>  '"' || p_ownname || '"',
                      tabname           =>  '"' || p_objname || '"',
                      partname          =>  '"' || nvl(p_subpartname, p_partname) || '"',
                      estimate_percent  =>  case when l_statoptions.auto_sample_size = 'TRUE'
                                                   then dbms_stats.AUTO_SAMPLE_SIZE
                                                 else l_statoptions.estimate_percent
                                            end,
                      block_sample      =>  case when l_statoptions.block_sample = 'TRUE'
                                                   then TRUE
                                                 else false
                                            end,
                      method_opt        =>  l_statoptions.method_opt,
                      degree            =>  case when l_statoptions.default_degree = 'TRUE'
                                                   then dbms_stats.default_degree
                                                 else l_statoptions.degree
                                            end,
                      granularity       =>  l_statoptions.granularity,
                      cascade           =>  case when l_statoptions.cascade = 'TRUE'
                                                   then TRUE
                                                 else FALSE
                                            end,
                      no_invalidate     =>  case when l_statoptions.no_invalidate = 'TRUE'
                                                   then TRUE
                                                 else FALSE
                                            end
                     );
                debug.f('Finished calling procedure dbms_stats.gather_table_stats');
            else
                debug.f('else then');
                debug.f('calling procedure dbms_stats.gather_index_stats');
                dbms_stats.gather_index_stats
                    ( ownname           =>  '"' || p_ownname || '"',
                      indname           =>  '"' || p_objname || '"',
                      partname          =>  '"' || nvl(p_subpartname, p_partname) || '"',
                      estimate_percent  =>  case when l_statoptions.auto_sample_size = 'TRUE'
                                                   then dbms_stats.AUTO_SAMPLE_SIZE
                                                   else l_statoptions.estimate_percent
                                            end,
                      degree            =>  case when l_statoptions.default_degree = 'TRUE'
                                                   then dbms_stats.DEFAULT_DEGREE
                                                 else l_statoptions.degree
                                            end,
                      granularity       =>  l_statoptions.granularity,
                      no_invalidate     =>  case when l_statoptions.no_invalidate = 'TRUE'
                                                   then TRUE
                                                 else FALSE
                                            end
                     );
                debug.f('finished calling procedure dbms_stats.gather_index_stats');
            end if;
            
            debug.f('End of inline procedure CalcStats');
            
        END CalcStats;

        -- log the start time, the involved object and the used options
        -- in the run_history_details table
        PROCEDURE LogStart

        IS

        BEGIN

            debug.f('Begin of inline procedure LogStart');
            
            debug.f('inserting a new record in run_history_details');
            insert into run_history_details
                ( statid, starttime, ownname, objtype, objname, partname, subpartname,
                  sto_ownname, sto_objtype, sto_objname, sto_partname, sto_subpartname,
                  sto_locked, sto_auto_sample_size, sto_estimate_percent,
                  sto_block_sample, sto_method_opt, sto_default_degree,
                  sto_degree, sto_granularity, sto_cascade, sto_no_invalidate
                 )
            values
                ( p_statid, sysdate, p_ownname, p_objtype, p_objname, p_partname, p_subpartname,
                  l_statoptions.owner, l_statoptions.object_type, l_statoptions.object_name,
                  l_statoptions.part_name, l_statoptions.subpart_name, l_statoptions.locked,
                  l_statoptions.auto_sample_size, l_statoptions.estimate_percent,
                  l_statoptions.block_sample, l_statoptions.method_opt, l_statoptions.default_degree,
                  l_statoptions.degree, l_statoptions.granularity, l_statoptions.cascade,
                  l_statoptions.no_invalidate
                );

            debug.f('inserted %s records', SQL%ROWCOUNT); 
            debug.f('committing insert');
            commit;

            debug.f('End of inline procedure CalcStats');

        END LogStart;

        -- update the run_history_details table with the end time and
        -- the status of the gather_table_stats procedure
        PROCEDURE LogStop

        IS

        BEGIN
            
            debug.f('Begin of inline procedure LogStop');
            
            debug.f('updating run_history_details, setting');
            debug.f('  l_calc_status = %s', l_calc_status);
            debug.f('  l_exp_status = %s', l_exp_status);
            update run_history_details
            set stoptime = sysdate,
                calc_status = l_calc_status,
                exp_status = l_exp_status
            where statid = p_statid
                  and ownname = p_ownname
                  and objtype = p_objtype
                  and objname = p_objname
                  and ( partname = p_partname
                        or p_partname is null
                      )
                  and ( subpartname = p_subpartname
                        or p_subpartname is null
                      );
            debug.f('updated %s records', sql%rowcount);
            debug.f('committing the update');
            commit;

            debug.f('End of inline procedure LogStop');
                        
        END LogStop;

        -- populates the l_statoptions record variable
        -- with the options found in the statoptions table
        PROCEDURE GetOptions

        IS

        BEGIN

            debug.f('Begin of inline procedure GetOptions');
            
            debug.f('Calling function GetStatOptions, passing values');
            debug.f('  p_ownname: %s', p_ownname);
            debug.f('  p_objtype: %s', p_objtype);
            debug.f('  p_objname: %s', p_objname);
            debug.f('  p_partname: %s', p_partname);
            debug.f('  p_subpartname: %s', p_subpartname);
            l_statoptions := getStatOptions
                                ( p_ownname     =>  p_ownname,
                                  p_objtype     =>  p_objtype,
                                  p_objname     =>  p_objname,
                                  p_partname    =>  p_partname,
                                  p_subpartname =>  p_subpartname
                                );
            debug.f('Finished calling function getStatOptions, retrieving l_StatOptions');
            debug.f('  l_StatOptions.locked: %s',l_StatOptions.locked);
            debug.f('  l_StatOptions.auto_sample_size: %s',l_StatOptions.auto_sample_size);
            debug.f('  l_StatOptions.estimate_percent: %s',l_StatOptions.estimate_percent);
            debug.f('  l_StatOptions.block_sample: %s',l_StatOptions.block_sample);
            debug.f('  l_StatOptions.method_opt: %s',l_StatOptions.method_opt);
            debug.f('  l_StatOptions.default_degree: %s',l_StatOptions.default_degree);
            debug.f('  l_StatOptions.degree: %s',l_StatOptions.degree);
            debug.f('  l_StatOptions.granularity: %s',l_StatOptions.granularity);
            debug.f('  l_StatOptions.cascade: %s',l_StatOptions.cascade);
            debug.f('  l_StatOptions.no_invalidate: %s',l_StatOptions.no_invalidate);

            debug.f('End of inline procedure GetOptions');

        END GetOptions;

        -- checks if the object has already been analyzed during this analyze run
        FUNCTION AlreadyAnalyzed
                    RETURN boolean
        
        IS
        
            l_last_analyzed     date;
            l_result            boolean;
        
        BEGIN
        
            debug.f('Begin of inline procedure AlreadyAnalyzed');

            debug.f('Calling function getLastAnalyzedDate.get_date');
            debug.f('  input parameter p_owner: %s',  p_ownname);
            debug.f('  input parameter p_object_type: %s', p_objtype);
            debug.f('  input parameter p_object_name: %s', p_objname);
            debug.f('  input parameter p_part_name: %s', p_partname);
            debug.f('  input parameter p_subpart_name: %s', p_subpartname);
            l_last_analyzed := getLastAnalyzedDate.getDate
                                    ( p_owner           =>  p_ownname,
                                      p_object_type     =>  p_objtype,
                                      p_object_name     =>  p_objname,
                                      p_part_name       =>  p_partname,
                                      p_subpart_name    =>  p_subpartname
                                    );
            debug.f('Finished calling function getLastAnalyzedDate.get_date');
            debug.f('Retrieved l_last_analyzed: %s', to_char(l_last_analyzed, 'DD/MM/YYYY HH24:MI:SS'));
            
            debug.f('Comparing p_startdate: %s, with l_last_analyzed: %s', to_char(p_startdate, 'DD/MM/YYYY HH24:MI:SS'),to_char(l_last_analyzed, 'DD/MM/YYYY HH24:MI:SS'));
            if p_startdate <= l_last_analyzed
            then
                debug.f('p_startdate <= l_last_analyzed, object has already been analyzed during this run');
                l_result := true;
            else
                debug.f('p_startdate > l_last_analyzed or l_last_analyzed is null, object has not yet been analyzed during this run');
                l_result := false;
            end if;
            
            debug.f('Returning l_result: %s',case when l_result = TRUE then 'TRUE' else 'FALSE' end);
            debug.f('End of inline procedure AlreadyAnalyzed');
            RETURN l_result;
        
        END;

-- START OF MAIN PROGRAM HERE

    BEGIN

        debug.f('Begin of procedure GatherIt');
        debug.f('  input parameter p_statid: %s', p_statid);
        debug.f('  input parameter p_ownname: %s', p_ownname);
        debug.f('  input parameter p_objtype: %s', p_objtype);
        debug.f('  input parameter p_objname: %s', p_objname);
        debug.f('  input parameter p_partname: %s', p_partname);
        debug.f('  input parameter p_subpartname: %s', p_subpartname);
        debug.f('  input parameter p_calcfailures: %s', p_calcfailures);
        debug.f('  input parameter p_expfailures: %s', p_expfailures);
    
        -- get the statistics options for this object
        debug.f('Calling procedure GetOptions');
        GetOptions;
        debug.f('Finished calling procedure GetOptions');

        -- log the start of the statistics gathering
        -- together with the used options
        debug.f('Calling procedure Logstart');
        LogStart;
        debug.f('Finished calling procedure Logstart');

        debug.f('check if the object already has been analyzed during this run');
        if AlreadyAnalyzed = false
        then
        
            debug.f('Object has not yet been analyzed during this run');
        
            -- check if the user did not exclude this object from statistics
            -- gathering
            debug.f('check if the object is not excluded by the user');
            if ( isLocked
                    ( p_obj_owner           =>      p_ownname,
                      p_obj_type            =>      p_objtype,
                      p_obj_name            =>      p_objname,
                      p_obj_part_name       =>      p_partname,
                      p_obj_subpart_name    =>      p_subpartname,
                      p_obj_locked          =>      l_statoptions.locked
                    ) = FALSE
               )
            then
                debug.f('Object is not excluded, gathering the statistics');
                -- Gather the statistics
                BEGIN
                    debug.f('Calling procedure CalcStats');
                    CalcStats;
                    debug.f('Finished calling procedure CalcStats');
                    l_calc_status := g_ok_msg;
                exception
                    when others then
                        debug.f('Finished calling procedure Calcstats with errors: %s, %s', sqlcode, sqlerrm);
                        debug.f('set the calc_status'); 
                        l_calc_status := 'calcstats error: ' || sqlcode || ' ' || sqlerrm;
                        debug.f('increase the p_calcfailures (%s) with 1', p_calcfailures);
                        p_calcfailures := p_calcfailures + 1;
                END;
    
                debug.f('check if calcstats finished without errors');
                if (l_calc_status = g_ok_msg)
                then
                    debug.f('Ok, start with the post backup operation');
                    -- backup the new statistics
                    BEGIN
                        debug.f('Calling procedure BackupPostStats');
                        BackupPostStats;
                        debug.f('Finished calling procedure BackupPoststats');
                        l_exp_status := g_ok_msg;
                    EXCEPTION
                        when others then
                            debug.f('Finished calling procedure BackupPoststats with errors: %s, %s', sqlcode, sqlerrm);
                            l_exp_status := 'backupPoststats error: ' || sqlcode || ' ' || sqlerrm;
                            debug.f('increase the p_expfailures (%s) with 1', p_expfailures); 
                            p_expfailures := p_expfailures + 1;
                    END;
                end if;
            else
                debug.f('Statistics locked, no new statistics calculated');
                l_calc_status := 'Statistics locked, no new statistics calculated';
            end if;
        else
            debug.f('Object already has been analyzed, skipping object');
            l_calc_status := 'Object already has been analyzed, skipping object'; 
        end if;
        
        -- log the end of the statistics gathering
        debug.f('Calling procedure LogStop');
        LogStop;
        debug.f('Finished calling procedure LogStop');

        debug.f('End of procedure GatherIt');
        
    END GatherIt;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> ListObjOptions </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Retrieves the statistic options from the statoptions table that will be used
            when new statistics for this object are generated.
            Returns a clob containing the options in a report format
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    FUNCTION ListObjOptions
        ( p_object_type     in      varchar2,                      -- object type, either TABLE or INDEX
          p_owner           in      varchar2,                      -- owner of the object
          p_object_name     in      varchar2,                      -- the object name
          p_part_name       in      varchar2,                      -- the partname of the object (if applicable)
          p_subpart_name    in      varchar2                       -- the subpart name of the object (if applicable)
        )
        RETURN CLOB

    IS
    
        l_statoptions               rec_statoptions;
        l_locked                    boolean;
        l_clob                      clob;
        l_eol           constant    varchar2(2)        :=  chr(10);

    BEGIN

        debug.f('Begin of function ListObjOptions');
        debug.f('  input parameters p_object_type: %s', p_object_type);
        debug.f('  input parameters p_owner: %s', p_owner);
        debug.f('  input parameters p_object_name: %s', p_object_name);
        debug.f('  input parameters p_part_name: %s', p_part_name);
        debug.f('  input parameters p_subpart_name: %s', p_subpart_name);        
        
      -- get thet statoptions for this object
        debug.f('Calling function GetStatOptions, passing values');
        debug.f('  p_ownname: %s', p_owner);
        debug.f('  p_objtype: %s', p_object_type);
        debug.f('  p_objname: %s', p_object_name);
        debug.f('  p_partname: %s', p_part_name);
        debug.f('  p_subpartname: %s', p_subpart_name);
        l_statoptions := getStatOptions
                            ( p_ownname     =>  p_owner,
                              p_objtype     =>  p_object_type,
                              p_objname     =>  p_object_name,
                              p_partname    =>  p_part_name,
                              p_subpartname =>  p_subpart_name
                            );
        debug.f('Finished calling function getStatOptions, retrieving l_StatOptions');
        debug.f('  l_StatOptions.locked: %s',l_StatOptions.locked);
        debug.f('  l_StatOptions.auto_sample_size: %s',l_StatOptions.auto_sample_size);
        debug.f('  l_StatOptions.estimate_percent: %s',l_StatOptions.estimate_percent);
        debug.f('  l_StatOptions.block_sample: %s',l_StatOptions.block_sample);
        debug.f('  l_StatOptions.method_opt: %s',l_StatOptions.method_opt);
        debug.f('  l_StatOptions.default_degree: %s',l_StatOptions.default_degree);
        debug.f('  l_StatOptions.degree: %s',l_StatOptions.degree);
        debug.f('  l_StatOptions.granularity: %s',l_StatOptions.granularity);
        debug.f('  l_StatOptions.cascade: %s',l_StatOptions.cascade);
        debug.f('  l_StatOptions.no_invalidate: %s',l_StatOptions.no_invalidate);
    
      -- check if the object has been locked
        debug.f('Calling procedure isLocked, passing values');
        debug.f('  p_obj_owner: %s', p_owner);
        debug.f('  p_obj_type: %s', p_object_type);
        debug.f('  p_obj_name: %s', p_object_name);
        debug.f('  p_obj_part_name: %s', p_part_name);
        debug.f('  p_obj_subpart_name: %s', p_subpart_name);
        debug.f('  p_obj_locked: %s', l_StatOptions.locked);
        l_locked := isLocked
                        ( p_obj_owner           =>      p_owner,
                          p_obj_type            =>      p_object_type,
                          p_obj_name            =>      p_object_name,
                          p_obj_part_name       =>      p_part_name,
                          p_obj_subpart_name    =>      p_subpart_name,
                          p_obj_locked          =>      l_StatOptions.locked
                        );     
        debug.f('Finished calling procedure islocked, retrieved l_locked: %s', (case when l_locked = TRUE then 'TRUE' else 'FALSE' end));
        
      -- construct the clob contents for output
        debug.f('Constructing clob contents');
        l_clob :=           'OBJECT PASSED' || l_eol;
        l_clob := l_clob || '-------------' || l_eol;
        l_clob := l_clob || 'Passed owner:            ' || p_owner || l_eol;
        l_clob := l_clob || 'Passed object type:      ' || p_object_type || l_eol;
        l_clob := l_clob || 'Passed object name:      ' || p_object_name || l_eol;
        l_clob := l_clob || 'Passed object part:      ' || p_part_name || l_eol;
        l_clob := l_clob || 'Passed object sub-part:  ' || p_subpart_name || l_eol;
        l_clob := l_clob || l_eol;
        l_clob := l_clob || 'OBJECT USED FROM THE STATOPTIONS TABLE' || l_eol;
        l_clob := l_clob || '--------------------------------------' || l_eol;
        l_clob := l_clob || l_eol;
        l_clob := l_clob || 'owner:              ' || l_StatOptions.owner || l_eol;
        l_clob := l_clob || 'object type:        ' || l_StatOptions.object_type || l_eol;
        l_clob := l_clob || 'object name:        ' || l_StatOptions.object_name || l_eol;
        l_clob := l_clob || 'object part:        ' || l_StatOptions.part_name || l_eol;
        l_clob := l_clob || 'object sub-part:    ' || l_StatOptions.subpart_name || l_eol;
        l_clob := l_clob || l_eol; 
        l_clob := l_clob || 'RETRIEVED OPTIONS FROM THE STATOPTIONS TABLE' || l_eol;
        l_clob := l_clob || '--------------------------------------------' || l_eol;
        l_clob := l_clob || l_eol;
        l_clob := l_clob || 'locked:                  ' || l_StatOptions.locked || l_eol;
        l_clob := l_clob || 'auto sample size:        ' || l_StatOptions.auto_sample_size || l_eol;
        l_clob := l_clob || 'estimate percent:        ' || l_StatOptions.estimate_percent || l_eol;
        l_clob := l_clob || 'block sample:            ' || l_StatOptions.block_sample || l_eol;
        l_clob := l_clob || 'method optimizer:        ' || l_StatOptions.method_opt || l_eol;
        l_clob := l_clob || 'default degree:          ' || l_StatOptions.default_degree || l_eol;
        l_clob := l_clob || 'degree:                  ' || l_StatOptions.degree || l_eol;
        l_clob := l_clob || 'granularity:             ' || l_StatOptions.granularity || l_eol;
        l_clob := l_clob || 'cascade:                 ' || l_StatOptions.cascade || l_eol;
        l_clob := l_clob || 'no invalidation:         ' || l_StatOptions.no_invalidate || l_eol;
        l_clob := l_clob || l_eol; 
        l_clob := l_clob || 'isLOCKED' || l_eol;
        l_clob := l_clob || '--------' || l_eol;
        l_clob := l_clob || l_eol;
        l_clob := l_clob || 'isLocked:                ' || (case when l_locked = TRUE then 'TRUE' else 'FALSE' end) || l_eol;

        debug.f('constructed clob');
        
        debug.f('End of function ListObjOptions, returning l_clob');
        RETURN l_clob;
        
    END ListObjOptions;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> PurgeHistory </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Deletes old history records from the run_history and run_history_details tables.
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE PurgeHistory
        ( p_days            in      number       default 30,         -- record older then passed number of days will be deleted
          p_with_operation  in      varchar2     default null,       -- only records with the given operation message will be deleted (null means everything) 
          p_rh              in      boolean      default true,       -- delete not only the records from run_history_details but also from run_history
          p_force           in      boolean      default false       -- delete also the protected records
        )

    IS
    
        l_sql_rhd       varchar2(4000);
        l_sql_rh        varchar2(4000);
        l_sql_sth       varchar2(4000);
        l_statid        st_rh_statid;
        l_log_msg       st_rh_operation;

-- FORWARD DECLARATION OF INLINE MODULES
        PROCEDURE construct_sql_del_sth;
        PROCEDURE construct_sql_del_rhd;
        PROCEDURE construct_sql_del_rh;
        PROCEDURE exec_sql_del_sth;
        PROCEDURE exec_sql_del_rhd;
        PROCEDURE exec_sql_del_rh;


-- START OF INLINE MODULES

        -- construct the sql needed to delete the records from the statistics_history table
        PROCEDURE construct_sql_del_sth

        IS

        BEGIN
        
            debug.f('Begin of inline procedure construct_sql_del_sth');
        
            -- create the base part of the sql
            debug.f('constructing the sql to delete from statistics_history');
            l_sql_sth :=          ' delete';
            l_sql_sth := l_sql_sth || ' from statistics_history';
            l_sql_sth := l_sql_sth || ' where statid in';
            l_sql_sth := l_sql_sth || '  ( select statid';
            l_sql_sth := l_sql_sth || '    from run_history';
            l_sql_sth := l_sql_sth || '    where nvl(endtime, starttime) <= sysdate - :p_days';
        
            -- if only entries with the given operation must be deleted
            debug.f('check if a filter on the operation field must be used');
            debug.f('  p_with_operation: %s', p_with_operation);
            if ( p_with_operation is not null )
            then
                l_sql_sth := l_sql_sth || '    and operation = :p_operation';
            end if;
            
            -- if the protected entries must be preserved
            debug.f('check if protected records must be deleted as well');
            debug.f('  p_force: %s', case when p_force = TRUE then 'TRUE' else 'FALSE' end);
            if ( p_force = false )
            then
                l_sql_sth := l_sql_sth || '    and protected = ''N''';
            end if;
            
            -- close the sql statement
            l_sql_sth := l_sql_sth || ')';
 
            debug.f('End of inline procedure construct_sql_del_sth');
                   
        END construct_sql_del_sth;


        -- construct the sql needed to delete the records from the run_history_details table
        PROCEDURE construct_sql_del_rhd

        IS

        BEGIN
        
            debug.f('Begin of inline procedure construct_sql_del_rhd');
        
            -- create the base part of the sql
            debug.f('constructing the sql to delete from run_history_details');
            l_sql_rhd :=          ' delete';
            l_sql_rhd := l_sql_rhd || ' from run_history_details';
            l_sql_rhd := l_sql_rhd || ' where statid in';
            l_sql_rhd := l_sql_rhd || '  ( select statid';
            l_sql_rhd := l_sql_rhd || '    from run_history';
            l_sql_rhd := l_sql_rhd || '    where nvl(endtime, starttime) <= sysdate - :p_days';
        
            -- if only entries with the given operation must be deleted
            debug.f('check if a filter on the operation field must be used');
            debug.f('  p_with_operation: %s', p_with_operation);
            if ( p_with_operation is not null )
            then
                l_sql_rhd := l_sql_rhd || '    and operation = :p_operation';
            end if;
            
            -- if the protected entries must be preserved
            debug.f('check if protected records must be deleted as well');
            debug.f('  p_force: %s', case when p_force = TRUE then 'TRUE' else 'FALSE' end);
            if ( p_force = false )
            then
                l_sql_rhd := l_sql_rhd || '    and protected = ''N''';
            end if;
            
            -- close the sql statement
            l_sql_rhd := l_sql_rhd || ')';
            
            debug.f('finished creating the l_sql_rhd statement: %s', l_sql_rhd);
 
            debug.f('End of inline procedure construct_sql_del_rhd');
                   
        END construct_sql_del_rhd;
        
        -- construct the sql needed to delete the records from the run_history table
        PROCEDURE construct_sql_del_rh

        IS

        BEGIN
        
            debug.f('Begin of inline procedure construct_sql_del_rh');

            -- create the base part of the sql
            l_sql_rh :=             ' delete'; 
            l_sql_rh := l_sql_rh || ' from run_history rh';
            l_sql_rh := l_sql_rh || ' where nvl(endtime, starttime) <= sysdate - :p_days';
            l_sql_rh := l_sql_rh || '       and statid != :l_statid';
            l_sql_rh := l_sql_rh || '       and not exists';
            l_sql_rh := l_sql_rh || '         ( select null';
            l_sql_rh := l_sql_rh || '           from run_history_details rhd';
            l_sql_rh := l_sql_rh || '           where rhd.statid = rh.statid';
            l_sql_rh := l_sql_rh || '         )';
            l_sql_rh := l_sql_rh || '       and not exists';
            l_sql_rh := l_sql_rh || '         ( select null';
            l_sql_rh := l_sql_rh || '           from statistics_history sth';
            l_sql_rh := l_sql_rh || '           where sth.statid = rh.statid';
            l_sql_rh := l_sql_rh || '         )';
            
            -- if only entries with the given operation must be deleted
            debug.f('check if a filter on the operation field must be used');
            debug.f('  p_with_operation: %s', p_with_operation);
            if ( p_with_operation is not null )
            then
                l_sql_rh := l_sql_rh || '       and operation = :p_operation';
            end if;
        
            -- if the protected entries must be preserved
            debug.f('check if protected records must be deleted as well');
            debug.f('  p_force: %s', case when p_force = TRUE then 'TRUE' else 'FALSE' end);
            if ( p_force = false )
            then
                l_sql_rh := l_sql_rh || '       and protected = ''N''';
            end if;
            
            debug.f('finished creating the l_sql_rh statement: %s', l_sql_rh);
            
            debug.f('End of inline procedure construct_sql_del_rh');
      
        END construct_sql_del_rh;

        -- execute the sql statement to delete the records from the run_history_details table
        -- because p_days is mandatory and p_force is a fixed value, 
        -- we only have two possible constructs for the bind variables.
        PROCEDURE exec_sql_del_sth

        IS

        BEGIN
        
            debug.f('Begin of inline procedure exec_sql_del_sth');
            
            debug.f('Check if the p_operation value must be used as bind variable');
            if (p_with_operation is not null)
            then
                debug.f('run the l_sql_sth statement with bind variables:');
                debug.f(' p_days: %s', p_days);
                debug.f(' p_operation: %s', p_with_operation);
                execute immediate l_sql_sth using p_days, p_with_operation;
            else
                debug.f('run the l_sql_sth statement with bind variable:');
                debug.f(' p_days: %s', p_days);
                execute immediate l_sql_sth using p_days;
            end if;

            debug.f('Finished deleting from statistics_history, %s records deleted', SQL%ROWCOUNT);

            debug.f('End of inline procedure exec_sql_del_sth');
            
        END exec_sql_del_sth;


        -- execute the sql statement to delete the records from the run_history_details table
        -- because p_days is mandatory and p_force is a fixed value, 
        -- we only have two possible constructs for the bind variables.
        PROCEDURE exec_sql_del_rhd

        IS

        BEGIN
        
            debug.f('Begin of inline procedure exec_sql_del_rhd');
            
            debug.f('Check if the p_operation value must be used as bind variable');
            if (p_with_operation is not null)
            then
                debug.f('run the l_sql_rhd statement with bind variables:');
                debug.f(' p_days: %s', p_days);
                debug.f(' p_operation: %s', p_with_operation);
                execute immediate l_sql_rhd using p_days, p_with_operation;
            else
                debug.f('run the l_sql_rhd statement with bind variable:');
                debug.f(' p_days: %s', p_days);
                execute immediate l_sql_rhd using p_days;
            end if;

            debug.f('Finished deleting from run_history_details, %s records deleted', SQL%ROWCOUNT);

            debug.f('End of inline procedure exec_sql_del_rhd');
            
        END exec_sql_del_rhd;

        -- execute the sql statement to delete the records from the run_history table
        PROCEDURE exec_sql_del_rh

        IS

        BEGIN

            debug.f('Begin of inline procedure exec_sql_del_rh');
            
            debug.f('Check if the p_operation value must be used as bind variable');
            if (p_with_operation is not null)
            then
                debug.f('run the l_sql_rh statement with bind variables:');
                debug.f(' p_days: %s', p_days);
                debug.f(' p_operation: %s', p_with_operation);
                execute immediate l_sql_rh using p_days, l_statid, p_with_operation;
            else
                debug.f('run the l_sql_rh statement with bind variable:');
                debug.f(' p_days: %s', p_days);
                execute immediate l_sql_rh using p_days, l_statid;
            end if;

            debug.f('Finished deleting from run_history, %s records deleted', SQL%ROWCOUNT);

            debug.f('End of inline procedure exec_sql_del_rh');

        END exec_sql_del_rh;

-- START OF MAIN PROGRAM HERE

    BEGIN
    
        debug.f('Begin of procedure PurgeHistory');

        -- get a new statid
        debug.f('Calling function GenNewID');
        l_statid := GenNewID;
        debug.f('Finished calling GenNewID');
        debug.f('retrieved statid %s', l_statid);
        
        -- log the start of the purge run
        -- construct the log_message
        debug.f('construct the l_log_msg');
        l_log_msg := 'Purging history older then ' || to_char(p_days) || ' days'; 
        l_log_msg := l_log_msg || case when p_with_operation is not null then ' and operation = '|| p_with_operation end; 
        l_log_msg := l_log_msg || ( case when p_force = true then ' ,including protected records,' else '' end );
        l_log_msg := l_log_msg || ' from run_history_details';
        l_log_msg := l_log_msg || ( case when p_rh = true then ' and run_history' end);
        debug.f('calling procedure logStartRun');
        debug.f('  p_statid: %s', l_statid);
        debug.f('  p_starttime: %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI;SS'));
        debug.f('  l_log_msg: %s', l_log_msg); 
        logStartRun
            ( p_statid          =>      l_statid,
              p_starttime       =>      sysdate,
              p_operation       =>      l_log_msg
            );
        
        -- construct and run the sql statement to delete the records from the run_history_details table
        debug.f('Calling inline procedure construct_sql_del_rhd');
        construct_sql_del_rhd;
        debug.f('Finished calling inline procedure construct_sql_del_rhd');
        debug.f('Calling inline procedure exec_sql_del_rhd');
        exec_sql_del_rhd;
        debug.f('Finished calling inline procedure exec_sql_del_rhd');
        
        -- when the "parent" records need to be deleted as well
        debug.f('Check if the records from run_history must be deleted as well');
        debug.f('  p_rh: %s', case when p_rh = TRUE then 'TRUE' else 'FALSE' end);
        if ( p_rh = true )
        then
            
            -- when the header record is deleted the backup of the statistics must also be deleted
            debug.f('Calling inline procedure construct_sql_del_sth');
            construct_sql_del_sth;
            debug.f('Finished calling inline procedure construct_sql_del_sth');
            debug.f('Calling inline procedure exec_sql_del_sth');
            exec_sql_del_sth;
            debug.f('Finished calling inline procedure exec_sql_del_rh');
        
            -- construct and run the sql statement to delete the records from the run_history table
            debug.f('Calling inline procedure construct_sql_del_rh');
            construct_sql_del_rh;
            debug.f('Finished calling inline procedure construct_sql_del_rh');
            debug.f('Calling inline procedure exec_sql_del_rh');
            exec_sql_del_rh;
            debug.f('Finished calling inline procedure exec_sql_del_rh');
        end if;
        
        -- commit the deletes
        commit;
                      
        -- log the end of the purge run
        debug.f('Calling procedure logEndRun');
        debug.f(' p_statid: %s', l_statid);
        debug.f(' p_endtime; %s', to_char(sysdate, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f(' p_calcfailures: 0');
        debug.f(' p_expfailures: 0');
        logEndRun
            ( p_statid          =>      l_statid,
              p_endtime         =>      sysdate,
              p_calcfailures    =>      0,
              p_expfailures     =>      0
            );
        debug.f('Finished calling procedure logEndRun');
                        
        debug.f('End of procedure PurgeHistory');

    END PurgeHistory;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> isDictionary </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Checks if the passed schema is part of the dictionary.
            It does this by checking if the schema is sys, system or listed
            in the dba_registry.
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/
/*
    FUNCTION isDictionary
        ( p_schema      in      varchar2
        )
        RETURN boolean

    IS
    
        l_dummy    varchar2(1);
        l_result   boolean;
    
    BEGIN
    
        debug.f('Begin of function isDictionary');
        debug.f('  input parameters p_schema: %s', p_schema);

        BEGIN
        
            select 'x'
            into l_dummy
            from dictionary_schemas
            where schema = p_schema;    
            
            l_result := TRUE;
            
        EXCEPTION
            when no_data_found then
                l_result := FALSE;
        END;

        debug.f('End of function isDictionary');
        debug.f('  Returning l_result: %s', case when l_result = TRUE then 'TRUE' else 'FALSE' end);
        
        RETURN l_result;
        
    END isDictionary;
*/
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> about </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            prints a message about this package
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE about

    IS
    
    BEGIN
    
        debug.f('Begin of procedure about');
        
        dbms_output.put_line('AnalyzeThis Version 1.0');
        dbms_output.put_line('21/07/2008');
        dbms_output.put_line('Written by Freek D''Hooge');
        dbms_output.put_line('email: freek.dhooge@telenet.be');
        dbms_output.put_line('freekdhooge.wordpress.com/analyzethis');
        dbms_output.new_line;
        dbms_output.put_line('AnalyzeThis is free software: you can redistribute it and/or modify');
        dbms_output.put_line('it under the terms of the GNU Lesser General Public License as published by');
        dbms_output.put_line('the Free Software Foundation, either version 3 of the License, or');
        dbms_output.put_line('(at your option) any later version.');

        
        debug.f('End of procedure about');
    
    END about;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


-- initialize the g_owner variable to the owner of this package 
-- used to specify the owner of the statistics_history table containing the old statistics

BEGIN

    debug.f('Initializing g_owner');
    g_owner := sys_context('USERENV', 'CURRENT_USER');
    debug.f('g_owner is set to: %s', g_owner);


END AnalyzeThis;
/

