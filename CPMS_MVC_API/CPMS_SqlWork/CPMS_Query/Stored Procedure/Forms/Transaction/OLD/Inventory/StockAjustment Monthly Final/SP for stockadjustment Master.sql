
USE ROUGH
GO
--select * from t_mstkadjmon


--Insert
alter proc [dbo].[ins_t_mstkadjmon](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmon_dat datetime,@itm_id int,@itmsub_id int,@mstkadjmon_typ char(1),@mstkadjmon_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mstkadjmon_id_out int output)
as
declare
@mstkadjmon_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mstkadjmon_id=(select max(mstkadjmon_id)+1 from t_mstkadjmon)
		if @mstkadjmon_id is null
			begin
				set @mstkadjmon_id=1
			end
			
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end
			
	insert into t_mstkadjmon(mstkadjmon_id,mstkadjmon_dat,itm_id,itmsub_id,mstkadjmon_typ,mstkadjmon_rmk )
			values(@mstkadjmon_id,@mstkadjmon_dat,@itm_id,@itmsub_id,@mstkadjmon_typ,@mstkadjmon_rmk)
		set @mstkadjmon_id_out=@mstkadjmon_id
		
		
					
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_mstkadjmon](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmon_id int,@mstkadjmon_dat datetime,@itm_id int,@itmsub_id int,@mstkadjmon_typ char(1),@mstkadjmon_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
			if (@itmsub_id=0)
				begin
					set @itmsub_id=null
				end


	update t_mstkadjmon set mstkadjmon_dat=@mstkadjmon_dat,itm_id=@itm_id,itmsub_id=@itmsub_id,mstkadjmon_typ=@mstkadjmon_typ,mstkadjmon_rmk=@mstkadjmon_rmk where mstkadjmon_id=@mstkadjmon_id	
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--exec del_t_mstkadjmon 1

--Delete
alter proc [dbo].[del_t_mstkadjmon](@com_id char(2),@br_id char(3),@m_yr_id char(2),@mstkadjmon_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(20)
begin
	set @aud_act='Delete'
	set @mvch_id=(select mvch_id from t_mstkadjmon where mstkadjmon_id=@mstkadjmon_id	 )

	exec del_t_vch @com_id,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des,@usr_id,@aud_ip	
	delete from m_stk where stk_frm ='stk_adjmon' and t_id=@mstkadjmon_id
	delete t_dstkadjmon where mstkadjmon_id=@mstkadjmon_id	
	delete t_mstkadjmon where mstkadjmon_id=@mstkadjmon_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		



