--select * from t_dpc where mpc_no=69

USE ZSONS
GO
--Voucher for Petty Cash
alter proc sp_voucher_pc (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpc_no int)
as
declare
@mpc_dat datetime,
@mpc_namt float,
@mpc_rmk varchar(250),
@acc_no int,
@acc_no_cash int,
@dpc_amt float,
@row_id int,
@mvch_no int,
@nar varchar(1000),
@mpc_rat float,
@cur_id int
begin
--GL Voucher
		set @row_id=0
		set @mpc_dat=(select mpc_dat from t_mpc where com_id=@com_id and mpc_no=@mpc_no)
		set @mpc_namt=(select sum(dpc_amt) from t_dpc where com_id=@com_id and mpc_no=@mpc_no and dpc_set=1)
		set @mpc_rmk=(select mpc_rmk from t_mpc where com_id=@com_id and mpc_no=@mpc_no)
		set @mpc_rat=(select mpc_rat from t_mpc where com_id=@com_id and mpc_no=@mpc_no)
		set @cur_id=(select cur_id from t_mpc where com_id=@com_id and mpc_no=@mpc_no)
		set @acc_no_cash=(select distinct acc_no_cash from gl_m_pc where br_id=@br_id)
		set @mvch_no=(select mvch_no from t_mpc where com_id=@com_id and mpc_no=@mpc_no)
		
		if (@mvch_no is null)
			begin
			
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpc_dat ,@mpc_dat ,'','01','02','Y','C' ,@mpc_rmk,'S','',@mpc_dat,0,0,@cur_id,@mpc_rat,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_mpc set mvch_no=@mvch_no where mpc_no=@mpc_no
			end
		else
			begin
				update t_mvch set mvch_ref=@mpc_rmk,mvch_rat=@mpc_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
--Detail Voucher
		
		if (@mpc_rmk!='')
			begin
				set @mpc_rmk='Remarks: '+@mpc_rmk
			end
					set @nar='Petty Cash # ' + cast(@mpc_no as char(100)) + ' '+ @mpc_rmk
--Debit Account Expenses

		declare exp_cursor CURSOR for
				select acc_no,dpc_amt from t_dpc where com_id=@com_id and mpc_no=@mpc_no and dpc_set=1
				open exp_cursor 
					fetch next  from exp_cursor 
							into @acc_no,@dpc_amt	

				while @@fetch_status =0

				begin
					--Debit Voucher				
					set @row_id=@row_id+1						
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@dpc_amt,0


				fetch next  from exp_cursor 
						into @acc_no,@dpc_amt	
				end
				close exp_cursor
				deallocate exp_cursor	

	

----Credit Account Supplier

					set @row_id=@row_id+1
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no_cash,@nar,0,@mpc_namt


end		

