USE zsons
go
--Insert
create proc [dbo].[ins_m_cusbk](@cusbk_nam varchar(250),@cusbk_snm char(10),@cusbk_act bit,@cusbk_typ char(1),@cusbk_id_out int output)
as
declare
@cusbk_id int
begin
	set @cusbk_id=(select max(cusbk_id)+1 from m_cusbk)
		if @cusbk_id is null
			begin
				set @cusbk_id=1
			end
	insert into m_cusbk(cusbk_id,cusbk_nam,cusbk_snm,cusbk_act,cusbk_typ )
			values(@cusbk_id,@cusbk_nam,@cusbk_snm,@cusbk_act,@cusbk_typ)
		set @cusbk_id_out=@cusbk_id

end
GO

--Update
create proc [dbo].[upd_m_cusbk](@cusbk_id int,@cusbk_nam varchar(250),@cusbk_snm char(10),@cusbk_act bit,@cusbk_typ char(1))
as
begin
	update m_cusbk set cusbk_nam=@cusbk_nam,cusbk_snm=@cusbk_snm,cusbk_act=@cusbk_act,cusbk_typ=@cusbk_typ where cusbk_id=@cusbk_id
end
GO


--Delete
create proc [dbo].[del_m_cusbk](@cusbk_id int)
as
begin
	delete m_cusbk where cusbk_id=@cusbk_id
end
		

