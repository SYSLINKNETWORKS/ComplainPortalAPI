
USE MFI
GO
--select * from t_mprtexp


--Insert
alter proc [dbo].[ins_t_mprtexp](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mprtexp_dat datetime,@itmsub_id int,@bd_id int,@mprtexp_typ char(1),@mprtexp_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mprtexp_id_out int output)
as
declare
@mprtexp_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mprtexp_id=(select max(mprtexp_id)+1 from t_mprtexp)
		if @mprtexp_id is null
			begin
				set @mprtexp_id=1
			end
			
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end
	insert into t_mprtexp(mprtexp_id,mprtexp_dat,itmsub_id,bd_id,mprtexp_typ,mprtexp_rmk )
			values(@mprtexp_id,@mprtexp_dat,@itmsub_id,@bd_id,@mprtexp_typ,@mprtexp_rmk)
		set @mprtexp_id_out=@mprtexp_id
		
		
					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mprtexp](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mprtexp_id int,@mprtexp_dat datetime,@itmsub_id int,@bd_id int,@mprtexp_typ char(1),@mprtexp_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end


	update t_mprtexp set mprtexp_dat=@mprtexp_dat,itmsub_id=@itmsub_id,bd_id=@bd_id,mprtexp_typ=@mprtexp_typ,mprtexp_rmk=@mprtexp_rmk where mprtexp_id=@mprtexp_id	
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mprtexp 1

--Delete
alter proc [dbo].[del_t_mprtexp](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mprtexp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(20)
begin
	set @aud_act='Delete'
	delete from m_stk where stk_frm ='stk_prtexp' and t_id=@mprtexp_id
	delete t_dprtexp where mprtexp_id=@mprtexp_id	
	delete t_mprtexp where mprtexp_id=@mprtexp_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		



