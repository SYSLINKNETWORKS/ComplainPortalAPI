USE rough
GO

ALTER view v_emp_latmin
as

select 
--cast(convert(varchar, inn, 101) +right(convert(varchar, rosgp_in, 100),7) as datetime) 
emppro_id,ddate,cast(datediff(mi,(cast(convert(varchar, min(inn), 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime)),inn) as float)/60 as latemin
from v_att inner join m_emppro on v_att.userid=m_emppro.emppro_userid inner join m_rosgp on m_emppro.ros_id=m_rosgp.rosgp_id-- where inn>dateadd(mm,rosgp_lat,cast(convert(varchar, inn, 101) +right(convert(varchar, rosgp_in, 100),7) as datetime))
where (cast(right(convert(varchar, inn, 100),7)as datetime))>(cast(right(convert(varchar, m_rosgp.rosgp_in+cast(('00:'+cast(rosgp_lat as varchar(2))+':00') as varchar), 100),7)as datetime))
and datename(weekday,ddate)<>'Sunday'
and ddate not in (select mholi_dat from m_holi where mholi_dayact=1)
group by ddate,rosgp_in,inn,emppro_id
