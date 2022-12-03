USE MFI
GO
--Insert
create proc [dbo].[ins_m_contyp](@contyp_ctyp varchar(250),@contyp_act bit,@contyp_typ char(1),@contyp_id_out int output)
as
declare
@contyp_id int
begin
	set @contyp_id=(select max(contyp_id)+1 from m_contyp)
		if @contyp_id is null
			begin
				set @contyp_id=1
			end
	insert into m_contyp(contyp_id,contyp_ctyp,contyp_act,contyp_typ )
			values(@contyp_id,@contyp_ctyp,@contyp_act,@contyp_typ)
		set @contyp_id_out=@contyp_id

end
GO

--Update
create proc [dbo].[upd_m_contyp](@contyp_id int,@contyp_ctyp varchar(250),@contyp_act bit,@contyp_typ char(1))
as
begin
	update m_contyp set contyp_ctyp=@contyp_ctyp,contyp_act=@contyp_act,contyp_typ=@contyp_typ where contyp_id=@contyp_id
end
GO


--Delete
create proc [dbo].[del_m_contyp](@contyp_id int)
as
begin
	delete m_contyp where contyp_id=@contyp_id
end
		

