USE MFI
GO

--alter table m_sys add dis_acc char(20),fre_acc char(20)
--update m_sys set dis_acc='05003008',fre_acc='02003003001'

--select * from m_itm

--Voucher for Purchase Bill
alter proc sp_voucher_inv (@com_id char(2),@br_id char(3),@m_yr_id char(2),@minv_id int,@usr_id int,@aud_ip varchar(250))
as
declare
@minv_dat datetime,
@minv_tamt float,
@minv_rmk varchar(250),
@itm_id int,
@itm_amt float,
@cus_id int,
@cus_nam varchar(250),
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@mfre_amt float,
@dis_amt float,
@cus_amt float,
@cur_id int,
@minv_rat float,
@aud_des varchar(1000)
begin
--GL Voucher
		set @row_id=0
		set @minv_dat=(select minv_dat from t_minv where minv_id=@minv_id)
		set @minv_tamt=(select minv_amt from t_minv where minv_id=@minv_id)
		set @minv_rmk=(select minv_rmk from t_minv where minv_id=@minv_id)
		set @cus_id=(select cus_id from t_minv where minv_id=@minv_id)
		set @cus_nam=(select cus_nam from m_cus where cus_id=@cus_id)
		set @cus_amt=(select minv_namt from t_minv where minv_id=@minv_id)
		set @mfre_amt=(select minv_freamt from t_minv where minv_id=@minv_id)
		set @dis_amt=(select minv_disamt from t_minv where minv_id=@minv_id)
		set @cur_id=(select cur_id from t_minv where minv_id=@minv_id)
		set @minv_rat=(select minv_rat from t_minv where minv_id=@minv_id)
	
		set @mvch_id=(select mvch_id from t_minv where minv_id=@minv_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				set @aud_des='Voucher of Invoice #'+rtrim(cast(@minv_id as char(1000)))
				exec ins_t_mvch @com_id,@br_id,@minv_dat,@minv_dat,'','01','05',@m_yr_id,'Y','C',@minv_rmk,'S','',@minv_dat,0,0,@cur_id,@minv_rat,@aud_des,'',@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_minv set mvch_id=@mvch_id where minv_id=@minv_id
			end
		else
			begin
				update t_mvch set mvch_ref=@minv_rmk,mvch_rat=@minv_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
								
--Detail Voucher
					set @nar='Invoice # ' + cast(@minv_id as char(100)) 
--Debit
					set @row_id=@row_id+1
					set @acc_id=(select acc_id from m_cus where cus_id=@cus_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@minv_dat,@row_id,@acc_id,@nar,@cus_amt,0,'05',@m_yr_id
					
					set @nar='Invoice # ' + cast(@minv_id as char(100)) + ' Customer Name : ' +@cus_nam 
					--Discount
					if (@dis_amt>0)
						begin
							set @row_id=@row_id+1
							set @acc_id=(select dis_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_id,@minv_dat,@row_id,@acc_id,@nar,@dis_amt,0,'05',@m_yr_id
						end
					

								
--Credit 
	--Freight
						if (@mfre_amt>0)
							begin
								set @row_id=@row_id+1
								set @acc_id=(select fre_acc from m_sys)
								exec ins_t_dvch @com_id,@br_id,@mvch_id,@minv_dat,@row_id,@acc_id,@nar,0,@mfre_amt,'05',@m_yr_id
							end

	--Sales
		--declare mitm_cursor CURSOR for
		--	select itm_id,sum(dinv_amt) as [Amount] from t_dinv inner join t_itm on t_dinv.titm_id=t_itm.titm_id where minv_id=@minv_id	group by itm_id

		--		open mitm_cursor 
		--			fetch next  from mitm_cursor 
		--					into @itm_id,@itm_amt	

		--		while @@fetch_status =0

		--		begin
					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select sacc_id from m_itm where itm_cat='F')-- itm_id=@itm_id)
					set @itm_amt=@cus_amt
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@minv_dat,@row_id,@acc_id,@nar,0,@itm_amt,'05',@m_yr_id

				--fetch next  from mitm_cursor 
				--		into @itm_id,@itm_amt	
				--end
				--close mitm_cursor
				--deallocate mitm_cursor	
					


end		