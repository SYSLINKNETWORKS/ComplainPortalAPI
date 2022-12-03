USE MFI
GO
--alter table gl_t_mstd_cos add itmqty_id int

--Insert
alter proc [dbo].[ins_t_mstdcos](@com_id char(2),@br_id char(3),@mstdcos_dat datetime,@mstdcos_typ char(1),@titm_id int,@itmqty_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mstdcos_id_out int output)
as
declare
@mstdcos_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mstdcos_id=(select max(mstdcos_id)+1 from t_mstdcos)
		if @mstdcos_id is null
			begin
				set @mstdcos_id=1
			end
	insert into t_mstdcos(mstdcos_id,mstdcos_dat,mstdcos_typ,titm_id,itmqty_id )
			values(@mstdcos_id,@mstdcos_dat,@mstdcos_typ,@titm_id,@itmqty_id)
		set @mstdcos_id_out=@mstdcos_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

	
end
GO

--Update
alter proc [dbo].[upd_t_mstdcos](@com_id char(2),@br_id char(3),@mstdcos_id int,@mstdcos_dat datetime,@mstdcos_typ char(1),@titm_id int,@itmqty_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update t_mstdcos set mstdcos_dat=@mstdcos_dat,mstdcos_typ=@mstdcos_typ,titm_id=@titm_id,itmqty_id=@itmqty_id where mstdcos_id=@mstdcos_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO



--exec del_gl_t_mstd_cos 13

--Delete
alter proc [dbo].[del_t_mstdcos](@com_id char(2),@br_id char(3),@mstdcos_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	exec del_t_dstdcos_exp @mstdcos_id
	exec del_t_dstdcos_rm @mstdcos_id
	exec del_t_dstdcos_pk @mstdcos_id
	delete t_mstdcos where mstdcos_id=@mstdcos_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

