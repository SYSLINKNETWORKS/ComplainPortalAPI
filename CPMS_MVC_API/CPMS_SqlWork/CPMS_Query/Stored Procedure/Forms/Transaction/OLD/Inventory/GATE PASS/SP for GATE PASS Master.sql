USE MFI
GO

--alter table t_mgp add itm_id int
--alter table t_mgp add constraint FK_TMGP_ITMCATID foreign key(itm_id) references m_itm(itm_id)

--Insert
alter   proc ins_t_mgp(@com_id char(2),@br_id char(3),@mgp_dat datetime,@mgp_typ char(1),@itm_id int,@emppro_no int,@m_yr_id char(2),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mgp_id_out int output)
as
declare
@mgp_id int,
@emppro_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_no)
	set @mgp_id=(select max(mgp_id)+1 from t_mgp )
		if @mgp_id is null
			begin
				set @mgp_id=1
			end
	insert into t_mgp(mgp_id,mgp_dat,emppro_id,mgp_typ,m_yr_id,itm_id )
			values(@mgp_id,@mgp_dat,@emppro_id,@mgp_typ,@m_yr_id,@itm_id)
	set @mgp_id_out=@mgp_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter   proc upd_t_mgp(@com_id char(2),@br_id char(3),@mgp_id int,@emppro_no int,@mgp_dat datetime,@mgp_typ char(1),@m_yr_id char(2),@itm_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@emppro_id int
begin
	set @aud_act='Update'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_no)
	update t_mgp set mgp_dat=@mgp_dat,emppro_id=@emppro_id,mgp_typ=@mgp_typ,itm_id=@itm_id where mgp_id=@mgp_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go

--Delete

alter   proc del_t_mgp(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mgp_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_id char(12)
begin
	set @aud_act='Delete'
	set @mvch_id=(select mvch_id from t_mgp where mgp_id=@mgp_id)
	--Delete Voucher
	exec del_t_vch @com_id,@br_id,@mvch_id,'05',@m_yr_id,'C',0,@aud_frmnam,@aud_des,@usr_id,@aud_ip
	--Delete Detail
	exec del_t_dgp @mgp_id
	--Delete Master
	delete t_mgp where mgp_id=@mgp_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from rm_det
