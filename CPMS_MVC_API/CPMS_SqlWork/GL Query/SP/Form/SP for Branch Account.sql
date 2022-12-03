
--Insert Branch Account
ALTER proc [dbo].[ins_bracc](@com_id char(2),@br_id varchar(3),@acc_id varchar(20),@acc_oid varchar(20),@acc_obal money)
as
begin
	if @acc_id is null
		begin
			insert into gl_br_acc(com_id,br_id,acc_id)
			select @com_id,@br_id,acc_id from gl_m_acc where acc_cid is not null and acc_id not in (select acc_id from gl_br_acc)
		end
	else
		begin	
			insert into gl_br_acc (com_id,br_id,acc_id,acc_oid,acc_obal)
			values
			(@com_id,@br_id,@acc_id,@acc_oid,@acc_obal)
		end
end
GO
