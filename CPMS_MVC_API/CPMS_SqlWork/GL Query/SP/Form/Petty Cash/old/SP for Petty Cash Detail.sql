USE zsons
GO

--Insert Detail
alter proc [dbo].[ins_t_dpc](@com_id char(2),@br_id char(3),@mpc_no int,@dpc_row int,@acc_no int,@dpc_nar nvarchar(1000),
@dpc_amt float,@dpc_set bit)
as
declare
@mpc_dat datetime,
@dpc_setdat datetime
begin
			set @mpc_dat=(select mpc_dat from t_mpc where mpc_no=@mpc_no)
			if (@dpc_set=1)
				begin
					set @dpc_setdat=@mpc_dat
				end
			else
				begin
					set @dpc_setdat=null
				end
	--Insert	
	insert into t_dpc
		(com_id,mpc_no,dpc_row,acc_no,dpc_nar,dpc_amt,dpc_set,dpc_setdat)
	values
		(@com_id,@mpc_no,@dpc_row,@acc_no,@dpc_nar,@dpc_amt,@dpc_set,@dpc_setdat)
end
GO

--Delete Detail
alter proc [dbo].[del_t_dpc](@com_id char(2),@br_id char(3),@mpc_no int)
as
	delete from t_dpc
		where mpc_no=@mpc_no and dpc_setdat is not null
	delete from t_dpc where dpc_setdat is null	
	
GO

