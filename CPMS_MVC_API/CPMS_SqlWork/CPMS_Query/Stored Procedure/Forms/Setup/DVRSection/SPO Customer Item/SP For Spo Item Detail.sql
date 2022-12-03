USE phm
go

--Insert
create proc ins_m_dspo_titm(@titm_id int,@mspo_id int)
as
declare
@dspo_titm_id int
begin

	set @dspo_titm_id=(select max(dspo_titm_id)+1 from m_dspo_titm)
		if @dspo_titm_id is null
			begin
				set @dspo_titm_id=1
			end
	insert into m_dspo_titm(dspo_titm_id,mspo_id,titm_id)
					values (@dspo_titm_id,@mspo_id,@titm_id)
end
go		

--Delete
create proc del_m_dspo_titm(@mspo_id int)
as
begin
	delete m_dspo_titm where mspo_id=@mspo_id
end


		