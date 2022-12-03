USE nathi
GO

--Insert
alter proc [dbo].[ins_m_dusr](@usr_id char(2),@usrgp_id int)
as
declare
@dusr_id int,
@com_id char(2),
@br_id char(3),
@men_id int,@per_view bit,@per_new bit,@per_upd bit,@per_del bit,@per_print bit,@per_tax bit,@per_can bit,@per_ck bit,@per_app bit
begin
	set @com_id ='01'
	set @br_id='01'
	set @dusr_id=(select max(dusr_id)+1 from m_dusr)
		if @dusr_id is null
			begin
				set @dusr_id=1
			end
	insert into m_dusr(dusr_id,usr_id,usrgp_id)
					values (@dusr_id,@usr_id,@usrgp_id)
					
declare  usrper  cursor for
		select men_id,gpper_view,gpper_new,gpper_upd,gpper_del,gpper_print,gpper_tax,gpper_can,gpper_ck,gpper_app from m_gpper where usrgp_id =@usrgp_id and (gpper_view!=0 or  gpper_new!=0 or gpper_upd!=0 or gpper_del!=0 or gpper_print!=0 or gpper_tax!=0)
		OPEN usrper
		FETCH NEXT FROM usrper
				INTO @men_id,@per_view,@per_new ,@per_upd,@per_del,@per_print,@per_tax,@per_can,@per_ck,@per_app
			WHILE @@FETCH_STATUS = 0
			BEGIN
				exec [ins_m_per] @com_id ,@br_id ,@per_view ,@per_new ,@per_upd , @per_del ,@per_print	,@per_tax ,@per_can,@per_ck,@per_app,@men_id ,@usr_id ,'','','',''
				FETCH NEXT FROM usrper
				INTO @men_id,@per_view,@per_new ,@per_upd,@per_del,@per_print,@per_tax,@per_can,@per_ck,@per_app
	end
	CLOSE usrper
	DEALLOCATE usrper

end
GO

--Delete
alter proc [dbo].[del_m_dusr](@usr_id int)
as
declare @com_id char(3),
@br_id char(2)
begin
	exec del_m_per @com_id ,@br_id ,@usr_id ,'','','',''
	delete m_dusr where usr_id=@usr_id
end
