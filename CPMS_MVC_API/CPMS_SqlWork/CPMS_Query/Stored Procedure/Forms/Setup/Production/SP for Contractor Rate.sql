USE meiji_rusk
GO

--Insert
alter proc [dbo].[ins_m_conrat](@conrat_dat datetime,@conrat_act bit,@conrat_typ char(1),@conrat_rat float,@con_id int,@conrat_id_out int output)
as
declare
@conrat_id int
begin
	set @conrat_id=(select max(conrat_id)+1 from m_conrat)
		if @conrat_id is null
			begin
				set @conrat_id=1
			end
	insert into m_conrat(conrat_id,conrat_dat,con_id,conrat_act,conrat_typ,conrat_rat)
			values(@conrat_id,@conrat_dat,@con_id,@conrat_act,@conrat_typ,@conrat_rat)
		set @conrat_id_out=@conrat_id

end
GO

--Update
alter proc [dbo].[upd_m_conrat](@conrat_id int,@conrat_dat datetime,@con_id int,@conrat_act bit,@conrat_rat float,@conrat_typ char(1))
as
begin
	update m_conrat set con_id=@con_id,conrat_dat=@conrat_dat,conrat_act=@conrat_act,conrat_typ=@conrat_typ,conrat_rat=@conrat_rat where conrat_id=@conrat_id
end
GO


--Delete
alter proc [dbo].[del_m_conrat](@conrat_id int)
as
begin
	delete m_conrat where conrat_id=@conrat_id
end
		

