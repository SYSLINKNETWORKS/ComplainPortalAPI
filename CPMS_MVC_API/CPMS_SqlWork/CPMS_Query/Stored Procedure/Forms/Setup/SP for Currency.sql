--select * from m_cur

--Insert
create proc ins_m_cur(@cur_nam varchar(250),@cur_snm char(10),@cur_typ char(1),@cur_id_out int output)
as
declare
@cur_id int
begin
	set @cur_id=(select max(cur_id)+1 from m_cur)
		if @cur_id is null
			begin
				set @cur_id=1
			end
	insert into m_cur(cur_id,cur_nam,cur_snm,cur_typ)
					values (@cur_id,@cur_nam,@cur_snm,@cur_typ)

	set @cur_id_out=@cur_id
end
go		

--Update
create proc upd_m_cur(@cur_id int,@cur_nam varchar(250),@cur_snm char(10),@cur_typ char(1))
as
begin
	update m_cur set cur_nam=@cur_nam,cur_snm=@cur_snm,cur_typ=@cur_typ where cur_id=@cur_id
end
		
go
--Delete
create proc del_m_cur(@cur_id int)
as
begin
	delete m_cur where cur_id=@cur_id
end
		