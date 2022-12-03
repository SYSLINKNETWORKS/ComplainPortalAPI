USE MEIJI_RUSK
go

--alter table m_cus add zone_id int
--alter table m_cus add constraint FK_MCUS_ZONEID foreign key (zone_id) references m_zone(zone_id)
--alter table m_cus add cus_st char(1)
--update m_cus set cus_st='N'

--alter table m_cus add constraint FK_MCUS_curID foreign key (cur_id) references m_cur(cur_id)
--update m_cus set cur_id=(select cur_id from m_cur where cur_typ='S')
--alter table m_cus add constraint UQ_Mcus_cusNAM Unique (cus_nam)

--alter table m_sys alter column cus_acc int
--update m_sys set cus_acc=278

--select * from m_cus
--alter table m_cus add acc_no int 
--alter table m_cus add constraint FK_MCUS_ACCNO foreign key (acc_no) references gl_m_acc(acc_no)
--alter table m_sys add constraint FK_MSYS_CUSACC foreign key (cus_acc) references gl_m_acc(acc_no)
--update m_cus set acc_no=(select acc_no from gl_m_acc where acc_id=m_cus.acc_id)
--alter table m_cus drop column acc_id
--select * from gl_m_acc where acc_id=(select cus_acc from m_sys) 
--alter table m_cus add com_id char(2),br_id char(3)
--alter table m_cus add constraint FK_MCUS_COMID foreign key (com_id) references m_com(com_id)
--alter table m_cus add constraint FK_MCUS_BRID foreign key (br_id) references m_br(br_id)
--ALTER table m_cus add constraint FK_MCUS_COMID_BRID_ACCNO foreign key(com_id,br_id,acc_no) references gl_m_acc (com_id,br_id,acc_no)
--select * from m_cus
--select * from gl_m_acc where acc_no=1829

--alter table m_cus add cus_app bit
--update m_cus set cus_app=1
--alter table m_cus add cus_cnic varchar(250)
--update m_cus set cus_cnic =''

--alter table m_cus add cus_sms bit
--alter table m_cus drop column cussubcat_id int 
--alter table m_cus drop constraint FK_MCUS_CUSSUBID foreign key (cussubcat_id) references m_cussubcat(cussubcat_id)
--update m_cus set cus_sms =0

--alter table m_cus add cus_ckweb bit
--alter table m_cus add cus_usrid varchar(100)
--alter table m_cus add cus_pwd varchar(50)
--update m_cus set cus_ckweb=0

--alter table m_cus add cus_smsest bit,cus_smsso bit,cus_smsadv bit,cus_smsdc bit,cus_smsinv bit,cus_smsrec bit,cus_smscre bit
--update m_cus set cus_smsest=0,cus_smsso=0,cus_smsadv=0,cus_smsdc=0,cus_smsinv=0,cus_smsrec=0,cus_smscre=0
--alter table m_cus alter column cus_pwd varchar(50) null
--alter table m_cus add cus_idold varchar(1000)
--alter table m_cus drop column zone_id
--alter table m_cus drop constraint FK_MCUS_zoneid
--alter table m_cus add cus_lic varchar(100),cus_exp datetime
--alter table m_cus add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)
--alter table m_cus add cus_dat datetime
--update m_cus set cus_dat=GETDATE()
--update m_cus set cus_lic='0',cus_exp='12/31/2015'
--alter table m_cus add brk_id int
--alter table m_cus add constraint FK_MCUS_BRKID foreign key (brk_id) references m_brk(brk_id)


--alter table m_cus drop constraint FK_MCUS_BRKID

--alter table m_cus add cus_adddc varchar(250),cus_ckadddc bit
--update m_cus set cus_ckadddc=0

--select * from m_cus
----alter table m_cus add cus_cash bit default 0
--update m_cus set cus_cash=0 
--update m_cus set cus_Cash =1 where cus_id in (1,39,40)

--alter table m_cus add cus_venrent float,cus_fue float,cus_fuelPA char(1),cus_venPA char(1)
--alter table m_cus add cus_sal float

