
USE MFI
GO

--Insert
alter proc [dbo].[ins_t_dstdcos_exp](@acc_id char(20),@dstdcos_rat float,@mstdcos_id int,@m_yr_id char(2),@usr_id int,@aud_ip varchar(100))
as
declare
@dstdcos_id int
begin

	set @dstdcos_id=(select max(dstdcos_id)+1 from t_dstdcos_exp)
		if @dstdcos_id is null
			begin
				set @dstdcos_id=1
			end
			
			
	insert into t_dstdcos_exp(dstdcos_id,acc_id,dstdcos_rat,mstdcos_id)
			values(@dstdcos_id,@acc_id,@dstdcos_rat,@mstdcos_id)



end
GO


--exec  del_gl_t_dstd_cos 13

--Delete
alter proc [dbo].[del_t_dstdcos_exp](@mstdcos_id int)
as
begin

	delete t_dstdcos_exp where mstdcos_id=@mstdcos_id
	delete t_dstdcos_rm where mstdcos_id=@mstdcos_id
	delete t_dstdcos_pk where mstdcos_id=@mstdcos_id
end

go
