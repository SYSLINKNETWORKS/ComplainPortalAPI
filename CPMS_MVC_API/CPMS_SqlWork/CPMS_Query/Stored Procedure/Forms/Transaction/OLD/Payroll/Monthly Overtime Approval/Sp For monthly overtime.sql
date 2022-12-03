USE phm
GO



--Insert
create proc [dbo].[ins_t_otemp](@com_id char(2),@br_id char(3),@m_yr_id char(3),@otemp_dat datetime,@otemp_apphrs float,@emppro_id int,@otemp_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@otemp_id			int,
@aud_act			char(20)
begin
	set @otemp_id =(select max(otemp_id) from t_otemp)+1
	set @aud_act='Insert'

	if (@otemp_id is null)
		begin	
			set @otemp_id=1
		end

	insert into t_otemp (com_id,br_id,m_yr_id,otemp_id,otemp_dat,otemp_apphrs,emppro_id,otemp_typ,otemp_app)
	values
	(@com_id,@br_id,@m_yr_id,@otemp_id,@otemp_dat,@otemp_apphrs,@emppro_id,@otemp_typ,0)


--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
create proc [dbo].[del_t_otemp](@com_id char(2),@br_id char(3),@m_yr_id char(2),@otemp_dat datetime,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from t_otemp  
			where otemp_dat=@otemp_dat 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--select * from t_otemp
