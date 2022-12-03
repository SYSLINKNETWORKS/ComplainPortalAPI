USE PAGEY
GO



--alter table m_procat add procat_prom char(1)

--Insert
alter proc ins_m_procat(@procat_nam varchar(250),@procat_typ char(1),@procat_act bit,@procat_prom char(1),@procat_id_out int output)
as
declare
@procat_id int
begin
	set @procat_id=(select max(procat_id)+1 from m_procat)
		if @procat_id is null
			begin
				set @procat_id=1
			end
	insert into m_procat(procat_id,procat_nam,procat_typ,procat_act,procat_prom)
					values (@procat_id,@procat_nam,@procat_typ,@procat_act,@procat_prom)

	set @procat_id_out=@procat_id
end
go		

--Update
alter proc upd_m_procat(@procat_id int,@procat_nam varchar(250),@procat_typ char(1),@procat_act bit,@procat_prom char(1))
as
begin
	update m_procat set procat_nam=@procat_nam,procat_typ=@procat_typ,procat_act=@procat_act,procat_prom=@procat_prom where procat_id=@procat_id
end
		
go
--Delete
alter proc del_m_procat(@procat_id int)
as
begin
	delete m_procat where procat_id=@procat_id
end
		