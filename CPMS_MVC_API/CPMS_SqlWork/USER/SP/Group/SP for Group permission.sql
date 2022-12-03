USE nathi
GO

--alter table m_gpper add gpper_tax bit
--update m_gpper set gpper_tax=0
--alter table m_gpper add gpper_app bit
--update m_gpper set gpper_tax=0
--ALTER table m_gpper add gpper_ck bit
--update m_gpper set gpper_ck=1

--alter table m_gpper add gpper_can bit
--update m_gpper set gpper_can=1



--Inser Group Permission
alter proc [dbo].[ins_m_gpper] (@com_id char(3),@br_id char(2),@gpper_view bit,@gpper_new bit,@gpper_upd bit, @gpper_del bit,@gpper_print bit,@gpper_tax bit,@gpper_can bit,@gpper_ck bit,@gpper_app bit,@men_id int,@usrgp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
 @gpper_id int,
 @usr_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @gpper_id =(select max(gpper_id) from m_gpper) +1
	if @gpper_id is null
		begin
			set @gpper_id=1	
		end
	
		insert into m_gpper (gpper_id,gpper_view,gpper_new,gpper_upd,gpper_del,gpper_print,gpper_tax,gpper_can,gpper_ck,gpper_app,men_id,usrgp_id)
		values (@gpper_id,@gpper_view,@gpper_new,@gpper_upd,@gpper_del,@gpper_print,@gpper_tax,@gpper_can,@gpper_ck,@gpper_app,@men_id,@usrgp_id)
	
	--Insert Permission to Users	
	declare  usrper  cursor for
			select new_usr.usr_id from new_usr inner join m_dusr on new_usr.usr_id=m_dusr.usr_id where usrgp_id=@usrgp_id
			
			OPEN usrper
			FETCH NEXT FROM usrper
					INTO @usr_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					exec [ins_m_per] @com_id ,@br_id ,@gpper_view ,@gpper_new ,@gpper_upd , @gpper_del ,@gpper_print,@gpper_tax,@gpper_can,@gpper_ck,@gpper_app ,@men_id ,@usr_id ,'','','',''
					FETCH NEXT FROM usrper
					INTO @usr_id
		end
		CLOSE usrper
		DEALLOCATE usrper

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end
GO

--Delete Group Permission
alter proc [dbo].[del_m_gpper] (@com_id char(2),@br_id char(3),@usrgp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id_aud int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	--Delete Permission from users
	delete from m_per where usr_id in (select new_usr.usr_id from new_usr inner join m_dusr on new_usr.usr_id=m_dusr.usr_id where usrgp_id=@usrgp_id)
	delete from m_gpper where usrgp_id = @usrgp_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id_aud,@aud_act,@aud_ip
end

GO


