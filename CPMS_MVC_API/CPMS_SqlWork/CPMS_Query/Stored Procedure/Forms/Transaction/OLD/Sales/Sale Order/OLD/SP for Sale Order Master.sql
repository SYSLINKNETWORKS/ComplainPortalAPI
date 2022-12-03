USE ZSONS
GO


--Insert
alter proc ins_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_dat datetime,@mso_cuspo varchar(250),@mso_podat datetime,@mso_ddat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_soapp bit,@mso_can bit,@mso_typ char(1),@emppro_macid int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mso_no_out int output,@mso_id_out int output)
as
declare
@mso_id int,
@mso_no int,
@emppro_id int,
@aud_act char(10),
@mso_app bit,
@usr_dat datetime,
@cur_id int,
@mso_currat float
begin
	set @mso_app=0
	set @usr_dat =GETDATE()
	set @aud_act='Insert'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mso_currat=1

	set @mso_id=(select max(mso_id)+1 from t_mso )
		if @mso_id is null
			begin
				set @mso_id=1
			end

	set @mso_no=(select max(mso_no)+1 from t_mso )
		if @mso_no is null
			begin
				set @mso_no=1
			end


	if (@mso_can =1)
		begin
			set @mso_app=0
		end
	else if (@mso_soapp=1)
		begin
			set @mso_app=1
		end
	insert into t_mso(com_id,br_id,m_yr_id,mso_id,mso_no,mso_dat,mso_cuspo,mso_podat,mso_ddat,mso_rmk,mso_currat,mso_amt,mso_disper,mso_disamt,mso_freamt,mso_othamt,mso_namt,mso_act,mso_app,mso_soapp,mso_can,mso_typ,ins_usr_id,ins_usr_dat,emppro_id,cus_id,cur_id,men_nam,usr_ip)
			values(@com_id,@br_id,@m_yr_id,@mso_id,@mso_no,@mso_dat,@mso_cuspo,@mso_podat,@mso_ddat,@mso_rmk,@mso_currat,@mso_amt,@mso_disper,@mso_disamt,@mso_freamt,@mso_othamt,@mso_namt,@mso_act,@mso_app,@mso_soapp,@mso_can,@mso_typ,@usr_id,@usr_dat,@emppro_id,@cus_id,@cur_id,@aud_frmnam,@aud_ip)
	set @mso_id_out=@mso_id
	set @mso_no_out=@mso_no

--Audit
	set @aud_des='ID # '+rtrim(cast(@mso_id as char(1000)))+' '+@aud_des 
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_id int,@mso_no int,@mso_dat datetime,@mso_cuspo varchar(250),@mso_podat datetime,@mso_ddat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_soapp bit,@mso_can bit,@mso_typ char(1),@emppro_macid int,@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mso_app bit,
@usr_dat datetime,
@emppro_id int,
@cur_id int,
@mso_currat float
begin
	set @mso_app=0
	set @usr_dat =GETDATE()
	set @aud_act='Update'
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mso_currat=1
	
	if (@mso_can =1)
		begin
			set @mso_app=0
		end
	else if (@mso_soapp=1)
		begin
			set @mso_app=1
		end
		
	update t_mso set mso_no=@mso_no,mso_dat=@mso_dat ,mso_cuspo=@mso_cuspo,mso_podat=@mso_podat,mso_ddat=@mso_ddat,mso_rmk=@mso_rmk,mso_currat=@mso_currat,mso_amt=@mso_amt,mso_disper=@mso_disper,mso_disamt=@mso_disamt,mso_freamt=@mso_freamt,mso_othamt=@mso_othamt,mso_namt=@mso_namt,mso_act=@mso_act,
								mso_app=@mso_app,mso_soapp=@mso_soapp,mso_can=@mso_can,mso_typ=@mso_typ,upd_usr_id=@usr_id,upd_usr_dat=@usr_dat,emppro_id=@emppro_id,cus_id=@cus_id,cur_id=@cur_id,men_nam=@aud_frmnam,usr_ip=@aud_ip
							where mso_id=@mso_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'

	exec del_t_dso_pat @mso_id 
	exec del_t_dso @mso_id 
	delete t_mso where mso_id=@mso_id 

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from rm_det


