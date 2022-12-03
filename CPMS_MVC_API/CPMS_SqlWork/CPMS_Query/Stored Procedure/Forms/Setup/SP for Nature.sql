USE MFI

GO
--select * from m_nat

--Insert
create proc ins_m_nat(@nat_nam varchar(250),@nat_typ char(1),@nat_id_out int output)
as
declare
@nat_id int
begin
	set @nat_id=(select max(nat_id)+1 from m_nat)
		if @nat_id is null
			begin
				set @nat_id=1
			end
	insert into m_nat(nat_id,nat_nam,nat_typ)
					values (@nat_id,@nat_nam,@nat_typ)

	set @nat_id_out=@nat_id
end
go		

--Update
create proc upd_m_nat(@nat_id int,@nat_nam varchar(250),@nat_typ char(1))
as
begin
	update m_nat set nat_nam=@nat_nam,nat_typ=@nat_typ where nat_id=@nat_id
end
		
go
--Delete
create proc del_m_nat(@nat_id int)
as
begin
	delete m_nat where nat_id=@nat_id
end
		