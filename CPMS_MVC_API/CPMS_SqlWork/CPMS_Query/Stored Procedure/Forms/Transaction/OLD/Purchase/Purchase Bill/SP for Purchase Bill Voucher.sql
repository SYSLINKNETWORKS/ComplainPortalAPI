--select * from t_mpb where mpb_id=69

USE phm
GO
--alter table m_sys add othchg_acc char(20)
--update m_sys set othchg_acc='05002012'
--select * from gl_m_acc where acc_nam like '%other%'
--select * from m_itm
--select * from m_itm where oacc_id in (select acc_id from gl_m_acc)
--update m_itm set oacc_id=(select acc_no from gl_m_acc where acc_id=oacc_id)
--update m_itm set cacc_id=(select acc_no from gl_m_acc where acc_id=cacc_id)
--update m_itm set pacc_id=(select acc_no from gl_m_acc where acc_id=pacc_id)
--update m_itm set sacc_id=(select acc_no from gl_m_acc where acc_id=sacc_id)
--update m_itm set aacc_id=(select acc_no from gl_m_acc where acc_id=aacc_id)
--update m_itm set wacc_id=(select acc_no from gl_m_acc where acc_id=wacc_id)
--update m_itm set woacc_id=(select acc_no from gl_m_acc where acc_id=woacc_id)
--update m_itm set wracc_id=(select acc_no from gl_m_acc where acc_id=wracc_id)
--update m_sys set conveyance_acc =(select acc_no from gl_m_acc where acC_id=conveyance_acc)
---alter table m_sys alter column conveyance_acc int
--update m_sys set design_acc =(select acc_no from gl_m_acc where acC_id=design_acc)
--alter table m_sys alter column design_acc int
--update m_sys set othchg_acc =(select acc_no from gl_m_acc where acC_id=othchg_acc)
--alter table m_sys alter column othchg_acc int
--update m_sys set conveyance_cash_acc =(select acc_no from gl_m_acc where acC_id=conveyance_cash_acc )
--alter table m_sys alter column conveyance_cash_acc int

--exec sp_voucher_pb '01','01','01',69,1,''
--SELECT * from t_mpb where mpb_id=5

--select * from gl_m_acc where acc_id='05007016'
--update m_sys set design_acc =1883

--select * from gl_m_acc where acc_id='02003005005'
--alter table m_sys add gsttax_acc int,fedtax_acc int,advtax_acc int,othtax_acc int
--update m_sys set gsttax_acc=1894,fedtax_acc=1895,advtax_acc=1896,othtax_acc=1897


--alter table t_mpb add mvch_taxno int

