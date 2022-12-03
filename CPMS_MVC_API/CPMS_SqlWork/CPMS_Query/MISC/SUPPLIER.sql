USE PAGEY
GO

--select * from m_sup
delete from gl_m_acc where acc_no in (select acc_no from m_sup)
delete from m_sup


declare @com_id char(2),@br_id char(3),@sup_creday float,@sup_amtltd float,@sup_nam varchar(100),@cur_id int,@sup_cp varchar(100),@sup_add varchar(250),@sup_pho varchar(100),@sup_mob varchar(100),@sup_fax varchar(100),@sup_eml varchar(100),@sup_web varchar(100),@sup_ntn varchar(100),@sup_stn varchar(100),@sup_act bit,@sup_app bit,@sup_typ char(1),@supcat_id int,@sup_idold varchar(1000)
	declare  supplier1  cursor for			
			SELECT supplierid,suppliername,address,phoneno,faxno,creditperiod FROM primeagencies.dbo.supplier
		OPEN supplier1
			FETCH NEXT FROM supplier1
			INTO @sup_idold,@sup_nam,@sup_add,@sup_pho,@sup_fax,@sup_creday
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @supcat_id=5
					set @sup_amtltd=0
					set @sup_cp=' '
					set @sup_eml=' '
					set @sup_web=' '
					set @sup_ntn=' '
					set @sup_stn=' '
					set @sup_mob=' '
					set @cur_id=(select cur_id from m_cur where cur_typ='S')
							exec ins_m_sup @com_id ,@br_id ,@sup_creday ,@sup_amtltd ,@sup_nam ,@cur_id ,@sup_cp ,@sup_add ,@sup_pho ,@sup_mob,@sup_fax,@sup_eml,@sup_web ,@sup_ntn ,@sup_stn ,1,1,'U',@supcat_id,@sup_idold ,'','','','',''
							
					FETCH NEXT FROM supplier1
					INTO @sup_idold,@sup_nam,@sup_add,@sup_pho,@sup_fax,@sup_creday
		end
		CLOSE supplier1
		DEALLOCATE supplier1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
