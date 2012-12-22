set linesize 150

column operation format a30 word_wrapped
column exp_status format a15
column calc_status format a15
column calcfailures format 999G999
column expfailures format 999G999
column counted format 999G999
column statid format a4 heading "id"

break on starttime, on endtime, on operation, on calcfailures, on expfailures

with rhd_aggr as
( select statid, calc_status, exp_status, count(*) counted
  from analyzethis.run_history_details
  group by statid, calc_status, exp_status
 )
select to_char(rh.starttime, 'dd/mm/yyyy hh24:mi:ss') starttime, 
       to_char(rh.endtime, 'dd/mm/yyyy hh24:mi:ss') endtime, 
       rh.operation, rh.statid, rh.calcfailures, rh.expfailures, rhda.exp_status, 
       rhda.calc_status, rhda.counted
from analyzethis.run_history rh, rhd_aggr rhda
where  rh.statid = rhda.statid(+)
order by rh.starttime, rh.endtime, rh.operation, rhda.exp_status, rhda.calc_status;

