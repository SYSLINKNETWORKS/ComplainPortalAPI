USE MFI
GO
--select * from t_mfg where mfg_id=1
--select * from t_mvch where typ_id='05' and mvch_id='040-20120702'

--alter table t_mfg add mvch_id chaR(12)
--alter table m_sys add fg_acc char(20)
--update m_sys set fg_acc='05001010'
--exec sp_voucher_fg '01','01','01',9,1,'',''

--alter table m_stk add stk_mvchid_rat char(12)
--alter table m_sys add stk_val_acc char(20)
--update m_sys set stk_val_acc='01003007'
--Voucher for Finish Goods Transfer
alter proc sp_voucher_endingstock (@com_id char(2),@br_id char(3),@m_yr_id char(2),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@row_id int,
@cur_id int,
@cur_rat int,
@mvch_id char(12),
@mvch_dat datetime,
@endingstock_amount float,
@acc_id_dr char(20),
@acc_id_cr char(20),
@nar varchar(1000)
begin
--GL Voucher
		--print 'Voucher row_id'
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @cur_rat=1
		set @mvch_id=(select distinct stk_mvchid_rat from m_stk where m_yr_id=@m_yr_id)
		set @mvch_dat=(select yr_end_dt from gl_m_yr where yr_id=@m_yr_id)
		set @endingstock_amount=(select sum(stk_ratdiff) from m_stk where stk_actrat<>0 and m_yr_id=@m_yr_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@mvch_dat,@mvch_dat,'','01','05',@m_yr_id,'Y','C','','S',0,@mvch_dat,0,0,@cur_id,@cur_rat,'Voucher of Ending Stock Value',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update m_stk set stk_mvchid_rat=@mvch_id where m_yr_id=@m_yr_id
			end
		else
			begin				
				set @mvch_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)				
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
					
			end
--Detail Voucher
					set @nar='Stock Ending Valuation Diff Voucher'  
--Debit Account
					set @row_id=@row_id+1
					if (@endingstock_amount>=0)
						begin					
							set @acc_id_dr=(select fg_acc from m_sys)
							set @acc_id_cr=(select stk_val_acc from m_sys)
						end
					else
						begin
							set @acc_id_dr=(select stk_val_acc from m_sys)
							set @acc_id_cr=(select fg_acc from m_sys)
							set @endingstock_amount=-@endingstock_amount
						end					
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mvch_dat,@row_id,@acc_id_dr,@nar,@endingstock_amount,0,'05',@m_yr_id
--Credit Account
					set @row_id=@row_id+1
								
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@mvch_dat,@row_id,@acc_id_cr,@nar,0,@endingstock_amount,'05',@m_yr_id

			

end		

--select * from t_mfg where mfg_id=1045
--select * from t_dfg where mfg_id=1045
--select * from t_diss where miss_id=57
--select * from t_diss where miss_id=9979
