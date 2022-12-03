USE nathi
GO

--Insert
alter proc ins_t_mclaim(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mclaim_recfrm varchar(250),@mclaim_dat datetime,@mclaim_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mclaim_id_out int output)
as
declare
@mclaim_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mclaim_id=(select max(mclaim_id)+1 from t_mclaim )
		if @mclaim_id is null
			begin
				set @mclaim_id=1
			end
	insert into t_mclaim(com_id,br_id,m_yr_id,mclaim_id,mclaim_dat,mclaim_recfrm,mclaim_typ)
			values(@com_id,@br_id,@m_yr_id,@mclaim_id,@mclaim_dat,@mclaim_recfrm,@mclaim_typ)
	set @mclaim_id_out=@mclaim_id
	
	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		
go
--Update
alter proc upd_t_mclaim(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mclaim_id int,@mclaim_recfrm varchar(250),@mclaim_dat datetime,@mclaim_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
   set @aud_act='Update'
	update t_mclaim set mclaim_recfrm=@mclaim_recfrm,mclaim_dat=@mclaim_dat,mclaim_typ=@mclaim_typ,m_yr_id=@m_yr_id
	where mclaim_id=@mclaim_id and com_id=@com_id and br_id=@br_id
	--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

go
--Delete

alter  proc del_t_mclaim(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mclaim_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
set @aud_act='Delete'	
	exec del_t_dclaim @mclaim_id
	delete t_mclaim where mclaim_id=@mclaim_id 
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		
--select * from rm_det

