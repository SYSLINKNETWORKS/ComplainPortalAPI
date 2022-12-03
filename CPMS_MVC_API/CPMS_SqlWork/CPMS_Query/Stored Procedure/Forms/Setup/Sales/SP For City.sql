USE ZSons
GO

--Insert
create proc ins_m_city(@city_nam varchar(250),@city_typ char(1),@city_act bit,@coun_id int,@city_id_out int output)
as
declare
@city_id int
begin
	set @city_id=(select max(city_id)+1 from m_city)
		if @city_id is null
			begin
				set @city_id=1
			end
	insert into m_city(city_id,city_nam,city_typ,city_act,coun_id)
					values (@city_id,@city_nam,@city_typ,@city_act,@coun_id)

	set @city_id_out=@city_id
end
go		

--Update
create proc upd_m_city(@city_id int,@city_nam varchar(250),@city_typ char(1),@city_act bit,@coun_id int)
as
begin
	update m_city set city_nam=@city_nam,city_typ=@city_typ,city_act=@city_act,coun_id=@coun_id where city_id=@city_id
end
		
go
--Delete
create proc del_m_city(@city_id int)
as
begin
	delete m_city where city_id=@city_id
end
		