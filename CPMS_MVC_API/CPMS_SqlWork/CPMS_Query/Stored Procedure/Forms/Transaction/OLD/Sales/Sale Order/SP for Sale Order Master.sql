USE MEIJI_RUSK
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
--alter table t_mso drop column cuscat_id
--alter table t_mso add mso_auth bit
--update t_mso set mso_auth=0

--alter table t_mso drop column mso_deptime
--alter table t_mso add mso_vno varchar(250)
--alter table t_mso add mso_drv varchar(250)
--alter table t_mso add wh_id int
--alter table t_mso add constraint FK_TMSO_WHID foreign key (wh_id) references m_wh(wh_id)
--alter table t_mso add carr_id int
--alter table t_mso add constraint FK_TMSO_CARRID foreign key (carr_id) references m_carr(carr_id)
--alter table t_mso add mso_bltyno varchar(100)
--alter table t_mso add mso_bltydat datetime
--alter table t_mso add mso_cashrec float

--alter table t_mso add mso_bdisper float,mso_bdisamt float
--update t_mso set mso_bdisper=0,mso_bdisamt =0

--alter table t_mso add mso_frecon char(1)
--update t_mso set mso_frecon='+'


--alter table t_mso add mso_fueamt float,mso_despa int,mso_despb int,veh_id int
--alter table t_mso add constraint FK_MSO_VEHID foreign key (veh_id) references m_veh(veh_id)
--alter table t_mso add constraint FK_MSO_DRVID foreign key (drv_id) references m_drv(drv_id)

--alter table t_mso add sec_id int
--alter table t_mso add constraint FK_MSO_SECID foreign key (sec_id) references m_sec(sec_id)

--alter table t_mso add mso_misamt float
--alter table t_mso add mso_misrmk varchar(250)

--alter table t_mso add mso_commamt float
--update t_mso set mso_commamt=0


