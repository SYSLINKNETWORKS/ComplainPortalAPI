USE NATHI
GO

--alter table m_men add men_qry varchar(1000)
--alter table m_men add men_whr varchar(250)
--alter table m_men add men_odb varchar(100)

--alter table m_men add men_ckweb bit
--update m_men set men_ckweb=0

--alter table m_men add men_fov bit
--update m_men set men_fov=0

---Insert
alter proc [dbo].[ins_m_men](@men_nam varchar(100),@men_qry varchar(1000),@module_id int,@men_ali varchar(100),@men_arc varchar(100),@men_whr varchar(250),@men_odb varchar(100),@men_act bit,@men_ckview bit,@men_ckfov bit,@men_cid int,@men_typ char(1),@mensubcat_id int,@men_id_out int output)
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
			
	insert into m_men(men_id,men_nam,men_qry,men_ali,men_arc,men_whr,men_odb,men_act,men_view,men_fov,men_typ,mensubcat_id,module_id,men_cid )
			values(@men_id,@men_nam,@men_qry,@men_ali,@men_arc,@men_whr,@men_odb,@men_act,@men_ckview,@men_ckfov,@men_typ,@mensubcat_id,@module_id,@men_cid)
		set @men_id_out=@men_id
		
		declare  gpper  cursor for
			select usrgp_id from m_usrgp where usrgp_typ<>'U'
		
		OPEN gpper
		FETCH NEXT FROM gpper
				INTO @usrgp_id
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec ins_m_gpper @com_id,@br_id,1,1,1, 1,1,1,1,1,1,@men_id,@usrgp_id ,'','','',''
				FETCH NEXT FROM gpper
				INTO @usrgp_id

	end
	CLOSE gpper
	DEALLOCATE gpper


end

GO

--Update
alter proc [dbo].[upd_m_men](@men_id int,@men_nam varchar(100),@men_qry varchar(1000),@module_id int,@men_ali varchar(100),@men_arc varchar(100),@men_whr varchar(250),@men_odb varchar(100),@men_act bit,@men_ckview bit,@men_ckfov bit,@men_typ char(1),@mensubcat_id int,@men_cid int)
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
			
	update m_men set men_nam=@men_nam,men_qry=@men_qry,men_ali=@men_ali,men_arc=@men_arc,men_whr=@men_whr,men_odb=@men_odb,men_act=@men_act,men_view=@men_ckview,men_fov=@men_ckfov,men_typ=@men_typ,mensubcat_id=@mensubcat_id,module_id=@module_id,men_cid=@men_cid where men_id=@men_id

----	exec del_m_per @com_id ,@br_id ,@usr_id ,'','','',''

--	declare  gpper  cursor for
--			select usrgp_id from m_usrgp where usrgp_typ<>'U'
		
--		OPEN gpper
--		FETCH NEXT FROM gpper
--				INTO @usrgp_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--				exec del_m_gpper @com_id,@br_id ,@usrgp_id,'','','',''
				
--				exec ins_m_gpper @com_id,@br_id,1,1,1, 1,1,1,1,@men_id,@usrgp_id ,'','','',''
--				FETCH NEXT FROM gpper
--				INTO @usrgp_id

--	end
--	CLOSE gpper
--	DEALLOCATE gpper
end
go


--Delete
alter proc [dbo].[del_m_men](@men_id int)
as
begin
	delete m_men where men_id=@men_id
end

go
