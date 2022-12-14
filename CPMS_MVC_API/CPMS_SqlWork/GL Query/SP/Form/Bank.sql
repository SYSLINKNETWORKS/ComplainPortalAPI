USE phm
GO
--alter table gl_m_bk add bk_act bit
--alter table gl_m_bk add com_id char(2),br_id char(3)
--alter table gl_m_bk add constraint FK_Mbk_COMID foreign key (com_id) references m_com(com_id)
--alter table gl_m_bk add constraint FK_Mbk_BRID foreign key (br_id) references m_br(br_id)
--ALTER table gl_m_bk add constraint FK_Mbk_COMID_BRID_ACCNO foreign key(com_id,br_id,acc_no) references gl_m_acc (com_id,br_id,acc_no)
--ALTER TABLE gl_m_bk add bk_format int
--update gl_m_bk set bk_format=2 where bk_id='01'
--update gl_m_bk set bk_format=2 where bk_id='02'
--update gl_m_bk set bk_format=2 where bk_id='03'
--update gl_m_bk set bk_format=2 where bk_id='04'

--update gl_m_bk set bk_format=1 where bk_id='05'

--update gl_m_bk set bk_format=2 where bk_id='06'

--update gl_m_bk set bk_format=3 where bk_id='07'
--update gl_m_bk set bk_format=3 where bk_id='08'
--select * from gl_m_bk
--ALTER table gl_m_bk add bk_idold varchar(1000)
--alter table gl_m_bk add bk_title varchar(250)

--alter table gl_m_bk add log_act char(1),log_dat datetime,usr_id int,log_ip varchar(100)

----Insert the Bank
ALTER proc [dbo].[ins_m_bk](@com_id char(2),@br_id char(3),@cur_id int,@bk_nam char(50),@bk_cp varchar(100),@bk_add varchar(255),@bk_pho varchar(100),@bk_fax varchar(100),@bk_eml varchar(100),@bk_web varchar(100),@bk_acc varchar(50),@bk_chq varchar(100),@bk_lev int,@bk_act bit,@bktyp_id char(2),@bk_typ char(1),@bk_idold varchar(1000),@bk_title varchar(250),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text,@bk_id_out char(2) output)
as
declare
@bk_id			char(2),
@chq_no			int,
@chq_lev		int,
@gl_acc_id		char(20),
@acc_no			int,
@acc_cid		int,
@log_dat datetime,
@acc_nam varchar(100)
begin
set @log_dat=GETDATE()
	
	set @bk_id =(select isnull(max(bk_id),0) from gl_m_bk)
	set @acc_cid =(select rtrim(bk_acc_id) from m_sys)
	----autonumber
	set @bk_id =dbo.autonumber(@bk_id,(select col_length('gl_m_bk','bktyp_id')))
	--select @gl_acc_id
	set @gl_acc_id =(select rtrim(@gl_acc_id))
	--select @gl_acc_id
	----Inserting record in Master table of Bank
	insert into gl_m_bk 
	(bk_id,cur_id,bk_nam,bk_cp,bk_add,bk_pho,bk_fax,bk_eml,bk_web,bk_acc,bk_chq,bk_lev,bktyp_id,com_id,br_id,bk_typ,bk_act,bk_idold,bk_title,log_act,log_dat,usr_id,log_ip)
	values
	(@bk_id,@cur_id,@bk_nam,@bk_cp,@bk_add,@bk_pho,@bk_fax,@bk_eml,@bk_web,@bk_acc,@bk_chq,@bk_lev,@bktyp_id,@com_id,@br_id,@bk_typ,@bk_act,@bk_idold,@bk_title,@log_act,@log_dat,@usr_id,@log_ip)

	----GL Account
	set @acc_nam=rtrim(@bk_nam)+ ' '+rtrim(@bk_title)+' ('+rtrim(@bk_acc)+')'
	exec ins_m_acc @com_id ,@br_id,@cur_id,@acc_nam ,@acc_cid,@bk_idold,'S',@bk_act,@log_frmnam ,'',@usr_id ,@log_ip,'',@acc_no_out=@acc_no output
	update gl_m_bk set acc_no=@acc_no where bk_id=@bk_id
	----Inserting record in Chq Book Leaves
	exec ins_chq @com_id,@br_id,@bk_id,@bk_chq,@bk_lev,@bk_chq,@bk_lev,'','U'

	set @bk_id_out=@bk_id
	
	set @log_newval= 'ID=' + cast(@bk_id as varchar) + '-' + cast(@log_newval as varchar(max))
		
		--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO

