USE zsons
GO

--alter table t_mdptot drop column dpt_id
--alter table t_mdptot drop constraint FK_tmdptot_dptID
--alter table t_mdptot add memp_sub_id int
--alter table t_mdptot add constraint FK_tmdptot_mempsubID foreign key (memp_sub_id) references m_emp_sub(memp_sub_id)

---Insert
alter proc [dbo].[ins_t_mdptot](@mdptot_dat datetime,@mdptot_hrs float,@memp_sub_id int,@mdptot_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@mdptot_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mdptot_id			int,
@aud_act			char(20)
begin
	set @mdptot_id =(select max(mdptot_id) from t_mdptot)+1
	set @aud_act='Insert'

	if (@mdptot_id is null)
		begin	
			set @mdptot_id=1
		end

	insert into t_mdptot (mdptot_id,mdptot_dat,mdptot_hrs,memp_sub_id,mdptot_typ)
	values
	(@mdptot_id,@mdptot_dat,@mdptot_hrs,@memp_sub_id,@mdptot_typ)

	set @mdptot_id_out=@mdptot_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete
alter proc [dbo].[del_t_mdptot](@com_id char(2),@br_id char(3),@mdptot_dat datetime,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from t_mdptot  
			where mdptot_dat=@mdptot_dat
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_mdptot
