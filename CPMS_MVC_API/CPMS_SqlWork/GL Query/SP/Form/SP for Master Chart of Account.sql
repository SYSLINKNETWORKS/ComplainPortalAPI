USE PAGEY
GO

--alter table gl_m_acc add acc_act bit,acc_del bit

--update gl_m_acc set acc_act=1,acc_del=0
--update gl_m_acc set acc_cno =(select acc_no from gl_m_acc glmacc where acc_id=gl_m_acc.acc_cid)

----Insert Chart of Account

ALTER proc [dbo].[ins_m_acc](@com_id char(2),@br_id varchar(2),@cur_id int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20),@acc_typ char(1),@acc_act bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@acc_id_out varchar(20) output,@acc_no_out int output)
as
declare
@acc_id			varchar(20),
@acc_lvl		int,
@acc_des		nvarchar(4000),
@acc_no			int,
@aud_act		char(10),
@acc_cid		char(20)
begin
	set @aud_act='Insert'
	set @acc_cid =(select acc_id from gl_m_acc where com_id=@com_id and acc_no=@acc_cno)
	if (@cur_id=0) 
		begin
			set @cur_id=null
		end
set @acc_des=(select acc_des from gl_m_acc where com_id=@com_id and acc_id=@acc_cid)
	if @acc_cid is null
		begin
			set @acc_des=rtrim(@acc_nam)
			set @acc_id =(select max(acc_id) from gl_m_acc where com_id=@com_id and acc_cid is null)
			set @acc_id=dbo.autonumber(@acc_id,2)
			set @acc_lvl=1
		end
	else
		begin
			set @acc_des = rtrim(@acc_nam)+'-'+rtrim(@acc_des)
			set @acc_id =(select right(max(rtrim(acc_id)),3) from gl_m_acc where com_id=@com_id and acc_cid=@acc_cid)
			set @acc_id=rtrim(@acc_cid)+dbo.autonumber(@acc_id,3)
			set @acc_lvl=(select distinct (acc_lvl) from gl_m_acc where com_id=@com_id and acc_id=@acc_cid)+1

		end
	set @acc_no=(select MAX(acc_no)+1 from gl_m_acc where com_id=@com_id)
	if (@acc_no is null)
		begin
			set @acc_no=1
		end
--inserting new record in m_acc
	insert into gl_m_acc
	(com_id,br_id,acc_id,acc_no,acc_nam,acc_des,acc_cid,acc_cno,acc_lvl,acc_dm,acc_typ,cur_id,acc_oid,acc_act,acc_del) 
	values
	(@com_id,@br_id,@acc_id,@acc_no,@acc_nam,@acc_des,@acc_cid,@acc_cno,@acc_lvl,'D',@acc_typ,@cur_id,@acc_oid,@acc_act,0)
-- updateing record with reference acc_cid
	update gl_m_acc
	set acc_dm='M' where com_id=@com_id and acc_id=@acc_cid
	set @acc_id_out=@acc_id
	set @acc_no_out=@acc_no

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO

----Update Chart of Account
ALTER proc [dbo].[upd_m_acc](@com_id char(2),@br_id char(2),@cur_id int,@acc_no int,@acc_nam varchar(100),@acc_cno int,@acc_oid varchar(20),@acc_typ char(1),@acc_act bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100),@acc_id_out char(20) output)
as
declare
@acc_lvl		int,
@acc_des nvarchar(4000),
@aud_act char(10),
@acc_cid_old char(20),
@acc_cid char(20),
@acc_id char(20)
begin
	set @aud_act='Update'
	set @acc_des=(select acc_des from gl_m_acc where com_id=@com_id and acc_no=@acc_cno)
	set @acc_cid_old=(select acc_cid from gl_m_acc where com_id=@com_id and acc_no=@acc_no)
	set @acc_cid =(select acc_id from gl_m_acc where com_id=@com_id and acc_no=@acc_cno)
	set @acc_id=(select acc_id from gl_m_acc where com_id=@com_id and acc_no=@acc_no)
	if @acc_cno is null
		begin
			set @acc_des=rtrim(@acc_nam)
			set @acc_id =(select max(acc_id) from gl_m_acc where com_id=@com_id and acc_cid is null)
			set @acc_id=dbo.autonumber(@acc_id,2)
			set @acc_lvl=1
		end
	else
		begin
			if (@acc_cid<>@acc_cid_old)
				begin
					set @acc_des = rtrim(@acc_nam)+'-'+rtrim(@acc_des)
					set @acc_id =(select right(max(rtrim(acc_id)),3) from gl_m_acc where com_id=@com_id and acc_cid=@acc_cid)
					set @acc_id=rtrim(@acc_cid)+dbo.autonumber(@acc_id,3)
					set @acc_lvl=(select distinct (acc_lvl) from gl_m_acc where com_id=@com_id and acc_id=@acc_cid)+1
				end
		end
	set @acc_des = rtrim(@acc_nam)+'-'+rtrim(@acc_des)
		
	if (@cur_id=0)
		begin
			set @Cur_id=null
		end
	
		update gl_m_acc set acc_id=@acc_id,acc_nam=@acc_nam,acc_des=@acc_des,acc_cid=@acc_cid,acc_cno=@acc_cno,acc_typ=@acc_typ,cur_id=@cur_id,acc_oid=@acc_oid,acc_act=@acc_act where com_id=@com_id and acc_no=@acc_no

	update gl_m_acc
	set acc_dm='M' where acc_no=@acc_cno

	update gl_m_acc set acc_dm='D' where  com_id=@com_id and acc_cid is not null and acc_id=@acc_cid_old and acc_id not in (select acc_id from gl_m_acc where com_id=@com_id and acc_id in (select acc_cid from gl_m_acc where com_id=@com_id))

	set @acc_id_out=@acc_id

--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO


----Delete the Chart of Account
ALTER proc [dbo].[del_m_acc](@com_id char(2),@br_id varchar(3),@acc_no int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	declare 
		--@acc_id varchar(20),
		@acc_cid		varchar(20),
		@cnt int
		begin
		
			set @cnt=(select count(acc_no) from t_dvch where com_id=@com_id and acc_no=@acc_no)
				if (@cnt=0)
					begin
						set @acc_cid =(select acc_cid from gl_m_acc where com_id=@com_id and acc_no=@acc_no)
						delete from gl_m_acc where com_id=@com_id and acc_cid is not null and acc_no=@acc_no
						update gl_m_acc set acc_dm='D' where com_id=@com_id and acc_cid is not null and acc_id=@acc_cid and acc_id not in (select acc_id from gl_m_acc where com_id=@com_id and acc_id in (select acc_cid from gl_m_acc where  com_id=@com_id))
					end
	end
--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip

end
GO

