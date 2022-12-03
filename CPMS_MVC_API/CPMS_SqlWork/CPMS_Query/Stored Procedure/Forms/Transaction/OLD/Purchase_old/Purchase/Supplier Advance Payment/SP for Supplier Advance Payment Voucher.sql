
USE ZSONS
GO
--ALTER TABLE t_supadv add mvch_taxno int

--exec sp_voucher_supadv 2
--Voucher for suptomer Advance RECEIVNG
alter proc sp_voucher_supadv (@supadv_id int)
as
declare
@aud_act char(10),
@supadv_dat datetime,
@supadv_rmk varchar(250),
@supadv_amt float,
@cur_id int,
@acc_id int,
@supadv_rat float,
@sup_id int,
@sup_nam char(250),
@sup_acc char(20),
@mvch_typ char(2),
@mvch_no int,
@mvch_no_epl int,
@mvch_nar varchar(250),
@amount float,
@row_id int,
@aud_frmnam varchar(1000),
@supadv_can bit,
@supadv_chqdat datetime,
@supadv_cb char(1),
@supadv_chq int,
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@wht_acc int,
@supadv_whtamt float,
@supadv_tamt float,
@supadv_cktax bit,
@supadv_gstwhtamt float,
@gstwht_acc int,
@mvch_taxno int,
@mpo_id int,
@mpo_str varchar(100)
begin
--Non-Taxable
--GL Voucher
			set @mpo_str=''
			set @aud_act='Insert'
			set @aud_frmnam='Voucher of Supplier advance'
			set @supadv_dat=(select supadv_dat from t_supadv where supadv_id=@supadv_id)
			set @supadv_rmk=(select supadv_rmk from t_supadv where supadv_id=@supadv_id) 
			set @supadv_amt=(select supadv_amt from t_supadv where supadv_id=@supadv_id)
			set @supadv_whtamt=(select supadv_whtamt from t_supadv where supadv_id=@supadv_id)
			set @supadv_tamt=(select supadv_tamt from t_supadv where supadv_id=@supadv_id)
			set @supadv_rat=(select supadv_rat from t_supadv where supadv_id=@supadv_id)
			set @cur_id=(select cur_id from t_supadv where supadv_id=@supadv_id)
			set @acc_id=(select acc_no from t_supadv inner join gl_m_acc on t_supadv.acc_id=gl_m_acc.acc_id where supadv_id=@supadv_id)
			set @sup_id=(select sup_id from t_supadv where supadv_id=@supadv_id)
			set @sup_nam =(select sup_nam from m_sup where sup_id=@sup_id)
			--set @supadv_amt=(select supadv_amt from t_supadv where supadv_id=@supadv_id)
			set @mvch_no=(select mvch_no from t_supadv where supadv_id=@supadv_id)
			set @supadv_can=(select supadv_can from t_supadv where supadv_id=@supadv_id)
			set @supadv_chqdat=(select supadv_chqdat from t_supadv where supadv_id=@supadv_id)
			set @supadv_cb=(select supadv_cb from t_supadv where supadv_id=@supadv_id)
			set @supadv_chq=(select supadv_chq from t_supadv where supadv_id=@supadv_id)
			set @com_id=(select com_id from t_supadv where supadv_id=@supadv_id)
			set @br_id=(select br_id from t_supadv where supadv_id=@supadv_id)
			set @m_yr_id=(select m_yr_id from t_supadv where supadv_id=@supadv_id)
			set @supadv_cktax=(select supadv_cktax from t_supadv where supadv_id=@supadv_id)
			set @supadv_gstwhtamt=(select supadv_gstwhtamt1 from t_supadv where supadv_id=@supadv_id)
			set @mpo_id=(select mpo_id from t_supadv where supadv_id=@supadv_id)

			if (@mpo_id!='')
				begin
					set @mpo_str='PO # '+rtrim(cast(@mpo_id as varchar(100)))
				end
			
			set @row_id=0
			--Voucher Type
			if @supadv_cb='C' 
				begin
					set @mvch_typ='02'
				end
			else if @supadv_cb='B'
				begin
					set @mvch_typ='04'
				end	
			else if @supadv_cb='J'
				begin
					set @supadv_cb='C'
					set @mvch_typ='05'
				end	
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@supadv_chqdat ,@supadv_dat ,@sup_nam,'01',@mvch_typ,'Y',@supadv_cb ,@supadv_rmk,'S',@supadv_chq,@supadv_chqdat,0,0,@cur_id,@supadv_rat,@supadv_can,0,'','','','','','',@mvch_no_out=@mvch_no output				
				--Update the voucher number and type
				update t_supadv set mvch_no=@mvch_no where supadv_id=@supadv_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@supadv_chqdat ,@mvch_typ,'Y',@sup_nam,'01',@supadv_cb,@supadv_rmk,@supadv_chq,@supadv_chqdat,0,0,@cur_id,@supadv_rat,'S',@supadv_can,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
		--Detail Voucher
		--if (@supadv_rmk!='')
		--	begin
		--		set @supadv_rmk='Remarks: ' +@supadv_rmk
		--	end
			--Debit
		set @mvch_nar='Advance Payment  ID # ' +rtrim(@supadv_id) + ' '+@mpo_str--+' ' + @supadv_rmk
		set @row_id=@row_id+1
		set @sup_acc=(select acc_no from m_sup where sup_id=@sup_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@sup_acc,@mvch_nar,@supadv_amt,0
		
		--Credit	
		--Cash/ Bank
		set @mvch_nar='Advance Payment  ID # ' +rtrim(@supadv_id) +'  to Supplier '+rtrim(@sup_nam) +' '+@mpo_str+' ' + @supadv_rmk
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@mvch_nar,0,@supadv_tamt
		--WHT
		if(@supadv_whtamt>0)
			begin
				set @row_id=@row_id+1
				set @wht_acc=(select whtax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@wht_Acc,@mvch_nar,0,@supadv_whtamt
			end
		--GST WHT
		if(@supadv_gstwhtamt>0)
			begin
				set @row_id=@row_id+1
				set @gstwht_acc=(select gstwhttax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@gstwht_Acc,@mvch_nar,0,@supadv_gstwhtamt
			end		
			
		
		
--Taxable
	if(@supadv_cktax=1)
		begin
				set @mvch_taxno=(select mvch_taxno from t_supadv where supadv_id=@supadv_id)		
				set @row_id=0
			if (@mvch_taxno is null)
				begin
					--Master Voucher
					exec ins_t_mvch @com_id,@br_id,@m_yr_id,@supadv_chqdat ,@supadv_dat ,@sup_nam,'01',@mvch_typ,'Y',@supadv_cb ,@supadv_rmk,'S',@supadv_chq,@supadv_chqdat,0,0,@cur_id,@supadv_rat,@supadv_can,@supadv_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output				
					--Update the voucher number and type
					update t_supadv set mvch_taxno=@mvch_taxno where supadv_id=@supadv_id 
				end
			else
				begin
					exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno ,@supadv_chqdat ,@mvch_typ,'Y',@sup_nam,'01',@supadv_cb,@supadv_rmk,@supadv_chq,@supadv_chqdat,0,0,@cur_id,@supadv_rat,'S',@supadv_can,@supadv_cktax,'','','',''
					delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
				end
			--Detail Voucher
			--if (@supadv_rmk!='')
			--	begin
			--		set @supadv_rmk='Remarks: ' +@supadv_rmk
			--	end
			--Debit
			set @mvch_nar='Advance Payment  ID # ' +rtrim(@supadv_id) +' '+@mpo_str+' ' + @supadv_rmk
			set @row_id=@row_id+1
			set @sup_acc=(select acc_no from m_sup where sup_id=@sup_id)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@sup_acc,@mvch_nar,@supadv_amt,0	
			
			--Credit
			--Cash/ Bank
			set @mvch_nar='Advance Payment  ID # ' +rtrim(@supadv_id) +'  to Supplier '+rtrim(@sup_nam) +' '+@mpo_str+' ' + @supadv_rmk
			set @row_id=@row_id+1
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@mvch_nar,0,@supadv_tamt
			--WHT
			if(@supadv_whtamt>0)
				begin
					set @row_id=@row_id+1
					set @wht_acc=(select whtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@wht_Acc,@mvch_nar,0,@supadv_whtamt
				end
			--GST WHT
			if(@supadv_gstwhtamt>0)
				begin
					set @row_id=@row_id+1
					set @gstwht_acc=(select gstwhttax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@gstwht_Acc,@mvch_nar,0,@supadv_gstwhtamt
				end		
				

	end
end		

