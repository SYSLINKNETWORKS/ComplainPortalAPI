USE zsons
GO

--alter table new_usr add usr_ckbr bit
--update new_usr set usr_ckbr=0

----Insert New User
alter proc [dbo].[ins_new_usr] (@com_id char(2),@br_id char(3),@usr_nam varchar(100),@usr_pwd varchar (50),@usr_add varchar(100),@usr_pho varchar(100),@usr_mob varchar(100),@usr_eml varchar(100),@gp_id char(2),@com_id1 char(2),@br_id1 char(3), @usr_typ char(1),@usr_ckbr bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100),@usr_id_out char(2) output)
as
declare
@usr_id int,
@aud_act char(10)
begin
	set @aud_act='Insert'
--set @usr_id=dbo.autonumber ((select max (usr_id) from new_usr),2)
	set @usr_id=(select max(cast(usr_id as int)) from new_usr)+1
	if (@usr_id is null)
		begin
			set @usr_id=1
		end
	insert into new_usr
	(usr_id , usr_nam , usr_pwd , usr_add ,usr_pho , usr_mob , usr_eml , gp_id , com_id , br_id , usr_typ,usr_ckbr)
	values
	(@usr_id , @usr_nam , @usr_pwd , @usr_add ,@usr_pho , @usr_mob , @usr_eml , @gp_id , @com_id , @br_id , @usr_typ,@usr_ckbr)
	set @usr_id_out=@usr_id

	--Audit
	exec sp_ins_aud1 @com_id1,@br_id1,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip

end
GO

--[ins_new_usr] (@usr_nam varchar(100),@usr_pwd varchar (50),@usr_add varchar(100),@usr_pho varchar(100),@usr_mob varchar(100),@usr_eml varchar(100),@gp_id char(2),@com_id char(2),@br_id char(3), @usr_typ char(1),@usr_id_out char(2) output)
--select * from db_websln.dbo.new_usr
--select * from m_br
--delete from new_usr
----Update New User
alter proc [dbo].[upd_new_usr] (@com_id char(2),@br_id char(3),@usr_id int,@usr_nam varchar(100),@usr_ckpwd bit,@usr_pwd varchar (50),@usr_add varchar(100),@usr_pho varchar(100),@usr_mob varchar(100),@usr_eml varchar(100),@gp_id char(2),@com_id1 char(2),@br_id1 char(3), @usr_typ char(1),@usr_ckbr bit,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100))
as
declare
@aud_act char(10)

begin
	set @aud_act ='Update'
update new_usr set usr_nam=@usr_nam ,  usr_add=@usr_add ,usr_pho=@usr_pho , usr_mob=@usr_mob , usr_eml=@usr_eml  , gp_id=@gp_id  , com_id=@com_id  , br_id=@br_id  , usr_typ=@usr_typ,usr_ckbr=@usr_ckbr
	where  usr_id=@usr_id
         if @usr_ckpwd =1
			begin
				update new_usr set usr_pwd=@usr_pwd where usr_id=@usr_id
			end
         --Audit
	exec sp_ins_aud1 @com_id1,@br_id1,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip

end
go
--select * from new_usr

--exec upd_new_usr '01','guj','29','ssstreet','00021','000300','saf@','01','01','01','U'



--Delete New User
alter proc [dbo].[del_new_usr] (@com_id1 char(2),@br_id1 char(3),@usr_id int,@aud_frmnam varchar(250),@aud_des varchar(1000),@usr_id1 int,@aud_ip char(100))
as
declare
@aud_act char(10)
begin
	set @aud_act='Delete'
	delete from new_usr where usr_id=@usr_id
	--Audit
		exec sp_ins_aud1 @com_id1,@br_id1,@aud_frmnam,@aud_des,@usr_id1,@aud_act,@aud_ip

end
GO

