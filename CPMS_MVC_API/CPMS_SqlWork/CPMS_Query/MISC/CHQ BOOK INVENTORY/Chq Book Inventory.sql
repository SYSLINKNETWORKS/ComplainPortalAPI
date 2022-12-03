USE PAGEY
GO

delete from gl_bk_chq



declare @com_id char(2),@br_id char(2),@bk_id char(2),@chq_str_no int,@chq_lev_no int,@chq_no char(100),@chq_lev int,
@bk_idold varchar(1000)
	declare  brand1  cursor for			
			select DISTINCT GLCODE,ChequeNo from primeagencies.dbo.TransactionDetail inner join gl_m_bk on transactiondetail.glcode=gl_m_bk.bk_idold where VoucherType in ('BB') and voucherdate between '07/01/2013' and '07/31/2013' --and voucherno='M00006' 
		OPEN brand1
			FETCH NEXT FROM brand1
			INTO @bk_idold,@chq_no
				WHILE @@FETCH_STATUS = 0
				BEGIN	
					SET @com_id='01'
					set @br_id='01'
					set @bk_id =(select bk_id from gl_m_bk where bk_idold=@bk_idold)
					set @chq_lev_no=1
					set @chq_lev=1
					
					exec ins_chq @com_id ,@br_id ,@bk_id ,@chq_no ,@chq_lev_no ,@chq_no ,@chq_lev ,' ','U'							
					FETCH NEXT FROM brand1
					INTO @bk_idold,@chq_no

		end
		CLOSE brand1
		DEALLOCATE brand1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
