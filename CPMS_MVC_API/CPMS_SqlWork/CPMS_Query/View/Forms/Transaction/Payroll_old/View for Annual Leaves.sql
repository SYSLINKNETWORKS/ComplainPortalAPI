use mfi
go

create view v_anl
as

select 
	v_att.userid,emppro_macid,emppro_nam,m_emppro.ros_id,ddate,inn,rosgp_in,case when datediff(mi,cast(convert(varchar, inn, 101) +' '+right(convert(varchar, dateadd(mi,rosgp_lat,rosgp_in), 100),7) as datetime),inn)>0 then inn-cast(convert(varchar, inn, 101) +' '+right(convert(varchar, m_rosgp.rosgp_in, 100),7) as datetime) end as [Lateinn],
	out,rosgp_out,case when datediff(mi,out,cast(convert(varchar, out, 101) +' '+right(convert(varchar, dateadd(mi,-rosgp_ear,rosgp_out), 100),7) as datetime))>0 then cast(convert(varchar, out, 101) +' '+right(convert(varchar, m_rosgp.rosgp_out, 100),7) as datetime)-out end as [Earlygo]
	--,datediff(mi,out,cast(convert(varchar, out, 101) +' '+right(convert(varchar, dateadd(mi,-rosgp_ear,rosgp_out), 100),7) as datetime))
	--,datediff(mi,out,cast(convert(varchar, out, 101) +' '+right(convert(varchar, dateadd(mi,rosgp_ear,rosgp_out), 100),7) as datetime))
	from m_emppro
	--Join with Roster
	inner join m_rosgp
	on m_emppro.ros_id=m_rosgp.rosgp_id
	--Join with Attendence View
	inner join v_att 
	on m_emppro.emppro_userid=v_att.userid
	--order by ddate
	