USE PAGEY
GO

		delete from t_dgrn
		delete from t_mgrn
		delete from t_dpo
		delete from t_mpo
		delete from t_dpr
		delete from t_mpr
		delete from m_lot
		delete from m_stk where stk_frm='GRN'
		



declare  @com_id char(2),@br_id char(3),@m_yr_id char(2),@pur_dat datetime,
		 @pur_amt float,@sup_id int,
		 @sup_dcdat datetime,@pur_idold varchar(1000),@pur_id int ,@sup_idold varchar(1000)	
		 
		 ,@dpur_qty float,@dpur_mandat bit,@dpur_man datetime,@ck_dat bit,@dpur_exp datetime
		 ,@titm_id int,@itmqty_id int,@sca_id int,@dpur_rat float,@dpur_amt float,@dpur_rmk varchar(250),
		 @titm_img bit,@dpur_acc float,@dpur_nqty float,@titm_idold varchar(1000) 
		 
	--MASTER
	declare  purchase1  cursor for			
			SELECT billno,billdate,supplierid,totalamount FROM primeagencies.dbo.purchasemaster --where billdate between '07/01/2013' and '07/31/2013'
		OPEN purchase1
			FETCH NEXT FROM purchase1
			INTO @pur_idold,@pur_dat,@sup_idold,@pur_amt
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @m_yr_id='01'
					set @sup_id=(select sup_id from m_sup where sup_idold=@sup_idold)
					print @pur_idold
				
				    exec ins_t_mpur @com_id,@br_id,@m_yr_id,@pur_dat,'U','01','',1,1,@pur_amt,'',@sup_id,2,0,1,'',@pur_dat,@pur_idold,1,'','','','','',@pur_id_out=@pur_id output 
							--Detail
							
							declare  purdetail  cursor for			
									SELECT itemid,costrate,quantity,amount FROM primeagencies.dbo.purchasedetail where billno=@pur_idold
								OPEN purdetail
									FETCH NEXT FROM purdetail
									INTO @titm_idold,@dpur_rat,@dpur_qty,@dpur_amt 
										WHILE @@FETCH_STATUS = 0
										BEGIN	
												
										set @titm_id=(select titm_id from t_itm where titm_idold=@titm_idold)	
																  
											exec ins_t_dpur @pur_id,1,@dpur_qty,0,@dpur_man,0,@dpur_exp,
															@titm_id ,1,1 ,@dpur_rat,@dpur_amt,'' ,@m_yr_id ,
															0 ,0,@dpur_qty 


											FETCH NEXT FROM purdetail
											INTO @titm_idold,@dpur_rat,@dpur_qty,@dpur_amt

								end
								CLOSE purdetail
								DEALLOCATE purdetail
								--Detail


					FETCH NEXT FROM purchase1
					INTO @pur_idold,@pur_dat,@sup_idold,@pur_amt

		end
		CLOSE purchase1
		DEALLOCATE purchase1
		GO
	--MASTER	
		--SELECT * FROM primeagencies.dbo.purchasedetail 
	
		--select * from t_mpr
		--select * from t_dpr
		--select * from t_mpo
		--select * from t_dpo
		--select * from t_mgrn
		--select * from t_dgrn
		--select * from m_cur
--select * from t_itm