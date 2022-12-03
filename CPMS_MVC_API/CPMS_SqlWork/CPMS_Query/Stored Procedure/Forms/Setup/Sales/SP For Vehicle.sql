USE MEIJI
GO

--Insert
alter proc ins_m_veh(@veh_nam varchar(250),@veh_typ char(1),@veh_act bit,@veh_id_out int output)
as
declare
@veh_id int
begin
	set @veh_id=(select max(veh_id)+1 from m_veh)
		if @veh_id is null
			begin
				set @veh_id=1
			end
	insert into m_veh(veh_id,veh_nam,veh_typ,veh_act)
					values (@veh_id,@veh_nam,@veh_typ,@veh_act)

	set @veh_id_out=@veh_id
end
go		

--Update
alter proc upd_m_veh(@veh_id int,@veh_nam varchar(250),@veh_typ char(1),@veh_act bit)
as
begin
	update m_veh set veh_nam=@veh_nam,veh_typ=@veh_typ,veh_act=@veh_act where veh_id=@veh_id
end
		
go
--Delete
alter proc del_m_veh(@veh_id int)
as
begin
	delete m_veh where veh_id=@veh_id
end
		