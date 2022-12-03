USE phm
go

--Insert
create proc ins_m_dspo_cus(@cus_id int,@mspo_id int)
as
declare
@dspo_cus_id int
begin

	set @dspo_cus_id=(select max(dspo_cus_id)+1 from m_dspo_cus)
		if @dspo_cus_id is null
			begin
				set @dspo_cus_id=1
			end
	insert into m_dspo_cus(dspo_cus_id,mspo_id,cus_id)
					values (@dspo_cus_id,@mspo_id,@cus_id)
end
go		

--Delete
create proc del_m_dspo_cus(@mspo_id int)
as
begin
	delete m_dspo_cus where mspo_id=@mspo_id
end


		