USE [MFI]
GO

alter view [dbo].[v_inout]
as
--Time In
select userid,
min(checktime) as [Inn],max(checktime) as [Out],
cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime) as [DDate],
convert(varchar, min(checktime), 108)  as [intime],
case when cast(right(convert(varchar, min(checktime), 100),7) as datetime)=cast(right(convert(varchar, max(checktime), 100),7) as datetime) then null else  convert(varchar, max(checktime), 108) end as [outtime] ,
check_typ,checkinout.inoutcat_id,inoutcat_nam
from checkinout 
left join m_inoutcat
on CHECKINOUT.inoutcat_id=m_inoutcat.inoutcat_id
where check_app=0
group by convert(varchar, checktime, 101),userid,check_typ,checkinout.inoutcat_id,inoutcat_nam

GO


