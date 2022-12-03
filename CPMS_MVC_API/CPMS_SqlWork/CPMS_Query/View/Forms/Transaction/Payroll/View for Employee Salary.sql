create view v_emp_sal
as

select emppro_id,userid,ddate,
case when m_emppro.emppro_lde=0 then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else(
case when emppro_sot=1 and datename(weekday,ddate)='Saturday' then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else 
(case when min(inn)=max(out) then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else (case when cast(right(convert(varchar, min(inn), 100),7)as datetime)<cast(right(convert(varchar, m_rosgp.rosgp_in+cast(('00:'+cast(rosgp_lat as varchar(2))+':00')as varchar), 100),7)as datetime) then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else min(inn) end) end)end 
) end as inn,

case when emppro_sot=1 and datename(weekday,ddate)='Saturday' then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else 
(case when max(out)=min(inn) then cast(convert(varchar, max(out), 101) +' '+right(convert(varchar, m_rosgp.rosgp_out, 100),7) as datetime) else
 (case when cast(right(convert(varchar, max(out), 100),7)as datetime)<cast(right(convert(varchar, m_rosgp.rosgp_in, 100),7)as datetime) then cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) else
  (case when cast(right(convert(varchar, max(out), 100),7)as datetime)<cast(right(convert(varchar, m_rosgp.rosgp_out-cast(('00:'+cast(rosgp_ear as varchar(2))+':00') as varchar), 100),7)as datetime) then max(out) else 
  cast(convert(varchar, max(out), 101) +' '+right(convert(varchar, m_rosgp.rosgp_out, 100),7) as datetime) 
  end)
 end)
end)end as out
--,cast(right(convert(varchar, min(inn), 100),7)as datetime),cast(right(convert(varchar, m_rosgp.rosgp_in+cast(('00:'+cast(rosgp_lat as varchar(2))+':00')as varchar), 100),7)as datetime)
--,min(inn),max(out)
from v_att inner join m_emppro on v_att.userid=m_emppro.emppro_userid inner join m_rosgp on m_emppro.ros_id=m_rosgp.rosgp_id
where datename(weekday,ddate)<>'Sunday'
 --and emppro_id=30
 and (select mholi_dayact from m_holi where mholi_dat=v_att.ddate)=0 --and (case when emppro_sot=1 then datename(weekday,ddate)<>'Sunday' else (emppro_sot=1 and datename(weekday,ddate)<>'Saturday') end)
group by m_emppro.emppro_id,rosgp_in,rosgp_out,ddate,userid,cast(convert(varchar, ddate, 101) as datetime),rosgp_lat,rosgp_ear,emppro_sot,emppro_lde


