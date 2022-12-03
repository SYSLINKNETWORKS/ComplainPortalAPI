USE MFI
GO
--alter table m_sys add gp_acc char(20)
--update m_sys set gp_acc='05007010'
--update gl_m_acc set acc_typ='S' where acc_id='05007010'

--exec sp_voucher_gp '01','01','01',9,1,'',''

--Voucher for Finish Goods Transfer
alter proc sp_voucher_gp (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mgp_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mgp_dat datetime,
@mgp_namt float,
@mgp_rmk varchar(250),
@itm_id int,
@itm_amt float,
@acc_id varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@mgp_rat float,
@dgp_id int,
@mgp_typ char(1),
@dgp_amt float
begin
--GL Voucher
		--print 'Voucher row_id'
		set @row_id=0
		set @mgp_typ=(select mgp_typ from t_mgp where mgp_id=@mgp_id)
		--print 'Voucher Currency'
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @mgp_rat=1
		--print 'Voucher ID'
		set @mvch_id=(select mvch_id from t_mgp where mgp_id=@mgp_id)
		--print 'Voucher gp Date'
		set @mgp_dat=(select mgp_dat from t_mgp where mgp_id=@mgp_id)
		set @mgp_namt=(select sum(dgp_qty*dgp_rat) from t_dgp where mgp_id=@mgp_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@mgp_dat,@mgp_dat,'','01','05',@m_yr_id,'Y','C',@mgp_rmk,'S',0,@mgp_dat,0,0,@cur_id,@mgp_rat,'Voucher of Finish Goods Transfer',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_mgp set mvch_id=@mvch_id where mgp_id=@mgp_id
			end
		else
			begin
				set @mgp_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)
				update t_mvch set mvch_ref=@mgp_rmk,mvch_rat=@mgp_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='GatePass # ' + cast(@mgp_id as char(100))  
--Debit Account

					set @row_id=@row_id+1
					set @acc_id=(select gp_acc from m_sys)
					set @mgp_namt=(select round(sum(dgp_rat*dgp_qty),4) from t_dgp where mgp_id=@mgp_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mgp_dat,@row_id,@acc_id,@nar,@mgp_namt,0,'05',@m_yr_id
--exec sp_voucher_gp '01','01','01',1043,'','',''
	
			declare @miss_id int
				declare  gpamt  cursor for			
					select itm_id,dgp_id,dgp_rat*dgp_qty from t_dgp inner join t_itm on t_dgp.titm_id=t_itm.titm_id where mgp_id=@mgp_id
					OPEN gpamt
						FETCH NEXT FROM gpamt
						INTO @itm_id,@dgp_id,@dgp_amt
							WHILE @@FETCH_STATUS = 0
							BEGIN
								--Credit RM
										set @row_id=@row_id+1
										set @acc_id=(select case when itm_cat='O' then pacc_id else cacc_id end from m_itm where itm_id=@itm_id)
										exec ins_t_dvch @com_id,@br_id,@mvch_id,@mgp_dat,@row_id,@acc_id,@nar,0,@dgp_amt,'05',@m_yr_id
								FETCH NEXT FROM gpamt
								INTO @itm_id,@dgp_id,@dgp_amt
									
									
					end
					CLOSE gpamt
					DEALLOCATE gpamt
	
			

end		

--select * from t_mgp where mgp_id=1045
--select * from t_dgp where mgp_id=1045
--select * from t_diss where miss_id=57
--select * from t_diss where miss_id=9979
