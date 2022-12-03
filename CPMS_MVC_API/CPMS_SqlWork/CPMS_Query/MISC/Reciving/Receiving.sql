USE PAGEY
GO

delete from t_dvch where mvch_no in (select mvch_no from t_mrec)
delete from t_mvch where mvch_no in (select mvch_no from t_mrec)
delete from t_drec
delete from t_mrec



declare @com_id char(2),@br_id char(3),@m_yr_id char(2),@mrec_dat datetime,@mrec_amt float,@mrec_cb char(1),@mrec_chq int,@mrec_chqdat datetime,@cus_id int,@cur_id int,@acc_id char(20),@mrec_id int,
@mrec_idold varchar(1000),@cus_idold varchar(1000),@minv_id int,@row_id int,@mso_idold varchar(1000)
	declare  receiving1  cursor for			
		select receiptno,receiptdate,customerid,amount,chequeno,chequedate,dsrno from primeagencies.dbo.CashDetail  --where DSRNo='M00094'
		OPEN receiving1
			FETCH NEXT FROM receiving1
			INTO @mrec_idold,@mrec_dat,@cus_idold,@mrec_amt,@mrec_chq,@mrec_chqdat,@mso_idold
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					SET @br_id='01'
					set @m_yr_id ='02'
					set @cur_id=(select cur_id from m_cur where cur_typ='S')
					set @cus_id=(select cus_id from m_cus where cus_idold=@cus_idold)
					set @minv_id =(select distinct minv_id from t_dinv inner join t_mdc on t_dinv.mdc_id=t_mdc.mdc_id inner join t_mso on t_mdc.mso_id=t_mso.mso_id where mso_idold=@mso_idold AND cus_id=@Cus_id)
					set @row_id=1					
					if (@mrec_chqdat is null)
						begin
							set @mrec_cb='C'
							set @acc_id='03002003002005'
						end
					else 
						begin
							set @mrec_cb ='B'
						end
					exec sp_ins_mrec  @com_id ,@br_id ,@m_yr_id ,@mrec_dat ,0,0,@mrec_amt ,0,0,@mrec_amt,0,@mrec_cb ,null,@mrec_chq ,@mrec_chqdat ,'',1,@cus_id ,@cur_id ,@acc_id ,0,@mrec_idold,'','','','','','',@mrec_id_out =@mrec_id  output
					exec sp_ins_drec 0,@mrec_amt ,0,0,0,0,@mrec_amt ,0,0,@minv_id ,@mrec_id ,@row_id 
--print @Cus_id
--print @minv_id
					FETCH NEXT FROM receiving1
					INTO @mrec_idold,@mrec_dat,@cus_idold,@mrec_amt,@mrec_chq,@mrec_chqdat,@mso_idold

		end
		CLOSE receiving1
		DEALLOCATE receiving1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
