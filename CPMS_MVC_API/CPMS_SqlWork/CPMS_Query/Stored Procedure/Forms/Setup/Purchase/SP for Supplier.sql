USE phm

GO


--alter table m_sup add acc_no int
--alter table m_sup add constraint FK_MSUP_ACCNO foreign key (acc_no) references gl_m_acc(acc_no)
--alter table m_sup add constraint FK_Mcur_curID foreign key (cur_id) references m_cur (cur_id)
--update m_sup set cur_id=(select cur_id from m_cur where cur_typ='S')
--alter table m_sup add constraint UQ_MSUP_SUPNAM Unique (sup_nam)
--alter table m_sup add com_id char(2),br_id char(3)
--alter table m_sup add constraint FK_Msup_COMID foreign key (com_id) references m_com(com_id)
--alter table m_sup add constraint FK_Msup_BRID foreign key (br_id) references m_br(br_id)
--ALTER table m_sup add constraint FK_Msup_COMID_BRID_ACCNO foreign key(com_id,br_id,acc_no) references gl_m_acc (com_id,br_id,acc_no)
--alter table m_sup add sup_app bit
--update m_sup set sup_app=1
--alter table m_sup add sup_snm vahrchar(10)
--alter table m_sup add sup_idold varchar(1000)


alter proc ins_m_sup(@com_id char(2),@br_id char(3),@sup_creday float,@sup_amtltd float,@sup_nam varchar(100),@cur_id int,@sup_cp varchar(100),@sup_add varchar(250),@sup_pho varchar(100),@sup_mob varchar(100),@sup_fax varchar(100),@sup_eml varchar(100),@sup_web varchar(100),@sup_ntn varchar(100),@sup_stn varchar(100),@sup_act bit,@sup_app bit,@sup_typ char(1),@supcat_id int,@sup_idold varchar(1000),@sup_snm varchar(10),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@sup_id_out int output)
as
declare
@sup_id int,
@acc_no int,
@acc_cno int,
@aud_act char(10)
begin
	set @aud_act ='Insert'
	set @sup_id=(select max(sup_id)+1 from m_sup)
		if @sup_id is null
			begin
				set @sup_id=1
			end
	if (@sup_app =0)
		begin
			set @sup_act=0
		end



	insert into m_sup
			(com_id,br_id,sup_id,sup_nam,sup_add,sup_cp,sup_pho,sup_mob,sup_fax, sup_eml,sup_web,sup_ntn,sup_stn,sup_act,sup_app,sup_creday,sup_amtltd,sup_typ,cur_id,supcat_id,sup_idold,sup_snm)
		 values(@com_id,@br_id,@sup_id,@sup_nam,@sup_add,@sup_cp,@sup_pho,@sup_mob,@sup_fax,@sup_eml,@sup_web,@sup_ntn,@sup_stn,@sup_act,@sup_app,@sup_creday,@sup_amtltd,@sup_typ,@cur_id,@supcat_id,@sup_idold,@sup_snm)

		set @sup_id_out=@sup_id
	--GL Account
	if (@sup_app=1)
		begin
			set @acc_cno=(select sup_acc from m_sys)
			exec ins_m_acc @com_id ,@br_id,@cur_id ,@sup_nam ,@acc_cno ,'','S',@sup_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
			update m_sup set acc_no=@acc_no where sup_id=@sup_id
		end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end	
--(select max(acc_id) from gl_m_acc where left(acc_id,8))=(select supplier_acc from m_sys)
go

--Update
alter proc upd_m_sup(@com_id char(2),@br_id char(3),@sup_id int,@sup_nam varchar(100),@cur_id int,@sup_add varchar(250),@sup_cp varchar(100),@sup_pho varchar(100),@sup_mob varchar(100),@sup_fax varchar(100),@sup_eml varchar(100),@sup_web varchar(100),@sup_ntn varchar(100),@sup_stn varchar(100),@sup_act bit,@sup_app bit,@sup_creday float,@sup_amtltd float,@sup_typ char(1),@supcat_id int,@sup_snm varchar(10),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@acc_cno int,
@acc_no int
begin
	set @aud_act ='Update'
	if (@sup_app =0)
		begin
			set @sup_act=0
		end
	update m_sup set sup_nam=@sup_nam,cur_id=@cur_id,sup_cp=@sup_cp,sup_add=@sup_add,sup_pho=@sup_pho,sup_mob=@sup_mob,sup_fax=@sup_fax,sup_eml=@sup_eml,sup_web=@sup_web,sup_ntn=@sup_ntn,@sup_stn=@sup_stn,sup_act=@sup_act,sup_app=@sup_app,sup_creday=@sup_creday,sup_amtltd=@sup_amtltd, sup_typ=@sup_typ,supcat_id=@supcat_id,sup_snm=@sup_snm where sup_id=@sup_id

	--GL Update	
	if (@sup_app=1)
		begin			
			set @acc_no=(select acc_no from m_sup where sup_id=@sup_id)
			set @acc_cno=(select sup_acc from m_sys)
			if (@acc_no is null)
				begin
					exec ins_m_acc @com_id ,@br_id,@cur_id ,@sup_nam ,@acc_cno ,'','S',@sup_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
					update m_sup set acc_no=@acc_no where sup_id=@sup_id
				end
			else
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id,@acc_no,@sup_nam ,@acc_cno,'','S',@sup_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,''
				end	
			
		end
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end	
go
--Delete
alter  proc del_m_sup(@com_id char(3),@br_id char(3),@sup_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@acc_no int,
@cnt int
begin
	set @aud_act ='Delete'
	set @acc_no=(select acc_no from m_sup where sup_id=@sup_id)	

--	set @cnt=(select count(acc_id) from t_dvch where acc_id in (select acc_id from m_sup where sup_id=@sup_id))
--	if (@cnt=0)
--		begin
			--Delete Supplier
			delete from m_sup where sup_id=@sup_id
			--GL Account
			exec del_m_acc @com_id,@br_id,@acc_no,@aud_frmnam,@aud_des,@usr_id,@aud_ip 
--		end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

GO
