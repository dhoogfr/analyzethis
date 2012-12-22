CREATE OR REPLACE PACKAGE BODY &AnalyzeThisUser..AnalyzeDB

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
        <MODULE_NAME> GatherDBStats </MODULE_NAME>
        <VERSION> 1.0 </VERSION>
        <AUTHOR> Freek D'Hooge </AUTHOR>
        <SUMMARY>
            Gather statistics for the objects in the database,
            for which the statistics are stale or empty
        </SUMMARY>
        <MODIFICATIONS>
            <MODIFICATION>
                <DATE> </DATE>
                <AUTHOR> </AUTHOR>
                <WHAT> 
                </WHAT>
            </MODIFICATION>
        </MODIFICATIONS>
*/

    PROCEDURE GatherDBStats
        ( p_backup      in      boolean     default TRUE,
          p_option      in      varchar2    default 'AUTO',
          p_GatherDict  in      boolean     default false,
          p_GatherTemp  in      boolean     default false
        )

    IS
    
        type rfc_schemas is ref cursor;
        
        l_schema_cursor     rfc_schemas;
        l_schema            varchar2(30);

    BEGIN

        debug.f('Begin of procedure GatherDBStats');
        debug.f('  input parameter p_backup: %s', case when p_backup = TRUE then'TRUE' else 'FALSE' end);
        debug.f('  input parameter p_option: %s', p_option);
        debug.f('  input parameter p_GatherDict: %s', case when p_gatherdict = TRUE then'TRUE' else 'FALSE' end);
        debug.f('  input parameter p_GatherTemp: %s', case when p_GatherTemp = TRUE then'TRUE' else 'FALSE' end);
        
        -- open the correct reference cursor based on the p_GatherDict parameter
        if p_GatherDict = TRUE
        then

            debug.f('Opening the ref cursor to get all the schema''s with objects');
            -- use the dba_segments view to get all schema's containing objects
            open l_schema_cursor for
                select distinct owner 
                from dba_segments;
        else

            debug.f('Opening the ref cursor to get all the schema''s with objects, filtering out dictionary schema''s');

            -- use the dba_segments view to get all schema's containing objects
            -- filter out the dictionary_schema's
            open l_schema_cursor for
                select distinct owner 
                from dba_segments 
                minus
                select schema
                from dictionary_schemas;
        
        end if;
        
        -- loop through the reference cursor, calling gatherschemastats for each schema
        debug.f('Looping through the schema''s ref cursor');
        loop
            
            fetch l_schema_cursor 
            into l_schema;
            debug.f('Fetched l_schema: %s', l_schema);
            
            exit when l_schema_cursor%NOTFOUND;
        
            debug.f('Calling procedure analyzethis.GatherSchemaStats');
            debug.f(' input par p_schema: %s', l_schema);
            debug.f(' input par p_backup: %s', case when p_backup = TRUE then'TRUE' else 'FALSE' end);
            debug.f(' input par p_option: %s', p_option);  
            debug.f(' input par p_GatherTemp: %s', case when p_GatherTemp = TRUE then'TRUE' else 'FALSE' end);
            analyzethis.GatherSchemaStats
                ( p_schema      =>  l_schema,
                  p_backup      =>  p_backup,
                  p_option      =>  p_option,
                  p_GatherTemp  =>  p_GatherTemp
                );
            debug.f('Finished calling procedure analyzethis.GatherSchemaStats');
              
        end loop;
        debug.f('Finished looping through the schema''s');
        
        debug.f('End of procedure GatherDBStats');

    END GatherDBStats;

/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END AnalyzeDB;
/

