USE ZSONS
GO
--alter table t_mpso add mpso_ckdel bit,mpso_delnam varchar(250),mpso_delpho varchar(250),mpso_deladd varchar(250)
--update t_mpso set mpso_ckdel=0,mpso_delnam='',mpso_delpho='',mpso_deladd=''


--Insert
alter proc ins_t_mpso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_dat datetime,@mpso_ddat datetime,@mpso_rmk varchar(250),@mpso_amt float,@mpso_disper float,@mpso_disamt float,@mpso_freamt float,@mpso_othamt float,@mpso_namt float,@mpso_act bit,@mpso_can bit,@mpso_ckdel bit,@mpso_delnam varchar(250),@mpso_delpho varchar(250),@mpso_deladd varchar(250),@mpso_typ char(1),@emppro_macid int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mpso_no_out int output,@mpso_id_out int output)
as
declare
@mpso_id int,
@mpso_no int,
@emppro_id int,
@aud_act char(10),
@mpso_app bit,
@usr_dat datetime,
@cur_id int,
@mpso_currat float
begin
	set @mpso_app=0
	set @usr_dat =GETDATE()
	set @aud_act='Insert'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mpso_currat=1

	set @mpso_id=(select max(mpso_id)+1 from t_mpso )
		if @mpso_id is null
			begin
				set @mpso_id=1
			end

	set @mpso_no=(select max(mpso_no)+1 from t_mpso )
		if @mpso_no is null
			begin
				set @mpso_no=1
			end


	if (@mpso_can =1)
		begin
			set @mpso_app=0
		end
	if (@mpso_ckdel=0)
		begin
			set @mpso_delnam=''
			set @mpso_delpho=''
			set @mpso_deladd=''
		end

	insert into t_mpso(com_id,br_id,m_yr_id,mpso_id,mpso_no,mpso_dat,mpso_ddat,mpso_rmk,mpso_currat,mpso_amt,mpso_disper,mpso_disamt,mpso_freamt,mpso_othamt,mpso_namt,mpso_act,mpso_ckdel,mpso_delnam,mpso_delpho,mpso_deladd,mpso_app,mpso_can,mpso_typ,ins_usr_id,ins_usr_dat,emppro_id,cus_id,cur_id,men_nam,usr_ip)
			values(@com_id,@br_id,@m_yr_id,@mpso_id,@mpso_no,@mpso_dat,@mpso_ddat,@mpso_rmk,@mpso_currat,@mpso_amt,@mpso_disper,@mpso_disamt,@mpso_freamt,@mpso_othamt,@mpso_namt,@mpso_act,@mpso_ckdel,@mpso_delnam,@mpso_delpho,@mpso_deladd,@mpso_app,@mpso_can,@mpso_typ,@usr_id,@usr_dat,@emppro_id,@cus_id,@cur_id,@aud_frmnam,@aud_ip)
	set @mpso_id_out=@mpso_id
	set @mpso_no_out=@mpso_no

--Audit
	set @aud_des='ID # '+rtrim(cast(@mpso_id as char(1000)))+' '+@aud_des 
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_mpso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_id int,@mpso_no int,@mpso_dat datetime,@mpso_ddat datetime,@mpso_rmk varchar(250),@mpso_amt float,@mpso_disper float,@mpso_disamt float,@mpso_freamt float,@mpso_othamt float,@mpso_namt float,@mpso_act bit,@mpso_can bit,@mpso_ckdel bit,@mpso_delnam varchar(250),@mpso_delpho varchar(250),@mpso_deladd varchar(250),@mpso_typ char(1),@emppro_macid int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mpso_app bit,
@usr_dat datetime,
@emppro_id int,
@cur_id int,
@mpso_currat float
begin
	set @mpso_app=0
	set @usr_dat =GETDATE()
	set @aud_act='Update'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mpso_currat=1
	
	if (@mpso_can =1)
		begin
			set @mpso_app=0
		end
	if (@mpso_ckdel=0)
		begin
			set @mpso_delnam=''
			set @mpso_delpho=''
			set @mpso_deladd=''
		end

	update t_mpso set mpso_no=@mpso_no,mpso_dat=@mpso_dat,mpso_ddat=@mpso_ddat,mpso_rmk=@mpso_rmk,mpso_currat=@mpso_currat,mpso_amt=@mpso_amt,mpso_disper=@mpso_disper,mpso_disamt=@mpso_disamt,mpso_freamt=@mpso_freamt,mpso_othamt=@mpso_othamt,mpso_namt=@mpso_namt,mpso_act=@mpso_act,
								mpso_ckdel=@mpso_ckdel,mpso_delnam=@mpso_delnam,mpso_delpho=@mpso_delpho,mpso_deladd=@mpso_deladd,
								mpso_app=@mpso_app,mpso_can=@mpso_can,mpso_typ=@mpso_typ,upd_usr_id=@usr_id,upd_usr_dat=@usr_dat,emppro_id=@emppro_id,cus_id=@cus_id,cur_id=@cur_id,men_nam=@aud_frmnam,usr_ip=@aud_ip
							where mpso_id=@mpso_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_mpso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'

	exec del_t_dpso_pat @mpso_id 
	exec del_t_dpso @mpso_id 
	delete t_mpso where mpso_id=@mpso_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from rm_det