--Voucher for Purchase Bill
alter proc sp_voucher_pb (@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpb_id int,@usr_id int,@aud_ip varchar(250),@aud_des varchar(1000))
as
declare
@mpb_dat datetime,
@mpb_namt float,
@mpb_rmk varchar(250),
@itm_id int,
@itm_amt float,
@sup_id int,
@sup_nam varchar(250),
@acc_id int,
@row_id int,
@mvch_no int,
@nar varchar(1000),
@mpb_disamt float,
@mpb_desamt float,
@mpb_othamt float,
@mpb_rat float,
@mpb_fre float,
@cur_id int,
@mpb_con char(1),
@sup_bill varchar(100),
@dpb_freamt float,
@nar_sup varchar(100),
@mpb_can bit,
@mpb_gstamt float,
@mpb_fedamt float,
@mpb_advtax float,
@mpb_othtax float,
@mpb_cktax bit,
@mvch_taxno int,
@mpb_auth bit,
@mvch_app char(1)
begin
--Non -Taxable
--GL Voucher
		set @mpb_con=(select mpb_con from t_mpb where mpb_id=@mpb_id)
		set @row_id=0
		set @mpb_dat=(select mpb_dat from t_mpb where mpb_id=@mpb_id)
		set @mpb_namt=(select mpb_namt from t_mpb where mpb_id=@mpb_id)
		set @mpb_rmk=(select mpb_rmk from t_mpb where mpb_id=@mpb_id)
		set @sup_id=(select sup_id from t_mpb where mpb_id=@mpb_id)
		set @sup_nam=(select sup_nam from m_sup where sup_id=@sup_id)
		set @mvch_no=(select mvch_no from t_mpb where mpb_id=@mpb_id)
		set @mpb_disamt=(select mpb_disamt from t_mpb where mpb_id=@mpb_id)
		set @mpb_disamt=@mpb_disamt/(select count( distinct itm_id) from t_dpb inner join t_itm on t_dpb.titm_id=t_itm.titm_id where mpb_id=@mpb_id)
		set @mpb_rat=(select mpb_rat from t_mpb where mpb_id=@mpb_id)
		set @cur_id=(select cur_id from t_mpb where mpb_id=@mpb_id)
		set @mpb_fre=(select mpb_fre from t_mpb where mpb_id=@mpb_id)
		set @dpb_freamt=@mpb_fre/(select count( distinct itm_id) from t_dpb inner join t_itm on t_dpb.titm_id=t_itm.titm_id where mpb_id=@mpb_id)
		set @mpb_desamt=(select mpb_desamt from t_mpb where mpb_id=@mpb_id)
		set @mpb_othamt=(select mpb_othamt from t_mpb where mpb_id=@mpb_id)
		set @sup_bill=(select sup_bill from t_mpb where mpb_id=@mpb_id)
		set @mpb_can=(select mpb_can from t_mpb where mpb_id=@mpb_id)
		set @mpb_gstamt=(select mpb_gstamt from t_mpb where mpb_id=@mpb_id)
		set @mpb_fedamt=(select mpb_fedamt from t_mpb where mpb_id=@mpb_id)
		set @mpb_advtax=(select mpb_advtax from t_mpb where mpb_id=@mpb_id)
		set @mpb_othtax=(select mpb_othtax from t_mpb where mpb_id=@mpb_id)
		set @mpb_cktax=(select mpb_cktax from t_mpb where mpb_id=@mpb_id)
		set @mpb_auth =(select mpb_auth from t_mpb where mpb_id=@mpb_id)
		if (@mpb_auth =1)
			begin
				set @mvch_app='Y'
			end
		else 
			begin
				set @mvch_app='N'
			end
		if (@mvch_no is null)
			begin
				--Master Voucher
				exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpb_dat ,@mpb_dat ,'','01','05',@mvch_app,'C' ,@mpb_rmk,'S','',@mpb_dat,0,0,@cur_id,@mpb_rat,@mpb_can,0,'','','','','','',@mvch_no_out=@mvch_no output
				update t_mpb set mvch_no=@mvch_no where mpb_id=@mpb_id
			end
		else
			begin
				update t_mvch set mvch_ref=@mpb_rmk,mvch_rat=@mpb_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
				delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_no
			end
--Detail Voucher
		if (@sup_bill!='')
			begin
				set @sup_bill='Supplier Bill # '+@sup_bill
			end
		--if (@mpb_rmk!='')
		--	begin
		--		set @mpb_rmk='Remarks: '+@mpb_rmk
		--	end
					set @nar='Purcahse Bill # ' + cast(@mpb_id as char(100)) + ' Supplier Name : ' +@sup_nam + ' '+@sup_bill + ' '+ @mpb_rmk
--Debit Account Purchase

		declare mitm_cursor CURSOR for
		select itm_id,sum(dpb_namt-dpb_gstamt-dpb_fedamt)-@mpb_disamt as [Amount] from t_dpb inner join t_itm on t_dpb.titm_id=t_itm.titm_id  where mpb_id=@mpb_id	group by itm_id
