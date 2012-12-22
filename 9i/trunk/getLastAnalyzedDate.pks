create or replace package &AnalyzeThisUser..getLastAnalyzedDate

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

