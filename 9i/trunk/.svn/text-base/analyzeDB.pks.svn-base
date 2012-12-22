create or replace package &AnalyzeThisUser..AnalyzeDB

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

    /* Gather statistics for the objects in the database,
       for which the statistics are stale or empty
    */
    PROCEDURE GatherDBStats
        ( p_backup      in      boolean     default TRUE,
          p_option      in      varchar2    default 'AUTO',
          p_GatherDict  in      boolean     default false,
          p_GatherTemp  in      boolean     default false
        );
        

/*      END declaration of public functions and procedures
-----------------------------------------------------------------------------------------------------------------------------------------------------------
*/


END AnalyzeDB;
/