--select * from t_dpb where mpb_id=5

				open mitm_cursor 
					fetch next  from mitm_cursor 
							into @itm_id,@itm_amt	

				while @@fetch_status =0

				begin
					--Debit Voucher				
					set @row_id=@row_id+1
					set @acc_id=(select case when pacc_id is null then cacc_id else pacc_id end from m_itm where itm_id=@itm_id)
					if (@mpb_con='-')
						begin
							set @itm_amt=@itm_amt-@dpb_freamt
						end
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@itm_amt,0


				fetch next  from mitm_cursor 
						into @itm_id,@itm_amt	
				end
				close mitm_cursor
				deallocate mitm_cursor	

	--Conveyance to Supplier
	if (@mpb_fre >0)
		begin
			if (@mpb_con='+')
				begin
					set @nar='Freight Charged by Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
						--Debit
									set @row_id=@row_id+1
									set @acc_id=(select conveyance_acc from m_sys)
									exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_fre,0
				end
		end
	
	--GST
	if (@mpb_gstamt>0)
		begin
			set @nar='GST Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
			set @row_id=@row_id+1
			set @acc_id=(select gsttax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_gstamt,0	
		end
	--FED
	if (@mpb_fedamt>0)
		begin
			set @nar='FED Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
			set @row_id=@row_id+1
			set @acc_id=(select fedtax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_fedamt,0	
		end			
	--Advance Tax
	if (@mpb_advtax>0)
		begin
			set @nar='Advance Tax Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
			set @row_id=@row_id+1
			set @acc_id=(select advtax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_advtax,0	
		end
	--Other Tax
	if (@mpb_othtax>0)
		begin
			set @nar='Other Tax Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
			set @row_id=@row_id+1
			set @acc_id=(select othtax_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_othtax,0	
		end
	--Design Charges
	if (@mpb_desamt>0)
		begin		
			set @nar='Design Charges Paid to Supplier : '+ @sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
			set @row_id=@row_id+1
			set @acc_id=(select design_acc from m_sys)
			exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_desamt,0
		end
	--Other Charges
		if (@mpb_othamt>0)
			begin		
				set @nar='Other Charges Paid to Supplier : '+ @sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
				set @row_id=@row_id+1
				set @acc_id=(select othchg_acc from m_sys)
				exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_othamt,0
			end

----Credit Account Supplier
	

					set @nar='Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
					set @row_id=@row_id+1
					set @acc_id=(select acc_no from m_sup where sup_id=@sup_id)
					exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,0,@mpb_namt


--Conveyance
	if (@mpb_fre >0)
		begin
			if (@mpb_con='-')
				begin
					set @nar='Paid for conveyance against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk	
						--Debit
									set @row_id=@row_id+1
									set @acc_id=(select conveyance_acc from m_sys)
									exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,@mpb_fre,0
						--Credit
									set @row_id=@row_id+1
									set @acc_id=(select conveyance_cash_acc  from m_sys)
									exec ins_t_dvch @com_id,@br_id,@mvch_no,@row_id,@acc_id,@nar,0,@mpb_fre
				end
		end
--Taxable
--GL Voucher
	if (@mpb_cktax =1)
		begin
				set @row_id=0
				set @mvch_taxno=(select mvch_taxno from t_mpb where mpb_id=@mpb_id)
				set @mpb_namt=(select mpb_taxnamt from t_mpb where mpb_id=@mpb_id)
				if (@mvch_taxno is null)
					begin
						--Master Voucher
						exec ins_t_mvch @com_id,@br_id,@m_yr_id,@mpb_dat ,@mpb_dat ,'','01','05',@mvch_app,'C' ,@mpb_rmk,'S','',@mpb_dat,0,0,@cur_id,@mpb_rat,@mpb_can,@mpb_cktax,'','','','','','',@mvch_no_out=@mvch_taxno output
						update t_mpb set mvch_taxno=@mvch_taxno where mpb_id=@mpb_id
					end
				else
					begin
						update t_mvch set mvch_ref=@mpb_rmk,mvch_rat=@mpb_rat,cur_id=@cur_id where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
						delete from t_dvch where com_id=@com_id and br_id=@br_id and mvch_no=@mvch_taxno
					end
		--Detail Voucher
				if (@sup_bill!='')
					begin
						set @sup_bill='Supplier Bill # '+@sup_bill
					end
				--if (@mpb_rmk!='')
				--	begin
				--		set @mpb_rmk='Remarks: '+@mpb_rmk
				--	end
							set @nar='Purcahse Bill # ' + cast(@mpb_id as char(100)) + ' Supplier Name : ' +@sup_nam + ' '+@sup_bill + ' '+ @mpb_rmk
		--Debit Account Purchase

				declare mitm_cursor CURSOR for
				select itm_id,sum(dpb_namt-dpb_gstamt-dpb_fedamt) as [Amount] from t_dpb inner join t_itm on t_dpb.titm_id=t_itm.titm_id  where mpb_id=@mpb_id and dpb_tax=1	group by itm_id
		--select * from t_dpb where mpb_id=5

						open mitm_cursor 
							fetch next  from mitm_cursor 
									into @itm_id,@itm_amt	

						while @@fetch_status =0

						begin
							--Debit Voucher				
							set @row_id=@row_id+1
							set @acc_id=(select case when pacc_id is null then cacc_id else pacc_id end from m_itm where itm_id=@itm_id)
							if (@mpb_con='-')
								begin
									set @itm_amt=@itm_amt-@dpb_freamt
								end
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@itm_amt,0


						fetch next  from mitm_cursor 
								into @itm_id,@itm_amt	
						end
						close mitm_cursor
						deallocate mitm_cursor	

			----Conveyance to Supplier
			--if (@mpb_fre >0)
			--	begin
			--		if (@mpb_con='+')
			--			begin
			--				set @nar='Freight Charged by Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
			--					--Debit
			--								set @row_id=@row_id+1
			--								set @acc_id=(select conveyance_acc from m_sys)
			--								exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_fre,0
			--			end
			--	end
			
			--GST
			if (@mpb_gstamt>0)
				begin
					set @nar='GST Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
					set @row_id=@row_id+1
					set @acc_id=(select gsttax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_gstamt,0	
				end
			--FED
			if (@mpb_fedamt>0)
				begin
					set @nar='FED Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
					set @row_id=@row_id+1
					set @acc_id=(select fedtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_fedamt,0	
				end			
			--Advance Tax
			if (@mpb_advtax>0)
				begin
					set @nar='Advance Tax Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
					set @row_id=@row_id+1
					set @acc_id=(select advtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_advtax,0	
				end
			--Other Tax
			if (@mpb_othtax>0)
				begin
					set @nar='Other Tax Supplier : '+@sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100))  + ' '+@sup_bill + ' '+ @mpb_rmk	
					set @row_id=@row_id+1
					set @acc_id=(select othtax_acc from m_sys)
					exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_othtax,0	
				end
			----Design Charges
			--if (@mpb_desamt>0)
			--	begin		
			--		set @nar='Design Charges Paid to Supplier : '+ @sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
			--		set @row_id=@row_id+1
			--		set @acc_id=(select design_acc from m_sys)
			--		exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_desamt,0
			--	end
			----Other Charges
			--	if (@mpb_othamt>0)
			--		begin		
			--			set @nar='Other Charges Paid to Supplier : '+ @sup_nam+' against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
			--			set @row_id=@row_id+1
			--			set @acc_id=(select othchg_acc from m_sys)
			--			exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_othamt,0
			--		end

		----Credit Account Supplier
			

							set @nar='Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk
							set @row_id=@row_id+1
							set @acc_id=(select acc_no from m_sup where sup_id=@sup_id)
							exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,0,@mpb_namt


		----Conveyance
		--	if (@mpb_fre >0)
		--		begin
		--			if (@mpb_con='-')
		--				begin
		--					set @nar='Paid for conveyance against Purchase Bill # ' + cast(@mpb_id as char(100)) + ' '+@sup_bill + ' '+ @mpb_rmk	
		--						--Debit
		--									set @row_id=@row_id+1
		--									set @acc_id=(select conveyance_acc from m_sys)
		--									exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,@mpb_fre,0
		--						--Credit
		--									set @row_id=@row_id+1
		--									set @acc_id=(select conveyance_cash_acc  from m_sys)
		--									exec ins_t_dvch @com_id,@br_id,@mvch_taxno,@row_id,@acc_id,@nar,0,@mpb_fre
		--				end
		--end
end

end		

