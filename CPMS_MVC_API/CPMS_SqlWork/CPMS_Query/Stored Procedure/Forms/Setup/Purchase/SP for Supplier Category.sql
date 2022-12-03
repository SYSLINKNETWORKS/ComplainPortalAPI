USE MFI
go
--Insert
create proc [dbo].[ins_m_supcat](@supcat_nam varchar(250),@supcat_act bit,@supcat_typ char(1),@supcat_id_out int output)
as
declare
@supcat_id int
begin
	set @supcat_id=(select max(supcat_id)+1 from m_supcat)
		if @supcat_id is null
			begin
				set @supcat_id=1
			end
	insert into m_supcat(supcat_id,supcat_nam,supcat_act,supcat_typ )
			values(@supcat_id,@supcat_nam,@supcat_act,@supcat_typ)
		set @supcat_id_out=@supcat_id

end
GO

--Update
create proc [dbo].[upd_m_supcat](@supcat_id int,@supcat_nam varchar(250),@supcat_act bit,@supcat_typ char(1))
as
begin
	update m_supcat set supcat_nam=@supcat_nam,supcat_act=@supcat_act,supcat_typ=@supcat_typ where supcat_id=@supcat_id
end
GO


--Delete
create proc [dbo].[del_m_supcat](@supcat_id int)
as
begin
	delete m_supcat where supcat_id=@supcat_id
end
		

