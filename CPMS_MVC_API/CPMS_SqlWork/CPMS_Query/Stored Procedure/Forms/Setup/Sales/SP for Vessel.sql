
USE MFI
GO
--Insert
create proc [dbo].[ins_m_ves](@ves_nam varchar(250),@ves_act bit,@ves_typ char(1),@ves_id_out int output)
as
declare
@ves_id int
begin
	set @ves_id=(select max(ves_id)+1 from m_ves)
		if @ves_id is null
			begin
				set @ves_id=1
			end
	insert into m_ves(ves_id,ves_nam,ves_act,ves_typ )
			values(@ves_id,@ves_nam,@ves_act,@ves_typ)
		set @ves_id_out=@ves_id

end
GO

--Update
create proc [dbo].[upd_m_ves](@ves_id int,@ves_nam varchar(250),@ves_act bit,@ves_typ char(1))
as
begin
	update m_ves set ves_nam=@ves_nam,ves_act=@ves_act,ves_typ=@ves_typ where ves_id=@ves_id
end
GO


--Delete
create proc [dbo].[del_m_ves](@ves_id int)
as
begin
	delete m_ves where ves_id=@ves_id
end
		

