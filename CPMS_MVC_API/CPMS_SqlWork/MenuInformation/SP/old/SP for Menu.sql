USE zsons
GO

--alter table m_men add men_qry varchar(1000)

---Insert
alter proc [dbo].[ins_m_men](@men_nam varchar(100),@men_qry varchar(1000),@module_id int,@men_ali varchar(100),@men_arc varchar(100),@men_act bit,@men_typ char(1),@mensubcat_id int,@men_id_out int output)
as
declare
@com_id char(2),@per_view char(1),@per_new char(1),@per_upd char(1),@per_del char(1),@per_print char(1),
@usrgp_id int,
@br_id char(3),
@usr_id int,
@men_id int
begin
	set @com_id ='01'
	set @br_id='01'
	set @men_id=(select max(men_id)+1 from m_men)
		if @men_id is null
			begin
				set @men_id=1
			end
			
							
			if (@men_qry='0')
			begin
				set @men_qry=null
			end			
			
	insert into m_men(men_id,men_nam,men_qry,men_ali,men_arc,men_act,men_typ,mensubcat_id,module_id )
			values(@men_id,@men_nam,@men_qry,@men_ali,@men_arc,@men_act,@men_typ,@mensubcat_id,@module_id)
		set @men_id_out=@men_id
		declare  gpper  cursor for
			select usrgp_id from m_usrgp where usrgp_typ<>'U'
		
		OPEN gpper
		FETCH NEXT FROM gpper
				INTO @usrgp_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_m_gpper @com_id,@br_id,1,1,1, 1,1,1,@men_id,@usrgp_id ,'','','',''
				FETCH NEXT FROM gpper
				INTO @usrgp_id

	end
	CLOSE gpper
	DEALLOCATE gpper

--declare  usrper  cursor for
--		select distinct new_usr.usr_id from new_usr inner join m_dusr on new_usr.usr_id =m_dusr.usr_id inner join m_usrgp on m_dusr.usrgp_id=m_usrgp.usrgp_id where usrgp_typ<>'U'
		
--		OPEN usrper
--		FETCH NEXT FROM usrper
--				INTO @usr_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				exec [ins_m_per] @com_id ,@br_id ,1 ,1 ,1 , 1 ,1 ,@men_id ,@usr_id ,'','','',''
--				FETCH NEXT FROM usrper
--				INTO @usr_id
--	end
--	CLOSE usrper
--	DEALLOCATE usrper

end

GO

--Update
alter proc [dbo].[upd_m_men](@men_id int,@men_nam varchar(100),@men_qry varchar(1000),@module_id int,@men_ali varchar(100),@men_arc varchar(100),@men_act bit,@men_typ char(1),@mensubcat_id int)
as
declare
@com_id char(2),@per_view char(1),@per_new char(1),@per_upd char(1),@per_del char(1),@per_print char(1),
@usrgp_id int,
@br_id char(3),
@usr_id int,
@per_dt1 datetime,
@per_dt2 datetime
begin
    set @per_dt1=GETDATE()
	set @per_dt2=GETDATE()
	set @com_id ='01'
	set @br_id='01'
			
			if (@men_qry='0')
			begin
				set @men_qry=null
			end			
			
	update m_men set men_nam=@men_nam,men_qry=@men_qry,men_ali=@men_ali,men_arc=@men_arc,men_act=@men_act,men_typ=@men_typ,mensubcat_id=@mensubcat_id,module_id=@module_id where men_id=@men_id
--	exec del_m_per @com_id ,@br_id ,@usr_id ,'','','',''
--declare  usrper  cursor for
--		select men_id,gpper_view,gpper_new,gpper_upd,gpper_del,gpper_print from m_gpper where usrgp_id =@usrgp_id
--		OPEN usrper
--		FETCH NEXT FROM usrper
--				INTO @men_id,@per_view,@per_new ,@per_upd,@per_del,@per_print
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				exec [ins_m_per] @com_id ,@br_id ,@per_view ,@per_new ,@per_upd , @per_del ,@per_print ,@men_id ,@usr_id ,@per_dt1 ,@per_dt2,'','','',''
--				FETCH NEXT FROM usrper
--				INTO @men_id,@per_view,@per_new ,@per_upd,@per_del,@per_print
--	end
--	CLOSE usrper
--	DEALLOCATE usrper
end
go


--Delete
alter proc [dbo].[del_m_men](@men_id int)
as
begin
	delete m_men where men_id=@men_id
end

go
