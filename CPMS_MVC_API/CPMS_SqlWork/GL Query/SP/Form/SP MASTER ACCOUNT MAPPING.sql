USE PAGEY
GO
--select * from gl_m_acc_master

----Insert Company
create proc [dbo].[ins_gl_m_acc_master](@com_id char(2),@br_id char(3),@accmaster_cno int,@accmaster_nam varchar(250),@accmaster_typ char(1),@accmaster_act bit,@accmaster_no_output int output)
as
declare
@accmaster_id int,
@accmaster_no int,
@cur_id int
begin
	set @cur_id =null
	set @accmaster_id =(select MAX(accmaster_id)+1 from gl_m_acc_master)
	if (@accmaster_id is null)
		begin
			set @accmaster_id=1
		end
		
	exec ins_m_acc @com_id,@br_id,@cur_id,@accmaster_nam,@accmaster_cno,'',@accmaster_typ,@accmaster_act,'','','','','',@acc_no_out =@accmaster_no output

	insert into gl_m_acc_master(com_id,br_id,accmaster_id,accmaster_no,accmaster_nam,accmaster_cno,accmaster_typ,accmaster_act)
			values(@com_id,@br_id,@accmaster_id,@accmaster_no,@accmaster_nam,@accmaster_cno,@accmaster_typ,@accmaster_act)
		set @accmaster_no_output=@accmaster_no
end
GO

--Delete Company
create proc [dbo].[del_gl_m_acc_master] (@com_id char(2),@br_id char(3),@accmaster_no int)
as
begin

		exec del_m_acc @com_id,@br_id,@accmaster_no,'','','',''
		delete from gl_m_acc_master where accmaster_no=@accmaster_no
		
end
GO

