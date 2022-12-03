USE phm
go
--Insert
create proc [dbo].[ins_m_prcat](@prcat_nam varchar(250),@prcat_act bit,@prcat_typ char(1),@prcat_id_out int output)
as
declare
@prcat_id int
begin
	set @prcat_id=(select max(prcat_id)+1 from m_prcat)
		if @prcat_id is null
			begin
				set @prcat_id=1
			end
	insert into m_prcat(prcat_id,prcat_nam,prcat_act,prcat_typ )
			values(@prcat_id,@prcat_nam,@prcat_act,@prcat_typ)
		set @prcat_id_out=@prcat_id

end
GO

--Update
create proc [dbo].[upd_m_prcat](@prcat_id int,@prcat_nam varchar(250),@prcat_act bit,@prcat_typ char(1))
as
begin
	update m_prcat set prcat_nam=@prcat_nam,prcat_act=@prcat_act,prcat_typ=@prcat_typ where prcat_id=@prcat_id
end
GO


--Delete
create proc [dbo].[del_m_prcat](@prcat_id int)
as
begin
	delete m_prcat where prcat_id=@prcat_id
end
		

