
USE MFI
GO
--select * from t_mpkadj


--Insert
alter proc [dbo].[ins_t_mpkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpkadj_dat datetime,@itmsub_id int,@bd_id int,@mpkadj_typ char(1),@mpkadj_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mpkadj_id_out int output)
as
declare
@mpkadj_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mpkadj_id=(select max(mpkadj_id)+1 from t_mpkadj)
		if @mpkadj_id is null
			begin
				set @mpkadj_id=1
			end
			
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end
			if (@bd_id=0)
				begin
					 set @bd_id=null
				 end
	insert into t_mpkadj(mpkadj_id,mpkadj_dat,itmsub_id,bd_id,mpkadj_typ,mpkadj_rmk )
			values(@mpkadj_id,@mpkadj_dat,@itmsub_id,@bd_id,@mpkadj_typ,@mpkadj_rmk)
		set @mpkadj_id_out=@mpkadj_id
		
		
					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mpkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpkadj_id int,@mpkadj_dat datetime,@itmsub_id int,@bd_id int,@mpkadj_typ char(1),@mpkadj_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end
			if (@bd_id=0)
				begin
					 set @bd_id=null
				 end


	update t_mpkadj set mpkadj_dat=@mpkadj_dat,itmsub_id=@itmsub_id,bd_id=@bd_id,mpkadj_typ=@mpkadj_typ,mpkadj_rmk=@mpkadj_rmk where mpkadj_id=@mpkadj_id	
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mpkadj 1

--Delete
alter proc [dbo].[del_t_mpkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpkadj_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(20)
begin
	set @aud_act='Delete'
	delete from m_stk where stk_frm ='stk_pkadj' and t_id=@mpkadj_id
	delete t_dpkadj where mpkadj_id=@mpkadj_id	
	delete t_mpkadj where mpkadj_id=@mpkadj_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		



