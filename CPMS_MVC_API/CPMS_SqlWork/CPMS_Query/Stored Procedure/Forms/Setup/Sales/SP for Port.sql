USE MFI
GO
--Insert
create proc [dbo].[ins_m_port](@port_nam varchar(250),@port_act bit,@port_typ char(1),@port_cat char(1),@port_id_out int output)
as
declare
@port_id int
begin
	set @port_id=(select max(port_id)+1 from m_port)
		if @port_id is null
			begin
				set @port_id=1
			end
	insert into m_port(port_id,port_nam,port_act,port_typ,port_cat )
			values(@port_id,@port_nam,@port_act,@port_typ,@port_cat)
		set @port_id_out=@port_id

end
GO

--Update
create proc [dbo].[upd_m_port](@port_id int,@port_nam varchar(250),@port_act bit,@port_typ char(1),@port_cat char(1))
as
begin
	update m_port set port_nam=@port_nam,port_act=@port_act,port_typ=@port_typ,port_cat=@port_cat where port_id=@port_id
end
GO


--Delete
create proc [dbo].[del_m_port](@port_id int)
as
begin
	delete m_port where port_id=@port_id
end
		

