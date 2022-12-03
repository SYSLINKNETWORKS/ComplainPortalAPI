USE PHM
GO



--Insert
create  proc [dbo].[ins_m_termres](@com_id char(2),@br_id char(3),@mtermres_nam varchar(250),@mtermres_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mtermres_id_out int output)
as
declare
@mtermres_id int,
@aud_act char(10)
begin
set @aud_act='Insert'
	set @mtermres_id =(select max(mtermres_id) from m_termres)+1
	

	if (@mtermres_id is null)
		begin	
			set @mtermres_id=1
		end

	insert into m_termres (com_id,br_id,mtermres_id,mtermres_nam,mtermres_typ)
	values
	(@com_id,@br_id,@mtermres_id,@mtermres_nam,@mtermres_typ)

	set @mtermres_id_out=@mtermres_id

		--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO

--Update

create  proc [dbo].[upd_m_termres](@com_id char(2),@br_id char(3),@mtermres_id int,@mtermres_nam varchar(250),@mtermres_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	
	set @aud_act='Update'
	update m_termres 
			set mtermres_nam=@mtermres_nam,mtermres_typ=@mtermres_typ
			where mtermres_id=@mtermres_id 
	
		--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create  proc [dbo].[del_m_termres](@com_id char(2),@br_id char(3),@mtermres_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
set @aud_act='Delete'	
	delete from m_termres  
			where mtermres_id=@mtermres_id

		--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
	
end
GO

