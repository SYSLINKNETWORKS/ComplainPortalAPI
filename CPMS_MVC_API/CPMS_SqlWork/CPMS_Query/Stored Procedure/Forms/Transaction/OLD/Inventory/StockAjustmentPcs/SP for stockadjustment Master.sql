
USE rough
GO
--select * from t_mstkadj


--Insert
alter proc [dbo].[ins_t_mstkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadj_dat datetime,@mstkadj_fdat datetime,@mstkadj_tdat datetime,@itm_id int,@itmsub_id int,@mstkadj_typ char(1),@mstkadj_pc bit,@mstkadj_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mstkadj_id_out int output)
as
declare
@mstkadj_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mstkadj_id=(select max(mstkadj_id)+1 from t_mstkadj)
		if @mstkadj_id is null
			begin
				set @mstkadj_id=1
			end
			
	insert into t_mstkadj(mstkadj_id,mstkadj_dat,mstkadj_fdat,mstkadj_tdat,mstkadj_pc,itm_id,itmsub_id,mstkadj_typ,mstkadj_rmk )
			values(@mstkadj_id,@mstkadj_dat,@mstkadj_fdat,@mstkadj_tdat,@mstkadj_pc,@itm_id,@itmsub_id,@mstkadj_typ,@mstkadj_rmk)
		set @mstkadj_id_out=@mstkadj_id
		
		
					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mstkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadj_id int,@mstkadj_dat datetime,@mstkadj_fdat datetime,@mstkadj_tdat datetime,@itm_id int,@itmsub_id int,@mstkadj_typ char(1),@mstkadj_pc bit,@mstkadj_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'


	update t_mstkadj set mstkadj_dat=@mstkadj_dat,mstkadj_fdat=@mstkadj_fdat,mstkadj_tdat=@mstkadj_tdat,itm_id=@itm_id,mstkadj_pc=@mstkadj_pc,itmsub_id=@itmsub_id,mstkadj_typ=@mstkadj_typ,mstkadj_rmk=@mstkadj_rmk where mstkadj_id=@mstkadj_id	
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mstkadj 1

--Delete
alter proc [dbo].[del_t_mstkadj](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadj_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'

	--delete from m_stk where stk_frm ='TransRM' and t_id=@mstkadj_id 
	exec del_t_dstkadj @mstkadj_id
	delete t_mstkadj where mstkadj_id=@mstkadj_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		




