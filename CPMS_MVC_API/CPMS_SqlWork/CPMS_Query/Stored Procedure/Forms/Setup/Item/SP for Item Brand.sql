USE PAGEY
GO

--alter table m_bd add bd_genact bit
--update m_bd set bd_genact=0
--update m_bd set bd_genact =1 where bd_id=12
--alter table m_bd add bd_idold varchar(1000)

--Insert
alter proc [dbo].[ins_m_bd](@bd_nam varchar(250),@bd_act bit,@bd_typ char(1),@bd_genact bit,@bd_idold varchar(1000),@bd_id_out int output)
as
declare
@bd_id int
begin
	set @bd_id=(select max(bd_id)+1 from m_bd)
		if @bd_id is null
			begin
				set @bd_id=1
			end
	insert into m_bd(bd_id,bd_nam,bd_act,bd_genact,bd_typ ,bd_idold)
			values(@bd_id,@bd_nam,@bd_act,@bd_genact,@bd_typ,@bd_idold)
		set @bd_id_out=@bd_id

end
GO

--Update
alter proc [dbo].[upd_m_bd](@bd_id int,@bd_nam varchar(250),@bd_act bit,@bd_genact bit,@bd_typ char(1))
as
begin
	update m_bd set bd_nam=@bd_nam,bd_act=@bd_act,bd_genact=@bd_genact,bd_typ=@bd_typ where bd_id=@bd_id
end
GO


--Delete
alter proc [dbo].[del_m_bd](@bd_id int)
as
begin
	delete m_bd where bd_id=@bd_id
end
		

