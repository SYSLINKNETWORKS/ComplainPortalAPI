USE PAGEY
GO


--Insert
alter proc ins_m_exp(@exp_nam varchar(100),@exp_typ char(1),@exp_id_out int output)
as
declare
@exp_id int
begin
	set @exp_id=(select max(exp_id)+1 from m_exp)
		if @exp_id is null
			begin
				set @exp_id=1
			end
	insert into m_exp(exp_id,exp_nam,exp_typ)
					values (@exp_id,@exp_nam,@exp_typ)

	set @exp_id_out=@exp_id
end
go		

--Update
alter proc upd_m_exp(@exp_id int,@exp_nam varchar(100),@exp_typ char(1))
as
begin
	update m_exp set exp_nam=@exp_nam,exp_typ=@exp_typ where exp_id=@exp_id
end
		
go
--Delete
alter proc del_m_exp(@exp_id int)
as
begin
	delete m_exp where exp_id=@exp_id
end
		

		