USE ZSONS
GO

--Insert
alter proc ins_t_magg(@com_id char(2),@br_id char(3),@m_yr_id char(2),@magg_dat datetime,@magg_datfrm datetime,@magg_datto datetime,@magg_amt float,@magg_typ char(1),@magg_ckamt bit,@magg_act bit,@cus_id int,@magg_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@magg_no_out int output,@magg_id_out int output)
as
declare
@magg_id int,
@magg_no int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @magg_id=(select max(magg_id)+1 from t_magg )
		if @magg_id is null
			begin
				set @magg_id=1
			end

	set @magg_no=(select max(magg_no)+1 from t_magg where com_id=@com_id and m_yr_id=@m_yr_id )
		if @magg_no is null
			begin
				set @magg_no=1
			end
			
	insert into t_magg(com_id,br_id,m_yr_id,magg_id,magg_no,magg_dat,magg_datfrm,magg_datto,magg_amt,cus_id,magg_ckamt,magg_act,magg_typ,ins_usr_id,ins_dat,magg_close,magg_rmk)
			values(@com_id,@br_id,@m_yr_id,@magg_id,@magg_no,@magg_dat,@magg_datfrm,@magg_datto,@magg_amt,@cus_id,@magg_ckamt,@magg_act,@magg_typ,@usr_id,GETDATE(),0,@magg_rmk)
	set @magg_id_out=@magg_id
	set @magg_no_out=@magg_no

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_magg(@com_id char(2),@br_id char(3),@m_yr_id char(2),@magg_id int,@magg_dat datetime,@magg_datfrm datetime,@magg_datto datetime,@magg_amt float,@magg_typ char(1),@magg_ckamt bit,@magg_act bit,@cus_id int,@magg_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update t_magg set magg_dat=@magg_dat,magg_datfrm=@magg_datfrm,magg_datto=@magg_datto,magg_amt=@magg_amt,cus_id=@cus_id,magg_ckamt=@magg_ckamt,magg_act=@magg_act,magg_typ=@magg_typ,magg_rmk=@magg_rmk,upd_usr_id=@usr_id,upd_dat=GETDATE() where magg_id=@magg_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_magg(@com_id char(2),@br_id char(3),@m_yr_id char(2),@magg_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	exec del_t_dagg @magg_id
	delete t_magg where magg_id=@magg_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from rm_det
