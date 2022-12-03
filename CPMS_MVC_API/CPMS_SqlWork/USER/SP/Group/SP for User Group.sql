USE PAGEY
GO
--Insert
alter proc [dbo].[ins_m_usrgp](@usrgp_nam varchar(250),@usrgp_act bit,@usrgp_typ char(10),@usrgp_id_out int output)
as
declare
@usrgp_id int
begin
	set @usrgp_id=(select max(usrgp_id)+1 from m_usrgp)
		if @usrgp_id is null
			begin
				set @usrgp_id=1
			end
	insert into m_usrgp(usrgp_id,usrgp_nam,usrgp_act,usrgp_typ)
			values(@usrgp_id,@usrgp_nam,@usrgp_act,@usrgp_typ)
		set @usrgp_id_out=@usrgp_id

end
Go
--Update
alter proc [dbo].[upd_m_usrgp](@usrgp_id int,@usrgp_nam varchar(250),@usrgp_act bit,@usrgp_typ char(10))
as
begin
	update m_usrgp set usrgp_nam=@usrgp_nam,usrgp_act=@usrgp_act,usrgp_typ=@usrgp_typ where usrgp_id=@usrgp_id
end

GO
--Delete
alter proc [dbo].[del_m_usrgp](@usrgp_id int)
as
begin	
	delete m_usrgp where usrgp_id=@usrgp_id
end







