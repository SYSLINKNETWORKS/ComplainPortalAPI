USE NATHI
GO

--alter table m_emppro add emppro_autact bit
--update m_emppro set emppro_autact=0

--alter table m_emppro add emppro_ckrat bit
--update m_emppro set emppro_ckrat =0

--alter table m_emppro add emppro_att bit 
--alter table m_emppro add emppro_salpay char(1)
--alter table m_emppro add emppro_ot bit
--update m_emppro set emppro_salpay='C'
--update m_emppro set emppro_ot=0

--alter table m_emppro add memp_sub_id int
--alter table m_emppro add emppro_ho bit
--alter table m_emppro add emppro_rat float
--alter table m_emppro add emppro_lde bit
--alter table m_emppro add emppro_sot bit
--alter table m_emppro add emppro_fot bit

--alter table m_emppro add emppro_tp char(1)
--alter table m_emppro add emppro_dat_sessi datetime 
--alter table m_emppro alter column emppro_sessi_no varchar(50)
--alter table m_emppro add emppro_srat float
--alter table m_emppro add empanl_id int
--alter table m_emppro add constraint FK_EMPPRO_EMPANLID foreign key (empanl_id) references m_empanl(empanl_id)
--update m_emppro set emppro_tp='P',emppro_dat_sessi=getdate(),emppro_srat=1,empanl_id=1


--alter table m_emppro add constraint FK_EMPPRO_EMPSUB foreign key (memp_sub_id) references m_emp_sub(memp_sub_id)


--select * from m_emppro
--exec ins_m_sal '10/06/2011',613,10000,'S','01','01','03',1,'Employee Salary from Employee Profile','','',''
--alter table m_emppro add rosemp_id int
--alter table m_emppro add constraint FK_MEMPPRO_ROSEMPID foreign key(rosemp_id) references m_rosemp(rosemp_id)
--alter table m_emppro add com_id char(2)
--update m_emppro set com_id='01'
--alter table m_emppro add mtermres_id int
--alter table m_emppro add emppro_restyp char(1)
--alter table m_emppro add constraint FK_MEMPPRO_MTERRESID foreign key (mtermres_id) references m_termres (mtermres_id)

--alter table m_emppro add acc_no int


