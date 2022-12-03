USE ZSONS
GO
--alter table t_maggvch add emppro_id int
--alter table t_maggvch add constraint FK_MAGGVCH_EMPPROID foreign key (emppro_id) references m_emppro(emppro_id)

--Insert
alter proc ins_t_maggvch(@com_id char(2),@br_id char(3),@m_yr_id char(2),@maggvch_dat datetime,@maggvch_datfrm datetime,@maggvch_datto datetime,@maggvch_typ char(1),@maggvch_act bit,@cus_id int,@emppro_macid int,@maggvch_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@maggvch_no_out int output,@maggvch_id_out int output)
as
declare
@maggvch_id int,
@maggvch_no int,
@emppro_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @maggvch_id=(select max(maggvch_id)+1 from t_maggvch )
		if @maggvch_id is null
			begin
				set @maggvch_id=1
			end

	set @maggvch_no=(select max(maggvch_no)+1 from t_maggvch where com_id=@com_id and m_yr_id=@m_yr_id )
		if @maggvch_no is null
			begin
				set @maggvch_no=1
			end
			
	insert into t_maggvch(com_id,br_id,m_yr_id,maggvch_id,maggvch_no,maggvch_dat,maggvch_datfrm,maggvch_datto,cus_id,emppro_id,maggvch_act,maggvch_typ,ins_usr_id,ins_dat,maggvch_close,maggvch_rmk)
			values(@com_id,@br_id,@m_yr_id,@maggvch_id,@maggvch_no,@maggvch_dat,@maggvch_datfrm,@maggvch_datto,@cus_id,@emppro_id,@maggvch_act,@maggvch_typ,@usr_id,GETDATE(),0,@maggvch_rmk)
	set @maggvch_id_out=@maggvch_id
	set @maggvch_no_out=@maggvch_no

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_maggvch(@com_id char(2),@br_id char(3),@m_yr_id char(2),@maggvch_id int,@maggvch_dat datetime,@maggvch_datfrm datetime,@maggvch_datto datetime,@maggvch_typ char(1),@maggvch_act bit,@cus_id int,@emppro_macid int,@maggvch_rmk varchar(250),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@emppro_id int,
@aud_act char(10)
begin
	set @aud_act='Update'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)

	update t_maggvch set maggvch_dat=@maggvch_dat,maggvch_datfrm=@maggvch_datfrm,maggvch_datto=@maggvch_datto,cus_id=@cus_id,emppro_id=@emppro_id,maggvch_act=@maggvch_act,maggvch_typ=@maggvch_typ,maggvch_rmk=@maggvch_rmk,upd_usr_id=@usr_id,upd_dat=GETDATE() where maggvch_id=@maggvch_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_maggvch(@com_id char(2),@br_id char(3),@m_yr_id char(2),@maggvch_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	exec del_t_daggvch @maggvch_id
	delete t_maggvch where maggvch_id=@maggvch_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from t_maggvch

