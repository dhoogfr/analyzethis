-- create the user
prompt creating user &AnalyzethisUser
create user &AnalyzeThisUser identified by &AnalyzeThisPwd
default tablespace &DefaultTS
temporary tablespace &TempTS
quota unlimited on &DefaultTS
account unlock
/

-- grant the necessary privileges

prompt granting the necessary privileges
grant create session to &AnalyzeThisUser;
grant analyze any to &AnalyzeThisUser;
grant select on dba_registry to &AnalyzeThisUser;
grant select any table to &AnalyzeThisUser;
grant execute any procedure to &AnalyzeThisUser;

prompt granting privileges needed for the packages getLastAnalyzedDate and getIndexTable
grant select on dba_indexes to &AnalyzeThisUser;
grant select on dba_ind_partitions to &AnalyzeThisUser;
grant select on dba_ind_subpartitions to &AnalyzeThisUser;
grant select on dba_tables to &AnalyzeThisUser;
grant select on dba_tab_partitions to &AnalyzeThisUser;
grant select on dba_tab_subpartitions to &AnalyzeThisUser;

prompt granting privileges needed for the getIndexTable package
grant select on dba_part_indexes to &AnalyzeThisUser;

prompt granting privileges needed for the analyzedb package
grant select on dba_segments to  &AnalyzeThisUser;
