USE ZSons
GO

--Insert
create proc ins_m_stdcatmas(@stdcatmas_nam varchar(250),@stdcatmas_typ char(1),@stdcatmas_act bit,@stdcatmas_id_out int output)
as
declare
@stdcatmas_id int
begin
	set @stdcatmas_id=(select max(stdcatmas_id)+1 from m_stdcatmas)
		if @stdcatmas_id is null
			begin
				set @stdcatmas_id=1
			end
	insert into m_stdcatmas(stdcatmas_id,stdcatmas_nam,stdcatmas_typ,stdcatmas_act)
					values (@stdcatmas_id,@stdcatmas_nam,@stdcatmas_typ,@stdcatmas_act)

	set @stdcatmas_id_out=@stdcatmas_id
end
go		

--Update
create proc upd_m_stdcatmas(@stdcatmas_id int,@stdcatmas_nam varchar(250),@stdcatmas_typ char(1),@stdcatmas_act bit)
as
begin
	update m_stdcatmas set stdcatmas_nam=@stdcatmas_nam,stdcatmas_typ=@stdcatmas_typ,stdcatmas_act=@stdcatmas_act where stdcatmas_id=@stdcatmas_id
end
		
go
--Delete
create proc del_m_stdcatmas(@stdcatmas_id int)
as
begin
	delete m_stdcatmas where stdcatmas_id=@stdcatmas_id
end
		