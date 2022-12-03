USE MFI
GO

alter proc sp_sal(@com_id char(2),@br_id char(3),@dt2 datetime,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as
declare
@mvch_id char(12),
@acc_id char(20),
@mvch_nar nvarchar(1000),
@empsalary float,
@emp_salary_ot float,
@emp_salary float,
@row_id int,
@mempcat_id int,
@cur_id int

begin
	set @row_id=1
	set @cur_id=(select cur_id from m_cur where cur_typ='S')
	--Check the Voucher #
	print 'Voucher#'
	set @mvch_id=(select distinct(mvch_id) from emp_sal where emp_sal_dat=@dt2)

	--Salary and Wages Payable Voucher
	--GL 
	set @mvch_nar='Salary and Wages Payable of Employee for the Month of ' +datename(month,@dt2)+'-'+rtrim(cast(datepart(yy,@dt2) as char(100)))
	if (@mvch_id is null)
		begin
			--Master Voucher
			exec ins_t_mvch @com_id,@br_id,@dt2,@dt2,'','01','05',@m_yr_id,'Y','C','','S','',@dt2,0,0,@cur_id,1,@mvch_nar,'',@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
			update emp_sal set mvch_id=@mvch_id where emp_sal_dat=@dt2

		end
	else
		begin
			delete from t_Dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			update emp_sal set mvch_id=@mvch_id where emp_sal_dat=@dt2
		end
	--Detail Voucher

	--Debit
		declare cur_sal CURSOR for
		select emppro_cat,sum(emppro_pay) from emp_sal inner join m_emppro on emp_sal.emppro_id=m_emppro.emppro_id where emp_sal_dat=@dt2 group by emppro_cat		
				open cur_sal 
					fetch next  from cur_sal 
							into @mempcat_id,@emp_salary	

				while @@fetch_status =0

				begin
					--Debit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select sal_accid from m_empcat where mempcat_id=@mempcat_id)
					exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@dt2,@row_id,@acc_id,@mvch_nar,@emp_salary,0,'05',@m_yr_id

				fetch next  from cur_sal 
						into @mempcat_id,@emp_salary	
				end
				close cur_sal
				deallocate cur_sal	
--select * from m_empcat

	--Credit
	set @acc_id=(select acc_salarypayable from m_Sys)
	set @emp_salary=(select sum(emppro_pay) from emp_sal where emp_sal_dat=@dt2)
	exec ins_t_dvch @com_id,@br_id ,@mvch_id ,@dt2,@row_id,@acc_id,@mvch_nar,0,@emp_salary,'05',@m_yr_id
end