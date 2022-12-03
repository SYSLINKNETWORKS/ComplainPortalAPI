USE ZSONS
GO
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



alter proc ins_m_cus(@com_id char(2),@br_id char(3),@cus_creday float,@cus_amtltd float,@cus_st char(1),@cus_nam varchar(100),@cur_id int,@cus_cp varchar(100),@cus_add varchar(250),@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_app bit,@cuscat_id int,@zone_id int,@cus_typ char(1),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@cus_id_out int output)
as
declare
@cus_id int,
@acc_no int,
@acc_cno int,
@aud_act char(10)
begin
	set @aud_act ='Insert'
	set @cus_id=(select max(cus_id)+1 from m_cus)
		if @cus_id is null
			begin
				set @cus_id=1
			end
		if (@cus_app =0)
		begin
			set @cus_act=0
		end
	insert into m_cus
			(com_id,br_id,cus_id,cus_nam,cur_id,cus_add,cus_cp,cus_cnic,cus_pho,cus_mob,cus_fax, cus_eml,cus_web,cus_ntn,cus_stn,cus_act,cus_creday,cus_amtltd,cus_typ,cuscat_id,zone_id,cus_st,cus_app)
		 values(@com_id,@br_id,@cus_id,@cus_nam,@cur_id,@cus_add,@cus_cp,@cus_cnic,@cus_pho,@cus_mob,@cus_fax,@cus_eml,@cus_web,@cus_ntn,@cus_stn,@cus_act,@cus_creday,@cus_amtltd,@cus_typ,@cuscat_id,@zone_id,@cus_st,@cus_app)

		set @cus_id_out=@cus_id
	--GL Account
	if (@cus_app=1)
		begin
			set @acc_cno=(select cus_acc from m_sys)
			exec ins_m_acc @com_id ,@br_id,@cur_id ,@cus_nam ,@acc_cno ,'','S',@cus_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
			update m_cus set acc_no=@acc_no where cus_id=@cus_id
		end

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end	

--(select max(acc_id) from gl_m_acc where left(acc_id,8))=(select cusplier_acc from m_sys)
go

--Update
alter proc upd_m_cus(@com_id char(2),@br_id char(3),@cus_id int,@cus_st char(1),@cus_app bit,@cus_nam varchar(100),@cur_id int,@cus_add varchar(250),@cus_cp varchar(100),@cus_cnic varchar(250),@cus_pho varchar(100),@cus_mob varchar(100),@cus_fax varchar(100),@cus_eml varchar(100),@cus_web varchar(100),@cus_ntn varchar(100),@cus_stn varchar(100),@cus_act bit,@cus_creday float,@cus_amtltd float,@cus_typ char(1),@cuscat_id int,@zone_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@acc_no int,
@acc_cno int,
@aud_act char(10)
begin
	set @aud_act='Update'
	
	if (@cus_app =0)
		begin
			set @cus_act=0
		end
		
	update m_cus set cus_st=@cus_st,cus_app=@cus_app,cus_nam=@cus_nam,cur_id=@cur_id,cus_cp=@cus_cp,cus_add=@cus_add,cus_cnic=@cus_cnic,cus_pho=@cus_pho,cus_mob=@cus_mob,cus_fax=@cus_fax,cus_eml=@cus_eml,cus_web=@cus_web,cus_ntn=@cus_ntn,cus_stn=@cus_stn,cus_act=@cus_act,cus_creday=@cus_creday,cus_amtltd=@cus_amtltd, cus_typ=@cus_typ,cuscat_id=@cuscat_id,zone_id=@zone_id where cus_id=@cus_id

	--GL Update
	if (@cus_app=1)
		begin
			set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)
			set @acc_cno=(select cus_acc from m_sys)
			if (@acc_no is null)
				begin
					exec ins_m_acc @com_id ,@br_id,@cur_id ,@cus_nam ,@acc_cno ,'','S',@cus_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
					update m_cus set acc_no=@acc_no where cus_id=@cus_id
				end
			else
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id,@acc_no,@cus_nam ,@acc_cno,'','S',@cus_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,''
				end
		end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end	
go

--select * from m_cus
--exec del_m_cus '01','01',6
--Delete
alter  proc del_m_cus(@com_id char(3),@br_id char(3),@cus_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@acc_no int,
@cnt int,
@aud_act char(10)
begin
	set @aud_act='Delete'
	--GL Account
	set @acc_no=(select acc_no from m_cus where cus_id=@cus_id)	
	--set @cnt=(select count(acc_id) from t_dvch where acc_id=(select acc_id from m_cus where cus_id=@cus_id))
--print @cnt
	--if (@cnt =0)
	--	begin
			--Delete Customer
			delete from m_cus where cus_id=@cus_id
			exec del_m_acc @com_id,@br_id,@acc_no,@aud_frmnam,@aud_des,@usr_id,@aud_ip 
	--	end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

GO