--Insert
alter proc ins_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_dat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_misamt float,@mso_misrmk varchar(250),@mso_fueamt float,@mso_commamt float,@mso_namt float,@mso_cash float,@mso_typ char(1),@cus_id int,@mso_idold varchar(1000),
@sec_id int,@drv_id int,@veh_id int,@mso_despa int,@mso_despb int,
@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@mso_no_out int output,@mso_id_out int output)
as
declare
@mso_id int,
@mso_no int,
@mso_app bit,
@cur_id int,
@mso_currat float,
@emppro_id int,
@mpso_id int,
@log_dat datetime,
@mdc_no int,
@mdc_id int,
@acc_id char(20),
@mrec_id int,
@minv_id int,
@emppro_macid int,
@mso_can bit,
@mso_act bit,
@mso_soapp bit,
@mso_ckdel bit,
@mso_delnam varchar(250),
@mso_delpho varchar(250),
@mso_deladd varchar(250),
@carr_id int,
@mso_cuspo varchar(250),
@mso_disper float,
@mso_disamt float,
@mso_frecon char(1),
@mso_freamt float,
@mso_othamt float,
@mso_auth bit,
@msodsr_id int,
@wh_id int
begin
	set @log_dat=GETDATE()	
	set @mso_app=0
	set @mso_can=0
	set @mso_act=1
	set @mso_soapp=0	
	set @mso_ckdel=0
	set @carr_id =0
	set @emppro_macid =0
	set @mso_cuspo=''
	set @mso_disper=0
	set @mso_disamt=0
	set @mso_frecon='+'
	set @mso_freamt=0
	set @mso_othamt=0
	set @mso_auth =1
	set @msodsr_id =null
	set @wh_id =(select top 1 wh_id from m_wh where wh_ckdef =1)
	
	if (@emppro_macid =0)	
		begin
			set @emppro_id =null
		end
	else
		begin
			set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
		end
		
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @mpso_id=null
	
	set @mso_currat=1


	if (@mso_typ='O')
		begin
			set @mso_id=isnull((select min(mso_id) from t_mso where mso_typ='O')-1,-1)
			set @mso_no=isnull((select min(mso_no) from t_mso where mso_typ='O')-1,-1)
		end
	else
		begin
			set @mso_id=isnull((select max(mso_id) from t_mso)+1,1)
			set @mso_no=isnull((select max(mso_no) from t_mso)+1,1)
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

		
	if (@carr_id =0)
		begin
			set @carr_id =null
		end
	if (@sec_id =0)
		begin
			set @sec_id=null
		end
	if (@drv_id=0)
		begin
			set @drv_id=null
		end
	if (@veh_id=0)
		begin
			set @veh_id=null
		end
	insert into t_mso(com_id,br_id,m_yr_id,mso_id,mso_no,mpso_id,mso_dat,mso_cuspo,mso_ddat,mso_rmk,mso_currat,mso_amt,mso_disper,mso_disamt,mso_frecon,mso_freamt,mso_othamt,mso_namt,mso_act,mso_auth,mso_app,mso_soapp,mso_can,mso_typ,mso_ckdel,mso_delnam,mso_delpho,mso_deladd,cus_id,cur_id,men_nam,msodsr_id,usr_ip,mso_idold,emppro_id,wh_id,carr_id,sec_id,veh_id,drv_id,mso_bltyno,mso_bltydat,log_act,log_dat,usr_id,log_ip,mso_cashrec,mso_bdisper,mso_bdisamt,mso_fueamt,mso_commamt,mso_despa,mso_despb,mso_misamt,mso_misrmk)
			values(@com_id,@br_id,@m_yr_id,@mso_id,@mso_no,@mpso_id,@mso_dat,@mso_cuspo,@mso_dat,@mso_rmk,@mso_currat,@mso_amt,@mso_disper,@mso_disamt,@mso_frecon,@mso_freamt,@mso_othamt,@mso_namt,@mso_act,@mso_auth,@mso_app,@mso_soapp,@mso_can,@mso_typ,@mso_ckdel,@mso_delnam,@mso_delpho,@mso_deladd,@cus_id,@cur_id,@log_frmnam,@msodsr_id,@log_ip,@mso_idold,@emppro_id,@wh_id,@carr_id,@sec_id,@veh_id,@drv_id,null,@mso_dat,@log_act,@log_dat,@usr_id,@log_ip,@mso_cash,0,0,@mso_fueamt,@mso_commamt  ,@mso_despa,@mso_despb,@mso_misamt,@mso_misrmk)
	set @mso_id_out=@mso_id
	set @mso_no_out=@mso_no
	
	set @log_newval= 'ID=' + cast(@mso_id as varchar) + '-' + cast(@log_newval as varchar(max))
	
	if (@mso_typ<>'O')
		begin
			----Delivery Chalan	
			exec ins_t_mdc @com_id,@br_id,@m_yr_id,@mso_dat,@mso_dat,'','','S',@mso_act,@mso_auth,@mso_no,@wh_id,@mso_rmk,@mso_ckdel,@mso_delnam,@mso_delpho,@mso_deladd,@carr_id,'',@mso_dat,@log_act,@usr_id,@log_ip,@log_frmnam,@log_oldval,@log_newval,null,@mdc_id_out=@mdc_id output	

			----Invoice
			exec ins_t_minv @com_id,@br_id,@m_yr_id,@mso_dat,@mso_dat ,'S',@mdc_id,1,@cur_id,@cus_id,@mso_rmk,0,0,0,0,0,@mso_amt,@mso_disamt,0,0,@mso_frecon,@mso_freamt,@mso_othamt,@mso_commamt,@mso_namt,@mso_can,@log_act,@usr_id,@log_ip,@log_frmnam,@log_oldval,@log_newval ,null,null,@minv_id_out=@minv_id output
			
			--Receiving
			if (@mso_cash >0)
				begin
					set @acc_id=(select acc_id from gl_m_acc where acc_no in (select cash_acc from m_sys))
					exec sp_ins_mrec @com_id,@br_id,@m_yr_id,@mso_dat,0,0,@mso_cash,0,0,@mso_cash,0,'C',0,0,@mso_dat,'',1,@cus_id,@cur_id,@acc_id,@mso_can,'','S','','','','','','','','',@mrec_id_out =@mrec_id output
					exec sp_ins_drec 0,@mso_cash,0,0,0,0,@mso_cash,0,0,@minv_id,@mrec_id,1			
				end
		end
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat	

