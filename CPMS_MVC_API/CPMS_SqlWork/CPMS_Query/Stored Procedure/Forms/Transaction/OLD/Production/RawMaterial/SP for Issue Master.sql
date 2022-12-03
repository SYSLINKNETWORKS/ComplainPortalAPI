use meiji_rusk
go

--alter table t_miss drop constraint fk_miss_cusid 
--alter table t_miss add com_id char(2),br_id char(3),m_yr_id char(2)
--alter table t_miss add constraint FK_TMISS_MCOMID foreign key (com_id) references m_com(com_id)
--alter table t_miss add constraint FK_TMISS_MBRID foreign key (br_id) references m_br(br_id)
--alter table t_miss add constraint FK_TMISS_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)
--update t_miss set com_id='01',br_id='01',m_yr_id='01'
--select * from t_miss where miss_dat>'06/30/2013'

--alter table t_miss add con_id int
--alter table t_miss add constraint FK_TMISS_CONID foreign key (con_id) references m_con(con_id)

--Insert
alter proc [dbo].[ins_t_miss](@com_id char(2),@br_id char(3),@m_yr_id char(2),@miss_dat datetime,@miss_nob float,@titm_id int,@titm_id_patti int,@mbat_id int,@cus_id int,@miss_act bit,@miss_ckso bit,@mso_id int,@con_id int,@miss_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@miss_id_out int output)
as
declare
@miss_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
	set @miss_id=(select max(miss_id)+1 from t_miss)
		if @miss_id is null
			begin
				set @miss_id=1
			end
		if @miss_ckso =0
			begin
				set @cus_id=null
				set @mso_id=null
			end
		if (@con_id=0)
			begin
				set @con_id=null
			end
	insert into t_miss(com_id,br_id,m_yr_id,miss_id,miss_dat,miss_nob,titm_id,titm_id_patti,mbat_id,miss_act,miss_ckso,mso_id,miss_typ,cus_id,con_id )
			values(@com_id,@br_id,@m_yr_id,@miss_id,@miss_dat,@miss_nob,@titm_id,@titm_id_patti,@mbat_id,@miss_act,@miss_ckso,@mso_id,@miss_typ,@cus_id,@con_id)
		set @miss_id_out=@miss_id
		
	--Contractor Voucher
	if (@con_id is not null)
		begin
			exec sp_voucher_iss_con @com_id,@br_id,@m_yr_id,@miss_id ,@usr_id,'',''
		end
		
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update
alter proc [dbo].[upd_t_miss](@com_id char(2),@br_id char(3),@m_yr_id char(2),@miss_id int,@miss_dat datetime,@miss_nob float,@titm_id int,@titm_id_patti int,@mbat_id int,@miss_act bit,@miss_ckso bit,@mso_id int,@cus_id int,@con_id int,@bd_id int,@miss_typ char(1),@dso_batact bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_no_con int
begin
	set @aud_act='Update'
	set @mvch_no_con =(select mvch_no_con from t_miss where miss_id=@miss_id)
		if @miss_ckso =0
			begin
				set @cus_id=null
				set @mso_id=null
			end
		if (@con_id=0)
			begin
				set @con_id=null
			end
	update t_miss set miss_dat=@miss_dat,miss_nob=@miss_nob,titm_id=@titm_id,titm_id_patti=@titm_id_patti,mbat_id=@mbat_id,miss_act=@miss_act,miss_ckso=@miss_ckso,mso_id=@mso_id,cus_id=@cus_id,con_id=@con_id,miss_typ=@miss_typ where miss_id=@miss_id	
	
	--Contractor Voucher
	if (@con_id is not null)
		begin
			exec sp_voucher_iss_con @com_id,@br_id,@m_yr_id,@miss_id ,@usr_id,'',''
		end
	else
		begin
			exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no_con,'','',@usr_id ,@aud_ip
		end

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO




--Delete
alter proc [dbo].[del_t_miss](@com_id char(2),@br_id char(3),@m_yr_id char(2),@miss_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@mvch_no_con int
begin
	set @aud_act='Delete'
	set @mvch_no_con =(select mvch_no_con from t_miss where miss_id=@miss_id)

	exec del_t_vch @com_id ,@br_id,@m_yr_id,@mvch_no_con,'','',@usr_id ,@aud_ip
	exec del_t_diss @miss_id
	delete t_miss where miss_id=@miss_id
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
		

	

