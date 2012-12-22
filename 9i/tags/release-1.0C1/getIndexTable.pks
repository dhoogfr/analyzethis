create or replace package &AnalyzeThisUser..getindexTable

IS

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

    /* gets the table_owner and table_name for a passed index
         p_owner:           owner of the index
         p_index_name:      name of the index
         p_table_owner:     owner of the table on which the passed index is active
         p_table_name       name of the table on which the passed index is active
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
        );


/*      END declaration of public functions and procedures
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END getindexTable;
/

