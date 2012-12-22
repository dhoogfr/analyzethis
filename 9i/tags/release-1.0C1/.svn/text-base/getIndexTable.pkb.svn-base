CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..getindexTable

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
        <MODULE_NAME> getIndexTable </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Get the table name for a given index
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE>  </DATE>
                <AUTHOR>  </AUTHOR>
                <WHAT>  </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE getTableInfo
        ( p_ind_owner           IN      varchar2,
          p_ind_name            IN      varchar2,
          p_ind_part_name       IN      varchar2    default null,
          p_ind_subpart_name    IN      varchar2    default null,
          p_tab_owner           OUT     varchar2,
          p_tab_name            OUT     varchar2,
          p_tab_part_name       OUT     varchar2,
          p_tab_subpart_name    OUT     varchar2
        )

    IS
    
        l_table_owner       dba_indexes.table_owner%TYPE;
        l_table_name        dba_indexes.table_name%TYPE;
        l_locality          dba_part_indexes.locality%TYPE;
        
 -- FORWARD DECLARATION OF INLINE MODULES
        PROCEDURE checkInput;
        PROCEDURE getPartInfo;
        PROCEDURE getNoPartInfo;
        
-- START OF INLINE MODULES

        -- Check the input paramter
        PROCEDURE checkInput
        
        IS
        
        BEGIN
        
            debug.f('Begin of inline procedure checkInput');

            -- check if p_ind_owner is not null
            if p_ind_owner is null
            then
                raise_application_error(-20002, 'p_ind_owner must be set');
            end if;
            
            -- check if p_ind_name is not null
            if p_ind_name is null
            then
                raise_application_error(-20003, 'p_ind_name must be set');
            end if;
            
            -- when p_ind_subpart_name is not null then check if p_ind_part_name is  not null
            if p_ind_subpart_name is not null
            then
                if p_ind_part_name is null
                then
                    raise_application_error(-20002, 'when p_ind_subpart_name is specified then p_ind_part_name must also be set');
                end if;
            end if;
            
            debug.f('End of inline procedure checkInput');
                
        END checkInput;

        -- get info on the base table of the partitioned index 
        PROCEDURE getPartInfo
        
        IS
        
        BEGIN
        
            debug.f('Begin of inline procedure getPartInfo');
            
            debug.f('Retrieving table info for index %s.%s', p_ind_owner, p_ind_name);

            select ind.table_owner, ind.table_name, pin.locality
            into l_table_owner, l_table_name, l_locality
            from dba_indexes ind, dba_part_indexes pin
            where pin.owner = ind.owner
                  and pin.index_name = ind.index_name
                  and ind.owner = p_ind_owner
                  and ind.index_name = p_ind_name;

            debug.f('Retrieved table_owner: %s, table_name: %s, l_locality: %s', l_table_owner, l_table_name, l_locality);
            
            debug.f('End of inline procedure getPartInfo');
        
        EXCEPTION
            when no_data_found
            then
                debug.f('Index could not be found');
                raise_application_error(-20001, 'getPartInfo: Index does not exists or is not partitioned');
        
        END getPartInfo;

        -- get info on the base table of the index
        PROCEDURE getNoPartInfo
        
        IS
        
        BEGIN
        
            debug.f('Begin of inline procedure getNoPartInfo');
            
            debug.f('Retrieving table info for index %s.%s', p_ind_owner, p_ind_name);

            select ind.table_owner, ind.table_name
            into l_table_owner, l_table_name
            from dba_indexes ind
            where ind.owner = p_ind_owner
                  and ind.index_name = p_ind_name;

            debug.f('Retrieved table_owner: %s and table_name: %s', l_table_owner, l_table_name);
            
            debug.f('End of inline procedure getNoPartInfo');
        
        EXCEPTION
            when no_data_found
            then
                debug.f('Index could not be found in dba_indexes');
                raise_application_error(-20001, 'getNoPartInfo: Index does not exists');
        
        END getNoPartInfo;

-- START OF MAIN PROGRAM
    BEGIN

        debug.f('Begin of procedure getTableInfo');
        debug.f('  input parameter p_ind_owner %s', p_ind_owner);
        debug.f('  input parameter p_ind_name: %s', p_ind_name);
        debug.f('  input parameter p_ind_part_name: %s', p_ind_part_name);
        debug.f('  input parameter p_ind_subpart_name: %s', p_ind_subpart_name);
        
        -- check the input parameters
        debug.f('Check the input parameters');
        checkInput;
        debug.f('Finished checking the input parameters');
        
        -- if a partition has been passed (and thus the index is partitioned)
        debug.f('If the index is partitioned');
        if p_ind_part_name is not null
        then
            
            debug.f('Get the table info for a partitioned index');
            getPartInfo;
            debug.f('Finished getting the table info for a partitioned index');
            
            debug.f('setting the output variablen');
            p_tab_owner := l_table_owner;
            p_tab_name := l_table_name;
            
            -- if it is a local partitioned index then
            debug.f('If it partitioned index is a local index');
            if l_locality = 'LOCAL'
            then
                -- set the table partition name and the table subpartition name to the same as the index
                debug.f('Setting the output variabelen for local partitioned indexes');
                p_tab_part_name := p_ind_part_name;
                p_tab_subpart_name := p_ind_subpart_name;
            end if;
            -- if it is a global partitioned index then no details about table partitiones are needed
        
        else
            
            debug.f('Get the table info for nonpartitioned indexes');
            getNopartInfo;
            debug.f('Finished getting the table info for partitioned indexes');
            
            debug.f('setting the output variablen');
            p_tab_owner := l_table_owner;
            p_tab_name := l_table_name;
        
        end if;
    
        debug.f('  output param p_tab_owner: %s', p_tab_owner);
        debug.f('  output param p_tab_name: %s', p_tab_name);
        debug.f('  output param p_tab_part_name: %s', p_tab_part_name);
        debug.f('  output param p_tab_subpart_name: %s', p_tab_subpart_name);
        debug.f('End of procedure getTableInfo');

        
    END getTableInfo;

END getindexTable;
/

