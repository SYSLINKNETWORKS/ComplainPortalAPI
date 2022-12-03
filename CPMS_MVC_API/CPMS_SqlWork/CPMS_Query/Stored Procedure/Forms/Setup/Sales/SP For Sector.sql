USE MEIJI
GO

--Insert
alter proc ins_m_sec(@sec_nam varchar(250),@sec_typ char(1),@sec_act bit,@sec_id_out int output)
as
declare
@sec_id int
begin
	set @sec_id=(select max(sec_id)+1 from m_sec)
		if @sec_id is null
			begin
				set @sec_id=1
			end
	insert into m_sec(sec_id,sec_nam,sec_typ,sec_act)
					values (@sec_id,@sec_nam,@sec_typ,@sec_act)

	set @sec_id_out=@sec_id
end
go		

--Update
alter proc upd_m_sec(@sec_id int,@sec_nam varchar(250),@sec_typ char(1),@sec_act bit)
as
begin
	update m_sec set sec_nam=@sec_nam,sec_typ=@sec_typ,sec_act=@sec_act where sec_id=@sec_id
end
		
go
--Delete
alter proc del_m_sec(@sec_id int)
as
begin
	delete m_sec where sec_id=@sec_id
end
		