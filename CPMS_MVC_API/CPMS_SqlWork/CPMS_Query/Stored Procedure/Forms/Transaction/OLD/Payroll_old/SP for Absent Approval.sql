USE zsons
GO
--alter table m_abs add mabs_abs float,mabs_al float,mabs_cl float,mabs_sl float
--alter table m_abs add com_id char(2),br_id char(3)
--alter table m_abs add constraint FK_MABS_COMID foreign key(com_id) references m_com(com_id)
--alter table m_abs add constraint FK_MABS_BRID foreign key(br_id) references m_br(br_id)
--alter table m_abs add m_yr_id char(2)
--alter table m_abs add constraint FK_MABS_MYRID foreign key (m_yr_id) references gl_m_yr(yr_id)

--select * from m_abs
--delete from m_abs

--Insert
alter  proc [dbo].[ins_m_abs](@com_id char(2),@br_id char(3),@m_yr_id char(3),@mabs_dat datetime,@emppro_macid int,@mabs_abs float,@mabs_al float,@mabs_cl float,@mabs_sl float,@mabs_typ char(1),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@mabs_id			int,
@aud_act			char(20)
begin
	set @mabs_id =(select max(mabs_id) from m_abs)+1
	set @aud_act='Insert'

	if (@mabs_id is null)
		begin	
			set @mabs_id=1
		end

	insert into m_abs (com_id,br_id,m_yr_id,mabs_id,mabs_dat,emppro_macid,mabs_abs,mabs_al,mabs_cl,mabs_sl,mabs_typ)
	values (@com_id,@br_id,@m_yr_id,@mabs_id,@mabs_dat,@emppro_macid,@mabs_abs,@mabs_al,@mabs_cl,@mabs_sl,@mabs_typ)



--Audit
	exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

--Update

alter  proc [dbo].[upd_m_abs](@mabs_id int,@mabs_dat datetime,@emppro_macid int,@mabs_abs float,@mabs_al float,@mabs_cl float,@mabs_sl float,@mabs_typ char(1),@com_id char(2),@br_id char(3),@m_yr_id char(3),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act char(20)
begin
	set @aud_act='Update'
	update m_abs 
			set mabs_dat=@mabs_dat,emppro_macid=@emppro_macid,mabs_abs=@mabs_abs,mabs_al=@mabs_al,mabs_cl=@mabs_cl,mabs_sl=@mabs_sl,mabs_typ=@mabs_typ
			where mabs_id=@mabs_id 
	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO



--Delete
alter  proc [dbo].[del_m_abs](@com_id char(2),@br_id char(3),@mabs_dat datetime,@m_yr_id char(2),@usr_id int,@aud_frmnam varchar(1024),@aud_des varchar(1024),@aud_ip varchar(100))
as
declare
@aud_act			char(20)
begin
	set @aud_act='Delete'
	delete from m_abs  
			where mabs_dat=@mabs_dat

	--Audit
		exec sp_ins_aud1 @com_id,@br_id,@aud_frmnam,@aud_des,@usr_id,@aud_act,@aud_ip
end
GO

