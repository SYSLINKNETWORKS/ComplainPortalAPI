USE PAGEY
GO

--select* from gl_m_acc


--delete from gl_m_acc where acc_id in ('14','15')
--delete from gl_m_acc where acc_cid in ('04002007','05003005004','05002012','05002012004','05003005','05003017','05002015','05005001','04002','03002002009003','03002002009002','03002002009001','03002002007001','03002002002','02001','03001002','03001001','02003003','01003','01001')

--delete from gl_m_acc where acc_id='02002001'

----Capital
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5)='01010'
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(select acc_no from gl_m_acc where acc_id='01001')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam


--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----P & L
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('01030','0102') order by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='01003')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Fixed ASSET
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('20010') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03001001')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO


----OTHER PAYABLE
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20),@acc_glcode varchar(1000)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('15010','15020','15030') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='02003003')
--					set @acc_glcode=(select acc_oid from gl_m_acc where acc_oid=@acc_oid)
--					if (@acc_glcode is null)
--						begin
--							EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
--						end		
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Receivable Account MISC
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20),@acc_glcode varchar(1000)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25070') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002009001')
--					set @acc_glcode=(select acc_oid from gl_m_acc where acc_oid=@acc_oid)
--					if (@acc_glcode is null)
--						begin
--							EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
--						end					
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Fixed ASSET Depricaition
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('20020') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03001002')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----LONG TERM LIABILIATIES
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25020') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='02001')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----ADVANCE to staff
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25030') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002002')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Security Deposit
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25050') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002007001')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO


----Receivable Account OTHERS
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25080') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002009002')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Receivable Account OTHERS 2
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25090') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002009003')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO
--select * from gl_m_acc where acc_cid='03002002009003'
--delete from gl_m_acc where acc_cid='03002002009003'

----CASH
--UPDATE gl_m_acc set acc_oid='25110001' where acc_id='03002003002005'

----Other Income
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('35010') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='04002')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Purchase Others
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('41010','40010') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05005001')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam
--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Administrative Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45010') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05002015')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Marketing Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45020') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05003017')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO
----Sales Promotional Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45030') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05003005')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO
----Sales Tax Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45040') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05002012004')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam
--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO
----Other Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45060','45070') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05002')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO
----Company Wise Exp.
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('45080','45090','45100','45120','45140','45180','45250','45290') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='05003005004')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Other Product Sales
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('30010','46010') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='04002007')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO


----Customer GL OLD ACCOUNT
--declare @acc_no int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select glcode,acc_no from primeagencies.dbo.customer inner join m_cus on customer.customerid=m_cus.cus_idold 
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_no
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					update gl_m_acc set acc_oid =@acc_oid where acc_no=@acc_no
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_no

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Supplier GL OLD ACCOUNT
--declare @acc_no int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select glcode,acc_no from primeagencies.dbo.supplier inner join m_sup on supplier.supplierid=m_sup.sup_idold 
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_no
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					update gl_m_acc set acc_oid =@acc_oid where acc_no=@acc_no
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_no

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Bank
--declare @com_id char(2),@br_id char(3),@cur_id int,@bk_nam char(50),@bk_acc varchar(50),@bk_idold varchar(1000)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25100') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @bk_idold,@bk_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					SET @com_id ='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @bk_acc='0'
					
--					exec ins_m_bk @com_id ,@br_id ,@cur_id ,@bk_nam ,'','','','','','',@bk_acc,0,0,1,'01','U',@bk_idold ,'','','','',''
					
							
--					FETCH NEXT FROM account1
--					INTO @bk_idold,@bk_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO


--Finish Goods Opening / Closing Inventory
--update gl_m_acc set acc_oid='25010001' where acc_id='03002004001'
--update gl_m_acc set acc_oid='25010002' where acc_id='03002005001'


----Advance Income Tax
--declare @com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20)
--	declare  account1  cursor for			
--		select GLCODE,CODENAME from primeagencies.dbo.glcode where left(glcode,5) in ('25040') ORDER by glcode
--		OPEN account1
--			FETCH NEXT FROM account1
--			INTO @acc_oid,@acc_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
--					set @acc_cno=(SELECT acc_no from gl_m_acc where acc_id='03002002006')
--					EXEC ins_m_acc @com_id ,@br_id ,@cur_id ,@acc_nam ,@acc_cno ,@acc_oid ,'U',1,'','','','','',''
							
--					FETCH NEXT FROM account1
--					INTO @acc_oid,@acc_nam

--		end
--		CLOSE account1
--		DEALLOCATE account1
--		GO

----Customer not in Customer Table but in GL TABLE 
--declare @com_id char(2),@br_id char(3),@cus_creday float,@cus_amtltd float,@cus_st char(1),@cus_nam varchar(100),@cur_id int,@cus_cp varchar(100),@cus_add varchar(250),@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_app bit,@cuscat_id int,@cussubcat_id int ,@zone_id int,@cus_idold varchar(1000)
--	declare  cusplier1  cursor for			
--			SELECT GLCODE,CODENAME FROM primeagencies.dbo.glcode where  left(glcode,5) in ('25070','25071') and glcode not in (select glcode from primeagencies.dbo.customer) ORDER by glcode
--		OPEN cusplier1
--			FETCH NEXT FROM cusplier1
--			INTO @cus_idold,@cus_nam
--				WHILE @@FETCH_STATUS = 0
--				BEGIN
--					set @com_id='01'
--					set @br_id='01'
--					set @cuscat_id=1
--					SET @cussubcat_id=1
--					set @cus_amtltd=0
--					set @cus_cp=' '
--					set @cus_eml=' '
--					set @cus_web=' '
--					set @cus_ntn=' '
--					set @cus_stn=' '
--					set @cus_mob=' '
--					set @zone_id=1
--					set @cus_cnic=' '
--					SET @cus_add=' '
--					set @cus_pho=' '
--					set @cus_fax=' '
--					set @cus_creday=0
--					set @cur_id=(select cur_id from m_cur where cur_typ='S')
					
--					exec ins_m_cus @com_id ,@br_id,@cus_creday ,@cus_amtltd ,@cus_st ,@cus_nam ,@cur_id ,@cus_cp ,@cus_add ,@cus_cnic ,@cus_pho ,@cus_mob ,@cus_fax,@cus_eml,@cus_web,@cus_ntn ,@cus_stn ,1,1,@cuscat_id ,@cussubcat_id  ,@zone_id ,'U',0,0,0,0,0,0,0,0,0,'',0,'',@cus_idold,'','','','',''
							
--					FETCH NEXT FROM cusplier1
--					INTO @cus_idold,@cus_nam
--		end
--		CLOSE cusplier1
--		DEALLOCATE cusplier1
--		GO

--select * from m_cus
--select * from gl_m_acc where acc_id='03002003002005'
--select * from gl_m_acc where acc_cid='03001001'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
--delete from gl_m_acc where acc_id in ('08','09','11','13')
--select * from gl_m_acc where acc_id in ('08','09','11','13')

