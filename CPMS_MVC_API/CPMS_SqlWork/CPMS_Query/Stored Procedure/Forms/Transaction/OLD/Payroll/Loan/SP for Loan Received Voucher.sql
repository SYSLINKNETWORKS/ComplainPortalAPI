
USE zsons
GO

--select * from t_rec_loan

--Voucher for loanance
alter proc sp_voucher_rec_loan (@trec_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@aud_act char(10),
@trec_dat datetime,
@trec_amt float,
@cur_id int,
@acc_no int,
@loan_accid int,
@emppro_id int,
@emppro_nam char(250),
@mvch_typ char(2),
@mvch_no int,
@mvch_nar varchar(250),
@row_id int,
@aud_frmnam varchar(1000),
@month varchar(100),
@tloan_id int,
@trec_chqdat datetime,
@trec_cb char(1),
@trec_chq int
begin
--GL Voucher

			set @aud_act='Insert'			
			set @com_id=(select com_id from t_rec_loan where trec_id=@trec_id)
			set @br_id=(select br_id from t_rec_loan where trec_id=@trec_id)
			set @m_yr_id=(select m_yr_id from t_rec_loan where trec_id=@trec_id)
			set @tloan_id=(select tloan_id from t_rec_loan where trec_id=@trec_id)
			set @trec_dat=(select trec_dat from t_rec_loan where trec_id=@trec_id)
			set @trec_chqdat=(select trec_dat from t_rec_loan where trec_id=@trec_id)
			set @trec_chq=(select trec_chq from t_rec_loan where trec_id=@trec_id)
			set @trec_cb=(select trec_cb from t_rec_loan where trec_id=@trec_id)			
			set @trec_amt=(select trec_amt from t_rec_loan where trec_id=@trec_id)
			set @cur_id=(select cur_id from m_cur where cur_typ='S')
			set @acc_no=(select acc_no from t_rec_loan where trec_id=@trec_id)
			set @emppro_id=(select emppro_id from t_loan where tloan_id=@tloan_id)
			set @emppro_nam =(select emppro_nam from m_emppro where emppro_id=@emppro_id)
			set @mvch_no=(select mvch_no from t_rec_loan where trec_id=@trec_id)
			set @month=(select datename(month,@trec_dat))
			
			
			
			--Voucher Type
			if @trec_cb='C' 
				begin
					set @mvch_typ='01'
				end
			else if @trec_cb='B'
				begin
					set @mvch_typ='03'
				end	

			set @row_id=0
			

		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@trec_chqdat ,@trec_dat ,@emppro_nam,'01',@mvch_typ,'Y',@trec_cb ,'','S',@trec_chq,@trec_chqdat,0,0,@cur_id,1,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				--Update the voucher number and type
				update t_rec_loan set mvch_no=@mvch_no where trec_id=@trec_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@trec_chqdat ,@mvch_typ,'Y',@emppro_nam,'01',@trec_cb,'',@trec_chq,@trec_chqdat,0,0,@cur_id,1,'S',0,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end	
			
			
			
		--Detail Voucher
		set @mvch_nar='Recover Loan# '+rtrim(cast(@trec_id as char(1000)))+' to '+rtrim(@emppro_nam) 
		
		
		--Cash/ Bank
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@mvch_nar,@trec_amt,0

		--Credit
		set @row_id=@row_id+1
		set @loan_accid=(select acc_loanstaff from m_sys)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@loan_accid,@mvch_nar,0,@trec_amt


end		

