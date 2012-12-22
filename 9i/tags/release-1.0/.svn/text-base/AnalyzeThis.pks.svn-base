create or replace package &AnalyzeThisUser..AnalyzeThis

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
        BEGIN declaration of global exception numbers
*/


/* END declaration of global exception_numbers
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global exception messages
*/


/*      END declaration of global exception messages
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
        BEGIN declaration of global types
*/

TYPE rfc_statsinput is ref cursor return dbms_stats.ObjectElem;

/*      END declaration of global types
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
        BEGIN declaration of public functions and procedures
*/

   /* Gather statistics for a given schema.
      The options used in the internal calls to dbms_stats are taken from the statoptions table.
      The startime, endtime and number of errors are stored in the run_history table and in run_history_details
      the starttime, endtime, status and used statistics options are stored. The new generated statistics are also
      put in statistics_history table 
        p_schema: Name of the schema to analyze
        p_backup: Backup the current statistics to the statistics_history table before calculating new ones 
                  (the new ones are always stored in the statistics_history table)
                  default TRUE
        p_option: Maps to the 
                  AUTO:  for all objects with empty or out of date (stale) statistics
                  STALE: for all objects with out of date (stale) statistics
                  EMPTY: for all objects that currently don't have statistics
                  default 'AUTO'
    */
    PROCEDURE GatherSchemaStats
        ( p_schema      in      varchar2,
          p_backup      in      boolean     default TRUE,
          p_option      in      varchar2    default 'AUTO',
          p_GatherTemp  in      boolean     default FALSE
        );


    /* Gather statistics for the given object.
         p_object_type:  object type, either TABLE or INDEX 
         p_owner:        owner of the object
         p_object_name:  the object name
         p_part_name:    the partname of the object (if applicable)
                         default NULL
         p_subpart_name: the subpart name of the object (if applicable)
                         default NULL
         p_backup:       if the current statistics of all objects of p_owner must backupped or not
                         default true
    */
    PROCEDURE GatherObjStats
        ( p_object_type     in      varchar2,
          p_owner           in      varchar2,
          p_object_name     in      varchar2,
          p_part_name       in      varchar2    default NULL,
          p_subpart_name    in      varchar2    default NULL,
          p_backup          in      boolean     default TRUE
        );


    /* Calculates new statistics for all objects given in the passed reference cursor.
       This function can be used to create statistics on custom object lists, when the
       GatherSchemaStats or the GatherObjStats procedures are not sufficient.
         p_obj_cursor:  reference cursor containing the list of objects for which new statistics needs to be generated.
                        the calling procedure is responsible for constructing the ref cursor and to close it afterwards
         p_log_message: text that will be used as value for the operation field in the run_history table.
    */
    PROCEDURE GatherStats
        ( p_obj_cursor   in out     rfc_statsinput,
          p_log_message  in         varchar2
        );


    /* Backup the existing statistics of a schema before 
       generating new statistics on an object in that schema
         p_schema       name of the schema for which the current statistics must be backupped
    */
    PROCEDURE BackupSchemaStats
        ( p_schema          in      varchar2
        );


    /* Retrieves the statistic options from the statoptions table that will be used
       when new statistics for this object are generated.
       Returns a clob containing the options in a report format
         p_object_type:     the type of the object: TABLE or INDEX
         p_owner:           the owner of the object
                            corresponds with the statoptions.owner field
         p_object_name:     the name of the object
                            corresponds with the statoptions.object_name field
         p_part_name:       the name of the partition
                            default null
                            corresponds with the statoptions.part_name field
         p_subpart_name:    the name of the subpartition
                            corresponds with the statoptions.subpart_name field
                            default null
    */
    FUNCTION ListObjOptions
        ( p_object_type     in      varchar2,
          p_owner           in      varchar2,
          p_object_name     in      varchar2,
          p_part_name       in      varchar2    default null,
          p_subpart_name    in      varchar2    default null
        )
        RETURN CLOB;


    /* Pipelined function that returns a list of objects that need statistics.
        p_schema: Name of the schema for which the list needs to be generated
        p_option: AUTO, STALE or EMPTY (default AUTO)
                  AUTO:  give all objects with empty or out of date (stale) statistics
                  STALE: give all objects with out of date (stale) statistics
                  EMPTY: give all objects that currently don't have statistics
        p_gather_temp:  TRUE | FALSE (default FALSE)
                        Whether or not to gather statistics on global temporary tables. 
                        The temporary table must be created with the "on commit preserve rows" clause. 
                        The statistics being collected are based on the data in the session in which this procedure is run, 
                        but shared across all sessions
    */
    FUNCTION NeedStatsList
        ( p_schema      in      varchar2    default user,
          p_option      in      varchar2    default 'AUTO',
          p_gather_temp in      varchar2    default 'FALSE'
        )
        RETURN dbms_stats.objecttab PIPELINED;

    
    /* deletes the records from the run_history_details, run_history and statistics_history table
        p_days:             records of which the run endtime is older then p_days will deleted
                            default 30 days
        p_with_operation:   Puts an additional filter on the "operation" field (checks on the exact string, case sensitive)
                            NULL means no filter
                            default NULL
        p_rh:               FALSE: delete only the records from the run_history_details table               
                            TRUE:  delete the records from the run_history, the run_history_details and the statistics history table
                            default true
        p_force:            FALSE: delete only the records for which the protected field is set to 'N'
                            TRUE: do not check the value of the field "protected"
                            default false 
    */
    PROCEDURE PurgeHistory
        ( p_days            in      number       default 30,
          p_with_operation  in      varchar2     default null, 
          p_rh              in      boolean      default true,
          p_force           in      boolean      default false
        );

    
    /* prints an "about" message
    */
    PROCEDURE about;

/*      END declaration of public functions and procedures
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END AnalyzeThis;
/

