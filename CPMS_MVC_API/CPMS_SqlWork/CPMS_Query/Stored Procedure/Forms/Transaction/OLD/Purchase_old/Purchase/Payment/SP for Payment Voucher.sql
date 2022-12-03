--select * from t_mpay where mpay_id=3
--update m_sys set whtax_acc=1883
--select * from gl_m_acc where acc_id='02003005001'

USE ZSONS
GO

--alter table t_mpay add mvch_taxno int,mvch_taxno_epl int


--Voucher for Purchase Bill
alter proc sp_voucher_pay (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpay_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@aud_act char(10),
@mpay_dat datetime,
@mpay_rmk varchar(250),
@mpay_amt float,
@cur_id int,
@acc_id int,
@mpay_rat float,
@sup_id int,
@sup_nam char(250),
@sup_acc char(20),
@mvch_typ char(2),
@mvch_no int,
@mvch_no_epl int,
@mvch_nar varchar(250),
@amount float,
@mpay_epl float,
@eplamount float,
@epl_acc char(20),
@mpay_namt float,
@row_id int,
@aud_frmnam varchar(1000),
@sup_bill varchar(1000),
@mpay_can bit,
@mpay_chqdat datetime,
@mpay_cb char(1),
@mpay_chq int,
@wh_acc int,
@mpay_whtax float,
@mpay_cktax bit,
@mpay_gstwhtamt float,
@gstwht_acc int,
@mvch_taxno int,
@mvch_taxno_epl int
begin
--Non- Taxable
--GL Voucher
			set @aud_act='Insert'
			set @aud_frmnam='Voucher of Supplier Payment'
			set @mpay_dat=(select mpay_dat from t_mpay where mpay_id=@mpay_id)
			set @mpay_rmk=(select mpay_rmk from t_mpay where mpay_id=@mpay_id) 
			set @mpay_amt=(select mpay_amt from t_mpay where mpay_id=@mpay_id)
			set @mpay_whtax=(select mpay_whtax from t_mpay where mpay_id=@mpay_id)
			set @mpay_namt=(select mpay_namt from t_mpay where mpay_id=@mpay_id)
			set @mpay_rat=(select mpay_rat from t_mpay where mpay_id=@mpay_id)
			set @mpay_epl=(select mpay_epl from t_mpay where mpay_id=@mpay_id)
			set @sup_bill=(select sup_bill from t_mpay where mpay_id=@mpay_id)
			set @cur_id=(select cur_id from t_mpay where mpay_id=@mpay_id)
			set @acc_id=(select acc_no from t_mpay where mpay_id=@mpay_id)
			set @sup_id=(select sup_id from t_mpay where mpay_id=@mpay_id)
			set @sup_nam =(select sup_nam from m_sup where sup_id=@sup_id)
			set @mvch_no=(select mvch_no from t_mpay where mpay_id=@mpay_id)
			set @mvch_no_epl=(select mvch_no_epl from t_mpay where mpay_id=@mpay_id)
			set @mpay_can=(select mpay_can from t_mpay where mpay_id=@mpay_id)
			set @mpay_chqdat=(select mpay_chqdat from t_mpay where mpay_id=@mpay_id)
			set @mpay_cb=(select mpay_cb from t_mpay where mpay_id=@mpay_id)
			set @mpay_chq=(select mpay_chq from t_mpay where mpay_id=@mpay_id)
			set @mpay_cktax=(select mpay_cktax from t_mpay where mpay_id=@mpay_id)
			set @mpay_gstwhtamt=(select mpay_gstwhtamt from t_mpay where mpay_id=@mpay_id)
			
			set @row_id=0
			--Voucher Type
			if @mpay_cb='C' 
				begin
					set @mvch_typ='02'
				end
			else if @mpay_cb='B'
				begin
					set @mvch_typ='04'
				end	
			else if @mpay_cb='J' 
				begin
					set @mpay_cb='C'
					set @mvch_typ='05'
				end
		----Checking Type
		--if (@mvch_typ!=@mvch_typ_old)
		--begin	
		--	exec del_t_vch @com_id,@br_id ,@mvch_id ,@mvch_typ_old,@m_yr_id,@mvch_cb_old, @mvch_chq_old,@aud_frmnam,@aud_des,@usr_id,@aud_ip
		--	exec del_t_vch @com_id,@br_id ,@mvch_id_epl ,@mvch_typ_old,@m_yr_id,@mvch_cb_old, @mvch_chq_old,@aud_frmnam,@aud_des,@usr_id,@aud_ip
		--	update t_mpay set mvch_id=null,mvch_id_epl=null where mpay_id=@mpay_id
		--	set @mvch_id=null
		--	set @mvch_id_epl=null
		--end

		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpay_chqdat ,@mpay_dat ,@sup_nam,'01',@mvch_typ,'Y',@mpay_cb ,@mpay_rmk,'S',@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,@mpay_can,0,'','','','','','',@mvch_no_out=@mvch_no output
				set @aud_des='Voucher Against Payment# '+rtrim(cast(@mpay_id as char(1000)))
				--Update the voucher number and type
				update t_mpay set mvch_no=@mvch_no where mpay_id=@mpay_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@mpay_chqdat ,@mvch_typ,'Y',@sup_nam,'01',@mpay_cb,@mpay_rmk,@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,'S',@mpay_can,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
		--Detail Voucher
		if (@sup_bill !='')
			begin
				set @sup_bill='Supplier Bill # '+ @sup_bill
			end
		if (@mpay_rmk!='')
			begin
				set @mpay_rmk='Remarks: ' +@mpay_rmk
			end
			
		set @mvch_nar='Payment ID # ' +rtrim(@mpay_id)+' ' +@sup_bill + ' ' + @mpay_rmk
		--Debit
		set @row_id=@row_id+1
		set @sup_acc=(select acc_no from m_sup where sup_id=@sup_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@sup_acc,@mvch_nar,@mpay_amt,0
		--Credit
		--With Holding
		if (@mpay_whtax>0)
			begin
				set @row_id=@row_id+1
				set @wh_acc=(select whtax_acc from m_sys )
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@wh_acc,@mvch_nar,0,@mpay_whtax
			end
		--GST With Holding
		if (@mpay_gstwhtamt>0)
			begin
				set @row_id=@row_id+1
				set @gstwht_acc=(select gstwhttax_acc from m_sys )
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@gstwht_acc,@mvch_nar,0,@mpay_gstwhtamt
			end
		--Cash/ Bank
		set @mvch_nar='Payment ID # ' +rtrim(@mpay_id)+' Supplier '+rtrim(@sup_nam) + ' ' +@sup_bill+ ' ' + @mpay_rmk
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@mvch_nar,0,@mpay_namt
		
		--Exchange Profit / Loss
		if (@mpay_epl!=0) 
			begin
					set @cur_id=(select cur_id from m_cur where cur_typ='S')
					set @mvch_typ='05'
					set @mpay_rat=1
					set @row_id=0
					if (@mvch_no_epl is null)
						begin
							--Master Voucher
							exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpay_chqdat ,@mpay_dat ,@sup_nam,'01',@mvch_typ,'Y','C' ,@mpay_rmk,'S',0,@mpay_chqdat,0,0,@cur_id,@mpay_rat,@mpay_can,'','','','','','',@mvch_no_out=@mvch_no_epl output
							set @aud_des='Voucher Against EPL Payment #'+rtrim(cast(@mpay_id as char(1000)))
							--Update the voucher number and type
							update t_mpay set mvch_no_epl=@mvch_no_epl where mpay_id=@mpay_id

						end
					else
						begin
							exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no_epl ,@mpay_chqdat ,@mvch_typ,'Y',@sup_nam,'01','C',@mpay_rmk,@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,'S',@mpay_can,'','','',''
							delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no_epl 
						end
					--EPL Debit
					if (@mpay_epl<0)
						begin	
							set @epl_acc=(select epl_acc from m_sys)
							set @eplamount=-@mpay_epl
							--set @mpay_tamt=@mpay_tamt-@eplamount
							--Debit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@epl_acc,@mvch_nar,@eplamount,0
							--Credit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@sup_acc,@mvch_nar,0,@eplamount
						end

					--EPL Credit
					if (@mpay_epl>0)
						begin	
							set @epl_acc=(select epl_acc from m_sys)
							set @eplamount=@mpay_epl
							--set @mpay_tamt=@mpay_tamt-@eplamount				
							--Debit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@sup_acc,@mvch_nar,@eplamount,0
							--Credit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@epl_acc,@mvch_nar,0,@eplamount
						end
		end
		else
		begin
				exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no_epl ,'','','',''
				update t_mpay set mvch_no_epl=null where mpay_id=@mpay_id 
		end
--Taxable 
	if (@mpay_cktax =1)
		begin
				set @mvch_taxno=(select mvch_taxno from t_mpay where mpay_id=@mpay_id)
				set @mvch_taxno_epl=(select mvch_taxno_epl from t_mpay where mpay_id=@mpay_id)
				
				set @row_id=0
				
			----Checking Type
			--if (@mvch_typ!=@mvch_typ_old)
			--begin	
			--	exec del_t_vch @com_id,@br_id ,@mvch_id ,@mvch_typ_old,@m_yr_id,@mvch_cb_old, @mvch_chq_old,@aud_frmnam,@aud_des,@usr_id,@aud_ip
			--	exec del_t_vch @com_id,@br_id ,@mvch_id_epl ,@mvch_typ_old,@m_yr_id,@mvch_cb_old, @mvch_chq_old,@aud_frmnam,@aud_des,@usr_id,@aud_ip
			--	update t_mpay set mvch_id=null,mvch_id_epl=null where mpay_id=@mpay_id
			--	set @mvch_id=null
			--	set @mvch_id_epl=null
			--end

			if (@mvch_taxno is null)
				begin
					--Master Voucher
					exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpay_chqdat ,@mpay_dat ,@sup_nam,'01',@mvch_typ,'Y',@mpay_cb ,@mpay_rmk,'S',@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,@mpay_can,@mpay_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output
					set @aud_des='Voucher Against Payment# '+rtrim(cast(@mpay_id as char(1000)))
					--Update the voucher number and type
					update t_mpay set mvch_taxno=@mvch_taxno where mpay_id=@mpay_id 
				end
			else
				begin
					exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno ,@mpay_chqdat ,@mvch_typ,'Y',@sup_nam,'01',@mpay_cb,@mpay_rmk,@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,'S',@mpay_can,@mpay_cktax,'','','',''
					delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
				end
			--Detail Voucher
			if (@sup_bill !='')
				begin
					set @sup_bill='Supplier Bill # '+ @sup_bill
				end
			if (@mpay_rmk!='')
				begin
					set @mpay_rmk='Remarks: ' +@mpay_rmk
				end
				
			set @mvch_nar='Payment ID # ' +rtrim(@mpay_id)+' ' +@sup_bill + ' ' + @mpay_rmk
			--Debit
			set @row_id=@row_id+1
			set @sup_acc=(select acc_no from m_sup where sup_id=@sup_id)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@sup_acc,@mvch_nar,@mpay_amt,0
			--Credit
			--With Holding
			if (@mpay_whtax>0)
				begin
					set @row_id=@row_id+1
					set @wh_acc=(select whtax_acc from m_sys )
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@wh_acc,@mvch_nar,0,@mpay_whtax
				end
			--GST With Holding
			if (@mpay_gstwhtamt>0)
				begin
					set @row_id=@row_id+1
					set @gstwht_acc=(select gstwhttax_acc from m_sys )
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@gstwht_acc,@mvch_nar,0,@mpay_gstwhtamt
				end
			--Cash/ Bank
			set @mvch_nar='Payment ID # ' +rtrim(@mpay_id)+' Supplier '+rtrim(@sup_nam) + ' ' +@sup_bill+ ' ' + @mpay_rmk
			set @row_id=@row_id+1
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@mvch_nar,0,@mpay_namt
			
			--Exchange Profit / Loss
			if (@mpay_epl!=0) 
				begin
						set @cur_id=(select cur_id from m_cur where cur_typ='S')
						set @mvch_typ='05'
						set @mpay_rat=1
						set @row_id=0
						if (@mvch_taxno_epl is null)
							begin
								--Master Voucher
								exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpay_chqdat ,@mpay_dat ,@sup_nam,'01',@mvch_typ,'Y','C' ,@mpay_rmk,'S',0,@mpay_chqdat,0,0,@cur_id,@mpay_rat,@mpay_can,'','','','','','',@mvch_no_out=@mvch_taxno_epl output
								set @aud_des='Voucher Against EPL Payment #'+rtrim(cast(@mpay_id as char(1000)))
								--Update the voucher number and type
								update t_mpay set mvch_taxno_epl=@mvch_taxno_epl where mpay_id=@mpay_id

							end
						else
							begin
								exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno_epl ,@mpay_chqdat ,@mvch_typ,'Y',@sup_nam,'01','C',@mpay_rmk,@mpay_chq,@mpay_chqdat,0,0,@cur_id,@mpay_rat,'S',@mpay_can,'','','',''
								delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno_epl 
							end
						--EPL Debit
						if (@mpay_epl<0)
							begin	
								set @epl_acc=(select epl_acc from m_sys)
								set @eplamount=-@mpay_epl
								--set @mpay_tamt=@mpay_tamt-@eplamount
								--Debit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@epl_acc,@mvch_nar,@eplamount,0
								--Credit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@sup_acc,@mvch_nar,0,@eplamount
							end

						--EPL Credit
						if (@mpay_epl>0)
							begin	
								set @epl_acc=(select epl_acc from m_sys)
								set @eplamount=@mpay_epl
								--set @mpay_tamt=@mpay_tamt-@eplamount				
								--Debit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@sup_acc,@mvch_nar,@eplamount,0
								--Credit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@epl_acc,@mvch_nar,0,@eplamount
							end
			end
			else
			begin
					exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_taxno_epl ,'','','',''
					update t_mpay set mvch_taxno_epl=null where mpay_id=@mpay_id 
			end
	
		end
end		

