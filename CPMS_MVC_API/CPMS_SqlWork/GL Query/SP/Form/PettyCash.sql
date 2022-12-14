USE ZSons
go
--select * from gl_m_pc


----Insert
alter proc [dbo].[ins_m_pc](@br_id char(2),@acc_no  int,@acc_id_cash char(20),@com_id char(2),@pc_typ char(1),@pc_id_out int output)
as
declare
@pc_id			int,
@acc_no_cash int
begin
	set @acc_no_cash=(select acc_no from gl_m_acc where acc_id=@acc_id_cash)
	set @pc_id =(select max(pc_id)+1 from gl_m_pc)
	if (@pc_id is null)
		begin
			set @pc_id =1
		end
	insert into gl_m_pc (pc_id,acc_no_cash,acc_no,pc_typ,com_id,br_id)
	values 	(@pc_id,@acc_no_cash,@acc_no,@pc_typ,@com_id,@br_id)
	set @pc_id_out=@pc_id

end
GO





--Delete
alter proc [dbo].[del_m_pc](@br_id char(2))
as
delete from gl_m_pc  
		where br_id=@br_id
GO
