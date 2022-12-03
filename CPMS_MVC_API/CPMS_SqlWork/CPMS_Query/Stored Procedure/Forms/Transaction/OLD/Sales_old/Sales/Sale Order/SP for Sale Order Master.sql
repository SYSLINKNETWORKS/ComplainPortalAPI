USE phm
GO

--alter table t_mso add mso_ckdel bit,mso_delnam varchar(250),mso_delpho varchar(250),mso_deladd varchar(250)
--update t_mso set mso_ckdel=0,mso_delnam='',mso_delpho='',mso_deladd=''

--alter table t_mso add mso_idold varchar(1000)
--ALTER table t_mso drop column mso_dsrid
--alter table t_mso add msodsr_id int
--alter table t_mso add constraint FK_TMSO_MSODSRID foreign key (msodsr_id) references t_msodsr(msodsr_id)
--alter table t_mso add lc_nam varchar(250)
--alter table t_mso add mso_saltyp char(2) 
--alter table t_mso drop column ins_usr_id,upd_usr_id
--alter table t_mso add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table t_mso add cuscat_id int
--Insert
alter proc ins_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mpso_no int,@mso_dat datetime,@mso_cuspo varchar(250),@mso_ddat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_soapp bit,@mso_can bit,@mso_ckdel bit,@mso_delnam varchar(250),@mso_delpho varchar(250),@mso_deladd varchar(250),@mso_typ char(1),@cus_id int,@msodsr_id int,@mso_idold varchar(1000),@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mso_no_out int output,@mso_id_out int output)
as
declare
@mso_id int,
@mso_no int,
@mso_app bit,
@cur_id int,
@mso_currat float,
@emppro_id int,
@mpso_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @mso_app=0
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)

	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mpso_id=(select mpso_id from t_mpso where mpso_no=@mpso_no)
	
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
		
	if (@mso_ckdel=0)
		begin
			set @mso_delnam=''
			set @mso_delpho=''
			set @mso_deladd=''
		end
	--if (@mso_saltyp='LS')
	--	begin
	--	--LC Insert
	--	exec ins_m_lc @lc_nam ,'S',@lc_id_out =@lc_id output
	--	end
	
	insert into t_mso(com_id,br_id,m_yr_id,mso_id,mso_no,mpso_id,mso_dat,mso_cuspo,mso_ddat,mso_rmk,mso_currat,mso_amt,mso_disper,mso_disamt,mso_freamt,mso_othamt,mso_namt,mso_act,mso_app,mso_soapp,mso_can,mso_typ,mso_ckdel,mso_delnam,mso_delpho,mso_deladd,cus_id,cur_id,men_nam,msodsr_id,usr_ip,mso_idold,emppro_id,log_act,log_dat,usr_id,log_ip)
			values(@com_id,@br_id,@m_yr_id,@mso_id,@mso_no,@mpso_id,@mso_dat,@mso_cuspo,@mso_ddat,@mso_rmk,@mso_currat,@mso_amt,@mso_disper,@mso_disamt,@mso_freamt,@mso_othamt,@mso_namt,@mso_act,@mso_app,@mso_soapp,@mso_can,@mso_typ,@mso_ckdel,@mso_delnam,@mso_delpho,@mso_deladd,@cus_id,@cur_id,@log_frmnam,@msodsr_id,@log_ip,@mso_idold,@emppro_id,@log_act,@log_dat,@usr_id,@log_ip)
	set @mso_id_out=@mso_id
	set @mso_no_out=@mso_no
	
	set @log_newval= 'ID=' + cast(@mso_id as varchar) + '-' + cast(@log_newval as varchar(max))

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat	

end
		
go
--Update
alter proc upd_t_mso(@m_yr_id char(2),@mso_id int,@mso_no int,@mpso_no int,@mso_dat datetime,@mso_cuspo varchar(250),@mso_ddat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_disper float,@mso_disamt float,@mso_freamt float,@mso_othamt float,@mso_namt float,@mso_act bit,@mso_soapp bit,@mso_can bit,@mso_ckdel bit,@mso_delnam varchar(250),@mso_delpho varchar(250),@mso_deladd varchar(250),@mso_typ char(1),@cus_id int,@emppro_macid int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare

@mso_app bit,
@cur_id int,
@mso_currat float,
@emppro_id int,
@mpso_id int,
@log_dat datetime
begin
	set @log_dat=GETDATE()	
	set @mpso_id=(select mpso_id from t_mpso where mpso_no=@mpso_no)
	set @mso_app=0
	set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
	
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	--set @lc_id=(select lc_id from m_lc where lc_id=@lc_id)
	set @mso_currat=1
	
	if (@mso_can =1)
		begin
			set @mso_app=0
		end
	else if (@mso_soapp=1)
		begin
			set @mso_app=1
		end
	if (@mso_ckdel=0)
		begin
			set @mso_delnam=''
			set @mso_delpho=''
			set @mso_deladd=''
		end
		

	update t_mso set mso_no=@mso_no,mpso_id=@mpso_id,mso_dat=@mso_dat ,mso_cuspo=@mso_cuspo,mso_ddat=@mso_ddat,mso_rmk=@mso_rmk,mso_currat=@mso_currat,mso_amt=@mso_amt,mso_disper=@mso_disper,mso_disamt=@mso_disamt,mso_freamt=@mso_freamt,mso_othamt=@mso_othamt,mso_namt=@mso_namt,mso_act=@mso_act,
								mso_ckdel=@mso_ckdel,mso_delnam=@mso_delnam,mso_delpho=@mso_delpho,mso_deladd=@mso_deladd,
								mso_app=@mso_app,mso_soapp=@mso_soapp,mso_can=@mso_can,mso_typ=@mso_typ,cus_id=@cus_id,cur_id=@cur_id,men_nam=@log_frmnam,emppro_id=@emppro_id,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
							where mso_id=@mso_id

--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end

go
--Delete

alter proc del_t_mso(@mso_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime
begin
	set @log_dat=GETDATE()	

	exec del_t_dso_pat @mso_id 
	exec del_t_dso @mso_id 
	update t_mso set log_act=@log_act where mso_id=@mso_id 
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat


end
		
--select * from rm_det


