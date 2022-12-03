--select * from t_miss where miss_id=69
--select * from t_mvch where mvch_id='002-20120929' and typ_id='05'
--select * from t_dvch where mvch_id='002-20120929' and typ_id='05'

--select * from t_diss where miss_id=4779


USE meiji_rusk
GO

--Voucher for Raw Material Transfer
alter proc sp_voucher_iss (@com_id char(2),@br_id char(3),@m_yr_id char(2),@miss_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@miss_dat datetime,
@miss_namt float,
@miss_rmk varchar(250),
@itm_id int,
@itm_amt float,
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@miss_rat float
begin
--GL Voucher
		--print 'Voucher row_id'
		set @row_id=0
		--print 'Voucher Currency'
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @miss_rat=1
		--print 'Voucher ID'
		set @mvch_id=(select t_miss.mvch_id from t_miss inner join t_mvch on t_miss.mvch_id=t_mvch.mvch_id and t_mvch.typ_id='05' and t_mvch.com_id=@com_id and t_mvch.br_id=@br_id and t_mvch.yr_id=@m_yr_id where miss_id=@miss_id)
		--print 'Voucher Miss Date'
		set @miss_dat=(select miss_dat from t_miss where miss_id=@miss_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@miss_dat,@miss_dat,'','01','05',@m_yr_id,'Y','C',@miss_rmk,'S',0,@miss_dat,0,0,@cur_id,@miss_rat,'Voucher of Raw Material Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_miss set mvch_id=@mvch_id where miss_id=@miss_id
			end
		else
			begin
				set @miss_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)
				update t_mvch set mvch_ref=@miss_rmk,mvch_rat=@miss_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='Raw Material Transfer # ' + cast(@miss_id as char(100))  
----Debit Account
--					--print 'Detail Debit Voucher'
--					--Debit Voucher				
--					set @row_id=@row_id+1
--					set @miss_namt=(select sum(diss_namt) from t_diss where miss_id=@miss_id)
--					set @acc_id=(select wip_acc from m_sys)
--					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_id,@nar,@miss_namt,0,'05',@m_yr_id

		declare mitm_cursor CURSOR for
		select itm_id,isnull(sum(diss_namt),0) from t_diss inner join t_itm on t_diss.titm_id=t_itm.titm_id  where miss_id=@miss_id	group by itm_id
				open mitm_cursor 
					fetch next  from mitm_cursor 
							into @itm_id,@itm_amt	

				while @@fetch_status =0

				begin

					--Debit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select wacc_id from m_itm where itm_id=@itm_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_id,@nar,@itm_amt,0,'05',@m_yr_id

					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select cacc_id from m_itm where itm_id=@itm_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_id,@nar,0,@itm_amt,'05',@m_yr_id


				fetch next  from mitm_cursor 
						into @itm_id,@itm_amt	
				end
				close mitm_cursor
				deallocate mitm_cursor	

end		

