
USE MFI
GO
--select * from t_dvch where mvch_dt='03/31/2013'
--alter table t_dstkadjmon add dstkadjmon_rat float,dstkadjmon_trat float,dstkadjmon_amt float,dstkadjmon_namt float
--alter table t_dstkadjmon add dstkadjmon_amt as dstkadjmon_rat*dstkadjmon_qty,dstkadjmon_namt as dstkadjmon_trat*dstkadjmon_qty
--exec sp_voucher_stkadjmon '01','01','01',6,1,'','',''
--delete from t_dvch where mvch_id='001-20130331' and typ_id='05'
--delete from t_mvch where mvch_id='001-20130331' and typ_id='05'
--update t_mstkadjmon set mvch_id=null

--Voucher for Raw Material Transfer
alter proc sp_voucher_stkadjmon (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmon_id int,@usr_id int,@aud_ip varchar(250),@aud_frmnam varchar(1000),@aud_des varchar(1000))
as
declare
@miss_dat datetime,
@miss_namt float,
@miss_rmk varchar(250),
@itm_id int,
@itm_amt float,
@acc_dr_id varchar(20),
@acc_cr_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@miss_rat float
begin
--GL Voucher
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @miss_rat=1
		set @mvch_id=(select mvch_id from t_mstkadjmon where mstkadjmon_id=@mstkadjmon_id)
		set @miss_dat=(select mstkadjmon_dat from t_mstkadjmon where mstkadjmon_id=@mstkadjmon_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@miss_dat,@miss_dat,'','01','05',@m_yr_id,'Y','C',@miss_rmk,'S',0,@miss_dat,0,0,@cur_id,@miss_rat,'Voucher of Raw Material Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_mstkadjmon set mvch_id=@mvch_id where mstkadjmon_id=@mstkadjmon_id
			end
		else
			begin
				set @miss_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)
				update t_mvch set mvch_ref=@miss_rmk,mvch_rat=@miss_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='Stock Ajustment Monthly # ' + cast(@mstkadjmon_id as char(100))  
					
--Debit Accountprint 'Detail Credit Voucher'
		declare mitm_cursor CURSOR for
		select itm_id,sum(isnull(dstkadjmon_namt,0)) from t_dstkadjmon inner join t_itm on t_dstkadjmon.titm_id=t_itm.titm_id  where mstkadjmon_id=@mstkadjmon_id	group by itm_id
				open mitm_cursor 
					fetch next  from mitm_cursor 
							into @itm_id,@itm_amt	

				while @@fetch_status =0

				begin

					if (@itm_amt>=0)
						begin
							set @acc_dr_id=(select wacc_id from m_itm where itm_id=@itm_id)
							set @acc_cr_id=(select cacc_id from m_itm where itm_id=@itm_id)
						end
					else	
						begin
							set @acc_dr_id=(select cacc_id from m_itm where itm_id=@itm_id)
							set @acc_cr_id=(select wacc_id from m_itm where itm_id=@itm_id)
							set @itm_amt=-@itm_amt
						end
					--Debit Voucher				
					set @row_id=@row_id+1
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_dr_id,@nar,@itm_amt,0,'05',@m_yr_id
					--Credit Voucher				
					set @row_id=@row_id+1
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_cr_id,@nar,0,@itm_amt,'05',@m_yr_id



				fetch next  from mitm_cursor 
						into @itm_id,@itm_amt	
				end
				close mitm_cursor
				deallocate mitm_cursor	
end		

