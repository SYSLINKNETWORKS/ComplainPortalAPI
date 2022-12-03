--select * from t_mdn where mdn_id=69
--select * from t_mdn

USE ZSONS
GO
--update m_sys set pur_ret_acc=(select acc_no from gl_m_acc where acc_id=pur_ret_acc)
--alter table m_sys alter column pur_ret_acc int

--alter table m_sys add design_acc char(20)
--update m_sys set design_acc='05007034'
--alter table t_mdn add mvch_taxno int

--exec sp_voucher_dn '01','01','01',69,1,'',''


--Voucher for Debit Note
alter proc sp_voucher_dn (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mdn_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mdn_dat datetime,
@mdn_namt float,
@mdn_rmk varchar(250),
@itm_id int,
@itm_amt float,
@sup_id int,
@sup_nam varchar(250),
@acc_no int,
@row_id int,
@mvch_no int,
@nar varchar(1000),
@mdn_rat float,
@cur_id int,
@mpb_id int,
@sup_bill varchar(250),
@mdn_gstamt float,
@mdn_fedamt float,
@mdn_cktax bit,
@acc_id int,
@mvch_taxno int
begin
--Non-Taxable
--GL Voucher
		set @row_id=0
		set @mdn_dat=(select mdn_dat from t_mdn where mdn_id=@mdn_id)
		set @mdn_namt=(select mdn_amt+mdn_gstamt+mdn_fedamt from t_mdn where mdn_id=@mdn_id)
		set @mdn_rmk=(select mdn_rmk from t_mdn where mdn_id=@mdn_id)
		set @sup_id=(select sup_id from t_mpb where mpb_id=(select mpb_id from t_mdn where mdn_id=@mdn_id))
		set @sup_nam=(select sup_nam from m_sup where sup_id=@sup_id)
		set @mvch_no=(select mvch_no from t_mdn where mdn_id=@mdn_id)
		set @mdn_rat=(select mdn_rat from t_mdn where mdn_id=@mdn_id)
		set @cur_id=(select cur_id from t_mdn where mdn_id=@mdn_id)
		set @mpb_id=(select mpb_id from t_mdn where mdn_id=@mdn_id)
		set @sup_bill=(select sup_bill from t_mpb where mpb_id=@mpb_id)
		set @mdn_gstamt=(select mdn_gstamt from t_mdn where mdn_id=@mdn_id)
		set @mdn_fedamt=(select mdn_fedamt from t_mdn where mdn_id=@mdn_id)
		set @mdn_cktax =(select mpb_cktax from t_mpb where mpb_id=@mpb_id)
		
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mdn_dat ,@mdn_dat ,'','01','05','Y','C' ,@mdn_rmk,'S','',@mdn_dat,0,0,@cur_id,@mdn_rat,0,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_mdn set mvch_no=@mvch_no where mdn_id=@mdn_id
			end
		else
			begin
				update t_mvch set mvch_ref=@mdn_rmk,mvch_rat=@mdn_rat,cur_id=@cur_id,mvch_tax=0 where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no 
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no 
			end
--Detail Voucher
			if (@sup_bill!='')
				begin
					set @sup_bill='Supplier Bill # ' +@sup_bill
				end

			--if (@mdn_rmk!='')
			--	begin
			--		set @mdn_rmk='Remarks: ' +@mdn_rmk
			--	end

		----Debit Account Supplier
					set @nar='Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mpb_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_sup where sup_id=@sup_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,@mdn_namt,0

					--Credit Voucher				
					--GST
	if (@mdn_gstamt>0)
		begin
			set @nar='GST Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mdn_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
			set @row_id=@row_id+1
			set @acc_id=(select gsttax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,0,@mdn_gstamt
		end
	--FED
	if (@mdn_fedamt>0)
		begin
			set @nar='FED Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mdn_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
			set @row_id=@row_id+1
			set @acc_id=(select fedtax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,0,@mdn_fedamt
		end			
		
				--Purchase Return
				set @nar='Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mpb_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
				set @row_id=@row_id+1
				set @acc_no=(select pur_ret_acc from m_sys )
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_no,@nar,0,@mdn_namt
--Taxable
if (@mdn_cktax =1)
	begin
			set @row_id=0
		set @mvch_taxno=(select mvch_taxno from t_mdn where mdn_id=@mdn_id)
		
		if (@mvch_taxno is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mdn_dat ,@mdn_dat ,'','01','05','Y','C' ,@mdn_rmk,'S','',@mdn_dat,0,0,@cur_id,@mdn_rat,0,@mdn_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output
				update t_mdn set mvch_taxno=@mvch_taxno where mdn_id=@mdn_id
			end
		else
			begin
				update t_mvch set mvch_ref=@mdn_rmk,mvch_rat=@mdn_rat,cur_id=@cur_id,mvch_tax=@mdn_cktax where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno 
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno 
			end
--Detail Voucher
			if (@sup_bill!='')
				begin
					set @sup_bill='Supplier Bill # ' +@sup_bill
				end

			--if (@mdn_rmk!='')
			--	begin
			--		set @mdn_rmk='Remarks: ' +@mdn_rmk
			--	end

		----Debit Account Supplier
					set @nar='Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mpb_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
					set @row_id=@row_id+1
					set @acc_no=(select acc_no from m_sup where sup_id=@sup_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,@mdn_namt,0

					--Credit Voucher				
					--GST
	if (@mdn_gstamt>0)
		begin
			set @nar='GST Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mdn_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
			set @row_id=@row_id+1
			set @acc_id=(select gsttax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,0,@mdn_gstamt
		end
	--FED
	if (@mdn_fedamt>0)
		begin
			set @nar='FED Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mdn_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
			set @row_id=@row_id+1
			set @acc_id=(select fedtax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,0,@mdn_fedamt
		end			
		
				--Purchase Return
				set @nar='Debit Note # ' + rtrim(cast(@mdn_id as char(100))) + ' Purchase Bill # ' +rtrim(cast(@mpb_id as char(100)))+' ' +@sup_bill +' '+@mdn_rmk
				set @row_id=@row_id+1
				set @acc_no=(select pur_ret_acc from m_sys )
				exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_no,@nar,0,@mdn_namt
	end
					
end		

