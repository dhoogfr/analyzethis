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
accept DefaultTS char prompt "Enter default tablespace for user &AnalyzeThisUser [USERS]: " def USERS
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
@analyzethis.pks
show err
@analyzethis.plb
show err

-- install the extention packages
prompt
prompt installing the extention packages
@analyzedb.pks
show err
@analyzedb.plb
show err
prompt

