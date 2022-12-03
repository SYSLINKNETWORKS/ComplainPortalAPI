USE ZSons
GO

--Insert
create proc ins_m_stdcat(@stdcat_nam varchar(250),@stdcat_typ char(1),@stdcat_act bit,@stdcatmas_id int,@stdcat_id_out int output)
as
declare
@stdcat_id int
begin
	set @stdcat_id=(select max(stdcat_id)+1 from m_stdcat)
		if @stdcat_id is null
			begin
				set @stdcat_id=1
			end
	insert into m_stdcat(stdcat_id,stdcat_nam,stdcat_typ,stdcatmas_id,stdcat_act)
					values (@stdcat_id,@stdcat_nam,@stdcat_typ,@stdcatmas_id,@stdcat_act)

	set @stdcat_id_out=@stdcat_id
end
go		

--Update
create proc upd_m_stdcat(@stdcat_id int,@stdcat_nam varchar(250),@stdcat_typ char(1),@stdcat_act bit,@stdcatmas_id int)
as
begin
	update m_stdcat set stdcat_nam=@stdcat_nam,stdcat_typ=@stdcat_typ,stdcat_act=@stdcat_act,stdcatmas_id=@stdcatmas_id where stdcat_id=@stdcat_id
end
		
go
--Delete
create proc del_m_stdcat(@stdcat_id int)
as
begin
	delete m_stdcat where stdcat_id=@stdcat_id
end
		