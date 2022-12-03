USE [PHM]
GO

--select * from v_inout 

alter view [dbo].[v_inout]
as
--Time In
select userid,
min(checktime) as [Inn],max(checktime) as [Out],
cast(convert(varchar, checktime, 101) +' 00:00:00' as datetime) as [DDate],
case checktype when 'I' then convert(varchar, min(checktime), 108) else null end  as [intime],
case checktype when 'O' then convert(varchar, max(checktime), 108) else null end as [outtime],
--case when cast(right(convert(varchar, min(checktime), 100),7) as datetime)=cast(right(convert(varchar, max(checktime), 100),7) as datetime) then null else  convert(varchar, max(checktime), 108) end as [outtime] ,
--case checktype when 'I' then convert(varchar, min(checktime), 108) else null end as [intime],
--case checktype when 'O' then convert(varchar, min(checktime), 108) else null end as [outtime],
check_app,
check_typ,checkinout.inoutcat_id,inoutcat_nam
from checkinout 
left join m_inoutcat
on CHECKINOUT.inoutcat_id=m_inoutcat.inoutcat_id
where --check_app=0 and
check_typ='U'
group by convert(varchar, checktime, 101),userid,CHECKTYPE,check_typ,checkinout.inoutcat_id,inoutcat_nam,check_app--,CHECKTYPE

GO


--select * from CHECKINOUT where USERID=7 and convert(varchar, checktime, 101)='02/03/2015'
