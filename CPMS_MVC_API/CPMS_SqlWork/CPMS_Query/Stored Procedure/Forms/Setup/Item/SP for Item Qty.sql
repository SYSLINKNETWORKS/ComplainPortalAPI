USE MFI
GO

--Insert
create proc [dbo].[ins_m_itmqty](@itmqty_nam varchar(250),@itmqty_act bit,@itmqty_typ char(1),@itmqty_id_out int output)
as
declare
@itmqty_id int
begin
	set @itmqty_id=(select max(itmqty_id)+1 from m_itmqty)
		if @itmqty_id is null
			begin
				set @itmqty_id=1
			end
	insert into m_itmqty(itmqty_id,itmqty_nam,itmqty_act,itmqty_typ )
			values(@itmqty_id,@itmqty_nam,@itmqty_act,@itmqty_typ)
		set @itmqty_id_out=@itmqty_id

end
GO

--Update
create proc [dbo].[upd_m_itmqty](@itmqty_id int,@itmqty_nam varchar(250),@itmqty_act bit,@itmqty_typ char(1))
as
begin
	update m_itmqty set itmqty_nam=@itmqty_nam,itmqty_act=@itmqty_act,itmqty_typ=@itmqty_typ where itmqty_id=@itmqty_id
end
GO


--Delete
create proc [dbo].[del_m_itmqty](@itmqty_id int)
as
begin
	delete m_itmqty where itmqty_id=@itmqty_id
end
		

