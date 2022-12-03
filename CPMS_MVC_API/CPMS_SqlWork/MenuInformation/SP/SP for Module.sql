USE ZSONS
GO




--INSERT		
create proc [dbo].[ins_m_module](@module_nam varchar(250),@module_act bit,@module_typ char(1),@module_id_out int output)
as
declare
@module_id int

begin
	set @module_id=(select max(module_id)+1 from m_module)
		if @module_id is null
			begin
				set @module_id=1
			end
	insert into m_module(module_id,module_nam,module_act,module_typ )
			values(@module_id,@module_nam,@module_act,@module_typ)
		set @module_id_out=@module_id

end

go

--UPDATE
create proc [dbo].[upd_m_module](@module_id int,@module_nam varchar(250),@module_act bit,@module_typ char(1))
as
begin
	update m_module set module_nam=@module_nam,module_act=@module_act,module_typ=@module_typ where module_id=@module_id
end
Go

--Delete
create proc [dbo].[del_m_module](@module_id int)
as
begin
	delete m_module where module_id=@module_id
end

go
