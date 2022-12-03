USE phm
GO
--alter table t_mdc add mdc_drv varchar(250),mdc_ckdel bit,mdc_delnam varchar(250),mdc_delpho varchar(250),mdc_deladd varchar(250)
--update t_mdc set mdc_drv='',mdc_ckdel=0,mdc_delnam='',mdc_delpho='',mdc_deladd=''

--6
--alter table t_mdc add emppro_id int
--ALTER table t_mdc add constraint FK_TMDC_EMPPROID foreign key (emppro_id) references m_Emppro (emppro_id)
--alter table t_mdc add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table t_mdc add carr_id int,mdc_bltyno varchar(100),mdc_bltydat datetime 

--Insert
alter proc ins_t_mdc(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mdc_dat datetime,@mdc_deptime datetime,@mdc_vno varchar(250),@mdc_drv char(250),@mdc_typ char(1),@mdc_act bit,@mso_no int,@wh_id int, @mdc_rmk varchar(250),@mdc_ckdel bit,@mdc_delnam varchar(250),@mdc_delpho varchar(250),@mdc_deladd varchar(250),@carr_id int,@mdc_bltyno varchar(100),@mdc_bltydat datetime,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mdc_no_out int output, @mdc_id_out int output)
as
declare
@mdc_id int,
@mdc_no int,
@mso_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	
	set @mso_id=(select mso_id from t_mso where mso_no=@mso_no)
	set @mdc_id=(select max(mdc_id)+1 from t_mdc)
		if @mdc_id is null
			begin
				set @mdc_id=1
			end
	set @mdc_no=(select max(mdc_no)+1 from t_mdc)
		if @mdc_no is null
			begin
				set @mdc_no=1
			end
	if (@mdc_ckdel=0)
		begin
			set @mdc_delnam=''
			set @mdc_delpho=''
			set @mdc_deladd=''
		end
	insert into t_mdc(com_id,br_id,m_yr_id,mdc_id,mdc_no,mdc_dat,mdc_typ,mdc_act,mso_id,wh_id,mdc_rmk,mdc_vno,mdc_drv,mdc_deptime,mdc_ckdel,mdc_delnam,mdc_delpho,mdc_deladd,carr_id,mdc_bltyno,mdc_bltydat,log_act,log_dat,usr_id,log_ip)
				values(@com_id,@br_id,@m_yr_id,@mdc_id,@mdc_no,@mdc_dat,@mdc_typ,0,@mso_id,@wh_id,@mdc_rmk,@mdc_vno,@mdc_drv,@mdc_deptime,@mdc_ckdel,@mdc_delnam,@mdc_delpho,@mdc_deladd,@carr_id,@mdc_bltyno,@mdc_bltydat,@log_act,@log_dat,@usr_id,@log_ip)
	set @mdc_id_out=@mdc_id
	set @mdc_no_out=@mdc_no

set @log_newval= 'ID=' + cast(@mdc_id as varchar) + '-' + cast(@log_newval as varchar(max))

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat


end
		
go
--Update
alter proc upd_t_mdc(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mdc_id int,@mdc_dat datetime,@mdc_deptime datetime,@mdc_vno varchar(250),@mdc_drv varchar(250),@mdc_typ char(1),@mdc_act bit,@wh_id int, @mdc_rmk varchar(250),@mdc_ckdel bit,@mdc_delnam varchar(250),@mdc_delpho varchar(250),@mdc_deladd varchar(250),@carr_id int,@mdc_bltyno varchar(100),@mdc_bltydat datetime,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	

		if (@mdc_ckdel=0)
		begin
			set @mdc_delnam=''
			set @mdc_delpho=''
			set @mdc_deladd=''
		end

	update t_mdc set mdc_dat=@mdc_dat,mdc_typ=@mdc_typ,wh_id=@wh_id,mdc_rmk=@mdc_rmk,mdc_deptime=@mdc_deptime,mdc_vno=@mdc_vno,mdc_drv=@mdc_drv,mdc_ckdel=@mdc_ckdel,mdc_delnam=@mdc_delnam,mdc_delpho=@mdc_delpho,mdc_deladd=@mdc_deladd,carr_id=@carr_id,mdc_bltyno=@mdc_bltyno,mdc_bltydat=@mdc_bltydat,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
	where mdc_id=@mdc_id

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
go

--Delete
alter proc del_t_mdc(@mdc_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mso_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()
	set @mso_id=(select mso_id from t_mdc where mdc_id=@mdc_id)
	

	exec del_t_ddc @mdc_id	 
	update t_mdc set log_act=@log_act where mdc_id=@mdc_id 
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
		
--select * from rm_det
