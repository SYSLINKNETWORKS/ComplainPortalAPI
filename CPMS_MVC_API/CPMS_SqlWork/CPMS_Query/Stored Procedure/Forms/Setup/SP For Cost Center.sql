USE ZSons
go

--Insert
alter proc ins_m_cs(@cs_nam varchar(250),@cs_typ char(1),@cs_act bit,@cs_id_out int output)
as
declare
@cs_id int
begin
	set @cs_id=(select max(cs_id)+1 from m_cs)
		if @cs_id is null
			begin
				set @cs_id=1
			end
	insert into m_cs(cs_id,cs_nam,cs_typ,cs_act)
					values (@cs_id,@cs_nam,@cs_typ,@cs_act)

	set @cs_id_out=@cs_id
end
go		

--Update
alter proc upd_m_cs(@cs_id int,@cs_nam varchar(250),@cs_typ char(1),@cs_act bit)
as
begin
	update m_cs set cs_nam=@cs_nam,cs_typ=@cs_typ,cs_act=@cs_act where cs_id=@cs_id
end
		
go
--Delete
alter proc del_m_cs(@cs_id int)
as
begin
	delete m_cs where cs_id=@cs_id
end
		