--Insert with out image
alter proc [dbo].[ins_m_emppro](@emppro_cat int,@emppro_macid int,@emppro_nam varchar(100),@emppro_fnam varchar(100),@memp_sub_id int,@emppro_add varchar(250),@dpt_id char(2),@emppro_doj datetime,@emppro_gen char(1),@emppro_mar char(1),@emppro_dob datetime,@emppro_cnic char(15),@emppro_ntn char(20),@emppro_ref varchar(250),@emppro_pho char(100),@emppro_mob char(100),@emppro_eml char(100),@emppro_expcom varchar(100),@emppro_expdes varchar(100),@emppro_expyrfrm datetime,@emppro_expyrto datetime,@emppro_exprmk varchar(100),@emppro_quains varchar(100),@emppro_quaqua varchar(50),@emppro_quayr datetime,@emppro_quarmk varchar(100),@emppro_sal float,@emppro_salpay char(1),@emppro_salpay_acc varchar(100),@emppro_ot bit,@emppro_att bit,@emppro_salgra bit,@emppro_saleobi bit,@emppro_saleobi_dor datetime,@emppro_saleobi_reg varchar(50),@emppro_salsessi bit,@emppro_salsp bit,@emppro_ho bit,@emppro_ckrat bit,@emppro_rat float,@emppro_attexp bit,@emppro_lde bit,@emppro_sot bit,@emppro_fot bit,@emppro_Salpt float,@emppro_salpot float,@emppro_reg bit,@emppro_reg_dat datetime,@emppro_reg_rmk varchar(100),@emppro_st bit,@emppro_autact bit,@ros_id int,@empanl_id int,@emppro_typ char(1),@emppro_tp char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100), @emppro_dat_sessi datetime,@emppro_sessi_no  varchar(50), @emppro_srat float,@mtermres_id int,@emppro_restyp char(1),@emppro_id_out int output)
as
declare
@emppro_id			int,
@aud_act			char(20),
@empros_id			int,
@msal_id			int,
@rosemp_id int,
@memp_cksal bit,
@acc_no int,
@acc_cno int,
@cur_id int
begin
	if (@emppro_macid =0)
		begin
			set @emppro_macid =isnull((select MAX(emppro_macid)+1 from m_emppro),1)
		end
	set @memp_cksal =(select memp_sub_salman from m_emp_sub where memp_sub_id=@memp_sub_id)
	set @emppro_id =(select max(emppro_id) from m_emppro)+1
	set @aud_act='Insert'

	if (@emppro_id is null)
		begin	
			set @emppro_id=1
		end
	if (@emppro_reg=0)
		begin
			set @emppro_restyp=null
			set @mtermres_id =null
		end
	if (@empanl_id =0)
		begin
			set @empanl_id =null
		end
	if (@ros_id=0)
		begin
			set @ros_id =null
		end

	insert into m_emppro(com_id,br_id,emppro_id,emppro_cat,emppro_macid,emppro_nam,emppro_fnam,memp_sub_id,emppro_add,dpt_id,emppro_doj,emppro_gen,emppro_mar,emppro_dob,emppro_cnic,emppro_ntn,emppro_ref,emppro_pho,emppro_mob,emppro_eml,emppro_expcom,emppro_expdes,emppro_expyrfrm,emppro_expyrto,emppro_exprmk,emppro_quains,emppro_quaqua ,emppro_quayr,emppro_quarmk,emppro_sal,emppro_salpay,emppro_salpay_acc,emppro_ot,emppro_att,emppro_salgra,emppro_saleobi,emppro_saleobi_dor,emppro_saleobi_reg,emppro_salsessi,emppro_salsp,emppro_ho,emppro_ckrat,emppro_rat,emppro_attexp,emppro_lde,emppro_sot,emppro_fot,emppro_salpt,emppro_salpot,emppro_reg,emppro_reg_dat,emppro_reg_rmk,emppro_st,ros_id,empanl_id,emppro_typ,emppro_userid,emppro_autact,emppro_tp,emppro_dat_sessi,emppro_sessi_no,emppro_srat,mtermres_id,emppro_restyp)
	values
	(@com_id,@br_id,@emppro_id,@emppro_cat,@emppro_macid,@emppro_nam,@emppro_fnam,@memp_sub_id,@emppro_add,@dpt_id,@emppro_doj,@emppro_gen,@emppro_mar,@emppro_dob,@emppro_cnic,@emppro_ntn,@emppro_ref,@emppro_pho,@emppro_mob,@emppro_eml,@emppro_expcom,@emppro_expdes,@emppro_expyrfrm,@emppro_expyrto,@emppro_exprmk,@emppro_quains,@emppro_quaqua ,@emppro_quayr,@emppro_quarmk,@emppro_sal,@emppro_salpay,@emppro_salpay_acc,@emppro_ot,@emppro_att,@emppro_salgra,@emppro_saleobi,@emppro_saleobi_dor,@emppro_saleobi_reg,@emppro_salsessi,@emppro_salsp,@emppro_ho,@emppro_ckrat,@emppro_rat,@emppro_attexp ,@emppro_lde,@emppro_sot,@emppro_fot,@emppro_salpt,@emppro_salpot,@emppro_reg,@emppro_reg_dat,@emppro_reg_rmk,@emppro_st,@ros_id,@empanl_id,@emppro_typ,@emppro_macid,@emppro_autact,@emppro_tp,@emppro_dat_sessi,@emppro_sessi_no,@emppro_srat,@mtermres_id,@emppro_restyp)

	set @emppro_id_out=@emppro_id

	--Employee Salary
	exec ins_m_sal @emppro_doj,@emppro_id,@emppro_sal,0,1,@emppro_sal,'S',@com_id,@br_id,@m_yr_id,@usr_id,'Employee Salary from Employee Profile',@aud_des,@aud_ip,@msal_id_out=@msal_id  output
	
	update m_emppro set msal_id=@msal_id where emppro_id=@emppro_id


	--Employee Auto Roster
	exec ins_m_rosemp  @com_id,@br_id,@emppro_doj,'S',@ros_id,@emppro_id,'','','','',@rosemp_id_out=@rosemp_id output
	update m_emppro set rosemp_id=@rosemp_id where emppro_id=@emppro_id

	--Account
	if (@memp_cksal=1)
	begin
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @acc_cno=(select salcom_acc from m_sys)
		exec ins_m_acc @com_id,@br_id,@cur_id ,@emppro_nam ,@acc_cno ,'','S',@emppro_st ,'','','','','',@acc_no_out =@acc_no output
		update m_emppro set acc_no=@acc_no where emppro_id=@emppro_id
	end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Insert with image
