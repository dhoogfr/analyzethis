-- <MODULE_NAME> crea_objects </MODULE_NAME>
-- <VERSION> 1.0 </VERSION>
-- <AUTHOR> Freek D'Hooge </AUTHOR>
-- <SUMMARY>
--     creates the needed objects during installation
-- </SUMMARY>
-- <MODIFICATIONS>
--     <MODIFICATION>
--         <DATE> 21/12/2007 </DATE>
--         <AUTHOR> Freek D'Hooge </AUTHOR>
--         <WHAT> Added a "not null" check to the statoptions.owner column.
--                This change was needed because the option to have set options on object_type level without an owner level, was replaced with the possiblity
--                to use a "*" as the owner name.
--                Also the procedure to add the current users in the statoptions table has been removed in favor of using 2 entries (one for tables and one for
--                the indexes) with the owner set to '*'
--         </WHAT>
--     </MODIFICATION>
-- </MODIFICATIONS>

create table &AnalyzeThisUser..statoptions
( owner                 varchar2(30)    not null,    
  object_name           varchar2(30),
  part_name             varchar2(30),
  subpart_name          varchar2(30),
  object_type           varchar2(6)     not null,
  locked                varchar2(5)     default 'FALSE',
  auto_sample_size      varchar2(5)     default 'TRUE',
  estimate_percent      number(9,6)     default null,
  block_sample          varchar2(5)     default 'FALSE',
  method_opt            varchar2(250)   default 'FOR ALL COLUMNS SIZE AUTO',
  default_degree        varchar2(5)     default 'AUTO',
  degree                number(2)       default NULL,
  granularity           varchar2(12)    default 'AUTO',
  cascade               varchar2(5)     default 'AUTO',
  no_invalidate         varchar2(5)     default 'AUTO',
  check(object_type in ('TABLE', 'INDEX')),
  check(locked in ('TRUE', 'FALSE')),
  check(auto_sample_size in ('TRUE', 'FALSE')),
  check(block_sample in ('TRUE', 'FALSE')),
  check(default_degree in ('AUTO', 'TRUE', 'FALSE')),
  check(granularity in ('DEFAULT', 'SUBPARTITION', 'PARTITION', 'GLOBAL', 'ALL', 'AUTO','GLOBAL AND PARTITION')),
  check(cascade in ('TRUE', 'AUTO', 'FALSE')),
  check(no_invalidate in ('TRUE', 'AUTO', 'FALSE'))
);

create table &AnalyzeThisUser..run_history
( statid                varchar2(11) not null,
  starttime             date,
  endtime               date,
  operation             varchar2(250),
  calcfailures          number(10,0),
  expfailures           number(10,0),
  protected             varchar2(1)     default 'N' not null,
  check(protected in ('Y', 'N'))
);

create table &AnalyzeThisUser..run_history_details
( statid                varchar2(11),
  starttime             date,
  stoptime              date,
  calc_status           varchar2(250),
  exp_status            varchar2(250),
  ownname               varchar2(30) not null,
  objtype               varchar2(6)  not null,
  objname               varchar2(30) not null,
  partname              varchar2(30),
  subpartname           varchar2(30),
  sto_ownname           varchar2(30),
  sto_objtype           varchar2(6),
  sto_objname           varchar2(30),
  sto_partname          varchar2(30),
  sto_subpartname       varchar2(30),
  sto_locked            varchar2(5),
  sto_auto_sample_size  varchar2(5),
  sto_estimate_percent  number(9,6),
  sto_block_sample      varchar2(5),
  sto_method_opt        varchar2(250),
  sto_default_degree    varchar2(5),
  sto_degree            number(2),
  sto_granularity       varchar2(12),
  sto_cascade           varchar2(5),
  sto_no_invalidate     varchar2(5)
);

BEGIN

    dbms_stats.create_stat_table
        ( ownname       =>  '&AnalyzeThisUser',
          stattab       =>  'STATISTICS_HISTORY'
        );
        
END;
/


create sequence &AnalyzeThisUser..seq_statid
start with 1
increment by 1
cache 2;

alter table &AnalyzeThisUser..statoptions 
add constraint sta_pk 
unique
    ( owner,
      object_name,
      object_type,
      part_name,
      subpart_name
    );

alter table &AnalyzeThisUser..run_history
add constraint rhi_pk
primary key
    ( statid
    );

alter table &AnalyzeThisUser..run_history_details
add constraint rhd_pk
unique
    ( statid,
      ownname,
      objname,
      objtype,
      partname,
      subpartname
    );

create index &AnalyzeThisUser..rh_endtime_i
on &AnalyzeThisUser..run_history
    ( endtime
    );

alter table &AnalyzeThisUser..run_history_details
add constraint rhd_rh_fk
foreign key (statid)
references &AnalyzeThisUser..run_history (statid);

alter table &AnalyzeThisUser..statistics_history
add constraint sth_rhi_fk
foreign key (statid)
references &AnalyzeThisUser..run_history (statid);

create view &AnalyzeThisUser..dictionary_schemas
(schema)
as
select distinct schema
from ( select schema from dba_registry
       union all
       select 'SYSTEM' from dual
     );

-- input default values
insert into &AnalyzeThisUser..statoptions ( owner, object_type)
values ('*', 'TABLE');

insert into &AnalyzeThisUser..statoptions ( owner, object_type)
values ('*', 'INDEX');
  
commit;
