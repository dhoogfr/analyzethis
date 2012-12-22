create or replace
type &AnalyzeThisUser..Argv as
table of varchar2(4000);
/

create table &AnalyzeThisUser..debugTab(
  userid     varchar2(30) primary key,
  modules     varchar2(4000),
  locat         varchar2(4000),
  filename varchar2(4000)
)
/

create or replace
trigger &AnalyzeThisUser..bi_fer_debugtab
before insert on &AnalyzeThisUser..debugtab for each row
begin
  :new.modules := upper( :new.modules );
end;
/
