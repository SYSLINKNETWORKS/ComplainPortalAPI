USE MFI
GO
--exec sp_employee_salary_paid '01','01','11/30/2012','12/05/2012','01',1,''

alter proc sp_employee_salary_paid (@com_id char(3),@br_id char(2),@dt2 datetime,@paid_dat datetime,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as
declare
@mvch_id char(12),
@acc_id char(20),
@mvch_nar nvarchar(1000),
@empsalary float,
@row_id int,
@cur_id int,
@typ_id char(2)
begin
	set @typ_id='02'
	set @row_id=1
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	--Check the Voucher #
	set @mvch_id=(select distinct(mvch_id_paid) from emp_sal where emp_sal_dat=@dt2)
	print @mvch_id
	--delete from t_dvch where mvch_dt='12/05/2012' 
	--delete from t_mvch where mvch_dt='12/05/2012' 
	--update emp_sal set mvch_id_paid=null 
	--Salary and Wages Payable Voucher
	---GL 
	set @mvch_nar='Paid Salary to Employee for the Month of ' +datename(month,@dt2)+'-'+rtrim(cast(datepart(yy,@dt2) as char(100)))
	if (@mvch_id is null)
		begin
			--Master Voucher
			exec ins_t_mvch @com_id,@br_id,@paid_dat,@paid_dat,'','01',@typ_id,@m_yr_id,'Y','C','','S','',@paid_dat,0,0,@cur_id,1,@mvch_nar,'',@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
			update emp_sal set mvch_id_paid=@mvch_id where emp_sal_dat=@dt2
			update emp_Sal set emp_sal_St=1 where emp_sal_dat=@dt2
		end
	else
		begin
			delete from t_Dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id=@typ_id
		end
	--Detail Voucher
	set @empsalary=(select sum(emppro_pay) from emp_sal where emp_Sal_dat=@dt2)

	--Debit
	set @acc_id=(select acc_salarypayable from m_Sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@paid_dat,1,@acc_id,@mvch_nar,@empsalary,0,@typ_id,@m_yr_id

	--Credit
	set @acc_id=(select cash_acc from m_sys)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@paid_dat,2,@acc_id,@mvch_nar,0,@empsalary,@typ_id,@m_yr_id

end
