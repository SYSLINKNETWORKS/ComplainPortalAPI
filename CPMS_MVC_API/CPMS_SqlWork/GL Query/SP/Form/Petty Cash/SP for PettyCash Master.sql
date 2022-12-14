USE zsons
go

----Insert Master Voucher

alter proc [dbo].[ins_t_mpc](@com_id char(2),@br_id char(3),@yr_id char(2),@mpc_dat datetime,@mpc_rmk varchar(100),@mpc_typ char(1),@cur_id int,@mpc_rat float,@mpc_dc bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),
@mpc_no_out int output)
as
declare
@mpc_no		int,
@aud_act		char(10)
begin
	set @aud_act='Insert'
			set @mpc_no=(select MAX(mpc_no)+1 from t_mpc)
			if (@mpc_no is null)
				begin
					set @mpc_no=1
				end
			

		--inserting value in master voucher
		insert into t_mpc
		(com_id,br_id,yr_id,mpc_no,mpc_dat,mpc_rmk,mpc_typ,cur_id,mpc_rat,mpc_dc,ins_usr_id,ins_dat)
		values
		(@com_id,@br_id,@yr_id,@mpc_no,@mpc_dat,@mpc_rmk,@mpc_typ,@cur_id,@mpc_rat,@mpc_dc,@usr_id,GETDATE())

		set @mpc_no_out=@mpc_no
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO
--sp_help t_mpc
--alter table t_mpc alter column mpc_chq int


----Update Master Voucher
alter proc [dbo].[upd_t_mpc](@com_id char(2),@br_id char(3),@yr_id char(2),@mpc_no int,@mpc_dat datetime,@mpc_rmk varchar(100),@cur_id int,@mpc_rat float,@mpc_typ char(1),@mpc_dc bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'

update t_mpc 
		set mpc_dat=@mpc_dat,mpc_rmk=@mpc_rmk,cur_id=@cur_id,mpc_rat=@mpc_rat,mpc_typ=@mpc_typ,mpc_dc=@mpc_dc,upd_usr_id=@usr_id,upd_dat=GETDATE() 
		where mpc_no=@mpc_no


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete Voucher
alter proc [dbo].[del_t_pc](@com_id char(2),@br_id char(3),@yr_id char(2),@mpc_no int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
set @aud_act='Delete'
				delete from t_dpc where mpc_no=@mpc_no
				delete from t_mpc where mpc_dat=@mpc_no
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end


GO
--select * from tbl_aud1 order by aud_dat


