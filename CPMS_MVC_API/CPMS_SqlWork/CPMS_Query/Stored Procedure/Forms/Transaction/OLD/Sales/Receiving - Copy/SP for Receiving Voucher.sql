
USE NATHI
GO
--alter table m_sys add ittax_acc int
--update m_sys set ittax_acc=1898
--select * from gl_m_acc where acc_id='03002006001'

--alter table t_mrec add mvch_taxno int,mvch_taxno_epl int
--exec sp_voucher_rec 2
--Voucher for Receiving
alter proc sp_voucher_rec (@mrec_id int)
as
declare
@aud_act char(10),
@mrec_dat datetime,
@mrec_rmk varchar(250),
@mrec_amt float,
@cur_id int,
@acc_id int,
@mrec_rat float,
@cus_id int,
@cus_nam char(250),
@cus_acc char(20),
@mvch_typ char(2),
@mvch_no int,
@mvch_no_epl int,
@mvch_nar varchar(250),
@amount float,
@mrec_epl float,
@eplamount float,
@epl_acc char(20),
@row_id int,
@aud_frmnam varchar(1000),
@mrec_can bit,
@mrec_chqdat datetime,
@mrec_cb char(1),
@mrec_chq int,
@mrec_no int,
@com_id char(2),
@br_id char(3),
@m_yr_id char(2),
@mrec_intax float,
@mrec_namt float,
@ittax_acc int,
@mrec_cktax bit,
@mrec_gstwhtamt float,
@gstwht_acc int,
@mvch_taxno int,
@mvch_taxno_epl int
begin
--GL Voucher

			set @aud_act='Insert'
			set @aud_frmnam='Voucher of cusplier recment'
			set @mrec_dat=(select mrec_dat from t_mrec where mrec_id=@mrec_id)
			set @mrec_rmk=(select mrec_rmk from t_mrec where mrec_id=@mrec_id) 
			set @mrec_amt=(select mrec_amt from t_mrec where mrec_id=@mrec_id)
			set @mrec_intax=(select mrec_intax from t_mrec where mrec_id=@mrec_id)
			set @mrec_gstwhtamt=(select mrec_gstwhtamt from t_mrec where mrec_id=@mrec_id)
			set @mrec_namt=(select mrec_namt from t_mrec where mrec_id=@mrec_id)
			set @mrec_rat=(select mrec_rat from t_mrec where mrec_id=@mrec_id)
			set @mrec_epl=(select mrec_epl from t_mrec where mrec_id=@mrec_id)
			set @cur_id=(select cur_id from t_mrec where mrec_id=@mrec_id)
			set @acc_id=(select acc_no from t_mrec where mrec_id=@mrec_id)
			set @cus_id=(select cus_id from t_mrec where mrec_id=@mrec_id)
			set @cus_nam =(select cus_nam from m_cus where cus_id=@cus_id)
			set @mrec_amt=(select mrec_amt from t_mrec where mrec_id=@mrec_id)
			set @mvch_no=(select mvch_no from t_mrec where mrec_id=@mrec_id)
			set @mvch_no_epl=(select mvch_no_epl from t_mrec where mrec_id=@mrec_id)
			set @mrec_can=(select mrec_can from t_mrec where mrec_id=@mrec_id)
			set @mrec_chqdat=(select mrec_chqdat from t_mrec where mrec_id=@mrec_id)
			set @mrec_cb=(select mrec_cb from t_mrec where mrec_id=@mrec_id)
			set @mrec_chq=(select mrec_chq from t_mrec where mrec_id=@mrec_id)
			set @mrec_no=(select mrec_no from t_mrec where mrec_id=@mrec_id)
			set @com_id=(select com_id from t_mrec where mrec_id=@mrec_id)
			set @br_id=(select br_id from t_mrec where mrec_id=@mrec_id)
			set @m_yr_id=(select m_yr_id from t_mrec where mrec_id=@mrec_id)
			set @mrec_cktax=(select mrec_cktax from t_mrec where mrec_id=@mrec_id)

			set @row_id=0
			--Voucher Type
			if @mrec_cb='C' 
				begin
					set @mvch_typ='01'
				end
			else if @mrec_cb='B'
				begin
					set @mvch_typ='03'
				end	
			else if @mrec_cb='J'
				begin
					set @mrec_cb='C'
					set @mvch_typ='05'
				end					
