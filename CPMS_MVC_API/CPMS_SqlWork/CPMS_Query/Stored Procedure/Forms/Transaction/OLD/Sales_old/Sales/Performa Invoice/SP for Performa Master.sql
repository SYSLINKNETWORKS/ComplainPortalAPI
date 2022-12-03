USE MFI
GO
--select * from t_mpso
--exec ins_t_mpso '01','01',1,0,'N','08/25/2012','08/25/2012','',1000,'U',0,1,1,'01','','',1,'',1,1,1,1,1,1,1,1,1,''
--Insert
alter proc ins_t_mpso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_no int,@mpso_pso int,@mpso_cat char,@mpso_dat datetime,@mpso_ddat datetime,@mpso_rmk varchar(1000),@mpso_amt float,@mpso_typ char(1),@mpso_act bit,@cus_id int,@cur_id int,@ves_id int,@port_id_des int,@port_id_loc int,@mpso_shptm varchar(100),@mpso_camt float,@mpso_dis float,@mpso_disper float,@mpso_ref float,@mpso_freamt float,@mpso_namt float,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@mpso_id_out int output)
as
declare
@mpso_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @mpso_id=(select max(mpso_id)+1 from t_mpso )
		if @mpso_id is null		
			begin
				set @mpso_id=1
			end
	insert into t_mpso(mpso_id,mpso_no,mpso_pso,mpso_cat,mpso_dat,mpso_ddat,mpso_rmk,mpso_amt,cus_id,cur_id,mpso_act,mpso_typ,m_yr_id,ves_id,port_id_des,port_id_loc,mpso_shptm,mpso_camt,mpso_dis,mpso_disper,mpso_ref,mpso_freamt,mpso_namt )
			values(@mpso_id,@mpso_no,@mpso_pso,@mpso_cat,@mpso_dat,@mpso_ddat,@mpso_rmk,@mpso_amt,@cus_id,@cur_id,@mpso_act,@mpso_typ,@m_yr_id,@ves_id,@port_id_des,@port_id_loc,@mpso_shptm,@mpso_camt,@mpso_dis,@mpso_disper,@mpso_ref,@mpso_freamt,@mpso_namt)
	set @mpso_id_out=@mpso_id
	--if @mpso_cat='N'
	--begin
	--	update t_mpso set mpso_pso=1 where mpso_id=@mpso_id
	--end
	
	
	if @mpso_cat='R'
	begin
		update t_mpso set mpso_act=1,mpso_typ='R' where mpso_id=@mpso_pso
	end
	

--Audit
	set @aud_des='ID #'+rtrim(cast(@mpso_id as char(1000)))+' ' +@aud_des
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
go
--Update
alter proc upd_t_mpso(@com_id char(2),@br_id char(3),@mpso_id int,@mpso_no int,@mpso_pso int,@mpso_cat char,@mpso_dat datetime,@mpso_ddat datetime,@mpso_rmk varchar(250),@mpso_amt float,@mpso_typ char(1),@mpso_act bit,@cus_id int,@cur_id int,@m_yr_id char(2),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@ves_id int,@port_id_des int,@port_id_loc int,@mpso_shptm varchar(100),@mpso_camt float,@mpso_dis float,@mpso_disper float,@mpso_ref float,@mpso_freamt float,@mpso_namt float)
as
declare
@aud_act char(10)
begin
	set @aud_act='Update'
	update t_mpso set mpso_no=@mpso_no,mpso_pso=@mpso_pso,mpso_cat=@mpso_cat,mpso_dat=@mpso_dat,mpso_ddat=@mpso_ddat,mpso_rmk=@mpso_rmk,mpso_amt=@mpso_amt,cus_id=@cus_id,cur_id=@cur_id,mpso_act=@mpso_act,mpso_typ=@mpso_typ,ves_id=@ves_id,port_id_des=@port_id_des,port_id_loc=@port_id_loc,mpso_shptm=@mpso_shptm,mpso_camt=@mpso_camt,mpso_dis=@mpso_dis,mpso_disper=@mpso_disper,mpso_ref=@mpso_ref,mpso_freamt=@mpso_freamt,mpso_namt=@mpso_namt where mpso_id=@mpso_id 
	--update t_mpso set mpso_act=1,mpso_typ='R' where mpso_id=@mpso_pso
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end

go
--Delete

alter proc del_t_mpso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@mpso_pso int,
@aud_act char(10)
begin
	set @aud_act='Delete'
	
	--update t_mpso set mpso_act=0,mpso_typ='U' where mpso_id=(select mpso_pso from t_mpso where mpso_id=@mpso_id)

	
	set @mpso_pso=(select mpso_pso from t_mpso where mpso_id=@mpso_id)
--	set @mpso_pso=(select mpso_id from t_mpso where mpso_no=mpso_pso)

	if @mpso_pso>0
	begin
		update t_mpso set mpso_act=0,mpso_typ='U' where mpso_id=@mpso_pso
	end

	delete t_pat where mpso_id=@mpso_id 
	delete t_dpso where mpso_id=@mpso_id 
	delete t_mpso where mpso_id=@mpso_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
		
--select * from t_pat

