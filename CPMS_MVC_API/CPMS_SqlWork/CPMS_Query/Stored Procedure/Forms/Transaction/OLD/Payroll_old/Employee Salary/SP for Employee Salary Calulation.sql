--USE [zsons]
--GO

/****** Object:  StoredProcedure [dbo].[sp_employee_salary]    Script Date: 10/29/2013 20:25:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--select * from emp_sal where emppro_macid =7 and emp_sal_dat ='08/31/2014'


--Drop table emp_sal
--CREATE table emp_sal
--(
--emp_sal_sno int identity(1001,1),
----emp_sal_id int,
--emp_sal_dat datetime,
--emp_sal_days int,
--emppro_id int,
--emppro_macid int,
--emppro_userid int,
--emppro_actemp_sal float default 0,
----emppro_perday_sal as round(emppro_actemp_sal/emp_sal_days,2),
--emppro_perday_sal as round(emppro_actemp_sal/30,2),
--emppro_roosterhrs float default 0,
--emppro_perhrs_sal as round(((emppro_actemp_sal/30)/emppro_roosterhrs),0),
--emppro_permin_sal as round((((emppro_actemp_sal/30)/emppro_roosterhrs))/60,2),
--emppro_pa int default 0,
--emppro_sunpre int default 0,
--emppro_absapp int default 0,
--emppro_absday as emp_sal_days-(emppro_pa+emppro_absapp),
--emppro_absamt as round((emp_sal_days-(emppro_pa+emppro_absapp))*round( emppro_actemp_sal/30,2),0),
--emppro_totpre int default 0, --total present
--emppro_emp_sal as round((emppro_actemp_sal/emp_sal_days)*emppro_totpre,0),
--emppro_addoth float default 0,
--emppro_latmin float default 0,
--emppro_latamt float default 0,
--emppro_ot float default 0,
--emppro_otamt float default 0,
--emppro_intax float default 0,
--all_att float default 0,
--all_heat float default 0,
--emppro_adv float default 0,
--emppro_loan float default 0,
--emppro_dedoth float default 0,
--emppro_eobi float default 0,
--com_id char(2),
--br_id char(3),
--m_yr_id char(2),
--mvch_id char(12),
--mvch_id_paid char(12),
--emp_Sal_st bit default 0,
--emp_sal_reg bit default 0,
--emp_sal_reg_dat datetime,
--emp_sal_sot bit default 0,
--emp_sal_attexp bit default 0,
--totaldays int default 1,
--emppro_pay as emppro_actemp_sal+emppro_otamt+all_att+all_heat+emppro_addoth-((round((emp_sal_days-(emppro_pa+emppro_absapp))*round( emppro_actemp_sal/30,2),0))+emppro_latamt+emppro_Adv+emppro_loan+emppro_dedoth+emppro_eobi),
--)
--alter table emp_sal drop column emppro_pay
--alter table emp_sal add emppro_pay as emppro_actemp_sal+emppro_otamt+all_att+all_heat+emppro_addoth-((round((emp_sal_days-(emppro_pa+emppro_absapp))*round( emppro_actemp_sal/30,2),0))+emppro_latamt+emppro_Adv+emppro_loan+emppro_dedoth-emppro_eobi)
--alter table emp_sal add emp_sal_sot bit default 0
--alter table emp_sal add emp_sal_reg_dat datetime
--alter table emp_sal add emp_sal_attexp bit default 0
--update emp_sal set emp_sal_attexp=0

--select emp_sal_reg from emp_sal
--update emp_sal set emp_sal_sot=0


--insert into m_sal values(43,'1990-08-01 00:00:00.000',35575,1,35575,44,'S')
--insert into m_sal values(147,'2012-07-01 00:00:00.000',11000,1,11000,1,'S')
--update m_emppro set msal_id=147 where emppro_id=1
--alter table m_sys add acc_salarypayable char(20)
--update m_sys set acc_salarypayable ='02003002007'


----Constraint
----Foreign Key
--alter table emp_sal add constraint FK_Temp_sal_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)

--select * from m_empall
--select case when all_fix=1 then all_amt when all_fix=0 then round(((all_amt/31)*20),0)  else 0 end from m_empall inner join m_all on m_empall.all_id=m_all.all_id where emppro_id=76-- and emp_sal_dat between @dt1 and @dt2
--select * from m_emppro where emppro_userid=144
--	select * from v_att where datename(dw,ddate)='Sunday' and ddate between '10/01/2012' and '10/31/2012'
--select * from v_att where  ddate in (select mholi_dat from m_holi where mholi_dat between '10/01/2012' and '10/31/2012' and mholi_dayact=1)

--select * from m_sal where msal_dat>'07/01/2012'
--update m_sal set msal_dat='07/01/2012'  where msal_dat>'07/01/2012'
--update m_emppro set emppro_doj='07/01/2012' where emppro_doj>'07/01/2012'

--exec sp_employee_salary '01','01','07/01/2014','07/31/2014','02',1,''
--exec sp_employee_salary '01','01','01/01/2013','01/31/2013','01',1,''
--select * from  emp_sal where emp_sal_dat='11/30/2012'
--delete from emp_sal
--select * from emp_sal where emppro_macid=207 and emp_sal_dat='01/31/2013'
--select * from m_emppro where emppro_userid=207

--	alter table emp_sal add totaldays int default 1
--	set @totaldays=(select userid from checkinout where userid=@emppro_id and CONVERT(VARCHAR(10),checktime,101) between @dt1 and @dt2 )
--select * from emp_sal where emppro_macid=10


--alter table emp_sal add emppro_eobi float default 0,emppro_intax float default 0
--alter table emp_sal drop column emppro_pay
--alter table emp_sal add emppro_pay as emppro_actemp_sal+emppro_otamt+all_att+all_heat+emppro_addoth-((round((emp_sal_days-(emppro_pa+emppro_absapp))*round( emppro_actemp_sal/emp_sal_days,2),0))+emppro_latamt+emppro_Adv+emppro_loan+emppro_dedoth+emppro_eobi+emppro_intax)
--exec sp_employee_salary '01','01','11/01/2014','11/30/2014','03',1,''
--select * from v_att

ALTER proc [dbo].[sp_employee_salary] (@com_id char(3),@br_id char(2),@dt1 datetime,@dt2 datetime,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as
declare
@emppro_id int,
@trec_amt float,
@tloan_id int,
@totaldays int
begin
	--Delete the records
	print 'Delete Record'	
	delete from emp_sal where emp_sal_dat=@dt2
	delete from emp_sal_loan_rec where trec_dat=@dt2
	--employee Name
	print 'Employee Name'
	insert into emp_sal(emppro_id,emppro_macid,emppro_userid,emp_sal_dat,emp_sal_days,com_id,br_id,m_yr_id,emp_sal_sot,emp_sal_attexp) select emppro_id,emppro_macid,emppro_userid,@dt2,datepart(dd,@dt2),@com_id,@br_id,@m_yr_id,emppro_sot,emppro_attexp from m_emppro where emppro_st=1 and emppro_salsp=0 and emppro_reg=0 and emppro_doj<=@dt2 --and emppro_macid=111
	--Resign Persons
	insert into emp_sal(emppro_id,emppro_macid,emppro_userid,emp_sal_dat,emp_sal_days,com_id,br_id,m_yr_id,emp_sal_reg,emp_sal_reg_dat,emp_sal_sot,emp_sal_attexp) select emppro_id,emppro_macid,emppro_userid,@dt2,datepart(dd,@dt2),@com_id,@br_id,@m_yr_id,1,emppro_reg_dat,emppro_sot,emppro_attexp from m_emppro where emppro_st=1 and emppro_salsp=0 and emppro_reg=1 and emppro_reg_dat between @dt1 and @dt2 --and emppro_macid=111
	--Salary
	print 'Basic Salary'	
	update emp_sal set emppro_actemp_sal=(select isnull(msal_amt,0) from m_sal where msal_dat=(select max(msal_dat) from m_sal where msal_dat<=@dt2 and emppro_id=emp_sal.emppro_id) and emppro_id=emp_sal.emppro_id) where emp_sal_dat=@dt2
	--Days Present
	print 'Present Days'
	update emp_sal set emppro_pa=(	select isnull(count(DDate),0) from v_att where DDate between @dt1 and @dt2 and v_att.userid=emp_sal.emppro_userid and datename(dw,ddate)<>'Sunday' ) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_sal set emppro_pa= (select DATEpart(Day,@dt2)) where emp_sal_dat=@dt2 and emp_sal_attexp=1
	update emp_sal set emppro_pa=emppro_pa-(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_rmks<>'Sunday' and mholi_dayact=1 and mholi_dat in (select ddate from v_rpt_attendance where DDate between @dt1 and @dt2 and v_rpt_attendance.userid=emp_sal.emppro_userid)) where emp_sal_dat=@dt2 and emp_sal_attexp=0
--	update emp_sal set emppro_pa=emppro_pa-(select count(DDate) from v_att where datename(dw,ddate)='Saturday' and ddate between @dt1 and @dt2 and v_att.userid=emp_sal.emppro_userid )  where emp_sal_dat=@dt2 and emp_sal_sot=1 and emp_sal_attexp=0
	--Holidays
	print 'Holidays'
	update emp_sal set emppro_pa=emppro_pa+(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_rmks<>'Sunday' and mholi_dayact=1) where emp_sal_dat=@dt2 and emp_sal_reg=0 and emp_sal_sot=0 and emp_sal_attexp=0
	update emp_sal set emppro_pa=emppro_pa+(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and datename(dw,mholi_dat) not in ('Saturday','Sunday') and mholi_dayact=1) where emp_sal_dat=@dt2 and emp_sal_reg=0 and emp_sal_sot=1 and emp_sal_attexp=0
	update emp_sal set emppro_pa=emppro_pa+(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dat<=emp_sal_reg_dat and mholi_rmks<>'Sunday' and mholi_dayact=1) where emp_sal_dat=@dt2 and emp_sal_reg=1 and emp_sal_sot=0 and emp_sal_attexp=0
	update emp_sal set emppro_pa=emppro_pa+(select count(mholi_dat) from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dat<=emp_sal_reg_dat and datename(dw,mholi_dat) not in ('Saturday','Sunday') and mholi_dayact=1) where emp_sal_dat=@dt2 and emp_sal_reg=1 and emp_sal_sot=1 and emp_sal_attexp=0
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
	update emp_sal set emppro_pa=emppro_pa+(select isnull(count(date),0) from dates where datename(dw,date) = 'Sunday') where emp_sal_dat=@dt2 and emp_sal_reg=0 and emp_sal_attexp=0

	
	----Saturday
	--print 'Saturday'
	--;with dates ( date )
	--as
	--(
	--select @dt1
	--union all
	--select dateadd(d,1,date)
	--from dates
	--where date < @dt2
	--)
	--update emp_sal set emppro_pa=emppro_pa+(select isnull(count(date),0) from dates where datename(dw,date) = 'Saturday') where emp_sal_dat=@dt2 and emp_sal_reg=0 and emp_sal_sot=1 and emp_sal_attexp=0

	--Absent in complete month
	print 'Absent in Complete month'
	update emp_sal set totaldays=(select count(*) from checkinout where userid=emppro_macid and checkdate between @dt1 and @dt2 ) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_sal set emppro_pa=0 where totaldays=0 and emp_sal_dat=@dt2 and emp_sal_attexp=0
	--Absent Approval
	print 'Absent Approval'
	update emp_sal set emppro_absapp=(select count(mabs_dat) from m_abs where m_abs.emppro_macid=emp_sal.emppro_macid and mabs_app=1 and mabs_dat between @dt1 and @dt2 ) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	--Total Present Days
	print 'Total Present Days'
	update emp_sal set emppro_totpre=(select emppro_pa+emppro_absapp from emp_sal paabs where paabs.emppro_macid=emp_sal.emppro_macid and paabs.emp_sal_dat=@dt2)  where emp_sal_dat=@dt2
	--Rooster Hours
	print 'Rooster Hours'
	update emp_sal set emppro_roosterhrs=(select  rosgp_wh from m_rosgp inner join m_emppro on m_rosgp.ros_id=m_emppro.ros_id where m_emppro.emppro_macid=emp_sal.emppro_macid and rosgp_dat =(select MAX(rosgp_dat) from m_rosgp mrosgp where m_rosgp.ros_id=mrosgp.ros_id and mrosgp.rosgp_dat<=@dt2)) where emp_sal_dat=@dt2
	--select * from m_rosgp inner join m_ros on m_rosgp.ros_id=m_ros.ros_id 
	--Late Min
	print 'Late Min'
	--update emp_sal set emppro_latmin=(select isnull(round((sum(isnull(late_inn,0)+isnull(early_going,0))),4),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and ddate between @dt1 and @dt2 and datename(dw,ddate) not in ('Saturday','Sunday') and ddate not in (select isnull(mholi_dat,'') from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dayact=1 and mholi_rmks<>'Sunday')) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	--update emp_sal set emppro_latmin=(select isnull(round((sum(isnull(late_inn,0)+isnull(early_going,0))),4),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where emppro_sot=0 and v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and ddate between @dt1 and @dt2 and datename(dw,ddate)='Saturday' and ddate not in (select isnull(mholi_dat,'') from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dayact=1 and mholi_rmks not in ('Sunday,''Sunday'))) where emp_sal_dat=@dt2 and emp_sal_sot=0 and emp_sal_attexp=0	
	--update emp_Sal set emppro_latmin=0 where emppro_latmin is null and emp_sal_dat=@dt2  and emp_sal_attexp=0
	update emp_sal set emppro_latmin=(select isnull(round((sum(isnull(late_inn,0)+isnull(early_going,0))),4),0) from v_emppro_ot inner join m_emppro on v_emppro_ot.emppro_macid=m_emppro.emppro_macid where v_emppro_ot.emppro_macid=emp_sal.emppro_macid and ddate between @dt1 and @dt2 and DATENAME(dw,ddate) not in ('Sunday')) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	----Late Amount
	print 'Late Amount'
	update emp_sal set emppro_latamt=(select isnull(round(emppro_latmin*emppro_permin_sal,0),0) from emp_sal latamount inner join m_emppro on latamount.emppro_macid=m_emppro.emppro_macid where latamount.emppro_macid=emp_sal.emppro_macid and emppro_lde=1 and latamount.emp_sal_dat between @dt1 and @dt2) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_Sal set emppro_latamt=0 where emppro_latamt is null and emp_sal_dat=@dt2 and emp_sal_attexp=0
	--Late Min update to Zero if Employee Late minute is not deducting
	update emp_sal set emppro_latmin=0 where emppro_latamt=0 and emp_sal_dat=@dt2 and emp_sal_attexp=0
	--Over Time
	--print 'Over Time'
	--update emp_sal set emppro_ot=(select isnull(sum(early_coming_OT)+sum(OT),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and emppro_ot=1 and ddate between @dt1 and @dt2 and ddate not in (select isnull(mholi_dat,'') from m_holi where mholi_dat between @dt1 and @dt2 and mholi_rmks<>'Sunday'  and mholi_dayact=1 or mholi_fovertime=1)) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_sal set emppro_ot=(select isnull(sum(early_coming_OT)+sum(OT),0) from v_emppro_ot inner join m_emppro on v_emppro_ot.emppro_macid=m_emppro.emppro_macid where v_emppro_ot.emppro_macid=emp_sal.emppro_macid and ddate between @dt1 and @dt2) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	------Holiday Over Time with Saturday
	------print 'Holiday Over Time'
	--update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(datediff(minute,inn,[out])),0) from v_rpt_attendance inner join m_emppro on v_rpt_attendance.userid=m_emppro.emppro_macid where v_rpt_attendance.userid=emp_sal.emppro_macid and emppro_ho=1 and emppro_sot=0 and ddate in (select mholi_dat from m_holi where  mholi_dat between @dt1 and @dt2 and mholi_dayact=1 and datename(dw,mholi_dat)<>'Sunday')) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	------print 'Holiday Over Time With Out Saturday'
	--update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(datediff(minute,inn,[out])),0) from v_rpt_attendance inner join m_emppro on v_rpt_attendance.userid=m_emppro.emppro_macid where v_rpt_attendance.userid=emp_sal.emppro_macid and emppro_ho=1 and emppro_sot=1 and ddate in (select mholi_dat from m_holi where mholi_dat between @dt1 and @dt2 and mholi_dayact=1 and datename(dw,mholi_dat)not in ('Sunday','Sunday'))) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	----Sunday Overtime
	--update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(totalmin),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and emppro_ho=1 and ddate between @dt1 and @dt2 and datename(dw,ddate)='Sunday') where emp_sal_dat=@dt2
	------Saturday Over Time
	----print 'Saturday Over Time'
	--update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(totalmin),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and emppro_sot=1  and datename(dw,ddate)='Saturday'  and ddate between @dt1 and @dt2) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	----Factory Over Time
	--print 'Factory Over Time'
	--update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(totalmin),0) from v_emppro_latmin inner join m_emppro on v_emppro_latmin.emppro_macid=m_emppro.emppro_macid where v_emppro_latmin.emppro_macid=emp_sal.emppro_macid and emppro_fot=1  and ddate in (select mholi_dat from m_holi where mholi_dat between @dt1 and @dt2 and mholi_fovertime=1))  where emp_sal_dat=@dt2 and emp_sal_attexp=0
	--Night OverTime
	print 'Night Over Time'
	update emp_sal set emppro_ot=emppro_ot+(select isnull(sum(datediff(minute,nightinn,nightout)),0) from v_nithrs where nithrs_dat between @dt1 and @dt2 and userid=emp_sal.emppro_macid and nithrs_app=1)  where emp_sal_dat=@dt2 and emp_sal_attexp=0	
	--Over Time Amount
	print 'Over Time Amount'
	update emp_sal set emppro_otamt=(select  case emppro_ckrat when 0 then  round((otamt.emppro_ot/60)*(emppro_perhrs_sal*emppro_rat),0) else round(ceiling(otamt.emppro_ot/60)*(emppro_rat),0) end from emp_sal otamt inner join m_emppro on otamt.emppro_macid=m_emppro.emppro_macid where otamt.emppro_macid=emp_sal.emppro_macid and emp_sal_dat=@dt2) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_Sal set emppro_otamt=0 where  emppro_otamt is null and emp_sal_dat=@dt2 and emp_sal_attexp=0
	----Attendence Allowance
	print 'Attendences Allowances'
	update emp_sal set all_att=(select case emppro_Att when 1 then case when isnull(emppro_pa,0)=emp_Sal_days then 300 else 0 end else 0 end from emp_sal empsalary inner join m_emppro on empsalary.emppro_macid=m_emppro.emppro_macid where empsalary.emppro_id=m_emppro.emppro_id and emppro_att=1 and empsalary.emppro_id=emp_sal.emppro_id and emp_sal_dat=@dt2) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_sal set all_att=0 where all_att is null and emp_sal_attexp=0
--select * from emp_sal where emppro_macid=1 and emp_sal_dat='11/30/2012'
	----Allowances	
	print 'Allowances'
	update emp_sal set all_heat=(select case when all_fix=1 then all_amt when all_fix=0 then round(((all_amt/emp_sal_Days)*emppro_totpre),0)  else 0 end from m_empall inner join m_all on m_empall.all_id=m_all.all_id where emppro_id=emp_sal.emppro_id) where emp_sal_dat=@dt2 and emp_sal_attexp=0
	update emp_Sal set all_heat=0 where all_heat is null and emp_sal_dat=@dt2  and emp_sal_attexp=0
	--Advance	
	print 'Advances'
	update emp_sal set emppro_adv=(select isnull(sum(adv_amt),0) from t_adv where adv_dat between @dt1 and @dt2 and emp_sal.emppro_id=t_adv.emppro_id) where emp_sal_dat=@dt2
	update emp_Sal set emppro_adv=0 where emppro_adv is null and emp_sal_dat=@dt2
	--Loan
	print 'Loan'
	update emp_sal set emppro_loan=(select isnull(sum(tloan_insamt),0) from t_loan where tloan_dat < @dt2 and emppro_id=emp_sal.emppro_id and tloan_st=0) where emp_sal_dat=@dt2
	update emp_Sal set emppro_loan=0 where emppro_loan is null and emp_sal_dat=@dt2
	
	--EOBI
	print 'EOBI'
	update emp_sal set emppro_eobi=80 where emppro_pa>0
		----Loan Received
	--exec sp_loan_rec @com_id,@br_id,@m_yr_id,@dt2,@usr_id,@aud_ip 

	----Voucher
	--if (@dt2>='12/01/2012') 
	--	begin
	--		exec sp_sal @com_id,@br_id ,@dt2,@m_yr_id,@usr_id,@aud_ip 
	--	end



end

--drop table emp_sal_loan_rec

--create table emp_sal_loan_rec
--(
--trec_dat datetime,
--tloan_id int,
--trec_amt float
--)
--select * from emp_sal_loan_rec

GO


