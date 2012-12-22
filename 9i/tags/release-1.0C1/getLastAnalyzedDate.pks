create or replace package &AnalyzeThisUser..getLastAnalyzedDate

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

    /* gets the last_analyzed date for the passed object
         p_owner:           owner of the object
         p_object_type:     type of the object, either TABLE or INDEX
         p_object_name:     name of the object
         p_part_name        partition name of the object (if applicable)
         p_subpart_name:    subpartition name of the object (if applicable)
    */
    FUNCTION getDate
        ( p_owner           IN      varchar2,
          p_object_type     IN      varchar2,
          p_object_name     IN      varchar2,
          p_part_name       IN      varchar2,
          p_subpart_name    IN      varchar2
        )
        RETURN date;


/*      END declaration of public functions and procedures
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END getLastAnalyzedDate;
/