--Non-Taxable
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mrec_chqdat ,@mrec_dat ,@cus_nam,'01',@mvch_typ,'Y',@mrec_cb ,@mrec_rmk,'S',@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,@mrec_can,0,'','','','','','',@mvch_no_out=@mvch_no output				
				--Update the voucher number and type
				update t_mrec set mvch_no=@mvch_no where mrec_id=@mrec_id 
			end
		else
			begin
				exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no ,@mrec_chqdat ,@mvch_typ,'Y',@cus_nam,'01',@mrec_cb,@mrec_rmk,@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,'S',@mrec_can,0,'','','',''
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
		----Detail Voucher
		--if (@mrec_rmk!='')
		--	begin
		--		set @mrec_rmk='Remarks: ' +@mrec_rmk
		--	end
			
		--Cash/ Bank
		set @mvch_nar='Receiving # ' +rtrim(cast(@mrec_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @mrec_rmk
		set @row_id=@row_id+1
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@mvch_nar,@mrec_amt,0
		--IT
		if(@mrec_intax>0)
			begin
				set @row_id=@row_id+1
				set @ittax_acc=(select whtax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@ittax_Acc,@mvch_nar,@mrec_intax,0
			end
		--GST WHT
		if(@mrec_gstwhtamt>0)
			begin
				set @row_id=@row_id+1
				set @gstwht_acc=(select gstwhttax_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@gstwht_Acc,@mvch_nar,@mrec_gstwhtamt,0
			end
		--Credit
		set @mvch_nar='Receiving # ' +rtrim(cast(@mrec_no as varchar(1000)))+ ' ' + @mrec_rmk
		set @row_id=@row_id+1
		set @cus_acc=(select acc_no from m_cus where cus_id=@cus_id)
		exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@cus_acc,@mvch_nar,0,@mrec_namt
		
		--Exchange Profit / Loss
		if (@mrec_epl!=0) 
			begin
					set @cur_id=(select cur_id from m_cur where cur_typ='S')
					set @mvch_typ='05'
					set @mrec_rat=1
					set @row_id=0
					if (@mvch_no_epl is null)
						begin
							--Master Voucher
							exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mrec_chqdat ,@mrec_dat ,@cus_nam,'01',@mvch_typ,'Y','C' ,@mrec_rmk,'S',0,@mrec_chqdat,0,0,@cur_id,@mrec_rat,@mrec_can,'','','','','','',@mvch_no_out=@mvch_no_epl output
							--Update the voucher number and type
							update t_mrec set mvch_no_epl=@mvch_no_epl where mrec_id=@mrec_id

						end
					else
						begin
							exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_no_epl ,@mrec_chqdat ,@mvch_typ,'Y',@cus_nam,'01','C',@mrec_rmk,@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,'S',@mrec_can,'','','',''
							delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no_epl 
						end
					--EPL Debit
					if (@mrec_epl<0)
						begin	
							set @epl_acc=(select epl_acc from m_sys)
							set @eplamount=-@mrec_epl
							--set @mrec_tamt=@mrec_tamt-@eplamount
							--Debit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@epl_acc,@mvch_nar,@eplamount,0
							--Credit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@cus_acc,@mvch_nar,0,@eplamount
						end

					--EPL Credit
					if (@mrec_epl>0)
						begin	
							set @epl_acc=(select epl_acc from m_sys)
							set @eplamount=@mrec_epl
							--set @mrec_tamt=@mrec_tamt-@eplamount				
							--Debit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@cus_acc,@mvch_nar,@eplamount,0
							--Credit
							set @row_id=@row_id+1
							exec ins_t_dvch @com_id,@br_id,@mvch_no_epl,@row_id,@epl_acc,@mvch_nar,0,@eplamount
						end
		end
		else
		begin
				exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no_epl ,'','','',''
				update t_mrec set mvch_no_epl=null where mrec_id=@mrec_id 
		end

--Taxable

	if(@mrec_cktax=1)
		begin
				set @mvch_taxno=(select mvch_taxno from t_mrec where mrec_id=@mrec_id)
				set @mvch_taxno_epl=(select mvch_taxno_epl from t_mrec where mrec_id=@mrec_id)
			if (@mvch_taxno is null)
				begin
					--Master Voucher
					exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mrec_chqdat ,@mrec_dat ,@cus_nam,'01',@mvch_typ,'Y',@mrec_cb ,@mrec_rmk,'S',@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,@mrec_can,@mrec_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output				
					--Update the voucher number and type
					update t_mrec set mvch_taxno=@mvch_taxno where mrec_id=@mrec_id 
				end
			else
				begin
					exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno ,@mrec_chqdat ,@mvch_typ,'Y',@cus_nam,'01',@mrec_cb,@mrec_rmk,@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,'S',@mrec_can,@mrec_cktax,'','','',''
					delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
				end
			----Detail Voucher
			--if (@mrec_rmk!='')
			--	begin
			--		set @mrec_rmk='Remarks: ' +@mrec_rmk
			--	end
				
			--Cash/ Bank
			set @mvch_nar='Receiving # ' +rtrim(cast(@mrec_no as varchar(1000)))+' Customer '+rtrim(@cus_nam) + ' ' + @mrec_rmk
			set @row_id=@row_id+1
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@mvch_nar,@mrec_amt,0
			--IT
			if(@mrec_intax>0)
				begin
					set @row_id=@row_id+1
					set @ittax_acc=(select whtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@ittax_Acc,@mvch_nar,@mrec_intax,0
				end
			--GST WHT
			if(@mrec_gstwhtamt>0)
				begin
					set @row_id=@row_id+1
					set @gstwht_acc=(select gstwhttax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@gstwht_Acc,@mvch_nar,@mrec_gstwhtamt,0
				end
			--Credit
			set @mvch_nar='Receiving # ' +rtrim(cast(@mrec_no as varchar(1000)))+ ' ' + @mrec_rmk
			set @row_id=@row_id+1
			set @cus_acc=(select acc_no from m_cus where cus_id=@cus_id)
			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@cus_acc,@mvch_nar,0,@mrec_namt
			
			--Exchange Profit / Loss
			if (@mrec_epl!=0) 
				begin
						set @cur_id=(select cur_id from m_cur where cur_typ='S')
						set @mvch_typ='05'
						set @mrec_rat=1
						set @row_id=0
						if (@mvch_taxno_epl is null)
							begin
								--Master Voucher
								exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mrec_chqdat ,@mrec_dat ,@cus_nam,'01',@mvch_typ,'Y','C' ,@mrec_rmk,'S',0,@mrec_chqdat,0,0,@cur_id,@mrec_rat,@mrec_can,0,'','','','','','',@mvch_no_out=@mvch_taxno_epl output
								--Update the voucher number and type
								update t_mrec set mvch_taxno_epl=@mvch_taxno_epl where mrec_id=@mrec_id

							end
						else
							begin
								exec upd_t_mvch @com_id ,@br_id ,@m_yr_id ,@mvch_taxno_epl ,@mrec_chqdat ,@mvch_typ,'Y',@cus_nam,'01','C',@mrec_rmk,@mrec_chq,@mrec_chqdat,0,0,@cur_id,@mrec_rat,'S',@mrec_can,0,'','','',''
								delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno_epl 
							end
						--EPL Debit
						if (@mrec_epl<0)
							begin	
								set @epl_acc=(select epl_acc from m_sys)
								set @eplamount=-@mrec_epl
								--set @mrec_tamt=@mrec_tamt-@eplamount
								--Debit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@epl_acc,@mvch_nar,@eplamount,0
								--Credit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@cus_acc,@mvch_nar,0,@eplamount
							end

						--EPL Credit
						if (@mrec_epl>0)
							begin	
								set @epl_acc=(select epl_acc from m_sys)
								set @eplamount=@mrec_epl
								--set @mrec_tamt=@mrec_tamt-@eplamount				
								--Debit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@cus_acc,@mvch_nar,@eplamount,0
								--Credit
								set @row_id=@row_id+1
								exec ins_t_dvch @com_id,@br_id,@mvch_taxno_epl,@row_id,@epl_acc,@mvch_nar,0,@eplamount
							end
			end
			else
				begin
						exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_taxno_epl ,'','','',''
						update t_mrec set mvch_taxno_epl=null where mrec_id=@mrec_id 
				end
		end
end		

