USE CPMS
GO

	--alter table t_mcomp add ins_dat datetime
	--alter table t_mcomp add mcomp_can_rmk varchar(250)

alter proc ins_t_mcomp(@com_id char(2),@br_id char(3),@mcomp_dat datetime,@mcomp_comp varchar(max),@mcomp_can bit,@mcomp_typ char(1),@mcomp_rmk varchar(1000),@mcomp_comp_by varchar(250),@mcomp_pr char(1),@mcomp_att int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mcomp_no_out int output,@mcomp_id_out int output)
as
declare
@mcomp_id int,
@mcomp_no int,
@usr_id_can int,
@mcomp_dat_can datetime,
@aud_act char(10)
begin
	set @aud_act ='Insert'
	set @mcomp_id=isnull((select max(mcomp_id)+1 from t_mcomp),1)
	set @mcomp_no=@mcomp_id--isnull((select max(mcomp_id)+1 from t_mcomp where com_id=@com_id and br_id=@br_id),1)

	if (@mcomp_can =1)
		begin
			set @mcomp_dat_can=GETDATE()
			set @usr_id_can=@usr_id
		end
	else
		begin
			set @mcomp_dat_can=null
			set @usr_id_can=null
		end

	insert into t_mcomp
			(com_id,br_id,mcomp_id,mcomp_no,mcomp_dat,mcomp_comp,mcomp_can,mcomp_typ,usr_id,usr_id_can,mcomp_dat_can,mcomp_rmk,mcomp_comp_by,mcomp_pr,mcomp_att)
		 values(@com_id,@br_id,@mcomp_id,@mcomp_no,@mcomp_dat,@mcomp_comp,@mcomp_can,@mcomp_typ,@usr_id,@usr_id_can,@mcomp_dat_can,@mcomp_rmk,@mcomp_comp_by,@mcomp_pr,@mcomp_att)

		set @mcomp_no_out=@mcomp_no
		set @mcomp_id_out=@mcomp_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
	--exec del_t_dcomp_img

end	
go

--Update
alter proc upd_t_mcomp(@com_id char(2),@br_id char(3),@mcomp_id int,@mcomp_dat datetime,@mcomp_comp varchar(max),@mcomp_can bit,@mcomp_typ char(1),@mcomp_rmk varchar(1000),@mcomp_comp_by varchar(250),@mcomp_pr char(1),@mcomp_act_rmk varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@usr_id_can int,
@mcomp_dat_can datetime,
@aud_act char(10)
begin
	set @aud_act ='Insert'

	if (@mcomp_can =1)
		begin
			set @mcomp_dat_can=GETDATE()
			set @usr_id_can=@usr_id
		end
	else
		begin
			set @mcomp_dat_can=null
			set @usr_id_can=null
		end

	update t_mcomp set mcomp_dat=@mcomp_dat,mcomp_comp=@mcomp_comp,@mcomp_typ=@mcomp_typ,usr_id_can=@usr_id_can,mcomp_dat_can=@mcomp_dat_can,mcomp_rmk=@mcomp_rmk,mcomp_comp_by=@mcomp_comp_by,mcomp_pr=@mcomp_pr,mcomp_act_rmk=@mcomp_act_rmk
		where mcomp_id=@mcomp_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end	
go

--Email Send
alter proc upd_t_mcomp_eml(@com_id char(2),@br_id char(3),@mcomp_id int,@mcomp_mail bit)
as
declare
@usr_id_can int,
@mcomp_dat_can datetime,
@aud_act char(10),
@mcomp_can bit,
@usr_id int,
@mcomp_dat datetime,
@mcomp_comp varchar(1000),
@mcomp_typ char(1)
begin
	set @aud_act ='Insert'
	set @mcomp_can=(select mcomp_can from t_mcomp where mcomp_id=@mcomp_id)
	set @usr_id=(select usr_id from t_mcomp where mcomp_id=@mcomp_id)
	set @mcomp_dat=(select mcomp_dat from t_mcomp where mcomp_id=@mcomp_id)
	set @mcomp_comp=(select mcomp_comp from t_mcomp where mcomp_id=@mcomp_id)
	set @mcomp_typ=(select mcomp_typ from t_mcomp where mcomp_id=@mcomp_id)

	if (@mcomp_can =1)
		begin
			set @mcomp_dat_can=GETDATE()
			set @usr_id_can=@usr_id
		end
	else
		begin
			set @mcomp_dat_can=null
			set @usr_id_can=null
		end

	update t_mcomp set mcomp_dat=@mcomp_dat,mcomp_comp=@mcomp_comp,@mcomp_typ=@mcomp_typ,usr_id_can=@usr_id_can,mcomp_dat_can=@mcomp_dat_can
		where mcomp_id=@mcomp_id
--Audit
	--exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end	
go

alter proc upd_t_mcomp_ck(@com_id char(2),@br_id char(3),@mcomp_id int,@mcomp_ck bit,@mcomp_ck_rmk varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act ='Insert'

	--if (@mcomp_ck=0 and @mcomp_app=1)
	--	begin
	--		set @mcomp_ck=1
	--	end
	update t_mcomp set mcomp_ck=@mcomp_ck,mcomp_dat_ck=GETDATE(),mcomp_ck_rmk=@mcomp_ck_rmk,usr_id_app=@usr_id,usr_id_ck=@usr_id
	where mcomp_id=@mcomp_id
--Audit
	--exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
go

alter proc upd_t_mcomp_app(@com_id char(2),@br_id char(3),@mcomp_id int,@mcomp_app bit,@mcomp_app_rmk varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mcomp_ck bit
begin
	set @aud_act ='Insert'
	set @mcomp_ck=(select mcomp_ck from t_mcomp where mcomp_id=@mcomp_id)

	if (@mcomp_ck=0 and @mcomp_app=1)
		begin
			set @mcomp_ck=1
		end
	update t_mcomp set mcomp_ck=@mcomp_ck,mcomp_app=@mcomp_app,mcomp_dat_app=GETDATE(),mcomp_app_rmk=@mcomp_app_rmk,usr_id_app=@usr_id,usr_id_ck=@usr_id
	where mcomp_id=@mcomp_id
--Audit
	--exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
go

alter proc upd_t_mcomp_act(@com_id char(2),@br_id char(3),@mcomp_id int,@mcomp_act bit,@mcomp_act_rmk varchar(1000),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act ='Insert'

	update t_mcomp set mcomp_act=@mcomp_act,mcomp_dat_act=GETDATE(),mcomp_act_rmk=@mcomp_act_rmk,usr_id_act=@usr_id
	where mcomp_id=@mcomp_id
--Audit
	--exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
go

--Delete
alter proc del_t_mcomp(@com_id char(3),@br_id char(3),@mcomp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act ='Delete'
	exec del_t_dcomp_img @mcomp_id 
	delete from t_mcomp where mcomp_id=@mcomp_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

GO
