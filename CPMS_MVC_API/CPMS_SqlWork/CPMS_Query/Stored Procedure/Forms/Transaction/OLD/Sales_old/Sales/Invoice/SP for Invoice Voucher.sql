USE PAGEY
GO
--create table m_sys add dis_acc char(20),fre_acc char(20)
--update m_sys set dis_acc='1028',othincome_acc=421,freincome_acc='1029'
--alter table m_sys add othincome_acc int,freincome_acc int
--alter table m_sys add gstwhttax_acc int
--update m_sys set gstwhttax_acc=1899

--select * from gl_m_acc where acc_id='02003005006'
--update m_sys set dis_acc =1836,othincome_acc=421,freincome_acc =1837
--select dis_acc from m_Sys
--exec sp_voucher_inv 1

--select * from gl_m_acc where acc_no in (1843,1844,421)

--alter table t_minv add mvch_taxno int

--Voucher for Purchase Bill
alter proc sp_voucher_inv (@minv_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yR_id char(2),
@minv_no int,
@mvch_no int,
@mvch_taxno int,
@minv_dat datetime,
@minv_rmk varchar(250),
@row_id int,
@nar varchar(1000),
@cur_id int,
@minv_rat float,
@minv_can bit,
@minv_namt float,
@minv_disamt float,
@minv_freamt float,
@minv_othamt float,
@cus_nam varchar(250),
@cus_id int,
@acc_no int,
@cus_amt float,
@titm_amt float,
@minv_gstamt float,
@minv_fedamt float,
@minv_cktax bit
begin
--GL Voucher
		set @row_id=0
		set @com_id=(select com_id from t_minv where minv_id=@minv_id)
		set @br_id=(select br_id from t_minv where minv_id=@minv_id)
		set @m_yr_id=(select m_yr_id from t_minv where minv_id=@minv_id)
		set @minv_no=(select minv_no from t_minv where minv_id=@minv_id)
		set @minv_dat=(select minv_dat from t_minv where minv_id=@minv_id)
		set @minv_rmk=(select minv_rmk from t_minv where minv_id=@minv_id)
		set @cur_id=(select cur_id from t_minv where minv_id=@minv_id)
		set @minv_rat=(select minv_rat from t_minv where minv_id=@minv_id)
		set @minv_can=(select minv_can from t_minv where minv_id=@minv_id)
		set @minv_namt=(select round(minv_namt,0) from t_minv where minv_id=@minv_id)
		set @minv_disamt=(select round(minv_disamt,0) from t_minv where minv_id=@minv_id)
		set @minv_freamt=(select round(minv_freamt,0) from t_minv where minv_id=@minv_id)
		set @minv_othamt=(select round(minv_othamt,0) from t_minv where minv_id=@minv_id)
		set @cus_id=(select cus_id from t_minv where minv_id=@minv_id)
		set @cus_nam=(select cus_nam from m_cus where com_id=@com_id and cus_id=@cus_id)
		set @minv_gstamt=(select minv_gstamt from t_minv where minv_id=@minv_id)
		set @minv_fedamt=(select minv_fedamt from t_minv where minv_id=@minv_id)
		set @minv_cktax=(select minv_cktax from t_minv where minv_id=@minv_id)
		
	
		set @mvch_no=(select mvch_no from t_minv where minv_id=@minv_id)
		if (@mvch_no is null)
			begin
				--Master Voucher			
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@minv_dat ,@minv_dat ,'','01','05','Y','C' ,@minv_rmk,'S','',@minv_dat,0,0,@cur_id,@minv_rat,@minv_can,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_minv set mvch_no=@mvch_no where minv_id=@minv_id
			end
		else
			begin
				update t_mvch set mvch_tax=0,mvch_ref=@minv_rmk,mvch_rat=@minv_rat,cur_id=@cur_id,mvch_can=@minv_can where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
								
--Detail Voucher
					set @nar='Invoice # ' + rtrim(cast(@minv_no as char(100))) + ' Customer Name : ' +rtrim(@cus_nam) 
--Debit
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
					set @cus_amt=@minv_namt
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@cus_amt,0
					--Discount
					if (@minv_disamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select dis_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@minv_disamt,0
						end
					

				
				--Other Income
					if (@minv_othamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select othincome_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@minv_othamt
						end
					--Freight
					if (@minv_freamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select freincome_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@minv_freamt
						end
					--GST AMT
					if (@minv_gstamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select gsttax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@minv_gstamt
						end
					--Freight
					if (@minv_fedamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select fedtax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@minv_fedamt
						end
					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_no=(select sacc_id from m_itm where itm_id=1)
					set @titm_amt=@minv_namt-@minv_othamt-@minv_freamt-@minv_gstamt-@minv_fedamt+@minv_disamt
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@titm_amt
					
					
--TAX VOUCHER
	IF (@minv_cktax =1)
		begin
		set @row_id=0
		set @minv_no=(select minv_no from t_minv where minv_id=@minv_id)
		set @minv_dat=(select minv_taxdat from t_minv where minv_id=@minv_id)
		set @minv_namt=(select round(minv_taxnamt,0) from t_minv where minv_id=@minv_id)
		set @minv_disamt=(select round(minv_taxdisamt,0) from t_minv where minv_id=@minv_id)
		set @minv_freamt=(select round(minv_freamt,0) from t_minv where minv_id=@minv_id)
		set @minv_othamt=(select round(minv_othamt,0) from t_minv where minv_id=@minv_id)
		set @minv_gstamt=(select minv_gstamt from t_minv where minv_id=@minv_id)
		set @minv_fedamt=(select minv_fedamt from t_minv where minv_id=@minv_id)
		set @mvch_taxno=(select mvch_taxno from t_minv where minv_id=@minv_id)
		if (@mvch_taxno is null)
			begin
				--Master Voucher			
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@minv_dat ,@minv_dat ,'','01','05','Y','C' ,@minv_rmk,'S','',@minv_dat,0,0,@cur_id,@minv_rat,@minv_can,1,'','','','','','',@mvch_no_out=@mvch_taxno output
				update t_minv set mvch_taxno=@mvch_taxno where minv_id=@minv_id
			end
		else
			begin
				update t_mvch set mvch_tax=1,mvch_ref=@minv_rmk,mvch_rat=@minv_rat,cur_id=@cur_id,mvch_can=@minv_can where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
			end
								
--Detail Voucher
					set @nar='Invoice # ' + rtrim(cast(@minv_no as char(100))) + ' Customer Name : ' +rtrim(@cus_nam) 
--Debit
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
					set @cus_amt=@minv_namt
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,@cus_amt,0
					--Discount
					if (@minv_disamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select dis_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,@minv_disamt,0
						end
					

				
				--Other Income
					if (@minv_othamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select othincome_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@minv_othamt
						end
					--Freight
					if (@minv_freamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select freincome_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@minv_freamt
						end
					--GST AMT
					if (@minv_gstamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select gsttax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@minv_gstamt
						end
					--Freight
					if (@minv_fedamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select fedtax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@minv_fedamt
						end
					--Credit Voucher				
					set @row_id=@row_id+1
					set @acc_no=(select sacc_id from m_itm where itm_id=1)
					set @titm_amt=@minv_namt-@minv_othamt-@minv_freamt-@minv_gstamt-@minv_fedamt+@minv_disamt
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@titm_amt
			end
end		

