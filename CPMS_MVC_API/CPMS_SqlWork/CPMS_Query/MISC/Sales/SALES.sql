USE PAGEY
GO



delete from t_dvch where mvch_no in (select mvch_no from t_minv)
delete from t_mvch where mvch_no in (select mvch_no from t_minv)
delete from t_dinv
delete from t_dinv_dc
delete from t_minv
delete from t_ddc
delete from t_mdc
delete from t_dso 
delete from t_mso
delete from t_msodsr
delete from m_stk where stk_frm='DC'


declare @com_id char(2),@br_id char(3),@m_yr_id char(2),
@mso_id int,@mso_dat datetime,@mso_rmk varchar(250),
@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@emppro_macid int,@cus_id int,@mso_idold varchar(1000),
@msodsr_id int,@bookerid varchar(100),@emppro_bokid int,@emppro_salmanid int,@emppro_salid int,@wh_id int,@salmanid varchar(1000),
@cus_idold varchar(1000),
@dso_stdsiz int,@dso_qty float,@dso_rat float,@dso_amt float,@dso_disper float,@dso_disamt float,@dso_othamt float,@dso_namt float,@titm_idold varchar(1000),@titm_id int,@itmqty_id int,@sca_id int,
@mdc_id int,@lot_id int,
@cur_id int,@minv_id int,@row_id int
	declare  DSR1  cursor for			
		SELECT distinct DSRNO FROM primeagencies.dbo.salesmaster --where dsrno='M00094'
		OPEN DSR1
			FETCH NEXT FROM DSR1
			INTO @mso_idold
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @m_yr_id='01'
					exec ins_t_msodsr @com_id ,@br_id ,@m_yr_id ,1 ,0,'U',@mso_idold,'','','','','',@msodsr_id_out=@msodsr_id output
							---MASTER SO
								declare  SO1  cursor for			
										SELECT  invoicedate,Customerid,BookerId,Salesmanid from primeagencies.dbo.salesmaster where dsrno=@mso_idold
									OPEN SO1
										FETCH NEXT FROM SO1
										INTO @mso_dat,@cus_idold,@bookerid,@salmanid
											WHILE @@FETCH_STATUS = 0
											BEGIN
												set @emppro_bokid=(select emppro_macid from m_emppro where emppro_idold=@bookerid)
												set @emppro_salid=(select emppro_macid from m_emppro where emppro_idold=@salmanid)
												set @mso_rmk=''
												set @mso_amt=(SELECT  sum(Amount) from primeagencies.dbo.SalesDetail where dsrno=@mso_idold and customerid=@cus_idold)
												set @mso_disper =0
												set @mso_disamt =0
												set @mso_othamt=0
												set @mso_freamt=0
												set @mso_namt =@mso_amt
												set @cus_id=(select cus_id from m_cus where cus_idold=@cus_idold)
												set @wh_id =1
												set @cur_id=(select cur_id from m_cur where cur_typ='S')
												print @msodsr_id		

												--SO	
												exec ins_t_mso @com_id ,@br_id ,@m_yr_id ,0,@mso_dat ,'',@mso_dat,@mso_dat,@mso_rmk ,@mso_amt ,@mso_disper ,@mso_disamt ,@mso_freamt ,@mso_othamt ,@mso_namt ,1,1,0,0,'','','','U',@emppro_bokid ,@cus_id ,@msodsr_id,@mso_idold,'','','','' ,'',@mso_id_out =@mso_id output							
												--DC
												exec ins_t_mdc @com_id ,@br_id ,@m_yr_id ,@mso_dat ,@mso_dat,'','','U',1,@mso_id,@wh_id,'',0,'','','',@emppro_salid,'','','','','', @mdc_id_out =@mdc_id output
												--Invoice
												exec ins_t_minv @com_id ,@br_id ,@m_yr_id ,@mso_dat ,@mso_dat ,'U',@mdc_id,1,@cur_id ,@cus_id ,'',0,0,0,0,0,@mso_amt,0,0,0,@mso_amt,0,'','','','','','',@minv_id_out =@minv_id output
												--Invoice with DC
												exec ins_t_dinv_dc @minv_id ,@mdc_id 
												---DETAIL SO
													declare  DSO1  cursor for			
															SELECT  itemid,Quantity,Rate,Amount from primeagencies.dbo.SalesDetail where dsrno=@mso_idold and customerid=@cus_idold
														OPEN DSO1
															FETCH NEXT FROM DSO1
															INTO @titm_idold,@dso_qty,@dso_rat,@dso_amt
																WHILE @@FETCH_STATUS = 0
																BEGIN
																print @mso_idold
																	set @dso_stdsiz =0
																	set @itmqty_id=1
																	set @sca_id=1
																	set @dso_namt=@mso_amt
																	set @dso_disper=0
																	set @dso_disamt=0
																	set @dso_othamt=0
																	set @lot_id =-1
																	set @titm_id=(select titm_id from t_itm where titm_idold=@titm_idold)
																	set @row_id=1

																		--SO Detail
																		exec ins_t_dso @dso_stdsiz ,@dso_qty ,@dso_rat ,@dso_amt ,@dso_disper ,@dso_disamt ,@dso_othamt ,@dso_namt ,@titm_id ,@itmqty_id,@mso_id,@sca_id,1							
																		--DC Detail
																		exec ins_t_ddc @dso_qty,0,@titm_id ,@itmqty_id ,@mdc_id ,@sca_id ,@lot_id 
																		--Invoice Detail
																		EXEC ins_t_dinv 0,@dso_qty ,0,@dso_rat ,0,@dso_amt,0,0,0,0,0,0,0,0,0,@dso_amt ,0,@minv_id,@titm_id ,@itmqty_id ,@sca_id ,0,@row_id,@mdc_id 
																	
																	FETCH NEXT FROM DSO1
																	INTO @titm_idold,@dso_qty,@dso_rat,@dso_amt
		
														end
														CLOSE DSO1
														DEALLOCATE DSO1
												---DETAIL SO
												
												FETCH NEXT FROM SO1
											INTO @mso_dat,@cus_idold,@BookerId,@salmanid 

									end
									CLOSE SO1
									DEALLOCATE SO1
								---MASTER SO
					FETCH NEXT FROM DSR1
					INTO @mso_idold

		end
		CLOSE DSR1
		DEALLOCATE DSR1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
