USE NATHI
GO
--update m_sys set sal_ret_acc =(select acc_no from gl_m_acc where acc_id='04001010')

--exec sp_voucher_cn 6
--alter table t_mcn add mvch_taxno int

alter proc sp_voucher_cn (@mcn_id int)
as
declare
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@row_id int,
@acc_no int,
@mcn_dat datetime,
@mcn_rmk varchar(250),
@cus_id int,
@cus_nam varchar(250),
@mvch_no int,
@mcn_amt float,
@mcn_disamt float,
@mcn_bdisamt float,
@mcn_freamt float,
@mcn_namt float,
@mcn_rat float,
@cur_id int,
@mcn_can bit,
@mcn_no int,
@cus_amt float,
@nar varchar(1000),
@titm_amt float,
@minv_no int,
@mcn_cktax bit,
@mcn_gstamt float,
@mcn_fedamt float,
@mvch_taxno float,
@mcn_cash float,
@mcn_salcom float,
@minv_id int,
@emppro_id int
begin
--Non-Taxable
--GL Voucher
		set @row_id=0
		set @com_id=(select com_id from t_mcn where mcn_id=@mcn_id)
		set @br_id=(select br_id from t_mcn where mcn_id=@mcn_id)
		set @m_yr_id=(select m_yr_id from t_mcn where mcn_id=@mcn_id)
		set @mcn_dat=(select mcn_dat from t_mcn where mcn_id=@mcn_id)
		set @mcn_rmk=(select mcn_rmk from t_mcn where mcn_id=@mcn_id)
		set @cus_id=(select cus_id from t_mcn where mcn_id=@mcn_id)
		set @cus_nam=(select cus_nam from m_cus where cus_id=@cus_id)
		set @mcn_rat=(select mcn_currat from t_mcn where mcn_id=@mcn_id)		
		set @mcn_amt=(select mcn_amt from t_mcn where mcn_id=@mcn_id)*@mcn_rat
		set @mcn_freamt =(select mcn_freamt from t_mcn where mcn_id=@mcn_id)*@mcn_rat
		set @mcn_disamt=(select mcn_disamt from t_mcn where mcn_id=@mcn_id)*@mcn_rat
		set @mcn_bdisamt=(select mcn_bdisamt from t_mcn where mcn_id=@mcn_id)*@mcn_rat
		set @mcn_namt=(select mcn_namt from t_mcn where mcn_id=@mcn_id)
		set @cur_id=(select cur_id from t_mcn where mcn_id=@mcn_id)
		set @mcn_can=(select mcn_can from t_mcn where mcn_id=@mcn_id)
		set @mcn_no=(select mcn_no from t_mcn where mcn_id =@mcn_id)
		set @mcn_cash=(select mcn_cash from t_mcn where mcn_id=@mcn_id)
		set @minv_no=(select minv_no from t_mcn inner join t_minv on t_mcn.minv_id=t_minv.minv_id where mcn_id =@mcn_id)
		set @mcn_salcom=(select sum(dcn_salcom) from t_dcn where mcn_id=@mcn_id)
		set @minv_id =(select minv_id from t_mcn where mcn_id=@mcn_id)
		set @emppro_id=(select distinct t_mso.emppro_id from t_mso inner join t_mdc on t_mso.mso_id=t_mdc.mso_id inner join t_dinv on t_mdc.mdc_id=t_dinv.mdc_id where minv_id=@minv_id)

		set @mcn_gstamt=(select mcn_gstamt from t_mcn where mcn_id=@mcn_id)
		set @mcn_fedamt=(select mcn_fedamt from t_mcn where mcn_id=@mcn_id)

		set @mvch_no=(select mvch_no from t_mcn where mcn_id=@mcn_id)
		set @mcn_cktax=(select mcn_cktax from t_mcn where mcn_id=@mcn_id)
		if (@mvch_no is null)
			begin
				--Master Voucher			
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mcn_dat ,@mcn_dat ,'','01','05','Y','C' ,@mcn_rmk,'S','',@mcn_dat,0,0,@cur_id,@mcn_rat,@mcn_can,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_mcn set mvch_no=@mvch_no where mcn_id=@mcn_id
			end
		else
			begin
				update t_mvch set mvch_ref=@mcn_rmk,mvch_rat=@mcn_rat,cur_id=@cur_id,mvch_can=@mcn_can,mvch_tax=0 where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
								
--Detail Voucher
					
					--Debit Voucher				
					set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))+ ' Customer Name : ' +@cus_nam 
					set @row_id=@row_id+1
					set @acc_no=(select sal_ret_acc from m_sys) 					
					set @titm_amt=@mcn_namt+@mcn_bdisamt+@mcn_disamt-@mcn_salcom--@mcn_gamt+@mcn_disamt
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@titm_amt,0
				
				--Salesman Commission Payable
					if (@mcn_salcom>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select acc_no from m_emppro where emppro_id=@emppro_id)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mcn_salcom,0
						end
					
					--GST AMT
					if (@mcn_gstamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select gsttax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mcn_gstamt,0
						end
					--FED
					if (@mcn_fedamt>0)
						begin
							set @row_id=@row_id+1
							set @acc_no=(select fedtax_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mcn_fedamt,0
						end
					
						
					--Discount
					if (@mcn_disamt>0)
						begin
							set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))+ ' Customer Name : ' +@cus_nam 
							set @row_id=@row_id+1
							set @acc_no=(select dis_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mcn_disamt
						end
	
					--B_Discount
					if (@mcn_bdisamt>0)
						begin
							set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))+ ' Customer Name : ' +@cus_nam 
							set @row_id=@row_id+1
							set @acc_no=(select bdis_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mcn_bdisamt
						end
	
					--Credit
					set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
					set @cus_amt=@mcn_namt--@mcn_gamt+@mcn_gstamt+@mcn_fedamt
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@cus_amt
					--Freight
					--Customer Debit for Conveyance
					if (@mcn_freamt>0)
						begin
							set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))
							set @row_id=@row_id+1
							set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mcn_freamt,0

							set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))+ ' Customer Name : ' +@cus_nam 
							set @row_id=@row_id+1
							set @acc_no=(select freincome_acc from m_sys)
							exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mcn_freamt
						end
						
		--Cash
		if (@mcn_cash<>0)
			begin
				--Debit
					set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
					set @cus_amt=@mcn_cash
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@cus_amt,0
				--Credit Cash					
					set @nar='Credit Note # ' + rtrim(cast(@mcn_no as char(100))) + ' Invoice # ' +rtrim(cast(@minv_no as char(100)))
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from gl_m_acc where acc_no in (select cash_acc from m_sys))
					set @cus_amt=@mcn_cash
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mcn_cash

			end


end		