alter proc ins_m_cus(@com_id char(2),@br_id char(3),@cus_creday float,@cus_amtltd float,@cus_st char(1),@cus_nam varchar(100),@cur_id int,@cus_cp varchar(100),@cus_add varchar(250),@cus_adddc varchar(250),@cus_ckadddc bit,@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_app bit,@cuscat_id int,@cus_typ char(1),@cus_sms bit,@cus_smsest bit,@cus_smsso bit,@cus_smsadv bit,@cus_smsdc bit,@cus_smsinv bit,@cus_smsrec bit,@cus_smscre bit,@cus_ckweb bit,@cus_usrid varchar(100),@cus_ckpwd bit,@cus_pwd varchar(50),@cus_idold varchar(1000),@brk_id int,@cus_lic varchar(100),@cus_exp datetime,@cus_dat datetime,
@cus_venrent float,@cus_fue float,@cus_fuelPA char(1),@cus_venPA char(1),@cus_sal float,
@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@cus_id_out int output)
as
declare
@cus_id int,
@acc_no int,
@acc_cno int,
@acc_firstname varchar(1),
@log_dat datetime
begin
set @log_dat=GETDATE()
	set @cus_id=(select max(cus_id)+1 from m_cus)
		if @cus_id is null
			begin
				set @cus_id=1
			end
		if (@cus_app =0)
		begin
			set @cus_act=0
		end
		if (@cus_ckweb =0)
			begin
				set @cus_usrid=null
				set @cus_pwd=null
			end
		if (@cus_ckadddc=0)
			begin
				set @cus_adddc=null
			end
		if(@cur_id=0)
			begin
				set @Cur_id=(select cur_id from m_cur where cur_typ='S')
			end
		if (@brk_id=0)
			BEGIN
				set @brk_id=null
			end

	insert into m_cus
			(com_id,br_id,cus_id,cus_nam,cur_id,cus_add,cus_adddc,cus_ckadddc,cus_cp,cus_cnic,cus_pho,cus_mob,cus_fax,cus_eml,cus_web,cus_ntn,cus_stn,cus_act,cus_creday,cus_amtltd,cus_typ,cuscat_id,cus_st,cus_app,cus_sms,cus_smsest,cus_smsso,cus_smsadv,cus_smsdc,cus_smsinv,cus_smsrec,cus_smscre,cus_ckweb,cus_usrid,cus_pwd,cus_idold,brk_id,cus_lic,cus_exp,cus_dat,cus_venrent,cus_venPA ,cus_fue ,cus_fuelPA,cus_sal ,log_act,log_dat,usr_id,log_ip)
		 values(@com_id,@br_id,@cus_id,@cus_nam,@cur_id,@cus_add,@cus_adddc ,@cus_ckadddc,@cus_cp,@cus_cnic,@cus_pho,@cus_mob,@cus_fax,@cus_eml,@cus_web,@cus_ntn,@cus_stn,@cus_act,@cus_creday,@cus_amtltd,@cus_typ,@cuscat_id,@cus_st,@cus_app,@cus_sms,@cus_smsest,@cus_smsso,@cus_smsadv,@cus_smsdc,@cus_smsinv,@cus_smsrec,@cus_smscre,@cus_ckweb,@cus_usrid,@cus_pwd,@cus_idold,@brk_id,@cus_lic,@cus_exp,@cus_dat,@cus_venrent,@cus_venPA ,@cus_fue ,@cus_fuelPA ,@cus_sal ,@log_act,@log_dat,@usr_id,@log_ip)

		set @cus_id_out=@cus_id
	--GL Account
	if (@cus_app=1)
		begin
			set @acc_firstname =LEFT(@cus_nam,1)
			set @acc_cno =(select accmaster_no from gl_m_acc_master where accmaster_nam=@acc_firstname)
			if (@acc_cno is null)
				begin
					set @acc_cno=(select cus_acc from m_sys)
					exec ins_gl_m_acc_master @com_id ,@br_id,@acc_cno,@acc_firstname,'S',1,@accmaster_no_output=@acc_cno output
				end
				
			exec ins_m_acc @com_id ,@br_id,@cur_id ,@cus_nam ,@acc_cno ,'','S',@cus_act,'' ,'' ,@usr_id ,'','',@acc_no_out =@acc_no output
			update m_cus set acc_no=@acc_no where cus_id=@cus_id
		end

		set @log_newval= 'ID=' + cast(@cus_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end	

--(select max(acc_id) from gl_m_acc where left(acc_id,8))=(select cusplier_acc from m_sys)
go
--SELECT * from m_cus
--select * from gl_m_acc where acc_no=1954

--Update
alter proc upd_m_cus(@com_id char(2),@br_id char(3),@cus_id int,@cus_st char(1),@cus_app bit,@cus_nam varchar(100),@cur_id int,@cus_add varchar(250),@cus_adddc varchar(250),@cus_ckadddc bit,@cus_cp varchar(100),@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_creday float,@cus_amtltd float,@cus_typ char(1),@cuscat_id int,@cus_sms bit,@cus_smsest bit,@cus_smsso bit,@cus_smsadv bit,@cus_smsdc bit,@cus_smsinv bit,@cus_smsrec bit,@cus_smscre bit,@cus_ckweb bit,@cus_usrid varchar(100),@cus_ckpwd bit,@cus_pwd varchar(50),@brk_id int,@cus_lic varchar(100),@cus_exp datetime,@cus_dat datetime,@log_act char(1),
@cus_venrent float,@cus_venPA char(1),@cus_fue float,@cus_fuelPA char(1),@cus_sal float,
@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@acc_no int,
@acc_cno int,
@acc_firstname char(1),
@log_dat datetime
begin
set @log_dat=GETDATE()
	
	if (@cus_app =0)
		begin
			set @cus_act=0
		end
		if (@cus_ckweb =0)
			begin
				set @cus_usrid=null
				set @cus_pwd=null
			end
		if (@cus_ckadddc=0)
			begin
				set @cus_adddc=null
			end
		if(@cur_id=0)
			begin
				set @Cur_id=(select cur_id from m_cur where cur_typ='S')
			end
		if (@brk_id=0)
			BEGIN
				set @brk_id=null
			end


	update m_cus set cus_st=@cus_st,cus_app=@cus_app,cus_nam=@cus_nam,cur_id=@cur_id,cus_cp=@cus_cp,cus_add=@cus_add,cus_adddc=@cus_adddc,cus_ckadddc=@cus_ckadddc,cus_cnic=@cus_cnic,cus_pho=@cus_pho,cus_mob=@cus_mob,cus_fax=@cus_fax,cus_eml=@cus_eml,cus_web=@cus_web,cus_ntn=@cus_ntn,cus_stn=@cus_stn,cus_act=@cus_act,cus_creday=@cus_creday,cus_amtltd=@cus_amtltd, cus_typ=@cus_typ,cuscat_id=@cuscat_id,cus_sms=@cus_sms,cus_smsest=@cus_smsest,cus_smsso=@cus_smsso,cus_smsadv=@cus_smsadv,cus_smsdc=@cus_smsdc,cus_smsinv=@cus_smsinv,cus_smsrec=@cus_smsrec,cus_smscre=@cus_smscre,cus_ckweb=@cus_ckweb,cus_usrid=@cus_usrid,brk_id=@brk_id,cus_lic=@cus_lic,cus_exp=@cus_exp,cus_dat=@cus_dat,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip,
	cus_venrent=@cus_venrent,cus_venPA=@cus_venPA,cus_fue=@cus_fue,cus_fuelPA=@cus_fuelPA,cus_sal=@cus_sal
	
	 where cus_id=@cus_id
	if (@cus_ckpwd=1)
		begin
			update m_cus set cus_pwd=@cus_pwd where cus_id=@cus_id
		end
	--GL Update
	if (@cus_app=1)
		begin
			set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
--			set @acc_cno=(select cus_acc from m_sys)
			set @acc_firstname =LEFT(@cus_nam,1)
			set @acc_cno =(select accmaster_no from gl_m_acc_master where accmaster_nam=@acc_firstname)
			if (@acc_cno is null)
				begin
					set @acc_cno=(select cus_acc from m_sys)
					exec ins_gl_m_acc_master @com_id ,@br_id,@acc_cno,@acc_firstname,'S',1,@accmaster_no_output=@acc_cno output
				end
			if (@acc_no is null)
				begin
					exec ins_m_acc @com_id ,@br_id,@cur_id ,@cus_nam ,@acc_cno ,'','S',@cus_act,'' ,'' ,@usr_id ,'','',@acc_no_out =@acc_no output
					update m_cus set acc_no=@acc_no where cus_id=@cus_id
				end
			else
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id,@acc_no,@cus_nam ,@acc_cno,'','S',@cus_act,'','' ,@usr_id ,'' ,''
				end
		end
--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end	
go

--select * from m_cus
--exec del_m_cus '01','01',6
--Delete
alter proc del_m_cus(@com_id char(3),@br_id char(3),@cus_id int,@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@acc_no int,
@cnt int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	--GL Account
	set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)	
	--set @cnt=(select count(acc_id) from t_dvch where acc_id=(select acc_id from m_cus where cus_id=@cus_id))
--print @cnt
	--if (@cnt =0)
	--	begin
			--Delete Customer
			delete from m_cus where cus_id=@cus_id
	  
			exec del_m_acc @com_id,@br_id,@acc_no,'','',@usr_id,''
	--	end
--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end

GO
