USE ZSONS
GO


--Insert
alter proc [dbo].[ins_t_sm1](@com_id char(2),@br_id char(3),@m_yr_id char(2),@sm1_dat datetime,@sm1_act bit,@sm1_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@sm1_id_out int output)
as
declare
@sm1_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @sm1_id=(select max(sm1_id)+1 from t_sm1)
		if @sm1_id is null
			begin
				set @sm1_id=1
			end
			

				
	insert into t_sm1(m_yr_id,sm1_id,sm1_dat,sm1_act,sm1_typ )
			values(@m_yr_id,@sm1_id,@sm1_dat,@sm1_act,@sm1_typ)
		set @sm1_id_out=@sm1_id
		
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

	
end
GO

--Update
alter proc [dbo].[upd_t_sm1](@com_id char(2),@br_id char(3),@m_yr_id char(2),@sm1_id int,@sm1_dat datetime,@sm1_act bit,@sm1_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update t_sm1 set sm1_dat=@sm1_dat,sm1_act=@sm1_act,sm1_typ=@sm1_typ where sm1_id=@sm1_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO



--exec del_t_sm1 13

--Delete
alter proc [dbo].[del_t_sm1](@com_id char(2),@br_id char(3),@m_yr_id char(2),@sm1_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	
	--Delete Detail FG
	exec del_t_dsm1 @sm1_id
	--Delete Master FG
	delete t_sm1 where sm1_id=@sm1_id
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		