--EXEC ins_m_bk '01','01','01','bank test 9','','','','','','','1000192',1,'109001',10,'01','U',''
----Update Bank
ALTER proc [dbo].[upd_m_bk](@com_id char(2),@br_id char(3),@bk_id char(2),@cur_id int,@bk_nam char(50),@bk_cp varchar(100),@bk_add varchar(255),@bk_pho varchar(100),@bk_fax varchar(100),@bk_eml varchar(100),@bk_web varchar(100),@bk_acc varchar(50),@bk_chq varchar(100),@bk_lev int,@bktyp_id char(2),@bk_typ char(1),@bk_act bit,@acc_id char(20),@bk_title varchar(250),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare

@acc_no int,
@acc_cno int,
@log_dat datetime,
@acc_nam varchar(100)
begin
set @log_dat=GETDATE()
	
--Bank Account
	set @acc_no=(select acc_no from gl_m_bk where bk_id=@bk_id)
	set @acc_cno=(select rtrim(bk_acc_id) from m_sys)
	update gl_m_bk set cur_id=@cur_id,bk_nam=@bk_nam,bk_cp=@bk_cp,bk_add=@bk_add,bk_pho=@bk_pho,bk_fax=@bk_fax,bk_eml=@bk_eml,bk_web=@bk_web,bk_chq=@bk_chq,bk_lev=@bk_lev,bktyp_id=@bktyp_id,bk_typ=@bk_typ,bk_acc=@bk_acc,bk_act=@bk_act,bk_title=@bk_title,log_act=@log_act,log_dat=@log_dat,usr_id=@usr_id,log_ip=@log_ip
		where com_id=@com_id and br_id=@br_id and bk_id=@bk_id
	--Chart of Accout
	set @acc_nam=rtrim(@bk_nam)+ ' '+rtrim(@bk_title)+' ('+rtrim(@bk_acc)+')'
	exec upd_m_acc @com_id,@br_id ,@cur_id ,@acc_no ,@acc_nam ,@acc_cno ,'' ,'S',@bk_act ,@log_frmnam ,'' ,@usr_id ,@log_ip ,''
--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat

end
GO


----Delete the Bank
ALTER proc [dbo].[del_m_bk](@com_id char(2),@br_id char(3),@bk_id char(2),@log_act char(1),@usr_id int,@log_ip varchar(100),@log_frmnam varchar(1024),@log_oldval text,@log_newval text)
as
declare
@acc_no int,
@cnt int,
@log_dat datetime
begin
set @log_dat=GETDATE()
	
		set @acc_no=(select acc_no from gl_m_bk where bk_id=@bk_id and com_id=@com_id and br_id =@br_id)
		set @cnt=(select count(acc_no) from t_dvch where acc_no=@acc_no)
			--if (@cnt=0)
			--	begin
				exec del_m_acc @com_id,@br_id,@acc_no ,@log_frmnam ,'' ,@usr_id,@log_ip 
					 
			update gl_m_bk set log_act=@log_act where bk_id=@bk_id
--Audit
		exec sp_ins_log @log_frmnam,@log_act,@usr_id,@log_ip,@log_oldval,@log_newval,@log_dat
end
GO
--update gl_m_bk set bk_typ='U' where bk_id='06'
--select * from gl_m_bk
--delete from gl_m_bk
--select * from gl_m_acc
--delete from gl_bk_chq
--delete from gl_br_acc where acc_id='01001003001'
--delete from gl_m_acc where acc_id='01001003001'
