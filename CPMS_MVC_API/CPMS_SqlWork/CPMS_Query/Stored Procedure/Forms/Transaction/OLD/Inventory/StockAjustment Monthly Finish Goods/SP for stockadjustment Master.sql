
USE MFI
GO

--select * from t_mstkadjmonfg
--alter table t_mstkadjmonfg add mstkadjmonfg_rmk varchar(250)
--alter table t_mstkadjmonfg add com_id char(2),br_id char(2),m_yr_id char(2)



--Insert
alter proc [dbo].[ins_t_mstkadjmonfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmonfg_dat datetime,@mstkadjmonfg_typ char(1),@mstkadjmonfg_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mstkadjmonfg_id_out int output)
as
declare
@mstkadjmonfg_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mstkadjmonfg_id=(select max(mstkadjmonfg_id)+1 from t_mstkadjmonfg)
		if @mstkadjmonfg_id is null
			begin
				set @mstkadjmonfg_id=1
			end
			
			
	insert into t_mstkadjmonfg(com_id,br_id,m_yr_id,mstkadjmonfg_id,mstkadjmonfg_dat,mstkadjmonfg_typ,mstkadjmonfg_rmk)
			values(@com_id,@br_id,@m_yr_id,@mstkadjmonfg_id,@mstkadjmonfg_dat,@mstkadjmonfg_typ,@mstkadjmonfg_rmk)
		set @mstkadjmonfg_id_out=@mstkadjmonfg_id
		
		
					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mstkadjmonfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmonfg_id int,@mstkadjmonfg_dat datetime,@mstkadjmonfg_typ char(1),@mstkadjmonfg_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'


	update t_mstkadjmonfg set mstkadjmonfg_dat=@mstkadjmonfg_dat,mstkadjmonfg_typ=@mstkadjmonfg_typ,mstkadjmonfg_rmk=@mstkadjmonfg_rmk where mstkadjmonfg_id=@mstkadjmonfg_id	
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mstkadjmonfg 1

--Delete
alter proc [dbo].[del_t_mstkadjmonfg](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmonfg_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(20)
begin
	set @aud_act='Delete'
	set @mvch_id=(select mvch_id from t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id	 )

	exec del_t_vch @com_id,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des,@usr_id,@aud_ip	
	delete from m_stk where stk_frm ='stk_adjmonfg' and t_id=@mstkadjmonfg_id
	delete t_dstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id	
	delete t_mstkadjmonfg where mstkadjmonfg_id=@mstkadjmonfg_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		



