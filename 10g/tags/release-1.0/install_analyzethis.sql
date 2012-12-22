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
    along with AnalyzeThis.  If not, see <http://www.gnu.org/licenses/>.
*/

set verify off
set echo off
set feedback off

-- prompt for the username and password
accept AnalyzeThisUser char prompt "Enter user to hold the analyze packages [analyzethis]: " def analyzethis
accept AnalyzeThisPwd char prompt "Enter password for user &AnalyzeThisUser [&AnalyzeThisUser]: " def &AnalyzeThisUser

-- list the available tablespaces
-- and let the user choose the default and temporary tablespace
set linesize 120
set pagesize 999
column tablespace_name format a30
column contents format a10
column max_mb format 9G999G999D99
column curr_mb format 9G999G999D99
column free_mb format 9G999G999D99
column pct_free format 990D99

select A.tablespace_name, A.contents, B.max_mb, B.curr_mb,
       (B.max_mb - B.curr_mb) + nvl(c.free_mb,0) free_mb, 
       ((100/B.max_mb)*(B.max_mb - B.curr_mb + nvl(c.free_mb,0))) pct_free
from dba_tablespaces A,
     ( select tablespace_name, sum(bytes)/1024/1024 curr_mb, 
              sum(greatest(bytes, maxbytes))/1024/1024 max_mb
       from dba_data_files
       group by tablespace_name
       union all
       select tablespace_name, sum(bytes)/1024/1024 curr_mb,
              sum(greatest(bytes, maxbytes))/1024/1024 max_mb
       from dba_temp_files
       group by tablespace_name
     ) B,
     ( select tablespace_name, sum(bytes)/1024/1024 free_mb
       from dba_free_space
       group by tablespace_name
     ) C
where A.tablespace_name = B.tablespace_name
      and A.tablespace_name = C.tablespace_name(+)
order by tablespace_name;

prompt
accept DefaultTS char prompt "Enter default tablespace for user &AnalyzeThisUser [SYSAUX]: " def SYSAUX
accept TempTS char prompt "Enter temporary tablespace for user &AnalyzeThisUser [TEMP]: " def TEMP
prompt
-- create the user
@crea_usr.sql

-- setup the debug package
prompt
prompt
prompt installing the debugging objects and packages
prompt creating the db objects
@crea_debug_objects.sql

prompt
prompt installing the packages
@debug.pks
show err
@empty_debug.pkb
show err


-- create the base analyzethis
prompt
prompt
prompt installing the analyzethis base objects and packages
prompt creating the db objects
@crea_objects.sql

prompt
prompt creating the helper packages
@getLastAnalyzedDate.pks
show err
@getLastAnalyzedDate.pkb
show err
@getIndexTable.pks
show err
@getIndexTable.pkb
show err

prompt
prompt creating the core packages
@AnalyzeThis.pks
show err
@AnalyzeThis.pkb
show err

-- install the extention packages
prompt
prompt installing the extention packages
@AnalyzeDB.pks
show err
@AnalyzeDB.pkb
show err
prompt

/*
  You can now setup a scheduler job to automate the gather stats (see scheduler_example.sql for an example), 
  but don't forget to turn off the default stats job:
  
    exec dbms_scheduler.disable('GATHER_STATS_JOB');

*/