USE MFI
GO
--exec sp_loan_rec '01','01','01','11/30/2012',1,''
--select * from emp_sal_loan_rec

alter proc sp_loan_rec(@com_id char(2),@br_id char(3),@m_yr_id char(2),@dt2 datetime,@usr_id int,@aud_ip varchar(100))
as
declare
@emppro_id int,
@tloan_id int,
@trec_amt float,
@trec_id int,
@mvch_id char(12)
begin
--Insert Loan in Employee Salary Loan Receive
delete from emp_sal_loan_rec where trec_dat=@dt2



declare  loanrec  cursor for
		select emppro_id from emp_sal where  emppro_loan!=0 and emp_sal_dat=@dt2
	OPEN loanrec
		FETCH NEXT FROM loanrec
				INTO @emppro_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
			print @emppro_id
				insert into emp_sal_loan_rec(trec_dat,tloan_id,trec_amt) select @dt2,tloan_id,tloan_insamt from t_loan where tloan_dat <= @dt2 and emppro_id=@emppro_id and tloan_st=0	
				
				FETCH NEXT FROM loanrec
				INTO @emppro_id
	end
	CLOSE loanrec
	DEALLOCATE loanrec	

	--Delete Record in Loan Received
	declare  loanrec_amt  cursor for
		select trec_id,mvch_id from t_rec_loan where trec_dat=@dt2 and trec_typ='S'
	OPEN loanrec_amt
		FETCH NEXT FROM loanrec_amt
				INTO @trec_id,@mvch_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec del_t_vch @com_id,@br_id ,@mvch_id ,'05',@m_yr_id,'C', 0,'Loan Receiving','',@usr_id,@aud_ip
				exec del_t_rec_loan @com_id,@br_id,@trec_id,@m_yr_id,@usr_id,'','',@aud_ip 
				FETCH NEXT FROM loanrec_amt
				INTO @trec_id,@mvch_id
	end
	CLOSE loanrec_amt
	DEALLOCATE loanrec_amt

	--Insert Record in Loan Received
	declare  loanrec_amt  cursor for
		select tloan_id,trec_amt from emp_sal_loan_rec where trec_dat=@dt2		
	OPEN loanrec_amt
		FETCH NEXT FROM loanrec_amt
				INTO @tloan_id,@trec_amt
			WHILE @@FETCH_STATUS = 0
			BEGIN
--				exec ins_t_rec_loan @com_id,@br_id,@m_yr_id,@dt2,@trec_amt,@tloan_id ,'S','','',0,'','',@usr_id,'','',@aud_ip
				exec ins_t_rec_loan @com_id ,@br_id,@m_yr_id,@dt2,@trec_amt,@tloan_id,'S',0,'05',0,'C','',@usr_id ,'','',@aud_ip 
				
				FETCH NEXT FROM loanrec_amt
				INTO @tloan_id,@trec_amt
	end
	CLOSE loanrec_amt
	DEALLOCATE loanrec_amt
end
