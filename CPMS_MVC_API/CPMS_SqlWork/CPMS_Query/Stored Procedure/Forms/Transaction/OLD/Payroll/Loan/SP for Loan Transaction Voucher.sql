
USE ZSONS
GO

--select * from t_loan
--select * from m_Sys
--update m_sys set acc_loanstaff =1900
--(select acc_no from gl_m_Acc where acc_id=acc_loanstaff)
--select * from gl_m_Acc where acc_id='03002002005001'

--Voucher for loanance
alter proc sp_voucher_loan (@loan_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@aud_act char(10),
@loan_dat datetime,
@loan_chqdat datetime,
@loan_chq int,
@loan_cb char(1),
@loan_amt float,
@cur_id int,
@acc_no int,
@loan_accid int,
@emppro_id int,
@emppro_nam char(250),
@mvch_typ char(2),
@mvch_no int,
@mvch_nar varchar(250),
@row_id int,
@month varchar(100),
@tloan_rmk varchar(250)
begin
--GL Voucher

			set @aud_act='Insert'
			set @com_id=(select com_id from t_loan where tloan_id=@loan_id)
			set @br_id=(select br_id from t_loan where tloan_id=@loan_id)
			set @m_yr_id=(select m_yr_id from t_loan where tloan_id=@loan_id)
			set @loan_dat=(select tloan_dat from t_loan where tloan_id=@loan_id)
			set @loan_chqdat=(select tloan_dat from t_loan where tloan_id=@loan_id)
			set @loan_amt=(select tloan_amt from t_loan where tloan_id=@loan_id)
			set @cur_id=(select cur_id from m_cur where cur_typ='S')
			set @acc_no=(select acc_no from t_loan where tloan_id=@loan_id)
			set @loan_cb=(select tloan_cb from t_loan where tloan_id=@loan_id)
			set @loan_chq=(select tloan_chq from t_loan where tloan_id=@loan_id)
			set @emppro_id=(select emppro_id from t_loan where tloan_id=@loan_id)
			set @emppro_nam =(select emppro_nam from m_emppro where emppro_id=@emppro_id)
			set @mvch_no=(select mvch_no from t_loan where tloan_id=@loan_id)
			set @month=(select datename(month,@loan_dat))
			set @tloan_rmk=(select tloan_rmk from t_loan where tloan_id=@loan_id)
			
			set @row_id=0
			--Voucher Type
			if @loan_cb='C' 
				begin
					set @mvch_typ='02'
				end
			else if @loan_cb='B'
				begin
					set @mvch_typ='04'
				end	

		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@loan_chqdat ,@loan_dat ,@emppro_nam,'01',@mvch_typ,'Y',@loan_cb ,'','S',@loan_chq,@loan_chqdat,0,0,@cur_id,1,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				--Update the voucher number and type
				update t_loan set mvch_no=@mvch_no where tloan_id=@loan_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@loan_chqdat ,@mvch_typ,'Y',@emppro_nam,'01',@loan_cb,'',@loan_chq,@loan_chqdat,0,0,@cur_id,1,'S',0,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end		


		--Detail Voucher
		set @mvch_nar='Paid Loan# '+rtrim(cast(@loan_id as char(1000)))+' to '+rtrim(@emppro_nam) 
		
		--Debit
		set @row_id=@row_id+1
		set @loan_accid=(select acc_loanstaff from m_sys)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@loan_accid,@mvch_nar,@loan_amt,0

		--Cash/ Bank
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@mvch_nar,0,@loan_amt



end		

