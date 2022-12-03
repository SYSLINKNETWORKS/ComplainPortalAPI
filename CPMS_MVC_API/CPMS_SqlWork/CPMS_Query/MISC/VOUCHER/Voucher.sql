USE PAGEY
GO

delete from t_dvch where mvch_no in(select mvch_no from t_mvch where mvch_typ='U')
DELETE from t_mvch where mvch_typ='U'
--select * from t_mvch where mvch_typ='U'

--select * from t_mvch where  typ_id='01' and mvch_typ='U'


--select * from t_mvch where mvch_TYP='u'
--select * from t_dvch where acc_no is null
--select * from t_mvch where mvch_no=8
--			select VoucherNo,VoucherDate,VoucherType,ChequeNo,ChequeDate,glcode from primeagencies.dbo.TransactionDetail where VoucherType not in ('SB','PB','OB') 
--			and voucherno in ('M00005') and vouchertype='BB'
----			and voucherdate between '07/01/2013' and '07/31/2013'

--SELECT * from gl_m_acc where acc_oid in('15010002')
--select * from primeagencies.dbo.glcode where glcode=25070061
--select * from t_itm

declare @com_id char(2),@br_id char(3),@yr_id char(2),@mvch_dat datetime,@mvch_pto varchar(20),@dpt_id char(2),@typ_id varchar(2),
@mvch_cb char(1),@mvch_ref varchar(100),@mvch_chq float,@mvch_chqdat datetime,@cur_id int,@mvch_oldvoucherno char(12),@vouchertype char(2),
@mvch_no int,
@dvch_dr_famt float,@dvch_cr_famt float,@dvch_nar varchar(1000),@acc_oldid varchar(1000),@dvch_row int,@acc_no int
	declare  voucher1  cursor for			
			select VoucherNo,VoucherDate,VoucherType,ChequeNo,ChequeDate from primeagencies.dbo.TransactionDetail where VoucherType not in ('SB','PB','OB') 
--			and voucherno in ('M00006')
--			and voucherdate between '07/01/2013' and '07/01/2013'
 			group by VoucherNo,VoucherDate,VoucherType,ChequeNo,ChequeDate
		OPEN voucher1
			FETCH NEXT FROM voucher1
			INTO @mvch_oldvoucherno,@mvch_dat,@vouchertype,@mvch_chq,@mvch_chqdat
				WHILE @@FETCH_STATUS = 0
				BEGIN
				set @com_id='01'
				set @br_id='01'
				set @yr_id ='01'
				set @cur_id=(select cur_id from m_cur where cur_typ='S')
				set @dpt_id='01'
				if (@vouchertype='JV')	
					begin
						set @typ_id='05'
						set @mvch_cb='C'
						set @mvch_chqdat=@mvch_dat
					end
				if (@vouchertype='BB')	
					begin
						set @typ_id='04'
						set @mvch_cb='B'
					end
				if (@vouchertype='CP')	
					begin
						set @typ_id='02'
						set @mvch_cb='C'
						set @mvch_chqdat=@mvch_dat
					end
				if (@vouchertype='CR')	
					begin
						set @typ_id='01'
						set @mvch_cb='C'
						set @mvch_chqdat=@mvch_dat
					end
				if (@vouchertype='CB')	
					begin
						set @typ_id='03'
						set @mvch_cb='B'
						set @mvch_chqdat=@mvch_dat
					end
				set @mvch_ref=''
				set @mvch_pto=''
				set @dvch_row=0
					exec [ins_t_mvch] @com_id ,@br_id ,@yr_id ,@mvch_dat ,@mvch_dat ,@mvch_pto ,@dpt_id ,@typ_id ,'Y',@mvch_cb ,@mvch_ref ,'U',@mvch_chq ,@mvch_chqdat ,0 ,0,@cur_id ,1,0,0,'','','','',@mvch_oldvoucherno ,'',@mvch_no_out =@mvch_no output
						--Voucher Detai Opening
							declare  vchdetail  cursor for			
									SELECT GLCODE,debit,Credit,[description] FROM primeagencies.dbo.transactiondetail where voucherno=@mvch_oldvoucherno and vouchertype=@vouchertype
								OPEN vchdetail
									FETCH NEXT FROM vchdetail
									INTO @acc_oldid,@dvch_dr_famt,@dvch_cr_famt,@dvch_nar
										WHILE @@FETCH_STATUS = 0
										BEGIN
											set @dvch_row=@dvch_row+1
											print @acc_oldid
											set @acc_no=(select acc_no from gl_m_acc where acc_oid=@acc_oldid)
											exec ins_t_dvch @com_id ,@br_id ,@mvch_no ,@dvch_row ,@acc_no ,@dvch_nar ,@dvch_dr_famt ,@dvch_cr_famt 
													
											FETCH NEXT FROM vchdetail
											INTO @acc_oldid,@dvch_dr_famt,@dvch_cr_famt,@dvch_nar

								end
								CLOSE vchdetail
								DEALLOCATE vchdetail
						--Voucher Detail End					
					
					FETCH NEXT FROM voucher1
					INTO @mvch_oldvoucherno,@mvch_dat,@vouchertype,@mvch_chq,@mvch_chqdat

		end
		CLOSE voucher1
		DEALLOCATE voucher1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
--select * from t_mvch where typ_id='04'
--select acc_id,gl_m_acc.acc_no,acc_des,dvch_nar,dvch_cr_famt from t_mvch inner join t_dvch on t_mvch.com_id=t_dvch.com_id and t_mvch.br_id=t_dvch.br_id and t_mvch.mvch_no=t_dvch.mvch_no left join m_dpt on t_mvch.dpt_id=m_dpt.dpt_id inner join gl_m_acc on t_dvch.com_id=gl_m_acc.com_id and t_dvch.acc_no=gl_m_acc.acc_no where t_mvch.typ_id='03' and t_mvch.mvch_id='001-20130702' and t_mvch.mvch_dt='1/1/1900 12:00:00 AM' order by dvch_row

