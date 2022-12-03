USE ZSons
GO

--drop table tbl_abs
--create table tbl_abs
--(
--emppro_id int,
--emppro_days int,
--emppro_pa int,
--emppro_sun int,
--emppro_hol int,
--emppro_app int,
--emppro_fabs bit, --Full Month Absent
--emppro_sot bit,
--emppro_reg bit,
--emppro_regdat datetime,
--emppro_abs as emppro_days-(emppro_pa+emppro_sun+emppro_hol+emppro_app)
--)

--exec sp_rpt_attendance '09/04/2013','09/04/2013'

alter proc sp_rpt_attendance(@dt1 datetime,@dt2 datetime)
as
begin
declare
@dt3 datetime
	delete from tbl_abs
insert into tbl_abs  select emppro_id,datepart(dd,@dt2) as [TotalDays],count(ddate) as [PresentDays],0,0,0,0,emppro_sot,emppro_reg,case emppro_reg when 1 then emppro_reg_dat else @dt2 end from v_rpt_attendance inner join m_emppro on v_rpt_attendance.userid=m_emppro.emppro_userid where  emppro_attexp =0 and ddate between @dt1 and @dt2 and datename(dw,ddate) <> 'Sunday' and emppro_sot=0 and ddate not in (select mholi_dat from m_holi where mholi_dayact=1 and mholi_dat between @dt1 and @dt2) and emppro_reg=0 group by emppro_id,emppro_sot,emppro_reg,emppro_reg_dat
insert into tbl_abs  select emppro_id,datepart(dd,@dt2) as [TotalDays],count(ddate) as [PresentDays],0,0,0,0,emppro_sot,emppro_reg,case emppro_reg when 1 then emppro_reg_dat else @dt2 end from v_rpt_attendance inner join m_emppro on v_rpt_attendance.userid=m_emppro.emppro_userid where  emppro_attexp =0 and ddate between @dt1 and @dt2 and datename(dw,ddate) not in ( 'Sunday','Saturday')  and ddate not in (select mholi_dat from m_holi where mholi_dayact=1 and mholi_dat between @dt1 and @dt2) and emppro_sot=1 and emppro_reg=0group by emppro_id,emppro_sot,emppro_reg,emppro_reg_dat
--Full Month Absent
insert into tbl_abs  select emppro_id,datepart(dd,@dt2) as [TotalDays],0,0,0,0,1,emppro_sot,emppro_reg,case emppro_reg when 1 then emppro_reg_dat else @dt2 end from m_emppro where emppro_userid not in (select emppro_userid from v_rpt_attendance where ddate between @dt1 and @dt2) and emppro_attexp =0

	--Sundays
	print 'Sunday'
	;with dates ( date )
	as
	(
	select @dt1
	union all
	select dateadd(d,1,date)
	from dates
	where date < @dt2
	)
	update tbl_abs set emppro_sun=(select isnull(count(date),0) from dates where datename(dw,date) = 'Sunday') where emppro_sot=0 and emppro_fabs=0
	
	--Saturday
	print 'Saturday'
	;with dates ( date )
	as
	(
	select @dt1
	union all
	select dateadd(d,1,date)
	from dates
	where date < @dt2
	)
	update tbl_abs set emppro_sun=(select isnull(count(date),0) from dates where datename(dw,date) in ('Sunday','Saturday')) where emppro_sot=1 and emppro_fabs=0
	
	set @dt3=(select max(emppro_regdat) from tbl_abs where emppro_reg=1)
	--Resign
	print 'Resign Sunday'
	;with dates ( date )
	as
	(
	select @dt1
	union all
	select dateadd(d,1,date)
	from dates
	where date < @dt3
	)
	update tbl_abs set emppro_sun=(select isnull(count(date),0) from dates where datename(dw,date) in ('Sunday')) where emppro_sot=0 and emppro_reg=1 and emppro_fabs=0

	--Resign Saturday
	set @dt3=(select max(emppro_regdat) from tbl_abs where emppro_reg=1)
	print 'Resign Saturday Sunday'
	;with dates ( date )
	as
	(
	select @dt1
	union all
	select dateadd(d,1,date)
	from dates
	where date < @dt3
	)
	update tbl_abs set emppro_sun=(select isnull(count(date),0) from dates where datename(dw,date) in ('Sunday','Saturday')) where emppro_sot=1 and emppro_reg=1 and emppro_fabs=0
	
	--Holidays
	update tbl_abs set emppro_hol=(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_rmks<>'Sunday' and mholi_dayact=1) where  emppro_reg=1 and emppro_sot=0 and emppro_fabs=0
	update tbl_abs set emppro_hol=(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_rmks<>'Sunday' and mholi_dayact=1) where  emppro_reg=0 and emppro_sot=0 and emppro_fabs=0
	update tbl_abs set emppro_hol=(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and datename(dw,mholi_dat) not in ('Saturday','Sunday') and mholi_dayact=1) where  emppro_reg=0 and emppro_sot=1 and emppro_fabs=0
	update tbl_abs set emppro_hol=(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dat<=emppro_regdat and mholi_rmks<>'Sunday' and mholi_dayact=1) where  emppro_reg=1 and emppro_sot=0 and emppro_fabs=0

	--Approval
	update tbl_abs set emppro_app=(select count(mabs_dat) from m_abs inner join m_emppro on m_abs.emppro_macid=m_emppro.emppro_macid where m_emppro.emppro_id=tbl_abs.emppro_id and mabs_app=1 and mabs_dat between @dt1 and @dt2 ) where emppro_fabs=0

	delete from tbl_abs where emppro_abs=0
	select emppro_macid,emppro_nam,isnull(emppro_days,0) as [emppro_days],isnull(emppro_abs,0) as [emppro_abs] from tbl_abs inner join m_emppro on tbl_abs.emppro_id=m_emppro.emppro_id  order by emppro_macid

end