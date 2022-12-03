USE ZSONS
GO



---Insert
create proc [dbo].[ins_m_mencat](@mencat_nam varchar(250),@mencat_act bit,@mencat_typ char(1),@mencat_id_out int output)
as
declare
@mencat_id int
--@mencat_id_out int
begin
	set @mencat_id=(select max(mencat_id)+1 from m_mencat)
		if @mencat_id is null
			begin
				set @mencat_id=1
			end
	insert into m_mencat(mencat_id,mencat_nam,mencat_act,mencat_typ )
			values(@mencat_id,@mencat_nam,@mencat_act,@mencat_typ)
		set @mencat_id_out=@mencat_id

end
go

--update
create proc [dbo].[upd_m_mencat](@mencat_id int,@mencat_nam varchar(250),@mencat_act bit,@mencat_typ char(1))
as
begin
	update m_mencat set mencat_nam=@mencat_nam,mencat_act=@mencat_act,mencat_typ=@mencat_typ where mencat_id=@mencat_id
end
GO

--Delete
create proc [dbo].[del_m_mencat](@mencat_id int)
as
begin
	delete m_mencat where mencat_id=@mencat_id
end

go
