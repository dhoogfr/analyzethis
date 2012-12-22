CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..getLastAnalyzedDate

IS



/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global constants
*/


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


/*
        END type declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception declaration
*/

        
/*
        END global exception declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN global exception messages declaration
*/


/*
        END global exception messages declaration
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN forward declarations
*/



/*
        END forward declarations
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/




/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        <MODULE_NAME> getDate </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            gets the last_analyzed date for the passed object
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/


    FUNCTION getDate
        ( p_owner           IN      varchar2,
          p_object_type     IN      varchar2,
          p_object_name     IN      varchar2,
          p_part_name       IN      varchar2,
          p_subpart_name    IN      varchar2
        )
        RETURN date
    
    IS
    
        l_lastAnalyzed      date;

-- FORWARD DECLARATION OF INLINE MODULES       
        PROCEDURE setTabSubpartDate;
        PROCEDURE setTabPartDate;
        PROCEDURE setTabDate;
        PROCEDURE setIndSubpartDate;
        PROCEDURE setIndPartDate;
        PROCEDURE setIndDate;
        PROCEDURE checkInput;

-- START OF INLINE MODULES
        -- set the l_lastAnalyzed variable to the last analyzed_date for a table subpartition
        PROCEDURE setTabSubpartDate
        
        IS
        
        BEGIN
        
            debug.f('Begin of inline procedure setTabSubpartDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_tab_subpartitions
            where table_owner = p_owner
                  and table_name = p_object_name
                  and partition_name = p_part_name
                  and subpartition_name = p_subpart_name;
            debug.f('End of inline procedure setTabSubpartDate');
            
        END setTabSubpartDate;

        -- set the l_lastAnalyzed variable to the last analyzed_date for a table partition
        PROCEDURE setTabPartDate
        
        IS
        
        BEGIN

            debug.f('Begin of inline procedure setTabPartDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_tab_partitions
            where table_owner = p_owner
                  and table_name = p_object_name
                  and partition_name = p_part_name;
            debug.f('End of inline procedure setTabPartDate');
        
        END setTabPartDate;

        -- set the l_lastAnalyzed variable to the last analyzed_date for a table
        PROCEDURE setTabDate
        
        IS
        
        BEGIN

            debug.f('Begin of inline procedure setTabDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_tables
            where owner = p_owner
                  and table_name = p_object_name;
            debug.f('End of inline procedure setTabDate');
            
        END setTabDate;

        -- set the l_lastAnalyzed variable to the last analyzed_date for an index subpartition
        PROCEDURE setIndSubpartDate
        
        IS
        
        BEGIN

            debug.f('Begin of inline procedure setIndSubpartDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_ind_subpartitions
            where index_owner = p_owner
                  and index_name = p_object_name
                  and partition_name = p_part_name
                  and subpartition_name = p_subpart_name;
            debug.f('End of inline procedure setIndSubpartDate');
        
        END setIndSubpartDate;

        -- set the l_lastAnalyzed variable to the last analyzed_date for an index partition
        PROCEDURE setIndPartDate
        
        IS
        
        BEGIN

            debug.f('Begin of inline procedure setIndPartDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_ind_partitions
            where index_owner = p_owner
                  and index_name = p_object_name
                  and partition_name = p_part_name;
            debug.f('End of inline procedure setIndPartDate');
            
        END setIndPartDate;

        -- set the l_lastAnalyzed variable to the last analyzed_date for an index
        PROCEDURE setIndDate
        
        IS
        
        BEGIN

            debug.f('Begin of inline procedure setIndDate');
            select last_analyzed
            into l_lastAnalyzed
            from dba_indexes
            where owner = p_owner
                  and index_name = p_object_name;
            debug.f('End of inline procedure setIndDate');
            
        END setIndDate;

        -- checks the input parameters
        PROCEDURE checkInput
        
        IS
        
        BEGIN
        
            debug.f('Begin of inline procedure checkInput');
            -- check if the p_object_type parameter containts a valid value
            if p_object_type not in ('TABLE', 'INDEX')
            then
                raise_application_error(-20002, 'p_object_type must be either set to TABLE or INDEX');
            end if;
            
            -- check if p_owner is not null
            if p_owner is null
            then
                raise_application_error(-20002, 'p_owner must be set');
            end if;
            
            -- check if p_object_name is not null
            if p_object_name is null
            then
                raise_application_error(-20003, 'p_object_name must be set');
            end if;
            
            -- when p_subpart_name is not null then check if p_part_name is  not null
            if p_subpart_name is not null
            then
                if p_part_name is null
                then
                    raise_application_error(-20004, 'when p_subpart_name is specified then p_part_name must also be set');
                end if;
            end if;

            debug.f('End of inline procedure checkInput');
            
        END checkInput;


-- START OF MAIN PROGRAM HERE    
    BEGIN

        debug.f('Begin of function getDate');
        debug.f('  input parameter p_owner %s', p_owner);
        debug.f('  input parameter p_object_type: %s', p_object_type);
        debug.f('  input parameter p_object_name: %s', p_object_name);
        debug.f('  input parameter p_part_name: %s', p_part_name);
        debug.f('  input parameter p_subpart_name: %s', p_subpart_name);
 
        debug.f('Check input parameter');
        checkInput;
    
        debug.f('retrieve last_analyzed_date');
        if p_subpart_name is not null 
        then
            if p_object_type = 'TABLE'
            then
                setTabSubpartDate;
            elsif p_object_type = 'INDEX'
            then
                setIndSubpartDate;
            end if;
        elsif p_part_name is not null
        then
            if p_object_type = 'TABLE'
            then
                setTabPartDate;
            elsif p_object_type = 'INDEX'
            then
                setIndPartDate;
            end if;
        else
            if p_object_type = 'TABLE'
            then
                setTabDate;
            elsif p_object_type = 'INDEX'
            then
                setIndDate;
            end if;
        end if;
        
        debug.f('Returning l_lastAnalyzed: %s', to_char(l_lastAnalyzed, 'DD/MM/YYYY HH24:MI:SS'));
        debug.f('End of function getDate');
        RETURN l_lastAnalyzed;
    
    EXCEPTION
        when no_data_found then
            raise_application_error(-20001, 'table or index does not exists');
    
    END getDate;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END getLastAnalyzedDate;
/

