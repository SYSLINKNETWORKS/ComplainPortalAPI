
USE MFI
GO
--alter table m_sys add disposal_acc char(20)
--update m_sys set disposal_acc='05007050'


--exec sp_voucher_adj '01','01','01','05/31/2013','stk_dispose',1,'',''

ALTER proc [dbo].[sp_voucher_adj] (@com_id char(2),@br_id char(3),@m_yr_id char(2),@stk_dat datetime,@stk_frm varchar(100),@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mvch_amt float,
@itm_id int,
@itm_amt float,
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@mvch_rat float
begin
--GL Voucher
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @mvch_rat=1
		set @mvch_id=(select distinct mvch_id from m_stk where stk_dat=@stk_dat and m_yr_id=@m_yr_id and stk_frm=@stk_frm)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@stk_dat,@stk_dat,'','01','05',@m_yr_id,'Y','C','','S',0,@stk_dat,0,0,@cur_id,@mvch_rat,'Voucher of Stock ADJUSTMENT/ Disposal',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update m_Stk set mvch_id=@mvch_id where stk_dat=@stk_dat and m_yr_id=@m_yr_id and stk_frm=@stk_frm
			end
		else
			begin
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='Stock Ajustment/ Disposal Dated: ' + CONVERT(VARCHAR(11),@stk_dat,106)
--Debit Account
					--Debit Voucher				
					set @row_id=@row_id+1
					set @mvch_amt=(select -sum(stk_qty*stk_rat) from m_stk where stk_dat=@stk_dat and m_yr_id=@m_yr_id and stk_frm=@stk_frm)
					set @acc_id=(select  disposal_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@stk_dat,@row_id,@acc_id,@nar,@mvch_amt,0,'05',@m_yr_id


--Credit
		declare mitm_cursor CURSOR for
		select t_itm.itm_id,-sum(stk_qty*stk_rat) from m_stk inner join t_itm on m_stk.itm_id=t_itm.titm_id  where stk_dat=@stk_dat and m_yr_id=@m_yr_id and stk_frm=@stk_frm	group by t_itm.itm_id
				open mitm_cursor 
					fetch next  from mitm_cursor 
							into @itm_id,@itm_amt	

				while @@fetch_status =0

				begin

					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select cacc_id from m_itm where itm_id=@itm_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@stk_dat,@row_id,@acc_id,@nar,0,@itm_amt,'05',@m_yr_id


				fetch next  from mitm_cursor 
						into @itm_id,@itm_amt	
				end
				close mitm_cursor
				deallocate mitm_cursor	

end		


GO


