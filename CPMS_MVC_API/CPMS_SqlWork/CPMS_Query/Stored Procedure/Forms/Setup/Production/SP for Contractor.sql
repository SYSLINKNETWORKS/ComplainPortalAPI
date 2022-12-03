USE meiji_rusk
GO


--alter table m_sup add acc_no int
--alter table m_con add constraint FK_MCON_ACCNO foreign key (acc_no) references gl_m_acc(acc_no)
--alter table m_sup add constraint FK_Mcur_curID foreign key (cur_id) references m_cur (cur_id)
--update m_sup set cur_id=(select cur_id from m_cur where cur_typ='S')
--alter table m_sup add constraint UQ_MSUP_SUPNAM Unique (sup_nam)
--alter table m_sup add com_id char(2),br_id char(3)
--alter table m_sup add constraint FK_Msup_COMID foreign key (com_id) references m_com(com_id)
--alter table m_sup add constraint FK_Msup_BRID foreign key (br_id) references m_br(br_id)
--alter table m_sup add constraint FK_Msup_COMID_BRID_ACCNO foreign key(com_id,br_id,acc_no) references gl_m_acc (com_id,br_id,acc_no)
--alter table m_sup add sup_app bit
--update m_sup set sup_app=1
--alter table m_sup add sup_snm vahrchar(10)
--alter table m_sup add sup_idold varchar(1000)

--alter table m_sys add con_acc int
--update m_sys set con_acc =(select acc_no from gl_m_acc where acc_id='02003001017')

alter proc ins_m_con(@com_id char(2),@br_id char(3),@con_creday float,@con_amtltd float,@con_nam varchar(100),@cur_id int,@con_cp varchar(100),@con_add varchar(250),@con_pho varchar(100),@con_mob varchar(100),@con_fax varchar(100),@con_eml varchar(100),@con_web varchar(100),@con_ntn varchar(100),@con_stn varchar(100),@con_act bit,@con_app bit,@con_typ char(1),@supcat_id int,@con_idold varchar(1000),@con_snm varchar(10),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@con_id_out int output)
as
declare
@con_id int,
@acc_no int,
@acc_cno int,
@aud_act char(10)
begin
	set @aud_act ='Insert'
	set @con_id=(select max(con_id)+1 from m_con)
		if @con_id is null
			begin
				set @con_id=1
			end
	if (@con_app =0)
		begin
			set @con_act=0
		end

	if (@supcat_id=0)
		begin
			set @supcat_id=null
		end


	insert into m_con
			(com_id,br_id,con_id,con_nam,con_add,con_cp,con_pho,con_mob,con_fax, con_eml,con_web,con_ntn,con_stn,con_act,con_app,con_creday,con_amtltd,con_typ,cur_id,supcat_id,con_idold,con_snm)
		 values(@com_id,@br_id,@con_id,@con_nam,@con_add,@con_cp,@con_pho,@con_mob,@con_fax,@con_eml,@con_web,@con_ntn,@con_stn,@con_act,@con_app,@con_creday,@con_amtltd,@con_typ,@cur_id,@supcat_id,@con_idold,@con_snm)

		set @con_id_out=@con_id
	--GL Account
	if (@con_app=1)
		begin
			set @acc_cno=(select con_acc from m_sys)
			exec ins_m_acc @com_id ,@br_id,@cur_id ,@con_nam ,@acc_cno ,'','S',@con_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
			update m_con set acc_no=@acc_no where con_id=@con_id
		end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end	
--(select max(acc_id) from gl_m_acc where left(acc_id,8))=(select supplier_acc from m_sys)
go

--Update
alter proc upd_m_con(@com_id char(2),@br_id char(3),@con_id int,@con_nam varchar(100),@cur_id int,@con_add varchar(250),@con_cp varchar(100),@con_pho varchar(100),@con_mob varchar(100),@con_fax varchar(100),@con_eml varchar(100),@con_web varchar(100),@con_ntn varchar(100),@con_stn varchar(100),@con_act bit,@con_app bit,@con_creday float,@con_amtltd float,@con_typ char(1),@supcat_id int,@con_snm varchar(10),@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@acc_cno int,
@acc_no int
begin
	set @aud_act ='Update'
	if (@con_app =0)
		begin
			set @con_act=0
		end
	if (@supcat_id=0)
		begin
			set @supcat_id=null
		end
	update m_con set con_nam=@con_nam,cur_id=@cur_id,con_cp=@con_cp,con_add=@con_add,con_pho=@con_pho,con_mob=@con_mob,con_fax=@con_fax,con_eml=@con_eml,con_web=@con_web,con_ntn=@con_ntn,@con_stn=@con_stn,con_act=@con_act,con_app=@con_app,con_creday=@con_creday,con_amtltd=@con_amtltd, con_typ=@con_typ,supcat_id=@supcat_id,con_snm=@con_snm where con_id=@con_id

	--GL Update	
	if (@con_app=1)
		begin			
			set @acc_no=(select acc_no from m_con where con_id=@con_id)
			set @acc_cno=(select con_acc from m_sys)
			if (@acc_no is null)
				begin
					exec ins_m_acc @com_id ,@br_id,@cur_id ,@con_nam ,@acc_cno ,'','S',@con_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip,'',@acc_no_out =@acc_no output
					update m_con set acc_no=@acc_no where con_id=@con_id
				end
			else
				begin
					exec upd_m_acc @com_id,@br_id,@cur_id,@acc_no,@con_nam ,@acc_cno,'','S',@con_act,@aud_frmnam ,@aud_des ,@usr_id ,@aud_ip ,''
				end	
			
		end
	
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end	
go
--Delete
alter  proc del_m_con(@com_id char(3),@br_id char(3),@con_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10),
@acc_no int,
@cnt int
begin
	set @aud_act ='Delete'
	set @acc_no=(select acc_no from m_con where con_id=@con_id)	

--	set @cnt=(select count(acc_id) from t_dvch where acc_id in (select acc_id from m_con where con_id=@con_id))
--	if (@cnt=0)
--		begin
			--Delete Supplier
			delete from m_con where con_id=@con_id
			--GL Account
			exec del_m_acc @com_id,@br_id,@acc_no,@aud_frmnam,@aud_des,@usr_id,@aud_ip 
--		end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end

GO
