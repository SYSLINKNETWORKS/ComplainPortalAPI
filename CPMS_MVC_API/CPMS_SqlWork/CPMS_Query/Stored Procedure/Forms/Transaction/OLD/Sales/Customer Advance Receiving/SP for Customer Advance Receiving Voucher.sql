
USE ZSONS
GO
--ALTER TABLE t_cusadv add mvch_taxno int

--exec sp_voucher_supadv 2
--Voucher for Customer Advance RECEIVNG
alter proc sp_voucher_cusadv (@cusadv_id int)
as
declare
@aud_act char(10),
@cusadv_dat datetime,
@cusadv_rmk varchar(250),
@cusadv_amt float,
@cur_id int,
@acc_id int,
@cusadv_rat float,
@cus_id int,
@cus_nam char(250),
@cus_acc char(20),
@mvch_typ char(2),
@mvch_no int,
@mvch_no_epl int,
@mvch_nar varchar(250),
@amount float,
@row_id int,
@aud_frmnam varchar(1000),
@cusadv_can bit,
@cusadv_chqdat datetime,
@cusadv_cb char(1),
@cusadv_chq int,
@cusadv_no int,
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@wht_acc int,
@cusadv_whtamt float,
@cusadv_tamt float,
@cusadv_cktax bit,
@cusadv_gstwhtamt float,
@gstwht_acc int,
@mvch_taxno int
begin
--Non-Taxable
--GL Voucher
			set @aud_act='Insert'
			set @aud_frmnam='Voucher of Custmer advance'
			set @cusadv_dat=(select cusadv_dat from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_rmk=(select cusadv_rmk from t_cusadv where cusadv_id=@cusadv_id) 
			set @cusadv_amt=(select cusadv_amt from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_whtamt=(select cusadv_whtamt from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_tamt=(select cusadv_tamt from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_rat=(select cusadv_rat from t_cusadv where cusadv_id=@cusadv_id)
			set @cur_id=(select cur_id from t_cusadv where cusadv_id=@cusadv_id)
			set @acc_id=(select acc_no from t_cusadv where cusadv_id=@cusadv_id)
			set @cus_id=(select cus_id from t_cusadv where cusadv_id=@cusadv_id)
			set @cus_nam =(select cus_nam from m_cus where cus_id=@cus_id)
			set @cusadv_amt=(select cusadv_amt from t_cusadv where cusadv_id=@cusadv_id)
			set @mvch_no=(select mvch_no from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_can=(select cusadv_can from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_chqdat=(select cusadv_chqdat from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_cb=(select cusadv_cb from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_chq=(select cusadv_chq from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_no=(select cusadv_no from t_cusadv where cusadv_id=@cusadv_id)
			set @com_id=(select com_id from t_cusadv where cusadv_id=@cusadv_id)
			set @br_id=(select br_id from t_cusadv where cusadv_id=@cusadv_id)
			set @m_yr_id=(select m_yr_id from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_cktax=(select cusadv_cktax from t_cusadv where cusadv_id=@cusadv_id)
			set @cusadv_gstwhtamt=(select cusadv_gstwhtamt1 from t_cusadv where cusadv_id=@cusadv_id)

			
			set @row_id=0
			--Voucher Type
			if @cusadv_cb='C' 
				begin
					set @mvch_typ='01'
				end
			else if @cusadv_cb='B'
				begin
					set @mvch_typ='03'
				end	
			else if @cusadv_cb='J'
				begin
					set @cusadv_cb='C'
					set @mvch_typ='05'
				end	
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@cusadv_chqdat ,@cusadv_dat ,@cus_nam,'01',@mvch_typ,'Y',@cusadv_cb ,@cusadv_rmk,'S',@cusadv_chq,@cusadv_chqdat,0,0,@cur_id,@cusadv_rat,@cusadv_can,0,'','','','','','',@mvch_no_out=@mvch_no output				
				--Update the voucher number and type
				update t_cusadv set mvch_no=@mvch_no where cusadv_id=@cusadv_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@cusadv_chqdat ,@mvch_typ,'Y',@cus_nam,'01',@cusadv_cb,@cusadv_rmk,@cusadv_chq,@cusadv_chqdat,0,0,@cur_id,@cusadv_rat,'S',@cusadv_can,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
		--Detail Voucher
		--if (@cusadv_rmk!='')
		--	begin
		--		set @cusadv_rmk='Remarks: ' +@cusadv_rmk
		--	end
			
		--Cash/ Bank
		set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@mvch_nar,@cusadv_amt,0
		--WHT
		if(@cusadv_whtamt>0)
			begin
				set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
				set @row_id=@row_id+1
				set @wht_acc=(select whtax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@wht_Acc,@mvch_nar,@cusadv_whtamt,0
			end
		--GST WHT
		if(@cusadv_gstwhtamt>0)
			begin
				set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
				set @row_id=@row_id+1
				set @gstwht_acc=(select gstwhttax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@gstwht_Acc,@mvch_nar,@cusadv_gstwhtamt,0
			end		
			
			--Credit
		set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+ ' ' + @cusadv_rmk
		set @row_id=@row_id+1
		set @cus_acc=(select acc_no from m_cus where cus_id=@cus_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@cus_acc,@mvch_nar,0,@cusadv_tamt
		
--Taxable
	if(@cusadv_cktax=1)
		begin
				set @mvch_taxno=(select mvch_taxno from t_cusadv where cusadv_id=@cusadv_id)		
				set @row_id=0
			if (@mvch_taxno is null)
				begin
					--Master Voucher
					exec ins_t_mvch @com_id,@br_id,@m_yr_id,@cusadv_chqdat ,@cusadv_dat ,@cus_nam,'01',@mvch_typ,'Y',@cusadv_cb ,@cusadv_rmk,'S',@cusadv_chq,@cusadv_chqdat,0,0,@cur_id,@cusadv_rat,@cusadv_can,@cusadv_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output				
					--Update the voucher number and type
					update t_cusadv set mvch_taxno=@mvch_taxno where cusadv_id=@cusadv_id 
				end
			else
				begin
					exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno ,@cusadv_chqdat ,@mvch_typ,'Y',@cus_nam,'01',@cusadv_cb,@cusadv_rmk,@cusadv_chq,@cusadv_chqdat,0,0,@cur_id,@cusadv_rat,'S',@cusadv_can,@cusadv_cktax,'','','',''
					delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
				end
			--Detail Voucher
			--if (@cusadv_rmk!='')
			--	begin
			--		set @cusadv_rmk='Remarks: ' +@cusadv_rmk
			--	end
				
			--Cash/ Bank
			set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
			set @row_id=@row_id+1
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@mvch_nar,@cusadv_amt,0
			--WHT
			if(@cusadv_whtamt>0)
				begin
					set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
					set @row_id=@row_id+1
					set @wht_acc=(select whtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@wht_Acc,@mvch_nar,@cusadv_whtamt,0
				end
			--GST WHT
			if(@cusadv_gstwhtamt>0)
				begin
					set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @cusadv_rmk
					set @row_id=@row_id+1
					set @gstwht_acc=(select gstwhttax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@gstwht_Acc,@mvch_nar,@cusadv_gstwhtamt,0
				end		
				
				--Credit
			set @mvch_nar='Customer Advance # ' +rtrim(cast(@cusadv_no as varchar(1000)))+ ' ' + @cusadv_rmk
			set @row_id=@row_id+1
			set @cus_acc=(select acc_no from m_cus where cus_id=@cus_id)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@cus_acc,@mvch_nar,0,@cusadv_tamt	

	end
end		