end
		
go
--Update
alter proc upd_t_mso(@m_yr_id char(2),@mso_id int,@mso_no int,@mso_dat datetime,@mso_rmk varchar(250),@mso_amt float,@mso_misamt float,@mso_misrmk varchar(250),@mso_fueamt float,@mso_commamt float,@mso_namt float,@mso_cash float,@mso_typ char(1),@cus_id int,@mso_idold varchar(1000),
@sec_id int,@drv_id int,@veh_id int,@mso_despa int,@mso_despb int,
@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@mso_app bit,
@cur_id int,
@mso_currat float,
@emppro_id int,
@mpso_id int,
@log_dat datetime,
@com_id char(2),
@br_id char(3),
@mdc_id int,
@minv_id int,
@mrec_id int,
@acc_id char(20),
@mpso_no int,
@emppro_macid int,
@mso_can bit,
@mso_soapp bit,
@mso_ckdel bit,
@mso_delnam varchar(250),
@mso_deladd varchar(250),
@mso_delpho varchar(250),
@mso_add varchar(250),
@carr_id int,
@mso_cuspo varchar(250),
@mso_disper float,
@mso_disamt float,
@mso_frecom float,
@mso_frecon char(1),
@mso_freamt float,
@mso_othamt float,
@mso_act bit,
@mso_auth bit,
@men_nam varchar(250),
@msodsr_id int,
@usr_ip char(100),
@wh_id int,
@mso_bltyno varchar(100),
@mso_bdisper float,
@mso_bdisamt float
begin
	set @mso_can =0
	set @log_dat=GETDATE()	
	set @com_id=(select com_id from t_mso where mso_id=@mso_id)
	set @br_id=(select br_id from t_mso where mso_id=@mso_id)
	set @mpso_id=(select mpso_id from t_mpso where mpso_no=@mpso_no)
	set @mso_app=0
	set @mdc_id=(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id=(select minv_id from t_minv where mdc_id=@mdc_id)
	set @mrec_id=(select distinct t_mrec.mrec_id from t_mrec inner join t_drec on t_mrec.mrec_id=t_drec.mrec_id where minv_id=@minv_id  and drec_amt <>0 and mrec_typ='S')
	set @cur_id=(select cur_id from m_cus where cus_id=@cus_id)
	set @wh_id =(select top 1 wh_id from m_wh where wh_ckdef =1)

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
	if (@emppro_macid =0)
		begin
			set @emppro_id=null
		end
	else
		begin
			set @emppro_id=(select emppro_id from m_emppro where emppro_macid=@emppro_macid)
		end
		
	if (@carr_id =0)
		begin
			set @carr_id =null
		end
	if (@sec_id =0)
		begin
			set @sec_id=null
		end
	
	if (@drv_id=0)
		begin
			set @drv_id=null
		end
	if (@veh_id=0)
		begin
			set @veh_id=null
		end

	update t_mso set mso_dat=@mso_dat,mso_cuspo=@mso_cuspo,mso_ddat=@mso_dat,mso_rmk=@mso_rmk,mso_currat=@mso_currat,mso_amt=@mso_amt,mso_disper=@mso_disper,mso_disamt=@mso_disamt,
						mso_frecon=@mso_frecon,mso_freamt=@mso_freamt,mso_othamt=@mso_othamt,mso_commamt=@mso_commamt,mso_namt=@mso_namt,mso_act=@mso_act,mso_auth=@mso_auth,mso_app=@mso_app,
						mso_soapp=@mso_soapp,mso_can=@mso_can,mso_typ=@mso_typ,mso_ckdel=@mso_ckdel,mso_delnam=@mso_delnam,mso_delpho=@mso_delpho,mso_deladd=@mso_deladd,
						cus_id=@cus_id,cur_id=@cur_id,men_nam=@men_nam,msodsr_id=@msodsr_id ,usr_ip=@usr_ip,mso_idold=@mso_idold,emppro_id=@emppro_id,wh_id=@wh_id,
						carr_id=@carr_id,sec_id=@sec_id,veh_id=@veh_id,drv_id=@drv_id,mso_bltyno=@mso_bltyno,mso_bltydat=@mso_dat,
						log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,mso_cashrec=@mso_cash,mso_bdisper=@mso_bdisper,
						mso_bdisamt=@mso_bdisamt,mso_fueamt=@mso_fueamt,mso_despa=@mso_despa,mso_despb=@mso_despb,mso_misamt=@mso_misamt,mso_misrmk=@mso_misrmk
							where mso_id=@mso_id
	if (@mso_typ<>'O')
		begin
			----Delivery Chalan
			 exec upd_t_mdc @com_id,@br_id,@m_yr_id,@mdc_id,@mso_dat,@mso_dat,'','','S',@mso_act,@mso_auth,@wh_id,@mso_rmk,@mso_ckdel,@mso_delnam,@mso_delpho,@mso_deladd,@carr_id,'',@mso_dat,@log_act,@usr_id,@log_ip,@log_frmnam,@log_oldval,@log_newval

			----Invoice
			exec upd_t_minv @com_id,@br_id,@m_yr_id,@minv_id ,@mso_dat,@mso_dat,'S',@mdc_id,@cur_id,@cus_id,1,@mso_rmk,0,0,0,0,0,@mso_amt,@mso_disamt,@mso_bdisper,@mso_bdisamt,@mso_frecon,@mso_freamt,@mso_othamt,@mso_commamt,@mso_namt,@mso_can,@log_act,@usr_id,@log_ip,@log_frmnam,@log_oldval ,@log_newval,''
			--Receiving
			set @acc_id=(select acc_id from gl_m_acc where acc_no in (select cash_acc from m_sys))
			exec sp_del_mrec @com_id ,@br_id ,@m_yr_id,@mrec_id ,'','','','','',''
			if (@mso_cash>0)
				begin
						exec sp_ins_mrec @com_id,@br_id,@m_yr_id,@mso_dat,0,0,@mso_cash,0,0,@mso_cash,0,'C',0,0,@mso_dat,'',1,@cus_id,@cur_id,@acc_id,@mso_can,'','S','','','','','','','','',@mrec_id_out=@mrec_id output
						exec sp_ins_drec 0,@mso_cash,0,0,0,0,@mso_cash,0,0,@minv_id,@mrec_id,1			
				end
		end
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end

go
--Delete

alter proc del_t_mso(@com_id char(2),@br_id char(3),@m_yr_id char(2),@mso_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@log_dat datetime,
@mdc_id int,
@minv_id int,
@mrec_id int
begin
	set @log_dat=GETDATE()	
	set @mdc_id=(select mdc_id from t_mdc where mso_id=@mso_id)
	set @minv_id=(select minv_id from t_minv where mdc_id=@mdc_id)
	set @mrec_id=(select distinct t_mrec.mrec_id from t_mrec inner join t_drec on t_mrec.mrec_id=t_drec.mrec_id where minv_id=@minv_id  and drec_amt <>0 and mrec_typ='S')
	
	--Receiving
	exec sp_del_mrec @com_id ,@br_id ,@m_yr_id,@mrec_id ,'',null,'','','',''
	
	--Invoice 
	exec del_t_minv @com_id,@br_id,@m_yr_id,@minv_id ,@log_act,@usr_id,@log_ip ,@log_frmnam ,@log_oldval ,@log_newval 

	--Delivery Chalan
	exec del_t_mdc @mdc_id,@log_act,@usr_id,@log_ip,@log_frmnam,@log_oldval,@log_newval

	exec del_t_dso_pat @mso_id 
	exec del_t_dso @mso_id 
	
	delete from t_mso where mso_id=@mso_id
	
--Audit
exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat


end
		
----select * from rm_det


