USE ZSons
GO

--Insert
create proc ins_m_zone(@zone_nam varchar(250),@zone_typ char(1),@zone_act bit,@city_id int,@zone_id_out int output)
as
declare
@zone_id int
begin
	set @zone_id=(select max(zone_id)+1 from m_zone)
		if @zone_id is null
			begin
				set @zone_id=1
			end
	insert into m_zone(zone_id,zone_nam,zone_typ,zone_act,city_id)
					values (@zone_id,@zone_nam,@zone_typ,@zone_act,@city_id)

	set @zone_id_out=@zone_id
end
go		

--Update
create proc upd_m_zone(@zone_id int,@zone_nam varchar(250),@zone_typ char(1),@zone_act bit,@city_id int)
as
begin
	update m_zone set zone_nam=@zone_nam,zone_typ=@zone_typ,zone_act=@zone_act,city_id=@city_id where zone_id=@zone_id
end
		
go
--Delete
create proc del_m_zone(@zone_id int)
as
begin
	delete m_zone where zone_id=@zone_id
end
		