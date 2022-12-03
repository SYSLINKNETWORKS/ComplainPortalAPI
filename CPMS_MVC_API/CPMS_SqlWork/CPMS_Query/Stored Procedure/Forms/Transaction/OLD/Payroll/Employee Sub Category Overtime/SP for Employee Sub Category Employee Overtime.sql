USE zsons
GO



--Insert
alter proc [dbo].[ins_t_ddptot](@ddptot_dat datetime,@ddptot_min float,@emppro_id int,@ddptot_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@ddptot_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@ddptot_id			int,
@aud_act			char(20)
begin
	set @ddptot_id =(select max(ddptot_id) from t_ddptot)+1
	set @aud_act='Insert'

	if (@ddptot_id is null)
		begin	
			set @ddptot_id=1
		end

	insert into t_ddptot (ddptot_id,ddptot_dat,ddptot_min,emppro_id,ddptot_typ)
	values
	(@ddptot_id,@ddptot_dat,@ddptot_min,@emppro_id,@ddptot_typ)

	set @ddptot_id_out=@ddptot_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO


--Delete
alter proc [dbo].[del_t_ddptot](@com_id char(2),@br_id char(3),@ddptot_dat datetime,@memp_sub_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from t_ddptot  
			where ddptot_dat=@ddptot_dat and emppro_id in (select emppro_id from m_emppro where memp_sub_id=@memp_sub_id)
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_ddptot
