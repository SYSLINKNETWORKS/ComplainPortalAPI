--select * from t_mret where mret_id=69
--select * from t_mvch where mvch_id='002-20120929' and typ_id='05'
--select * from t_dvch where mvch_id='002-20120929' and typ_id='05'

USE MFI
GO
--alter table m_sys add wip_ret_acc char(20)
--update m_sys set wip_ret_acc='05001011'
--alter table m_itm add wracc_id char(20)

--exec sp_voucher_ret '01','01','01',1,'','',''
--Voucher for Raw Material Transfer
alter proc sp_voucher_ret (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mret_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mret_dat datetime,
@mret_namt float,
@mret_rmk varchar(250),
@itm_id int,
@itm_amt float,
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@mret_rat float
begin
--GL Voucher
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @mret_rat=1
		set @mvch_id=(select mvch_id from t_mret where mret_id=@mret_id)
		set @mret_dat=(select mret_dat from t_mret where mret_id=@mret_id)
		if (@mvch_id is null)
			begin		
			
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@mret_dat,@mret_dat,'','01','05',@m_yr_id,'Y','C',@mret_rmk,'S',0,@mret_dat,0,0,@cur_id,@mret_rat,'Voucher of Raw Material Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_mret set mvch_id=@mvch_id where mret_id=@mret_id
			end
		else
			begin
				update t_mvch set mvch_ref=@mret_rmk,mvch_rat=@mret_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='Return Note # ' + rtrim(cast(@mret_id as char(100)))  

--Debit
		declare mitm_cursor CURSOR for
		select itm_id,sum(dret_namt) from t_dret inner join t_itm on t_dret.titm_id=t_itm.titm_id  where mret_id=@mret_id	group by itm_id
				open mitm_cursor 
					fetch next  from mitm_cursor 
							into @itm_id,@itm_amt	

				while @@fetch_status =0

				begin

					--Debit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select wracc_id from m_itm where itm_id=@itm_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mret_dat,@row_id,@acc_id,@nar,@itm_amt,0,'05',@m_yr_id

					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select wacc_id from m_itm where itm_id=@itm_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mret_dat,@row_id,@acc_id,@nar,0,@itm_amt,'05',@m_yr_id


				fetch next  from mitm_cursor 
						into @itm_id,@itm_amt	
				end
				close mitm_cursor
				deallocate mitm_cursor	


end		

