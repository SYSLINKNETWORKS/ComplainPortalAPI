USE [zsons]
GO

ALTER view [dbo].[v_anl]
as

select 
	v_attd.userid,m_emppro.emppro_macid,emppro_nam,m_emppro.ros_id,checkdate,inn,rosgp_in,case when datediff(mi,cast(convert(varchar, inn, 101) +' '+right(convert(varchar, dateadd(mi,rosgp_lat,rosgp_in), 100),7) as datetime),inn)>0 then inn-cast(convert(varchar, inn, 101) +' '+right(convert(varchar, rosgp_in, 100),7) as datetime) end as [Lateinn],
	out,rosgp_out,case when datediff(mi,out,cast(convert(varchar, out, 101) +' '+right(convert(varchar, dateadd(mi,-rosgp_ear,rosgp_out), 100),7) as datetime))>0 then cast(convert(varchar, out, 101) +' '+right(convert(varchar, rosgp_out, 100),7) as datetime)-out end as [Earlygo]
	from m_emppro
	--Join with Attendence View
	inner join v_attd
	on m_emppro.emppro_userid=v_attd.userid
	
GO


