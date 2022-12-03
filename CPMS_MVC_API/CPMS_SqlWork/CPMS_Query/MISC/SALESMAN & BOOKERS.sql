USE PAGEY
GO

--select * from m_sup
delete from m_sal
delete from m_emppro 
delete from m_rosemp
--alter table m_rosemp drop constraint FK_MEMPOS_EMPPROID
--select * from m_emp_sub 
--select * from m_emppro 



--BOOKER
declare @emppro_macid int,@emppro_nam varchar(100),@memp_sub_id int,@dpt_id char(2),@emppro_doj datetime,
@com_id char(2),@br_id char(3),@m_yr_id char(3),@emppro_idold varchar(1000)
	declare  booker1  cursor for			
			SELECT salesmanID,salesmanname FROM primeagencies.dbo.salesman where booker=1 order by salesmanid
		OPEN booker1
			FETCH NEXT FROM booker1
			INTO @emppro_idold,@emppro_nam
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @m_yr_id ='01'
					set @memp_sub_id=(SELECT memp_sub_id from m_emp_sub where memp_sub_booker=1)
					set @dpt_id ='01'
					set @emppro_doj=GETDATE()
					set @emppro_macid =(select max(emppro_macid)+1 from m_emppro)
					if (@emppro_macid is null)
						begin
							set @emppro_macid=1
						end
					exec ins_m_emppro 1,@emppro_macid ,@emppro_nam ,'',@memp_sub_id ,'',@dpt_id ,@emppro_doj,'M',
					'M',@emppro_doj, '','','','','','','','',
					@emppro_doj,@emppro_doj,'','','',
					@emppro_doj,'',0,'C','',0,0,0,0,@emppro_doj,'',
					0,0,0,0,0,0,0,0,0,0,0,0,@emppro_doj,'',1,0,1,1,'U','P',@com_id ,@br_id ,@m_yr_id ,@emppro_idold ,
					'','','','', @emppro_doj,0,0,''
							
					FETCH NEXT FROM booker1
					INTO @emppro_idold,@emppro_nam
		end
		CLOSE booker1
		DEALLOCATE booker1
		GO
--BOOKER
declare @emppro_macid int,@emppro_nam varchar(100),@memp_sub_id int,@dpt_id char(2),@emppro_doj datetime,
@com_id char(2),@br_id char(3),@m_yr_id char(3),@emppro_idold varchar(1000)
	declare  salesman1  cursor for			
			SELECT salesmanID,salesmanname FROM primeagencies.dbo.salesman where booker=0 order by salesmanid
		OPEN salesman1
			FETCH NEXT FROM salesman1
			INTO @emppro_idold,@emppro_nam
				WHILE @@FETCH_STATUS = 0
				BEGIN
					set @com_id='01'
					set @br_id='01'
					set @m_yr_id ='01'
					set @memp_sub_id=(SELECT memp_sub_id from m_emp_sub where memp_sub_salman=1)
					set @dpt_id ='01'
					set @emppro_doj=GETDATE()
					set @emppro_macid =(select max(emppro_macid)+1 from m_emppro)
					if (@emppro_macid is null)
						begin
							set @emppro_macid=1
						end
					exec ins_m_emppro 1,@emppro_macid ,@emppro_nam ,'',@memp_sub_id ,'',@dpt_id ,@emppro_doj,'M',
					'M',@emppro_doj, '','','','','','','','',
					@emppro_doj,@emppro_doj,'','','',
					@emppro_doj,'',0,'C','',0,0,0,0,@emppro_doj,'',
					0,0,0,0,0,0,0,0,0,0,0,0,@emppro_doj,'',1,0,1,1,'U','P',@com_id ,@br_id ,@m_yr_id ,@emppro_idold ,
					'','','','', @emppro_doj,0,0,''
							
					FETCH NEXT FROM salesman1
					INTO @emppro_idold,@emppro_nam
		end
		CLOSE salesman1
		DEALLOCATE salesman1
		GO