alter proc [dbo].[ins_m_emppro_img](@emppro_cat int,@emppro_macid int,@emppro_nam varchar(100),@emppro_fnam varchar(100),@memp_sub_id int,@emppro_add varchar(250),@dpt_id char(2),@emppro_doj datetime,@emppro_gen char(1),@emppro_mar char(1),@emppro_dob datetime,@emppro_cnic char(15),@emppro_ntn char(20),@emppro_ref varchar(250),@emppro_pho char(100),@emppro_mob char(100),@emppro_eml char(100),@emppro_expcom varchar(100),@emppro_expdes varchar(100),@emppro_expyrfrm datetime,@emppro_expyrto datetime,@emppro_exprmk varchar(100),@emppro_quains varchar(100),@emppro_quaqua varchar(50),@emppro_quayr datetime,@emppro_quarmk varchar(100),@emppro_sal float,@emppro_salgra bit,@emppro_saleobi bit,@emppro_salsessi bit,@emppro_salsp bit,@emppro_ho bit,@emppro_ckrat bit,@emppro_rat float,@emppro_attexp bit,@emppro_lde bit,@emppro_sot bit,@emppro_fot bit,@emppro_reg bit,@emppro_reg_dat datetime,@emppro_reg_rmk varchar(100),@emppro_st bit,@emppro_img image,@ros_id int,@empanl_id int,@emppro_autact bit,@emppro_typ char(1),@emppro_tp char(1),@com_id char(3),@br_id char(3),@m_yr_id char(3),@emppro_id_out int output,@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024), @emppro_dat_sessi datetime,@emppro_sessi_no varchar(50) , @emppro_srat float,@mtermres_id int,@emppro_restyp char(1),@aud_ip varchar(100))
as
declare
@emppro_id			int,
@aud_act			char(20),
@empros_id			int,
@msal_id				int,
@rosemp_id int,
@memp_cksal bit,
@acc_no int,
@acc_cno int,
@cur_id int
begin
	if (@emppro_macid =0)
		begin
			set @emppro_macid =isnull((select MAX(emppro_macid)+1 from m_emppro),1)
		end

	set @memp_cksal =(select memp_sub_salman from m_emp_sub where memp_sub_id=@memp_sub_id)
	set @emppro_id =(select max(emppro_id) from m_emppro)+1
	set @aud_act='Insert'

	if (@emppro_id is null)
		begin	
			set @emppro_id=1
		end
	if (@emppro_reg=0)
		begin
			set @emppro_restyp=null
			set @mtermres_id =null
		end
	if (@empanl_id =0)
		begin
			set @empanl_id =null
		end
	if (@ros_id=0)
		begin
			set @ros_id =null
		end

	insert into m_emppro(com_id,br_id,emppro_cat,emppro_id,emppro_macid,emppro_nam,emppro_fnam,memp_sub_id,emppro_add,dpt_id,emppro_doj,emppro_gen,emppro_mar,emppro_dob,emppro_cnic,emppro_ntn,emppro_ref,emppro_pho,emppro_mob,emppro_eml,emppro_expcom,emppro_expdes,emppro_expyrfrm,emppro_expyrto,emppro_exprmk,emppro_quains,emppro_quaqua ,emppro_quayr,emppro_quarmk,emppro_sal,emppro_salgra,emppro_saleobi,emppro_salsessi,emppro_salsp,emppro_ho,emppro_ckrat,emppro_rat,emppro_attexp,emppro_lde,emppro_sot,emppro_fot,emppro_reg,emppro_reg_dat,emppro_reg_rmk,emppro_st,emppro_img,ros_id,empanl_id,emppro_typ,emppro_userid,emppro_autact,emppro_tp,emppro_dat_sessi,emppro_sessi_no,emppro_srat,mtermres_id,emppro_restyp)
	values
	(@com_id,@br_id,@emppro_cat,@emppro_id,@emppro_macid,@emppro_nam,@emppro_fnam,@memp_sub_id,@emppro_add,@dpt_id,@emppro_doj,@emppro_gen,@emppro_mar,@emppro_dob,@emppro_cnic,@emppro_ntn,@emppro_ref,@emppro_pho,@emppro_mob,@emppro_eml,@emppro_expcom,@emppro_expdes,@emppro_expyrfrm,@emppro_expyrto,@emppro_exprmk,@emppro_quains,@emppro_quaqua ,@emppro_quayr,@emppro_quarmk,@emppro_sal,@emppro_salgra,@emppro_saleobi,@emppro_salsessi,@emppro_salsp,@emppro_ho,@emppro_ckrat,@emppro_rat,@emppro_attexp,@emppro_lde,@emppro_sot,@emppro_fot,@emppro_reg,@emppro_reg_dat,@emppro_reg_rmk,@emppro_st,@emppro_img,@ros_id,@empanl_id,@emppro_typ,@emppro_macid,@emppro_autact,@emppro_tp,@emppro_dat_sessi,@emppro_sessi_no,@emppro_srat,@mtermres_id,@emppro_restyp)

	set @emppro_id_out=@emppro_id

	--Employee Salary
	exec ins_m_sal @emppro_doj,@emppro_id,@emppro_sal,0,1,@emppro_sal,'S',@com_id,@br_id,@m_yr_id,@usr_id,'Employee Salary from Employee Profile',@aud_des,@aud_ip,@msal_id_out=@msal_id  output		
	update m_emppro set msal_id=@msal_id where emppro_id=@emppro_id

	--Employee Auto Roster
	exec ins_m_rosemp  @com_id,@br_id,@emppro_doj,'S',@ros_id,@emppro_id,'','','','',@rosemp_id_out=@rosemp_id output
	update m_emppro set rosemp_id=@rosemp_id where emppro_id=@emppro_id
	
	update m_emppro set empros_id=@empros_id where emppro_id=@emppro_id

	--Account
	if (@memp_cksal=1)
	begin
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @acc_cno=(select salcom_acc from m_sys)
		exec ins_m_acc @com_id,@br_id,@cur_id ,@emppro_nam ,@acc_cno ,'','S',@emppro_st ,'','','','','',@acc_no_out =@acc_no output
		update m_emppro set acc_no=@acc_no where emppro_id=@emppro_id
	end

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update without image
alter proc [dbo].[upd_m_emppro](@emppro_id int,@emppro_cat int,@emppro_macid int,@emppro_nam varchar(100),@emppro_fnam varchar(100),@memp_sub_id int,@emppro_add varchar(250),@dpt_id char(2),@emppro_doj datetime,@emppro_gen char(1),@emppro_mar char(1),@emppro_dob datetime,@emppro_cnic char(15),@emppro_ntn char(20),@emppro_ref varchar(250),@emppro_pho char(100),@emppro_mob char(100),@emppro_eml char(100),@emppro_expcom varchar(100),@emppro_expdes varchar(100),@emppro_expyrfrm datetime,@emppro_expyrto datetime,@emppro_exprmk varchar(100),@emppro_quains varchar(100),@emppro_quaqua varchar(50),@emppro_quayr datetime,@emppro_quarmk varchar(100),@emppro_sal float,@emppro_salpay char(1),@emppro_salpay_acc varchar(100),@emppro_ot bit,@emppro_att bit,@emppro_salgra bit,@emppro_saleobi bit,@emppro_saleobi_dor datetime,@emppro_saleobi_reg varchar(50),@emppro_salsessi bit,@emppro_salsp bit,@emppro_ho bit,@emppro_ckrat bit,@emppro_rat float,@emppro_lde bit,@emppro_sot bit,@emppro_fot bit,@emppro_Salpt float,@emppro_salpot float,@emppro_reg bit,@emppro_reg_dat datetime,@emppro_reg_rmk varchar(100),@emppro_st bit,@ros_id int,@empanl_id int,@emppro_autact bit,@emppro_typ char(1),@emppro_tp char(1),@emppro_attexp bit,@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024), @emppro_dat_sessi datetime,@emppro_sessi_no varchar(50), @emppro_srat float,@mtermres_id int,@emppro_restyp char(1),@aud_ip varchar(100))
as
declare
@aud_act char(20),
@empros_id int,
@msal_id int,
@rosemp_id int,
@memp_cksal bit,
@memp_cksal_old bit,
@acc_no int,
@acc_cno int,
@cur_id int
begin
	set @aud_act='Update'
	set @msal_id=(select msal_id from m_emppro where emppro_id=@emppro_id)
	set @rosemp_id=(select max(rosemp_id) from m_rosemp where emppro_id=@emppro_id and rosemp_typ='S')
	set @memp_cksal_old =(select memp_sub_salman from m_emppro inner join m_emp_sub on m_emppro.memp_sub_id=m_emp_Sub.memp_sub_id where emppro_id=@emppro_id)
	set @memp_cksal =(select memp_sub_salman from m_emp_sub where memp_sub_id=@memp_sub_id)

	if (@emppro_reg=0)
		begin
			set @emppro_restyp=null
			set @mtermres_id =null
		end

	if (@empanl_id =0)
		begin
			set @empanl_id =null
		end
	if (@ros_id=0)
		begin
			set @ros_id =null
		end

	update m_emppro 
			set emppro_macid=@emppro_macid,emppro_cat=@emppro_cat,emppro_nam=@emppro_nam,emppro_fnam=@emppro_fnam,memp_sub_id=@memp_sub_id,emppro_add=@emppro_add,dpt_id=@dpt_id,emppro_doj=@emppro_doj,emppro_gen=@emppro_gen,emppro_mar=@emppro_mar,emppro_dob=@emppro_dob,emppro_cnic=@emppro_cnic,emppro_ntn=@emppro_ntn,emppro_ref=@emppro_ref,emppro_pho=@emppro_pho,emppro_mob=@emppro_mob,emppro_eml=@emppro_eml,emppro_expcom=@emppro_expcom,emppro_expdes=@emppro_expdes,emppro_expyrfrm=@emppro_expyrfrm,emppro_expyrto=@emppro_expyrto,emppro_exprmk=@emppro_exprmk,emppro_quains=@emppro_quains,emppro_quaqua=@emppro_quaqua ,emppro_quayr=@emppro_quayr,emppro_quarmk=@emppro_quarmk,emppro_sal=@emppro_sal,emppro_salgra=@emppro_salgra,emppro_saleobi=@emppro_saleobi,emppro_salsessi=@emppro_salsessi,emppro_ot=@emppro_ot,emppro_salsp=@emppro_salsp,emppro_ho=@emppro_ho,emppro_ckrat=@emppro_ckrat,emppro_rat=@emppro_rat,emppro_lde=@emppro_lde,emppro_sot=@emppro_sot,emppro_fot=@emppro_fot,emppro_reg=@emppro_reg,emppro_reg_dat=@emppro_reg_dat,emppro_reg_rmk=@emppro_reg_rmk,emppro_st=@emppro_st,ros_id=@ros_id,empanl_id=@empanl_id,emppro_typ=@emppro_typ,emppro_att=@emppro_Att,emppro_userid=@emppro_macid,emppro_attexp=@emppro_attexp,emppro_autact=@emppro_autact,emppro_tp=@emppro_tp,emppro_dat_sessi=@emppro_dat_sessi,emppro_sessi_no=@emppro_sessi_no,emppro_srat=@emppro_srat,mtermres_id= @mtermres_id,emppro_restyp=@emppro_restyp
			where emppro_id=@emppro_id 

	--Employee Salary
	exec upd_m_sal @msal_id,@emppro_doj,@emppro_sal,0,1,@emppro_sal,@emppro_id,'S',@com_id,@br_id,@m_yr_id,@usr_id,'Employee Salary from Employee Profile',@aud_des,@aud_ip
	
	--Employee Auto Roster
	exec upd_m_rosemp @com_id,@br_id,@rosemp_id,@emppro_doj,'S',@ros_id ,@emppro_id ,'','','',''

	--Account
	if (@memp_cksal=1)
	begin
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @acc_no=(select acc_no from m_emppro where emppro_id=@emppro_id)
		set @acc_cno=(select salcom_acc from m_sys)
			if (@acc_no is null)	
				begin
					exec ins_m_acc @com_id,@br_id,@cur_id ,@emppro_nam ,@acc_cno ,'','S',@emppro_st ,'','','','','',@acc_no_out =@acc_no output
					update m_emppro set acc_no=@acc_no where emppro_id=@emppro_id
				end
			else 
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id ,@acc_no ,@emppro_nam ,@acc_cno ,'','S',@emppro_st,'','','','',''				
				end
	end
 

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update with image
alter proc [dbo].[upd_m_emppro_img](@emppro_id int,@emppro_cat int,@emppro_macid int,@emppro_nam varchar(100),@emppro_fnam varchar(100),@memp_sub_id int,@emppro_add varchar(250),@dpt_id char(2),@emppro_doj datetime,@emppro_gen char(1),@emppro_mar char(1),@emppro_dob datetime,@emppro_cnic char(15),@emppro_ntn char(20),@emppro_ref varchar(250),@emppro_pho char(100),@emppro_mob char(100),@emppro_eml char(100),@emppro_expcom varchar(100),@emppro_expdes varchar(100),@emppro_expyrfrm datetime,@emppro_expyrto datetime,@emppro_exprmk varchar(100),@emppro_quains varchar(100),@emppro_quaqua varchar(50),@emppro_quayr datetime,@emppro_quarmk varchar(100),@emppro_sal float,@emppro_salpay char(1),@emppro_salpay_acc varchar(100),@emppro_ot bit,@emppro_att bit,@emppro_salgra bit,@emppro_saleobi bit,@emppro_saleobi_dor datetime,@emppro_saleobi_reg varchar(50),@emppro_salsessi bit,@emppro_salsp bit,@emppro_ho bit,@emppro_ckrat bit,@emppro_rat float,@emppro_lde bit,@emppro_sot bit,@emppro_fot bit,@emppro_Salpt float,@emppro_salpot float,@emppro_reg bit,@emppro_reg_dat datetime,@emppro_reg_rmk varchar(100),@emppro_st bit,@ros_id int,@empanl_id int,@emppro_attexp bit,@emppro_typ char(1),@emppro_img image,@emppro_autact bit,@emppro_tp char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024), @emppro_dat_sessi datetime,@emppro_sessi_no varchar(50), @emppro_srat float,@mtermres_id int,@emppro_restyp char(1),@aud_ip varchar(100))
as
declare
@aud_act char(20),
@empros_id int,
@msal_id int,
@rosemp_id int,
@memp_cksal bit,
@memp_cksal_old bit,
@acc_no int,
@acc_cno int,
@cur_id int
begin
	
	set @memp_cksal =(select memp_sub_salman from m_emp_sub where memp_sub_id=@memp_sub_id)
	set @memp_cksal_old =(select memp_sub_salman from m_emppro inner join m_emp_sub on m_emppro.memp_sub_id=m_emp_Sub.memp_sub_id where emppro_id=@emppro_id)
	set @aud_act='Update'
	set @msal_id=(select msal_id from m_emppro where emppro_id=@emppro_id)
	set @rosemp_id=(select max(rosemp_id) from m_rosemp where emppro_id=@emppro_id and rosemp_typ='S')

	if (@emppro_reg=0)
		begin
			set @emppro_restyp=null
			set @mtermres_id =null
		end

	if (@empanl_id =0)
		begin
			set @empanl_id =null
		end
	if (@ros_id=0)
		begin
			set @ros_id =null
		end

	update m_emppro 
			set emppro_macid=@emppro_macid,emppro_cat=@emppro_cat,emppro_nam=@emppro_nam,emppro_fnam=@emppro_fnam,memp_sub_id=@memp_sub_id,emppro_add=@emppro_add,dpt_id=@dpt_id,emppro_doj=@emppro_doj,emppro_gen=@emppro_gen,emppro_mar=@emppro_mar,emppro_dob=@emppro_dob,emppro_cnic=@emppro_cnic,emppro_ntn=@emppro_ntn,emppro_ref=@emppro_ref,emppro_pho=@emppro_pho,emppro_mob=@emppro_mob,emppro_eml=@emppro_eml,emppro_expcom=@emppro_expcom,emppro_expdes=@emppro_expdes,emppro_expyrfrm=@emppro_expyrfrm,emppro_expyrto=@emppro_expyrto,emppro_exprmk=@emppro_exprmk,emppro_quains=@emppro_quains,emppro_quaqua=@emppro_quaqua ,emppro_quayr=@emppro_quayr,emppro_quarmk=@emppro_quarmk,emppro_sal=@emppro_sal,emppro_salgra=@emppro_salgra,emppro_saleobi=@emppro_saleobi,emppro_salsessi=@emppro_salsessi,emppro_ot=@emppro_ot,emppro_salsp=@emppro_salsp,emppro_ho=@emppro_ho,emppro_ckrat=@emppro_ckrat,emppro_rat=@emppro_rat,emppro_lde=@emppro_lde,emppro_sot=@emppro_sot,emppro_fot=@emppro_fot,emppro_reg=@emppro_reg,emppro_reg_dat=@emppro_reg_dat,emppro_reg_rmk=@emppro_reg_rmk,ros_id=@ros_id,empanl_id=@empanl_id,emppro_st=@emppro_st,emppro_img=@emppro_img,emppro_typ=@emppro_typ,emppro_att=@emppro_att,emppro_userid=@emppro_macid,emppro_attexp=@emppro_attexp,emppro_autact=@emppro_autact,emppro_tp=@emppro_tp,emppro_dat_sessi=@emppro_dat_sessi,emppro_sessi_no=@emppro_sessi_no,emppro_srat=@emppro_srat,mtermres_id= @mtermres_id,emppro_restyp=@emppro_restyp
			where emppro_id=@emppro_id 

	--Employee Salary
	exec upd_m_sal @msal_id,@emppro_doj,@emppro_sal,0,1,@emppro_sal,@emppro_id,'S',@com_id,@br_id,@m_yr_id,@usr_id,'Employee Salary from Employee Profile',@aud_des,@aud_ip
				
	--Employee Auto Roster
	exec upd_m_rosemp @com_id,@br_id,@rosemp_id,@emppro_doj,'S',@ros_id ,@emppro_id ,'','','',''

	--Account
	if (@memp_cksal=1)
	begin
		set @cur_id=(select cur_id from m_cur where cur_typ='S')
		set @acc_no=(select acc_no from m_emppro where emppro_id=@emppro_id)
		set @acc_cno=(select salcom_acc from m_sys)
			if (@acc_no is null)	
				begin
					exec ins_m_acc @com_id,@br_id,@cur_id ,@emppro_nam ,@acc_cno ,'','S',@emppro_st ,'','','','','',@acc_no_out =@acc_no output
					update m_emppro set acc_no=@acc_no where emppro_id=@emppro_id
				end
			else 
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id ,@acc_no ,@emppro_nam ,@acc_cno ,'','S',@emppro_st,'','','','',''				
				end
	end
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Delete
alter proc [dbo].[del_m_emppro](@com_id char(2),@br_id char(3),@emppro_id int,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20),
@msal_id			int,
@rosemp_id int
begin
	set @rosemp_id=(select rosemp_id from m_rosemp where emppro_id=@emppro_id)
	set @msal_id=(select msal_id from m_emppro where emppro_id=@emppro_id)
	set @aud_act='Delete'
	
	exec del_m_rosemp @com_id,@br_id,@rosemp_id ,@usr_id ,'','',''

	delete from m_sal where emppro_id=@emppro_id
	delete from m_empall where emppro_id=@emppro_id
	delete from m_emppro  
			where emppro_id=@emppro_id
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO