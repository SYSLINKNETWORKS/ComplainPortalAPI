USE PAGEY
GO

--delete from m_cuscat
--delete from m_cussubcat
--DELETE from m_zone
 
 

--select * from m_cus
delete from gl_m_acc where acc_no in (select acc_no from m_cus)
delete from m_cus


declare @com_id char(2),@br_id char(3),@cus_creday float,@cus_amtltd float,@cus_st char(1),@cus_nam varchar(100),@cur_id int,@cus_cp varchar(100),@cus_add varchar(250),@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_app bit,@cuscat_id int,@cussubcat_id int ,@zone_id int,@cus_idold varchar(1000)
	declare  cusplier1  cursor for			
			SELECT customerid,customername,address,phoneno,faxno,creditperiod FROM primeagencies.dbo.customer ORDER by customername
		OPEN cusplier1
			FETCH NEXT FROM cusplier1
			INTO @cus_idold,@cus_nam,@cus_add,@cus_pho,@cus_fax,@cus_creday
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @cuscat_id=1
					SET @cussubcat_id=1
					set @cus_amtltd=0
					set @cus_cp=' '
					set @cus_eml=' '
					set @cus_web=' '
					set @cus_ntn=' '
					set @cus_stn=' '
					set @cus_mob=' '
					set @zone_id=1
					set @cus_cnic=' '
					set @cur_id=(select cur_id from m_cur where cur_typ='S')
					
					exec ins_m_cus @com_id ,@br_id,@cus_creday ,@cus_amtltd ,@cus_st ,@cus_nam ,@cur_id ,@cus_cp ,@cus_add ,@cus_cnic ,@cus_pho ,@cus_mob ,@cus_fax,@cus_eml,@cus_web,@cus_ntn ,@cus_stn ,1,1,@cuscat_id ,@cussubcat_id  ,@zone_id ,'U',0,0,0,0,0,0,0,0,0,'',0,'',@cus_idold,'','','','',''
							
					FETCH NEXT FROM cusplier1
					INTO @cus_idold,@cus_nam,@cus_add,@cus_pho,@cus_fax,@cus_creday
		end
		CLOSE cusplier1
		DEALLOCATE cusplier1
		GO
--select * from gl_m_acc where acc_id='0302007'
--SELECT * from gl_m_acc where acc_no=(select acc_no from m_cus where cus_id=1)
--update gl_m_acc set acc_cid='00' where acc_no=598
