
USE MFI
GO
--select * from t_dvch where mvch_dt='03/31/2013'
--create table t_dstkadjmonfg add dstkadjmonfg_rat float,dstkadjmonfg_trat float,dstkadjmonfg_amt float,dstkadjmonfg_namt float
--create table t_dstkadjmonfg add dstkadjmonfg_amt as dstkadjmonfg_rat*dstkadjmonfg_qty,dstkadjmonfg_namt as dstkadjmonfg_trat*dstkadjmonfg_qty
--exec sp_voucher_stkadjmon '01','01','01',1,1,'',''
--delete from t_dvch where mvch_id='001-20130331' and typ_id='05'
--delete from t_mvch where mvch_id='001-20130331' and typ_id='05'
--update t_mstkadjmonfg set mvch_id=null

--Voucher for Raw Material Transfer
alter proc sp_voucher_stkadjmonfg (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmonfg_id int,@usr_id int,@aud_ip varchar(250),@aud_frmnam varchar(1000),@aud_des varchar(1000))
as
declare
@miss_dat datetime,
@miss_rmk varchar(250),
@acc_id_dr varchar(20),
@acc_id_cr varchar(20),
@row_id int,
@mvch_id char(20),
@nar varchar(1000),
@cur_id int,
@miss_rat float,
@dstkadjmonfg_amt float
begin
--GL Voucher
		set @row_id=0
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @miss_rat=1
		set @mvch_id=(select mvch_id from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id)
		set @miss_dat=(select mstkadjmonfg_dat from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id)
		set @dstkadjmonfg_amt=(select sum(dstkadjmonfg_qty*dstkadjmonfg_trat) from t_dstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id)
		if (@mvch_id is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@miss_dat,@miss_dat,'','01','05',@m_yr_id,'Y','C',@miss_rmk,'S',0,@miss_dat,0,0,@cur_id,@miss_rat,'Voucher of Finish Goods Adjustment',@aud_des,@usr_id,@aud_ip,'',@mvch_id_out=@mvch_id output
				update t_mstkadjmonfg set mvch_id=@mvch_id where mstkadjmonfg_id=@mstkadjmonfg_id
			end
		else
			begin
				set @miss_dat=(select mvch_dt from t_mvch where typ_id='05' and mvch_id=@mvch_id and com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id)
				update t_mvch set mvch_ref=@miss_rmk,mvch_rat=@miss_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
				delete from t_dvch where com_id=@com_id and br_id=@br_id and yr_id=@m_yr_id and mvch_id=@mvch_id and typ_id='05'
			end
--Detail Voucher
					set @nar='Stock Ajustment Finish Goods Monthly # ' + rtrim(cast(@mstkadjmonfg_id as char(100)))  				
					if (@dstkadjmonfg_amt>=0)
						begin
							set @acc_id_dr=(select oacc_id from m_itm where itm_id=1)
							set @acc_id_cr=(select fg_acc from m_sys)
					end	
					else
						begin
							set @acc_id_dr=(select fg_acc from m_sys)
							set @acc_id_cr=(select oacc_id from m_itm where itm_id=1)
							set @dstkadjmonfg_amt=-@dstkadjmonfg_amt
						end

					--Debit Voucher				
					set @row_id=@row_id+1
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_id_dr,@nar,@dstkadjmonfg_amt,0,'05',@m_yr_id

					--Credit Voucher				
					set @row_id=@row_id+1
					exec ins_t_dvch @com_id,@br_id,@mvch_id,@miss_dat,@row_id,@acc_id_cr,@nar,0,@dstkadjmonfg_amt,'05',@m_yr_id
end		

